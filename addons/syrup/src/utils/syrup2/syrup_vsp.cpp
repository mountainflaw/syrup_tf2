// Syrup2 VSP
// Adds VScript_RegisterConsoleCommand function to TF2's VScript VM.
// Version 1.0

// Building in 2013 SDK:
// Create new directory in src/utils
// Copy most of the example plugin's vpc except it just builds one file
// Add new vpc to project_default.vpc
// Build

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <dlfcn.h>
#include <unordered_map>
#include <string>
#include <sys/mman.h>

#include "vscript/ivscript.h"

#include "interface.h"
#include "eiface.h"
#include "engine/iserverplugin.h"

IVEngineServer* g_pEngine = nullptr;

class CScriptManager;

using CreateVM_t = IScriptVM* (*)(CScriptManager*, ScriptLanguage_t);

static void*      g_VScriptHandle = nullptr;
static void*      g_CreateVMAddr  = nullptr;
static uint8_t    g_OrigBytes[16];
static CreateVM_t g_Trampoline    = nullptr;

IScriptVM *g_pVM = NULL;

// from IDA: offset of CScriptManager::CreateVM in vscript_srv.so
static constexpr uintptr_t CREATEVM_OFFSET = 0xE130;


//void test_vscript(void) {
//	Msg("Print From C++!\n");
//}

static std::unordered_map<std::string, std::string> g_CommandCallbacks;


// vscript gets really mad and just kills the whole server if we try to pass a function pointer from here
// so we store it all as strings and do a lookup through the root table

void VScript_RegisterConsoleCommand(const char *cmd, const char *func) {
	std::string fullCmd = "sy_";
	fullCmd += cmd;
	g_CommandCallbacks[fullCmd] = func;
	Msg("[Syrup2] Registering concommand %s -> %s\n", fullCmd.c_str(), func);
}

static IScriptVM* Hooked_CreateVM(CScriptManager* self, ScriptLanguage_t lang) {
	IScriptVM* vm = g_Trampoline(self, lang);
	g_pVM = vm;
	//ScriptRegisterFunction(vm, test_vscript, "test");
	//Msg("[Syrup2] Registered test_vscript\n");
	ScriptRegisterFunction(vm, VScript_RegisterConsoleCommand, "Registers a console command from VScript.");
	Msg("[Syrup2] self=%p lang=%d vm=%p\n", self, (int)lang, vm);
	return vm;
}

static bool InstallHook() {
	g_VScriptHandle = dlopen("vscript_srv.so", RTLD_NOW);

	if (!g_VScriptHandle) {
        	Msg("[Syrup2] dlopen vscript_srv.so failed: %s\n", dlerror());
        	return false;
	}

	void* anySym = dlsym(g_VScriptHandle, "VScriptServerInit");
	if (!anySym) {
		anySym = dlsym(g_VScriptHandle, "CreateInterface");
	}


	if (!anySym) {
		Msg("[Syrup2] dlsym helper symbol failed: %s\n", dlerror());
		return false;
	}

	Dl_info info{};
	if (!dladdr(anySym, &info) || !info.dli_fbase) {
		Msg("[Syrup2] dladdr failed\n");
		return false;
	}

	uintptr_t base = (uintptr_t)info.dli_fbase;
	g_CreateVMAddr = (void*)(base + CREATEVM_OFFSET);

	Msg("[Syrup2] vscript_srv base = %p\n", info.dli_fbase);
	Msg("[Syrup2] CreateVM addr   = %p\n", g_CreateVMAddr);

	memcpy(g_OrigBytes, g_CreateVMAddr, 16);

	void* tramp = mmap(nullptr, 4096, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

	if (!tramp) {
		Msg("[Syrup2] mmap failed\n");
		return false;
	}

	memcpy(tramp, g_OrigBytes, 16);

	uint8_t* t = (uint8_t*)tramp + 16;
	*t++ = 0xE9;
	*(int32_t*)t = (int32_t)((uintptr_t)g_CreateVMAddr + 16 - ((uintptr_t)tramp + 21));
	g_Trampoline = (CreateVM_t)tramp;

	mprotect((void*)((uintptr_t)g_CreateVMAddr & ~4095), 4096, PROT_READ | PROT_WRITE | PROT_EXEC);

	uint8_t* p = (uint8_t*)g_CreateVMAddr;
	p[0] = 0xE9;
	*(int32_t*)&p[1] = (int32_t)((uintptr_t)&Hooked_CreateVM - ((uintptr_t)g_CreateVMAddr + 5));

	Msg("[Syrup] Hook installed\n");
	return true;
}

static void RemoveHook() {
	if (g_CreateVMAddr) {
		mprotect((void*)((uintptr_t)g_CreateVMAddr & ~4095), 4096, PROT_READ | PROT_WRITE | PROT_EXEC);
		memcpy(g_CreateVMAddr, g_OrigBytes, 16);
		Msg("[Syrup2] Hook removed\n");
	}

	if (g_VScriptHandle) {
		dlclose(g_VScriptHandle);
		g_VScriptHandle = nullptr;
	}
}

class CCreateVMPlugin : public IServerPluginCallbacks {
public:
	bool Load(CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory) override {
		g_pEngine = (IVEngineServer*)interfaceFactory(INTERFACEVERSION_VENGINESERVER, nullptr);
		Msg("[Syrup2] Plugin Loaded\n");

		if (!InstallHook()) {
			Msg("[Syrup2] InstallHook FAILED\n");
		}
		return true;
	}

	void Unload() override {
		Msg("[Syrup2] Plugin Unloaded\n");
		RemoveHook();
	}

	const char* GetPluginDescription() override {
		return "Syrup VScript Extensions";
	}


	PLUGIN_RESULT ClientCommand(edict_t* pEntity, const CCommand& cmd) override {
		if (!g_pVM) {
			return PLUGIN_CONTINUE;
		}

		const char* cmdName = cmd.Arg(0);
		//Msg("Client command detected: %s\n", cmdName);

		auto it = g_CommandCallbacks.find(cmdName);
		if (it == g_CommandCallbacks.end()) {
			//Msg("[Syrup2] No VScript callback registered for %s\n", cmdName);
			return PLUGIN_CONTINUE;
		}

		auto cmdFunc  = it->second;
		//Msg("Mapped cmd to function: %s\n", cmdFunc.c_str());

		HSCRIPT hServerExec = g_pVM->LookupFunction("ServerExecuteCommand", nullptr);
		if (!hServerExec) {
			Msg("[Syrup2] ServerExecuteCommand not found in VScript\n");
			return PLUGIN_CONTINUE;
		}

		int caller = g_pEngine->GetPlayerUserId(pEntity);

		// vscript has a limit of 14 args. we want to support more, so concat as a giant space seperated
		// string. we work in strings anyways for arguments, so we can rebuild it as a list of strings
		// on the vscript side

		std::string argString;
		for (int i = 0; i < cmd.ArgC(); i++) {
			if (i > 0) argString += " ";
			argString += cmd.Arg(i);
		}

		g_pVM->Call(hServerExec, nullptr, true, nullptr, caller, cmdFunc.c_str(), argString.c_str());
		return PLUGIN_STOP;
	}

	void Pause() override {}
	void UnPause() override {}
	void LevelInit(const char*) override {}
	void ServerActivate(edict_t*, int, int) override {}
	void GameFrame(bool) override {}
	void LevelShutdown() override {}
	void ClientActive(edict_t*) override {}
	void ClientDisconnect(edict_t*) override {}
	void ClientPutInServer(edict_t*, const char*) override {}
	void SetCommandClient(int) override {}
	void ClientSettingsChanged(edict_t*) override {}
	PLUGIN_RESULT ClientConnect(bool*, edict_t*, const char*, const char*, char*, int) override { return PLUGIN_CONTINUE; }
	PLUGIN_RESULT NetworkIDValidated(const char*, const char*) override { return PLUGIN_CONTINUE; }
	void OnQueryCvarValueFinished(QueryCvarCookie_t, edict_t*, EQueryCvarValueStatus, const char*, const char*) override {}
	void OnEdictAllocated(edict_t*) override {}
	void OnEdictFreed(const edict_t*) override {}
};

static CCreateVMPlugin g_Plugin;
EXPOSE_SINGLE_INTERFACE_GLOBALVAR(CCreateVMPlugin, IServerPluginCallbacks, INTERFACEVERSION_ISERVERPLUGINCALLBACKS, g_Plugin);

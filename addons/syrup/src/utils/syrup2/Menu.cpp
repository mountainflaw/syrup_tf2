#include "syrup_vsp.h"

std::vector<VScriptMenu> g_VScriptMenus;

int FindVScriptMenuIndexByUserID(int client) {
	for (int i = 0; i < g_VScriptMenus.size(); i++) {
		if (g_VScriptMenus[i].client == client) {
			return i;
		}
	}
	return -1;
}

// delete any menu that is dispatched to the user. this is probably over engineered, but i wanted it to be extra safe.

void UndispatchAllVScriptMenusByUserID(int client) {
	std::vector<unsigned int> menusToUndispatch;
	for (int i = 0; i < g_VScriptMenus.size(); i++) {
		if (g_VScriptMenus[i].client == client) {
			menusToUndispatch.emplace_back(i);
		}
	}

	for (int i = 0; i < menusToUndispatch.size(); i++) {
		g_VScriptMenus.erase(g_VScriptMenus.begin() + menusToUndispatch[i]);
	}
}

VScriptMenu::VScriptMenu() {
	time = 4; // workaround
}

bool VScriptMenu::Execute(unsigned int key) {
    unsigned int enabledCount = 0;
	for (unsigned int i = 0; i < keys.size(); i++) {
		if (keys[i].func == "NO_KEY") {
			continue;
		}

		if (enabledCount == key) {
			if (keys[i].func == "NO_KEY_DISABLED") {
				return false;
	    		}
            		return keys[i].ExecuteKey(client);
        	}
		enabledCount++;
	}
	return false;
}


void VScriptMenu::SetTime(int t) {
	//time = t;
	time = 4; // workaround
}

void VScriptMenu::Dispatch(int c) {
	client = c;
	timer = time * 66.6f; // TODO: hardcoded tickrate
	UndispatchAllVScriptMenusByUserID(client);
	g_VScriptMenus.emplace_back(*this);
	this->Display();
}

void VScriptMenu::Display() {
	unsigned short options = 0;
	int buttonIndex = 0;
	TF2RecipientFilter filter(UserIdToEntityIndex(client));
	bf_write *msg = g_pEngine->UserMessageBegin(&filter, 9);

	for (int i = 0; i < keys.size(); i++) {
		buttonIndex = 0;
		for (int j = 0; j < i; j++) {
			if (keys[j].func != "NO_KEY")
				buttonIndex++;
		}

		if (keys[i].func == "NO_KEY") {
			combinedKeys += keys[i].text + "\n";
			continue;
		}

		if (keys[i].func == "NO_KEY_DISABLED") {
			combinedKeys += std::to_string(buttonIndex + 1) + ". " + keys[i].text + "\n";
			continue;
		}

		options |= (1 << buttonIndex);

		if (keys[i].func == "EXIT") {
			combinedKeys += std::to_string(buttonIndex + 1) + ". " + keys[i].text + "\n";
		} else {
			combinedKeys += "->" + std::to_string(buttonIndex + 1) + ". " + keys[i].text + "\n";
		}
	}

	msg->WriteWord(options);
	msg->WriteChar(4);
	msg->WriteByte(0); // something to do with length... sm seems to split this up every 240 chars and uses this to denote that.
	msg->WriteString(combinedKeys.c_str());

	g_pEngine->MessageEnd();
}

// used for the timer code in the main file. if timer is 0 then all menus for the user are removed from the dispatched menus vector.

bool VScriptMenu::TimerTick() {
	//Msg("Timer: %d Time: %d\n", timer, time);
	if (time == -1) { // infinite time
		return false;
	}
	if (timer != 0) {
		timer--;
		return false;
	}
	return true;
}

void VScriptMenu::SetKeyFunc0(const char *k, const char *f) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f));
}
void VScriptMenu::SetKeyFunc1(const char *k, const char *f, ScriptVariant_t a0) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0));
}
void VScriptMenu::SetKeyFunc2(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1));
}
void VScriptMenu::SetKeyFunc3(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2));
}
void VScriptMenu::SetKeyFunc4(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3));
}
void VScriptMenu::SetKeyFunc5(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4));
}
void VScriptMenu::SetKeyFunc6(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4, a5));
}
void VScriptMenu::SetKeyFunc7(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4, a5, a6));
}
void VScriptMenu::SetKeyFunc8(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4, a5, a6, a7));
}
void VScriptMenu::SetKeyFunc9(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4, a5, a6, a7, a8));
}
void VScriptMenu::SetKeyFunc10(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9));
}
void VScriptMenu::SetKeyFunc11(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10) {
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10));
}

void VScriptMenu::SetKeyFunc12(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10, ScriptVariant_t a11) { // top out at 12. vscript maximum is 14 args.
	if (keys.size() >= MAX_KEYS) {
		return;
	}
	keys.emplace_back(MenuKey(k, f, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11));
}

BEGIN_SCRIPTDESC_ROOT(VScriptMenu, "Syrup VSP VScript menu extension")
	DEFINE_SCRIPT_CONSTRUCTOR() // i do not know if this actually allows using arguments in the constructor
	DEFINE_SCRIPTFUNC(SetTime, "Set VScript menu timer") // added because above comment
	DEFINE_SCRIPTFUNC(Dispatch, "Dispatch VScript menu to client")
	DEFINE_SCRIPTFUNC(SetKeyFunc0, "Define VScript menu func (caller + 0 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc1, "Define VScript menu func (caller + 1 arg)")
	DEFINE_SCRIPTFUNC(SetKeyFunc2, "Define VScript menu func (caller + 2 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc3, "Define VScript menu func (caller + 3 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc4, "Define VScript menu func (caller + 4 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc5, "Define VScript menu func (caller + 5 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc6, "Define VScript menu func (caller + 6 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc7, "Define VScript menu func (caller + 7 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc8, "Define VScript menu func (caller + 8 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc9, "Define VScript menu func (caller + 9 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc10, "Define VScript menu func (caller + 10 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc11, "Define VScript menu func (caller + 11 args)")
	DEFINE_SCRIPTFUNC(SetKeyFunc12, "Define VScript menu func (caller + 12 args)")
END_SCRIPTDESC();

void VScriptMenu_Register(IScriptVM *vm) {
	vm->RegisterClass(GetScriptDescForClass(VScriptMenu));
	ScriptRegisterFunction(vm, UndispatchAllVScriptMenusByUserID, "Given a client ID, remove all VScript menus dispatched to the client.");
}

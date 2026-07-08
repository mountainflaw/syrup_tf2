#pragma once

#define MAX_KEYS 10

class TF2RecipientFilter : public IRecipientFilter {
public:
	TF2RecipientFilter(int client) {
		m_Recipients.AddToTail(client);
		m_bReliable = true;
	}

	bool IsReliable(void) const override { return true; }
	bool IsInitMessage(void) const override { return false; }
	int GetRecipientCount(void) const override { return m_Recipients.Count(); }
	int GetRecipientIndex(int slot) const override { return m_Recipients[slot]; }

private:
	bool m_bReliable;
	bool m_bInitMessage;
	CUtlVector<int> m_Recipients;
};

class MenuKey {
public:
	std::string text;
	std::string func;
	std::vector<ScriptVariant_t> args;

	MenuKey(std::string t, std::string f) {
		text = t;
		func = f;
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0) {
		text = t;
		func = f;
		args.emplace_back(a0);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
		args.emplace_back(a6);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
		args.emplace_back(a6);
		args.emplace_back(a7);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
		args.emplace_back(a6);
		args.emplace_back(a7);
		args.emplace_back(a8);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
		args.emplace_back(a6);
		args.emplace_back(a7);
		args.emplace_back(a8);
		args.emplace_back(a9);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
		args.emplace_back(a6);
		args.emplace_back(a7);
		args.emplace_back(a8);
		args.emplace_back(a9);
		args.emplace_back(a10);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10, ScriptVariant_t a11) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
		args.emplace_back(a6);
		args.emplace_back(a7);
		args.emplace_back(a8);
		args.emplace_back(a9);
		args.emplace_back(a10);
		args.emplace_back(a11);
	}

	MenuKey(std::string t, std::string f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10, ScriptVariant_t a11, ScriptVariant_t a12) {
		text = t;
		func = f;
		args.emplace_back(a0);
		args.emplace_back(a1);
		args.emplace_back(a2);
		args.emplace_back(a3);
		args.emplace_back(a4);
		args.emplace_back(a5);
		args.emplace_back(a6);
		args.emplace_back(a7);
		args.emplace_back(a8);
		args.emplace_back(a9);
		args.emplace_back(a10);
		args.emplace_back(a11);
		args.emplace_back(a12);
	}

	bool ExecuteKey(int client) {
		if (func == "NO_KEY" || func == "NO_KEY_DISABLED") {
			return false;
		}

		if (func == "EXIT") {
			return true;
		}

		HSCRIPT hServerExec = g_pVM->LookupFunction(func.c_str(), nullptr);
		
		if (hServerExec == NULL) {
			return false;
		}
		switch(args.size()) {
			case 0: g_pVM->Call(hServerExec, nullptr, true, nullptr, client); break;
			case 1: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0]); break;
			case 2: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1]); break;
			case 3: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2]); break;
			case 4: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3]); break;
			case 5: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4]); break;
			case 6: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5]); break;
			case 7: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5], args[6]); break;
			case 8: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]); break;
			case 9: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]); break;
			case 10: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]); break;
			case 11: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]); break;
			case 12: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]); break;
			case 13: g_pVM->Call(hServerExec, nullptr, true, nullptr, client, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]); break;
		}
		return true;
	}
};

class VScriptMenu {
private:
	int time;
	std::vector<MenuKey> keys;
	std::string combinedKeys = "";
public:
	int client;
	unsigned int timer = 0;
	VScriptMenu();
	bool Execute(unsigned int key);
	
	void SetTime(int t);
	void Dispatch(int c);
	void Display();

	bool TimerTick();

	void SetKeyFunc0(const char *k, const char *f);
	void SetKeyFunc1(const char *k, const char *f, ScriptVariant_t a0);
	void SetKeyFunc2(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1);
	void SetKeyFunc3(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2);
	void SetKeyFunc4(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3);
	void SetKeyFunc5(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4);
	void SetKeyFunc6(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5);
	void SetKeyFunc7(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6);
	void SetKeyFunc8(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7);
	void SetKeyFunc9(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8);
	void SetKeyFunc10(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9);
	void SetKeyFunc11(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10);
	void SetKeyFunc12(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10, ScriptVariant_t a11);
	void SetKeyFunc13(const char *k, const char *f, ScriptVariant_t a0, ScriptVariant_t a1, ScriptVariant_t a2, ScriptVariant_t a3, ScriptVariant_t a4, ScriptVariant_t a5, ScriptVariant_t a6, ScriptVariant_t a7, ScriptVariant_t a8, ScriptVariant_t a9, ScriptVariant_t a10, ScriptVariant_t a11, ScriptVariant_t a12);
};

extern std::vector<VScriptMenu> g_VScriptMenus;

void VScriptMenu_Register(IScriptVM *vm);
int FindVScriptMenuIndexByUserID(int client);
void UndispatchAllVScriptMenusByUserID(int client);

#include "syrup_vsp.h"

std::vector<VScriptTimer> s_VScriptTimers;

VScriptTimer::VScriptTimer(unsigned int tL, std::string n, std::string f, std::string a) {
	status = TIMER_RUNNING;
	name = n;
	func = f;
	args = a;
}
unsigned char VScriptTimer::CountDown() {
	if (status != TIMER_RUNNING) {
		cdfailsafe:
		return TIMER_RUNNING;
	}
	if (timeLeft-- <= 0 && g_pVM) {
		HSCRIPT hServerExec = g_pVM->LookupFunction("ServerExecuteFunction", nullptr);
		if (hServerExec) {
			g_pVM->Call(hServerExec, nullptr, true, nullptr, func.c_str(), args.c_str());
		} else {
			Msg("[Syrup2] No ServerExecuteFunction method found in VScript. Timer will not execute.\n");
		}
		return TIMER_FINISHED;
	}
	goto cdfailsafe;
}

std::string VScriptTimer::GetName() { return name; }
unsigned int VScriptTimer::GetTimeLeft() { return timeLeft; }
unsigned char VScriptTimer::GetStatus() { return status; }
void VScriptTimer::Pause() { status = TIMER_PAUSED; }
void VScriptTimer::Resume() { status = TIMER_RUNNING; }
void VScriptTimer::SetTimeLeft(unsigned int t) { timeLeft = t; }
void VScriptTimer::AddToTime(int t) { timeLeft += t; }

unsigned int VScript_TimerGetTimeLeft(unsigned int i) {
	if (i < 0 || i >= s_VScriptTimers.size()) {
		return 0;
	}
	return s_VScriptTimers[i].GetTimeLeft();
}

unsigned char VScript_TimerGetStatus(unsigned int i) {
	if (i < 0 || i >= s_VScriptTimers.size()) {
		return TIMER_RUNNING;
	}
	return s_VScriptTimers[i].GetTimeLeft();
}

void VScript_TimerPause(unsigned int i) {
	if (i < 0 || i >= s_VScriptTimers.size()) {
		return;
	}
	s_VScriptTimers[i].Pause();
}

void VScript_TimerResume(unsigned int i) {
	if (i < 0 || i >= s_VScriptTimers.size()) {
		return;
	}
	s_VScriptTimers[i].Resume();
}

void VScript_TimerSetTimeLeft(unsigned int i, unsigned int t) {
	if (i < 0 || i >= s_VScriptTimers.size()) {
		return;
	}
	s_VScriptTimers[i].SetTimeLeft(t);
}

void VScript_TimerAddToTime(unsigned int i, unsigned int t) {
	if (i < 0 || i >= s_VScriptTimers.size()) {
		return;
	}
	s_VScriptTimers[i].AddToTime(t);
}

char *VScript_TimerFindNameByIndex(unsigned int i) {
	if (i < 0 || i >= s_VScriptTimers.size()) {
		return NULL;
	}
	return (char *)s_VScriptTimers[i].GetName().c_str();
}

int VScript_TimerFindIndexByName(const char *n) {
	for (unsigned int i = 0; i < s_VScriptTimers.size(); i++) {
		if (n == s_VScriptTimers[i].GetName()) {
			return i;
		}
	}
	return -1;
}

unsigned int VScript_TimerCreate(unsigned int tL, const char *n, const char *f, const char *a) {
	s_VScriptTimers.emplace_back(VScriptTimer(tL, n, f, a));
	return s_VScriptTimers.size() - 1;
}

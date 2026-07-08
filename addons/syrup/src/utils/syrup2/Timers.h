#pragma once

#include <string>
#include <vector>

enum {
	TIMER_RUNNING,
	TIMER_PAUSED,
	TIMER_FINISHED
};

class VScriptTimer {
private:
	unsigned char status;
	unsigned int timeLeft;
	std::string name;
	std::string func;
	std::string args;
public:
	VScriptTimer(unsigned int tL, std::string n, std::string f, std::string a);
	unsigned char CountDown(); 
	std::string GetName();
	unsigned int GetTimeLeft();
	unsigned char GetStatus();
	void Pause();
	void Resume();
	void SetTimeLeft(unsigned int t);
	void AddToTime(int t);
};

unsigned int VScript_TimerGetTimeLeft(unsigned int i);
unsigned char VScript_TimerGetStatus(unsigned int i);
void VScript_TimerPause(unsigned int i);
void VScript_TimerResume(unsigned int i);
void VScript_TimerSetTimeLeft(unsigned int i, unsigned int t);
void VScript_TimerAddToTime(unsigned int i, unsigned int t);
char *VScript_TimerFindNameByIndex(unsigned int i);
int VScript_TimerFindIndexByName(const char *n);
unsigned int VScript_TimerCreate(unsigned int tL, const char *n, const char *f, const char *a);

extern std::vector<VScriptTimer> s_VScriptTimers;

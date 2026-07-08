#pragma once

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <dlfcn.h>
#include <unordered_map>
#include <string>
#include <vector>
#include <sys/mman.h>

#include "tier2/tier2.h"


#include "interface.h"
#include "filesystem.h"
#include "engine/iserverplugin.h"
#include "eiface.h"

#include "convar.h"
#include "Color.h"

#include "engine/IEngineTrace.h"

#include "irecipientfilter.h"
#include "igameevents.h"
#include "interface.h"
#include "eiface.h"
#include "engine/iserverplugin.h"
#include "vstdlib/random.h"
#include "vscript/ivscript.h"

#include "game/server/pluginvariant.h"
#include "game/server/iplayerinfo.h"
#include "game/server/ientityinfo.h"
#include "game/server/igameinfo.h"

extern IVEngineServer* g_pEngine;
extern IScriptVM *g_pVM;
extern IPlayerInfoManager *playerinfomanager;
void VScriptUserMessage_Register(IScriptVM *vm);
int UserIdToEntityIndex(int userID);

#include "Timers.h"
#include "Menu.h"

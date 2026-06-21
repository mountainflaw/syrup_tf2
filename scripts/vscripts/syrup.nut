/*
 * Copyright 2023 mountainflaw
 * 
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, this list of 
 * conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other
 * materials provided with the distribution.
 *
 * Neither the name of the copyright holder nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.[8]
 */

/*
 * Syrup VScript // Version 2.1
 *
 * Syrup is a simple failsafe SourceMod replacement written in VScript/Squirrel. In
 * addition to this, Syrup also provides a handful of additional features.
 *
 * Author: mountainflaw, with some special thanks to ficool2 for helping out with bits
 * and pieces.
 *
 * IMPORTANT: MAKE SURE TO SET sv_allow_point_servercommand.
 *
 * Commands can only be executed through chat on a barebones install, and players are targetted using user IDs
 * rather than usernames.
 * Installing the Syrup2 extension allows commands to be registered to client's consoles and executed there.
 *
 * Version 2.1:
 * Added command logging.
 * Added console command support through Syrup2 VSP addon.
 * - Registered automatically with chat commands, accessed through sy_X where X is the command.
 * - Example: sy_ls
 * Overhauls to many stock plugins:
 * - Kickban:
 * - - Moved to SendToConsoleServer because Valve broke SendToServerConsole
 * - Conditions:
 * - - Can now target other players than the caller.
 * - - Announces conditions added/removed.
 * - - Added condlist command.
 * - - Bounds checking.
 * - Map:
 * - - Fixed logging.
 * - Rcon:
 * - - Added rcon plugin. Provides admins an rcon command to execute commands on the server commandline.
 * - Skybox:
 * - - Now supports 3D skybox fog.
 * - -Fog is set using netprops and is persistent through use of the player_spawn game event.
 * - Chat:
 * - - Fixed csay causing a VScript error when no arguments are provided.
 * - - Added whisper command to privately send a message to another player on the server.
 * - Noclip:
 * - - Fixed a VScript error on execution.
 */

local adminsRaw = FileToString("admins.txt")
local admins = split(adminsRaw, "\n")

function IsClientAdmin(client, err) {
    local clientID = GetClientID(client)
    for (local i = 0; i < admins.len(); i++) {
//    LogPrivate(client, format("Permission debug: %s vs %s || Client ID: %d", GetClientID(client), admin[i], client))
        if (clientID == admins[i]) {
            return true
        }
    }
    if (err) {
        LogPrivate(client, "You do not have access to this command.")
    }
    return false
}

local commands = []

class Command {
    cmd = null
    func = null
    desc = null
    admin = null
    constructor(c, f, d, a) {
        cmd = c
        func = f
        desc = d
        admin = a
    }
    function Execute(caller, argv) {
        local clientID = GetClientID(caller) // we have to store these explicitly because vscript?
	local clientName = GetClientName(caller)
        if (!admin || IsClientAdmin(caller, true)) {
            printl(format("[Syrup] Player %s / %s executed command %s.", clientName, clientID, cmd))
            func(caller, argv)
        } else {
            printl(format("[Syrup] Player %s / %s attempted to execute admin command %s.", clientName, clientID, cmd))
	}
    }
}

function rfind(str, ch, start) {
    for (local i = start; i >= 0; i--)
    {
        if (str[i] == ch)
            return i;
    }
    return null;
}

function GetFunctionName(func) {
    local info = func.getinfos();
    if (info == null)
        return null;

    if (!("name" in info))
        return null;

    return info.name;
}


function RegisterCommand(cmd, func, desc) {
    commands.append(Command(cmd, func, desc, false))
    printl(GetFunctionName(func))
    VScript_RegisterConsoleCommand(cmd, GetFunctionName(func));
}

function RegisterAdminCommand(cmd, func, desc) {
    commands.append(Command(cmd, func, desc, true))
    VScript_RegisterConsoleCommand(cmd, GetFunctionName(func));
}

class Plugin {
    pN = null   // Name
    pV = null   // Version
    pA = null   // Author
    pD = null   // Description
    pTable = null
    constructor(file) {
        pTable = {}
        IncludeScript(format("plugins/%s.nut", file), pTable)
        pTable.OnPluginStart()
        pN = pTable.GetPluginProperty(0)
        pV = pTable.GetPluginProperty(1)
        pA = pTable.GetPluginProperty(2)
        pD = pTable.GetPluginProperty(3)

        printl(format("[Syrup] // Plugin %s %s (%s) by %s -- Loaded.", pN, pV, pD, pA))
    }
}

local pluginsRaw = FileToString("plugins.txt")
local plugin = split(pluginsRaw, "\n")
local plugins = []

for (local i = 0; i < plugin.len(); i++) {
    plugins.append(Plugin(plugin[i]))
}

local PlayerManager = Entities.FindByClassname(null, "tf_player_manager");

//::GetPlayerUserID <- function(player) {
function GetPlayerUserID(ply) {
    return NetProps.GetPropIntArray(PlayerManager, "m_iUserID", ply.entindex());
}

function LogPublic(msg) {
    ClientPrint(null, 3, format("[Syrup] // %s", msg))
}

function LogPrivate(client, msg) {
    ClientPrint(client, 3, format("\x03[Syrup] // %s", msg))
}

function IsClientValid(client) {
    return true
}

function GetClientName(client) {
    return NetProps.GetPropString(GetPlayerFromUserID(client), "m_szNetname")
}

function GetClientID(client) {
    return NetProps.GetPropString(GetPlayerFromUserID(client), "m_szNetworkIDString")
}

function ArgErrTooFew(client) {
    LogPrivate(client, "Error: Too few arguments.")
}

function ArgErrTooMany(client) {
    LogPrivate(client, "Error: Too many arguments.")
}

function ArgErrInvalid(client) {
    LogPrivate(client, "Error: Invalid argument(s).")
}

// Validates a string integer.
function ArgValidateInt(client, input) {
    try {
        input.tointeger()
    } catch(exception) {
        LogPrivate(client, "Error: Non-valid integer given as an argument.")
        return false
    }
    return true
}

// Validates input for single argument commands. (most of them)
function ArgValidateSingle(client, isInt, argv) {
    if (argv.len() < 2) {
        ArgErrTooFew(client)
        return false
    } else if (argv.len() > 2) {
        ArgErrTooMany(client)
        return false
    }
    if (isInt && !ArgValidateInt(client, argv[1])) {
        return false
    }
    return true
}

function OnGameEvent_player_say(data) {
    local client = data.userid
    local argv = split(data.text, " ")

    for (local i = 0; i < commands.len(); i++) {
        if (strip(argv[0]) == strip(format("?%s", commands[i].cmd))) {
            commands[i].Execute(client, argv)
            break
        }
    }
}

function CommandListPlayers(caller, argv) {
//    if (!IsClientAdmin(caller, true)) { // Usually unrestricted to make it easier to report cheaters.
//        return
//    }
    local pCount = 0
    for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++) {
        local ply = PlayerInstanceFromIndex(i)
        if (ply == null) continue
        local adminSymbol = ""

        if (IsClientAdmin(caller, false) && IsClientAdmin(GetPlayerUserID(ply), false)) {
            adminSymbol = " - [A]"
        }
        LogPrivate(caller, format("Player #%d - %s - %s%s", GetPlayerUserID(ply), GetClientName(GetPlayerUserID(ply)), GetClientID(GetPlayerUserID(ply)), adminSymbol))
        pCount++
    }

    LogPrivate(caller, format("There are \x01%d\x03 / \x01%d\x03 players currently connected.", pCount, MaxClients()))
}

function CommandHelp(caller, argv) {
    for (local i = 0; i < commands.len(); i++) {
        local adminSymbol = ""
        if (commands[i].admin) {
            adminSymbol = "[A]"
        }
        if (!commands[i].admin || IsClientAdmin(caller, false))
        LogPrivate(caller, format("%s ?%s - %s", adminSymbol, commands[i].cmd, commands[i].desc))
    }
}

// Wrapper for the Syrup Extensions VSP to execute forwarded concommands. The args are sent as a single string and formed into a list which is then passed as the real args to the command func.

function ServerExecuteCommand(caller, funcName, arg)
{
    local argv = split(arg, " ");

    for (local i = 0; i < commands.len(); i++)
    {
        local cmdObj = commands[i];

        // Get the actual function name from metadata
        local extracted = GetFunctionName(cmdObj.func);
        if (extracted == null)
            continue;

        // Compare against the incoming function name
        if (extracted == funcName)
        {
            cmdObj.Execute(caller, argv);
            return;
        }
    }
}

RegisterCommand("help", CommandHelp, "Displays the help menu.")
RegisterCommand("ls", CommandListPlayers, "Lists all currently connected players.")

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

LogPublic("This server is running Syrup Next 2.1 by mountainflaw.")

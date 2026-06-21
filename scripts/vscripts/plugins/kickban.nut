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

local pName = "Syrup Kick / Ban"
local pAuth = "mountainflaw"
local pVers = "1.1"
local pDesc = "Basic kick and ban commands."

// Version 1.1: Fixed ban overriding kick command.

function GetPluginProperty(prop) {
    switch (prop) {
        case 0: return pName
        case 1: return pVers
        case 2: return pAuth
        case 3: return pDesc
        default: return null
    }
}

function CommandKick(caller, argv) {
    local argFinal = ""
    if (argv.len() < 2) {
        ArgErrTooFew(caller)
        return
    } else if (argv.len() < 3) { // Default kick reason
        argFinal = "Kicked by server administrator"
    } else {
        argFinal += argv[2]
        for (local i = 3; i < argv.len(); i++) {
            argFinal += " " + argv[i]
        }
    }
    
    if (!ArgValidateInt(caller, argv[1])) {
        return
    }
    printl(format("kickid %s %s", argv[1], argFinal))
    SendToConsoleServer(format("kickid %s %s", argv[1], argFinal))
}

function CommandBan(caller, argv) {
    local argFinal = ""
    if (argv.len() < 2) {
        ArgErrTooFew(caller)
        return
    } else if (argv.len() < 3) { // Default kick reason
        argFinal = "Banned by server administrator"
    } else {
        argFinal += argv[2]
        for (local i = 3; i < argv.len(); i++) {
            argFinal += " " + argv[i]
        }
    }
    
    if (!ArgValidateInt(caller, argv[1])) {
        return
    }
    SendToConsoleServer(format("banid %s %s", argv[1], argFinal))
}


function OnPluginStart() {
    RegisterAdminCommand("kick", CommandKick, "Kicks a currently connected player. Can specify a reason if wanted.")
    RegisterAdminCommand("ban", CommandBan, "Bans a currently connected player. Can specify a reason if wanted.")
}

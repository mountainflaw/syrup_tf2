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

local pName = "Syrup Map"
local pAuth = "mountainflaw"
local pVers = "1.1"
local pDesc = "Basic map command."

// Version 1.1: Switched to SendToConsoleServer. They somehow broke the other server console func???
//              - Moved LogPublic to before the concommand is executed so it would be logged.

function GetPluginProperty(prop) {
    switch (prop) {
        case 0: return pName
        case 1: return pVers
        case 2: return pAuth
        case 3: return pDesc
        default: return null
    }
}

function CommandMap(caller, argv) {
    if (ArgValidateSingle(caller, false, argv)) {
        LogPublic(format("%s is changing the map to %s.", GetClientName(caller), argv[1]))
        SendToConsoleServer(format("changelevel %s", argv[1]))
    }
}

function OnPluginStart() {
    RegisterAdminCommand("map", CommandMap, "Changes the map to the one specified.")
}

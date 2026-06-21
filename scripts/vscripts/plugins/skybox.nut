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

// Version 1.1: Added fog adjustments and persistence.

local pName = "Syrup Skybox"
local pAuth = "mountainflaw"
local pVers = "1.1"
local pDesc = "Basic skybox commands."

function GetPluginProperty(prop) {
    switch (prop) {
        case 0: return pName
        case 1: return pVers
        case 2: return pAuth
        case 3: return pDesc
        default: return null
    }
}

class Skybox {
    realName = null
    voteName = null

    red = null
    green = null
    blue = null

    fogStart = null
    fogEnd = null

    constructor(r, v, cr, cg, cb, f0, f1) {
        realName = r
        voteName = v
	red = cr
	green = cg
	blue = cb
	fogStart = f0
	fogEnd = f1
    }
}

class PersistentFog {
    red = null
    green = null
    blue = null
    fogStart = null
    fogEnd = null
    active = false
    constructor(r, g, b, f0, f1) {
        red = r
	green = g
	blue = b
	fogStart = f0
	fogEnd = f1
    }
}

local fogPersistence = PersistentFog(0, 0, 0, 0, 0)

local skyList = [
    Skybox("sky_dustbowl_01",        "Dustbowl",       164, 199, 214, 8000, 10000), // 164 199 214 164 199 214 8000 10000
    Skybox("sky_granary_01",         "Granary",        209 207, 191,  5000, 10000), // 209 207 191 209 207 191 5000 10000
    Skybox("sky_gravel_01",          "Gravelpit",      117, 109, 111, 4000, 9000), // 117 109 111 117 109 111 4000 9000
    Skybox("sky_well_01",            "Well",           119, 109, 133, 5000, 8000), // 119 109 133 119 109 133 5000 8000
    Skybox("sky_tf2_04",             "2Fort",          124, 167, 197, 7600, 10000), // 124 167 197 124 167 197 7600 10000
    Skybox("sky_hydro_01",           "Hydro",          185, 197, 201, 5000, 11000), // 185 197 201 185 197 201 5000 11000
    Skybox("sky_badlands_01",        "Badlands",       124, 113, 123, 4000, 11000), // 124 113 123 124 113 123 4000 11000
    Skybox("sky_goldrush_01",        "Goldrush",       184, 179, 161, 4000, 11000), // 184 179 161 184 179 161 4000 11000
    Skybox("sky_trainyard_01",       "Process",        156, 179, 199, 3000, 11000), // 156 179 199 156 179 199 3000 11000
    Skybox("sky_night_01",           "Metalworks",     64,  65,  79,  8000, 15000), // 64 65 79 64 65 79 8000 15000
    Skybox("sky_alpinestorm_01",     "Mannworks",      71,  77,  84,  2000, 13000), // 71 77 84 71 77 84 2000 13000
    Skybox("sky_morningsnow_01",     "Viaduct",        173, 167, 193, 2000, 13000), // 173 167 193 173 167 193 2000 13000
    Skybox("sky_nightfall_01",       "Doublecross",    11,  12,  13,  1000, 6000), // 248 197 139 248 197 139 1000 6000
    Skybox("sky_harvest_01",         "Harvest",        204, 175, 127, 4000, 15000), // 204 175 127 204 175 127 4000 15000
    Skybox("sky_harvest_night_01",   "Harvest_Event",  75,  44,  65,  4000, 15000), // 75 44 65 75 44 65 4000 15000
    Skybox("sky_upward",             "Upward",         117, 147, 170, 4000, 15000), // 117 147 170 117 147 170 4000 15000
    Skybox("sky_stormfront_01",      "Coldfront",      182, 187, 211, 2000, 13000), // 182 187 211 182 187 211 2000 13000
    Skybox("sky_halloween",          "Halloween",      16,  16,  22,  1000, 6000), // 16 16 22 16 16 22 1000 6000
    Skybox("sky_halloween_night_01", "Helltower",      14,  15,  18,  1000, 6000), // 14 15 18 14 15 18 1000 6000
    Skybox("sky_island_01",          "Mercenary_Park", 111, 116, 121, 4000, 15000), // 111 116 121 111 116 121 4000 15000
    Skybox("sky_day01_01",           "Target",         142, 143, 142, 5000, 16000) // 142 143 142 142 143 142 5000 16000
]

function CommandListSkyboxes(caller, argv) {
    for (local i = 0; i < skyList.len(); i++) {
        LogPrivate(caller, format("%s - %s", skyList[i].voteName, skyList[i].realName))
    }
}

local function SetSkyboxFog(client, r, g, b, f0, f1) {
    local ply = GetPlayerFromUserID(client)
    local fog = (r) | (g << 8) | (b << 16) | (0xFF << 24);
    NetProps.SetPropInt(ply, "m_Local.m_skybox3d.fog.colorPrimary", fog);
    NetProps.SetPropInt(ply, "m_Local.m_skybox3d.fog.colorPrimaryHdr", fog);
    NetProps.SetPropInt(ply, "m_Local.m_skybox3d.fog.colorSecondary", fog);
    NetProps.SetPropInt(ply, "m_Local.m_skybox3d.fog.colorSecondaryHdr", fog);
    NetProps.SetPropFloat(ply, "m_Local.m_skybox3d.fog.start", f0);
    NetProps.SetPropFloat(ply, "m_Local.m_skybox3d.fog.end", f1);
}

::SkyboxEventTable <- { // We setup a class earlier to enable fog persistence within the current map load. This will sync newly connected clients to the new fog values.
    function OnGameEvent_player_spawn(data) {
        if (fogPersistence.active) {
            SetSkyboxFog(data.userid, fogPersistence.red, fogPersistence.green, fogPersistence.blue, fogPersistence.fogStart, fogPersistence.fogEnd)
        }
    }
}

function CommandSkybox(caller, argv) {
    if (ArgValidateSingle(caller, false, argv)) {
        for (local i = 0; i < skyList.len(); i++) {
            if (argv[1].tolower() == skyList[i].voteName.tolower()) {
                LogPublic(format("%s has changed the skybox texture to %s.", GetClientName(caller), skyList[i].voteName))

                for (local j = 1; j <= Constants.Server.MAX_PLAYERS; j++) {
                    local ply = GetPlayerFromUserID(j)
		    if (ply != null) {
                        fogPersistence.red = skyList[i].red
                        fogPersistence.green = skyList[i].green
                        fogPersistence.blue = skyList[i].blue
                        fogPersistence.fogStart = skyList[i].fogStart
                        fogPersistence.fogEnd = skyList[i].fogEnd
			fogPersistence.active = true
                        SetSkyboxFog(j, skyList[i].red, skyList[i].green, skyList[i].blue, skyList[i].fogStart, skyList[i].fogEnd)
                        __CollectGameEventCallbacks(SkyboxEventTable) // Enable persistence
		    }
                }

                SetSkyboxTexture(skyList[i].realName)
                return
            }
        }
        LogPrivate(caller, format("Error: Skybox %s is not a valid skybox. Use ?skybox to list available skyboxes.", argv[1]))
    }
}

function OnPluginStart() {
    RegisterAdminCommand("skybox", CommandSkybox, "Changes the skybox the specified texture.")
    RegisterCommand("skylist", CommandListSkyboxes, "Lists available skybox textures.")
}

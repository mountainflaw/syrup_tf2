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
 * 1.1
 * Added multi-arg cmd variant.
 * Added public announcing of add/removecond with condition names.
 * Added bounds checking.
 * Added condlist.
 */

local pName = "Syrup Conditions"
local pAuth = "mountainflaw"
local pVers = "1.1"
local pDesc = "Basic add / remove TF2 condition commands."

function GetPluginProperty(prop) {
    switch (prop) {
        case 0: return pName
        case 1: return pVers
        case 2: return pAuth
        case 3: return pDesc
        default: return null
    }
}

class ConditionTypes {
    realName = null
    niceName = null
    constructor(r, n) {
        realName = r
        niceName = n
    }
}

local conditionList = [
    ConditionTypes("TF_COND_AIMING", "Aiming"),
    ConditionTypes("TF_COND_ZOOMED", "Sniper Rifle Zoom"),
    ConditionTypes("TF_COND_DISGUISING", "Disguising"),
    ConditionTypes("TF_COND_DISGUISED", "Disguised"),
    ConditionTypes("TF_COND_STEALTHED", "Cloaked"),
    ConditionTypes("TF_COND_INVULNERABLE", "Ubercharged"),
    ConditionTypes("TF_COND_TELEPORTED", "Teleported"),
    ConditionTypes("TF_COND_TAUNTING", "Taunting"),
    ConditionTypes("TF_COND_INVULNERABLE_WEARINGOFF", "Ubercharge Flicker"),
    ConditionTypes("TF_COND_STEALTHED_BLINK", "Semi-Cloaked"),
    ConditionTypes("TF_COND_SELECTED_TO_TELEPORT", "Teleporting"),
    ConditionTypes("TF_COND_CRITBOOSTED", "Crits (Broken)"),
    ConditionTypes("TF_COND_TMPDAMAGEBONUS", "Damage Buff (Broken)"),
    ConditionTypes("TF_COND_FEIGN_DEATH", "Dead-Ringer Feign"),
    ConditionTypes("TF_COND_PHASE", "Bonk! Atomic Punch"),
    ConditionTypes("TF_COND_STUNNED", "Movement Stun"),
    ConditionTypes("TF_COND_OFFENSEBUFF", "Buff-Banner Minicrits"),
    ConditionTypes("TF_COND_SHIELD_CHARGE", "Shield Charge"),
    ConditionTypes("TF_COND_DEMO_BUFF", "Eyelander Buff"),
    ConditionTypes("TF_COND_ENERGY_BUFF", "Self-Minicrits"),
    ConditionTypes("TF_COND_RADIUSHEAL", "Amputator Medicating Melody"),
    ConditionTypes("TF_COND_HEALTH_BUFF", "Continous Healing"),
    ConditionTypes("TF_COND_BURNING", "Burning"),
    ConditionTypes("TF_COND_HEALTH_OVERHEALED", "Overhealed"),
    ConditionTypes("TF_COND_URINE", "Jarate"),
    ConditionTypes("TF_COND_BLEEDING", "Bleeding"),
    ConditionTypes("TF_COND_DEFENSEBUFF", "Battalion's Backup"),
    ConditionTypes("TF_COND_MAD_MILK", "Mad Milk"),
    ConditionTypes("TF_COND_MEGAHEAL", "Quick-Fix Uber Effects"),
    ConditionTypes("TF_COND_REGENONDAMAGEBUFF", "Concheror Buff"),
    ConditionTypes("TF_COND_MARKEDFORDEATH", "Marked For Death"),
    ConditionTypes("TF_COND_NOHEALINGDAMAGEBUFF", "Minicrits + No Healing"),
    ConditionTypes("TF_COND_SPEED_BOOST", "Speed Boost"),
    ConditionTypes("TF_COND_CRITBOOSTED_PUMPKIN", "Crits (Halloween Pumpkin)"),
    ConditionTypes("TF_COND_CRITBOOSTED_USER_BUFF", "Crits (MvM Canteen)"),
    ConditionTypes("TF_COND_CRITBOOSTED_DEMO_CHARGE", "Crits (Shield Charge)"),
    ConditionTypes("TF_COND_SODAPOPPER_HYPE", "Hype"),
    ConditionTypes("TF_COND_CRITBOOSTED_FIRST_BLOOD", "Crits (First Blood)"),
    ConditionTypes("TF_COND_CRITBOOSTED_BONUS_TIME", "Crits (Victory)"),
    ConditionTypes("TF_COND_CRITBOOSTED_CTF_CAPTURE", "Crits (Flag Capture)"),
    ConditionTypes("TF_COND_CRITBOOSTED_ON_KILL", "Crits (Crit-On-Kill Weapons)"),
    ConditionTypes("TF_COND_CANNOT_SWITCH_FROM_MELEE", "Melee Only"),
    ConditionTypes("TF_COND_DEFENSEBUFF_NO_CRIT_BLOCK", "Bomb-Carrier Defense Buff"),
    ConditionTypes("TF_COND_REPROGRAMMED", "Reprogrammed"),
    ConditionTypes("TF_COND_CRITBOOSTED_RAGE_BUFF", "Crits (Phlogistinator)"),
    ConditionTypes("TF_COND_DEFENSEBUFF_HIGH", "Phlogistinator Defense Buff"),
    ConditionTypes("TF_COND_SNIPERCHARGE_RAGE_BUFF", "Hitman's Heatmaker Focus"),
    ConditionTypes("TF_COND_DISGUISE_WEARINGOFF", "Disguise Wearing Off"),
    ConditionTypes("TF_COND_MARKEDFORDEATH_SILENT", "Self Marked-For-Death"),
    ConditionTypes("TF_COND_DISGUISED_AS_DISPENSER", "Disguised As Dispenser"),
    ConditionTypes("TF_COND_SAPPED", "MvM Robot Sapped"),
    ConditionTypes("TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED", "Ubercharged (MvM Robot Spawn)"),
    ConditionTypes("TF_COND_INVULNERABLE_USER_BUFF", "Ubercharged (MvM Canteen)"),
    ConditionTypes("TF_COND_HALLOWEEN_BOMB_HEAD", "Halloween Bomb Head"),
    ConditionTypes("TF_COND_HALLOWEEN_THRILLER", "Thriller Dance"),
    ConditionTypes("TF_COND_RADIUSHEAL_ON_DAMAGE", "Amputator Medicating Melody Full Effects"),
    ConditionTypes("TF_COND_CRITBOOSTED_CARD_EFFECT", "Crits (Wheel-Of-Doom)"),
    ConditionTypes("TF_COND_INVULNERABLE_CARD_EFFECT", "Ubercharged (Wheel-Of-Doom)"),
    ConditionTypes("TF_COND_MEDIGUN_UBER_BULLET_RESIST", "Vaccinator Ubercharge Bullet Resistance"),
    ConditionTypes("TF_COND_MEDIGUN_UBER_BLAST_RESIST", "Vaccinator Ubercharge Blast Resistance"),
    ConditionTypes("TF_COND_MEDIGUN_UBER_FIRE_RESIST", "Vaccinator Ubercharge Fire Resistance"),
    ConditionTypes("TF_COND_MEDIGUN_SMALL_BULLET_RESIST", "Vaccinator Passive Bullet Resistance"),
    ConditionTypes("TF_COND_MEDIGUN_SMALL_BLAST_RESIST", "Vaccinator Passive Blast Resistance"),
    ConditionTypes("TF_COND_MEDIGUN_SMALL_FIRE_RESIST", "Vaccinator Passive Fire Resistance"),
    ConditionTypes("TF_COND_STEALTHED_USER_BUFF", "Cloak (Halloween Spell)"),
    ConditionTypes("TF_COND_MEDIGUN_DEBUFF", "Medigun Debuff (Broken)"),
    ConditionTypes("TF_COND_STEALTHED_USER_BUFF_FADING", "Cloak (Halloween Spell) (Fading)"),
    ConditionTypes("TF_COND_BULLET_IMMUNE", "Immune To Bullet Damage"),
    ConditionTypes("TF_COND_BLAST_IMMUNE", "Immune To Blast Damage"),
    ConditionTypes("TF_COND_FIRE_IMMUNE", "Immune To Fire Damage"),
    ConditionTypes("TF_COND_PREVENT_DEATH", "Buddha Effect"),
    ConditionTypes("TF_COND_MVM_BOT_STUN_RADIOWAVE", "MvM Robot Capture Stun"),
    ConditionTypes("TF_COND_HALLOWEEN_SPEED_BOOST", "Minify Magic Spell"),
    ConditionTypes("TF_COND_HALLOWEEN_QUICK_HEAL", "Healing Aura Magic Spell"),
    ConditionTypes("TF_COND_HALLOWEEN_GIANT", "Medieval Third Person Shoulder View"),
    ConditionTypes("TF_COND_HALLOWEEN_TINY", "Bumper Car Player Effects"),
    ConditionTypes("TF_COND_HALLOWEEN_IN_HELL", "Helltower In Hell"),
    ConditionTypes("TF_COND_HALLOWEEN_GHOST_MODE", "Halloween Ghost"),
    ConditionTypes("TF_COND_MINICRITBOOSTED_ON_KILL", "Minicrits (Minicrits On Kill Weapons"),
    ConditionTypes("TF_COND_OBSCURED_SMOKE", "Semi-Bonk! Atomic Punch"),
    ConditionTypes("TF_COND_PARACHUTE_ACTIVE", "Parachuting"),
    ConditionTypes("TF_COND_BLASTJUMPING", "Blast Jumping"),
    ConditionTypes("TF_COND_HALLOWEEN_KART", "Bumper Cart"),
    ConditionTypes("TF_COND_HALLOWEEN_KART_DASH", "Bumper Cart (Speed Boost)"),
    ConditionTypes("TF_COND_BALLOON_HEAD", "Balloon Head"),
    ConditionTypes("TF_COND_MELEE_ONLY", "Melee Only (Halloween)"),
    ConditionTypes("TF_COND_SWIMMING_CURSE", "Swimming Curse (Halloween)"),
    ConditionTypes("TF_COND_FREEZE_INPUT", "Frozen Player"),
    ConditionTypes("TF_COND_HALLOWEEN_KART_CAGE", "CoC Bumper Cart Cage"),
    ConditionTypes("TF_COND_DONOTUSE_0", "Mannpower Holding Powerup"),
    ConditionTypes("TF_COND_RUNE_STRENGTH", "Mannpower Strength Powerup"),
    ConditionTypes("TF_COND_RUNE_HASTE", "Mannpower Haste Powerup"),
    ConditionTypes("TF_COND_RUNE_REGEN", "Mannpower Regen Powerup"),
    ConditionTypes("TF_COND_RUNE_RESIST", "Mannpower Resistance Powerup"),
    ConditionTypes("TF_COND_RUNE_VAMPIRE", "Mannpower Vampire Powerup"),
    ConditionTypes("TF_COND_RUNE_REFLECT", "Mannpower Reflect Powerup"),
    ConditionTypes("TF_COND_RUNE_PRECISION", "Mannpower Precision Powerup"),
    ConditionTypes("TF_COND_RUNE_AGILITY", "Mannpower Agility Powerup"),
    ConditionTypes("TF_COND_GRAPPLINGHOOK", "Grappling Hook Fired"),
    ConditionTypes("TF_COND_GRAPPLINGHOOK_SAFEFALL", "Grappling Hook Pulling"),
    ConditionTypes("TF_COND_GRAPPLINGHOOK_LATCHED", "Grappling Hook Latched"),
    ConditionTypes("TF_COND_GRAPPLINGHOOK_BLEEDING", "Grappling Hook Bleeding"),
    ConditionTypes("TF_COND_AFTERBURN_IMMUNE", "Immune To Afterburn"),
    ConditionTypes("TF_COND_RUNE_KNOCKOUT", "Mannpower Knockout Powerup"),
    ConditionTypes("TF_COND_RUNE_IMBALANCE", "Mannpower Revenge Powerup"),
    ConditionTypes("TF_COND_CRITBOOSTED_RUNE_TEMP", "Crits (Mannpower Powerup)"),
    ConditionTypes("TF_COND_PASSTIME_INTERCEPTION", "Passtime Jack Interception"),
    ConditionTypes("TF_COND_SWIMMING_NO_EFFECTS", "Swim In Air"),
    ConditionTypes("TF_COND_PURGATORY", "Player In Halloween Underworld"),
    ConditionTypes("TF_COND_RUNE_KING", "Mannpower King Powerup"),
    ConditionTypes("TF_COND_RUNE_PLAGUE", "Mannpower Plague Powerup"),
    ConditionTypes("TF_COND_RUNE_SUPERNOVA", "Mannpower Supernova Powerup"),
    ConditionTypes("TF_COND_PLAGUE", "Affected By Mannpower Plague Powerup"),
    ConditionTypes("TF_COND_KING_BUFFED", "Mannpower King Powerup AoE Buff"),
    ConditionTypes("TF_COND_TEAM_GLOWS", "Respawn Team Glow"),
    ConditionTypes("TF_COND_KNOCKED_INTO_AIR", "Airborne From Airblast"),
    ConditionTypes("TF_COND_COMPETITIVE_WINNER", "Competitive Mode Winner"),
    ConditionTypes("TF_COND_COMPETITIVE_LOSER", "Competitive Mode Loser"),
    ConditionTypes("TF_COND_HEALING_DEBUFF", "Healing Debuff"),
    ConditionTypes("TF_COND_PASSTIME_PENALTY_DEBUFF", "Passtime Penalty"),
    ConditionTypes("TF_COND_GRAPPLED_TO_PLAYER", "Grappled To Player"),
    ConditionTypes("TF_COND_GRAPPLED_BY_PLAYER", "Grappled By Player"),
    ConditionTypes("TF_COND_PARACHUTE_DEPLOYED", "Parachute Deployed"),
    ConditionTypes("TF_COND_GAS", "Coated In Gas"),
    ConditionTypes("TF_COND_BURNING_PYRO", "Pyro Afterburn"),
    ConditionTypes("TF_COND_ROCKETPACK", "Thermal Thruster Jump"),
    ConditionTypes("TF_COND_LOST_FOOTING", "Low Friction"),
    ConditionTypes("TF_COND_AIR_CURRENT", "Air Current Movement"),
    ConditionTypes("TF_COND_HALLOWEEN_HELL_HEAL", "Hell Healing"),
    ConditionTypes("TF_COND_POWERUPMODE_DOMINANT", "Mannpower Top Scorer Debuff"),
    ConditionTypes("TF_COND_IMMUNE_TO_PUSHBACK", "Immune To Knockback"),
]

local function IsConditionValid(caller, cond) {
    if (cond < 0 || cond > conditionList.len() - 1) {
        LogPrivate(caller, format("Condition %i is out of range. Refer to ?condlist for valid conditions.", cond))
	return false
    }
    return true
}

function CommandListConditions(caller, argv) {
    for (local i = 0; i < conditionList.len(); i++) {
        LogPrivate(caller, format("%i - %s - %s", i, conditionList[i].niceName, conditionList[i].realName))
    }
}

//argc = 2
// argv[1]: player
// argv[2]: condition

//argc = 1
// argv[1] = condition

function CommandAddCondition(caller, argv) {
    if (argv.len() > 2 && ArgValidateInt(caller, argv[1]) && ArgValidateInt(caller, argv[2]) && IsConditionValid(caller, argv[2].tointeger())) {
        local ply = GetPlayerFromUserID(argv[1].tointeger())
        ply.AddCond(argv[2].tointeger())
        LogPublic(format("%s added condition %s / %s to %s.", GetClientName(caller), conditionList[argv[2].tointeger()].realName, conditionList[argv[2].tointeger()].niceName, GetClientName(argv[1].tointeger())))
    } else if (ArgValidateSingle(caller, true, argv) && IsConditionValid(caller, argv[1].tointeger())) {
        local ply = GetPlayerFromUserID(caller)
        ply.AddCond(argv[1].tointeger())
        LogPublic(format("%s added condition %s / %s to themselves.", GetClientName(caller), conditionList[argv[1].tointeger()].realName, conditionList[argv[1].tointeger()].niceName))
    }
}

function CommandRemoveCondition(caller, argv) {
    if (argv.len() > 2 && ArgValidateInt(caller, argv[1]) && ArgValidateInt(caller, argv[2]) && IsConditionValid(caller, argv[2].tointeger())) {
        local ply = GetPlayerFromUserID(argv[1].tointeger())
        ply.RemoveCond(argv[2].tointeger())
        LogPublic(format("%s removed condition %s / %s to %s.", GetClientName(caller), conditionList[argv[2].tointeger()].realName, conditionList[argv[2].tointeger()].niceName, GetClientName(argv[1].tointeger())))
    } else if (ArgValidateSingle(caller, true, argv) && IsConditionValid(caller, argv[1].tointeger())) {
        local ply = GetPlayerFromUserID(caller)
        ply.RemoveCond(argv[1].tointeger())
        LogPublic(format("%s removed condition %s / %s to themselves.", GetClientName(caller), conditionList[argv[1].tointeger()].realName, conditionList[argv[1].tointeger()].niceName))
    }
}

function OnPluginStart() {
    RegisterAdminCommand("addcond", CommandAddCondition, "Adds a condition to command issuer or another user.")
    RegisterAdminCommand("removecond", CommandRemoveCondition, "Removes a condition to command issuer or another user.")
    RegisterCommand("condlist", CommandListConditions, "List conditions.")
}

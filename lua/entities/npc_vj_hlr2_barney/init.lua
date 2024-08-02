AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/barney.mdl" -- Model(s) to spawn with | Picks a random one if it's a table 
ENT.StartHealth = 100
ENT.HasHealthRegeneration = true -- Can the NPC regenerate its health?
ENT.HealthRegenerationAmount = 1 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ.SET(0.35,0.35) -- How much time until the health increases
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this NPC be friends with other player allies?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.AnimTbl_MeleeAttack = "vjseq_MeleeAttack01" -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the NPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = ACT_RANGE_ATTACK_THROW -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 0.87 -- Time until the grenade is released
ENT.GrenadeAttackAttachment = "anim_attachment_RH" -- The attachment that the grenade will spawn at
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_Idle = {
	"vo/streetwar/sniper/ba_hauntsme.wav",
}
ENT.SoundTbl_IdleDialogue = {
	"vo/k_lab/ba_itsworking04.wav",
	"vo/streetwar/sniper/ba_hearcat.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_knowevac.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vo/k_lab/ba_saidlasttime.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_deceiving01.wav",
}
ENT.SoundTbl_CombatIdle = {
	"vo/npc/barney/ba_goingdown.wav",
	"vo/streetwar/rubble/ba_damnitall.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_comeon01.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_herewego.wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"vo/npc/barney/ba_imwithyou.wav",
}
ENT.SoundTbl_FollowPlayer = {
	"vo/npc/barney/ba_imwithyou.wav",
	"vo/npc/barney/ba_letsdoit.wav",
	"vo/npc/barney/ba_letsgo.wav",
	"vo/npc/barney/ba_oldtimes.wav",
	"vo/k_lab2/ba_goodnews_c.wav",
	"vo/streetwar/nexus/ba_thenletsgo.wav",
	"vo/streetwar/sniper/ba_letsgetgoing.wav",
}
ENT.SoundTbl_UnFollowPlayer = {
	"vo/npc/barney/ba_hurryup.wav",
	"vo/k_lab/ba_dontblameyou.wav",
	"vo/k_lab/ba_geethanks.wav",
	"vo/k_lab/ba_getoutofsight02.wav",
	"vo/k_lab/ba_goodluck02.wav",
	"vo/trainyard/ba_goodluck01.wav",
	"vo/trainyard/ba_meetyoulater01.wav",
	"vo/streetwar/nexus/ba_seeyou.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_areyousure.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_dontletmedown.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_donttakelong.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_ifyousayso.wav",
	"vo/streetwar/rubble/ba_seeya.wav",
}
ENT.SoundTbl_MoveOutOfPlayersWay = {
	"vo/k_lab/ba_whoops.wav",
}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {
	"vo/npc/barney/ba_followme01.wav",
	"vo/npc/barney/ba_followme02.wav",
	"vo/npc/barney/ba_followme03.wav",
	"vo/npc/barney/ba_followme05.wav",
	"vo/k_lab/ba_thereyouare.wav",
	"vo/trainyard/ba_heygordon.wav",
	"vo/trainyard/ba_rememberme.wav",
	"vo/streetwar/rubble/ba_gordon.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_greeting01.wav",
}
ENT.SoundTbl_Investigate = {
	"vo/npc/barney/ba_danger02.wav",
	"vo/k_lab/ba_whatthehell.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vo/k_lab/ba_whatthehell.wav",
}
ENT.SoundTbl_Alert = {
	"vo/npc/barney/ba_bringiton.wav",
	"vo/npc/barney/ba_hereitcomes.wav",
	"vo/npc/barney/ba_heretheycome01.wav",
	"vo/npc/barney/ba_heretheycome02.wav",
	"vo/npc/barney/ba_openfiregord.wav",
	"vo/npc/barney/ba_uhohheretheycome.wav",
	"vo/k_lab2/ba_incoming.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vo/npc/barney/ba_gordonhelp.wav",
	"vo/npc/barney/ba_littlehelphere.wav",
	"vo/streetwar/nexus/ba_surrounded.wav",
	"vo/streetwar/rubble/ba_helpmeout.wav",
	"vo/streetwar/sniper/ba_overhere.wav",
}
ENT.SoundTbl_BecomeEnemyToPlayer = {
	"vj_hlr/hl2_npc/barney/ba_fuckyou.wav"
}
ENT.SoundTbl_Suppressing = {
	"vj_hlr/hl2_npc/barney/ba_fuckyou.wav",
}
ENT.SoundTbl_WeaponReload = {
	"vo/npc/barney/ba_covermegord.wav",
	"vo/npc/barney/ba_damnit.wav",
	"vo/k_lab/ba_getitoff01.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {}
ENT.SoundTbl_OnGrenadeSight = {
	"vo/npc/barney/ba_damnit.wav",
	"vo/npc/barney/ba_duck.wav",
	"vo/npc/barney/ba_getaway.wav",
	"vo/npc/barney/ba_getdown.wav",
	"vo/npc/barney/ba_getoutofway.wav",
	"vo/npc/barney/ba_grenade01.wav",
	"vo/npc/barney/ba_grenade02.wav",
	"vo/npc/barney/ba_lookout.wav",
	"vo/k_lab/ba_headhumper02.wav",
	"vo/k_lab/ba_thingaway02.wav",
}
ENT.SoundTbl_OnDangerSight = {
	"vo/npc/barney/ba_damnit.wav",
	"vo/npc/barney/ba_duck.wav",
	"vo/npc/barney/ba_getaway.wav",
	"vo/npc/barney/ba_getdown.wav",
	"vo/npc/barney/ba_getoutofway.wav",
	"vo/npc/barney/ba_lookout.wav",
	"vo/k_lab/ba_headhumper02.wav",
	"vo/k_lab/ba_thingaway02.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vo/npc/barney/ba_downyougo.wav",
	"vo/npc/barney/ba_gotone.wav",
	"vo/npc/barney/ba_laugh01.wav",
	"vo/npc/barney/ba_laugh02.wav",
	"vo/npc/barney/ba_laugh03.wav",
	"vo/npc/barney/ba_laugh04.wav",
	"vo/npc/barney/ba_losttouch.wav",
	"vo/npc/barney/ba_ohyeah.wav",
	"vo/npc/barney/ba_yell.wav",
	"vo/streetwar/nexus/ba_alldown.wav",
	"vo/streetwar/nexus/ba_done.wav",
	"vo/streetwar/sniper/ba_onedownonetogo.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_hellyeah.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_ohyeah01.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_woo.wav",
	"vj_hlr/hl2_npc/ep1/c17/ba_yeah01.wav",
}
ENT.SoundTbl_AllyDeath = {
	"vo/k_lab/ba_cantlook.wav",
	"vo/k_lab/ba_guh.wav",
	"vo/streetwar/rubble/ba_damnitall.wav",
}
ENT.SoundTbl_Pain = {
	"vo/npc/barney/ba_damnit.wav",
	"vo/npc/barney/ba_pain01.wav",
	"vo/npc/barney/ba_pain02.wav",
	"vo/npc/barney/ba_pain03.wav",
	"vo/npc/barney/ba_pain04.wav",
	"vo/npc/barney/ba_pain05.wav",
	"vo/npc/barney/ba_pain06.wav",
	"vo/npc/barney/ba_pain07.wav",
	"vo/npc/barney/ba_pain08.wav",
	"vo/npc/barney/ba_pain09.wav",
	"vo/npc/barney/ba_pain10.wav",
	"vo/npc/barney/ba_wounded01.wav",
	"vo/npc/barney/ba_wounded02.wav",
	"vo/npc/barney/ba_wounded03.wav",
}
ENT.SoundTbl_DamageByPlayer = {
	"vo/k_lab/ba_notime.wav",
	"vo/k_lab/ba_notimetofool01.wav",
	"vo/k_lab/ba_notimetofool02.wav",
	"vo/k_lab/ba_pissinmeoff.wav",
	"vo/k_lab/ba_pushinit.wav",
}
ENT.SoundTbl_Death = {
	"vo/npc/barney/ba_no01.wav",
	"vo/npc/barney/ba_no02.wav",
	"vo/npc/barney/ba_ohshit03.wav",
}

-- Specific alert sounds
local sdAlertHuman = {"vo/npc/barney/ba_soldiers.wav"}
local sdAlertGunship = {"vj_hlr/hl2_npc/ep1/c17/ba_wrinkleship.wav"}
local sdAlertAPC = {"vj_hlr/hl2_npc/ep1/c17/ba_ohmanapc.wav"}
local sdAlertStrider = {"vj_hlr/hl2_npc/ep1/c17/ba_kiddingstrider.wav","vj_hlr/hl2_npc/ep1/c17/ba_takedownstrider.wav"}
local sdAlertDropShip = {"vo/streetwar/nexus/ba_uhohdropships.wav"}
local sdAlertHeadcrab = {"vo/npc/barney/ba_headhumpers.wav"}
local sdAlertTurret = {"vo/npc/barney/ba_turret.wav"}

--[[ UNUSED

-- Complementing the player
"vo/k_lab/ba_sarcastic01.wav",
"vo/k_lab/ba_sarcastic02.wav",
"vo/k_lab/ba_sarcastic03.wav",
"vo/streetwar/sniper/ba_returnhero.wav",
"vj_hlr/hl2_npc/ep1/c17/ba_asskicking.wav",
"vj_hlr/hl2_npc/ep1/c17/ba_goodjob.wav",
"vj_hlr/hl2_npc/ep1/c17/ba_gordoniknow.wav",
"vj_hlr/hl2_npc/ep1/c17/ba_nicework.wav",
"vj_hlr/hl2_npc/ep1/c17/ba_tellemdoc.wav",
"vj_hlr/hl2_npc/ep1/c17/ba_yougothim.wav",

-- Soldier with RPG
"vj_hlr/hl2_npc/ep1/c17/ba_soldierrpg.wav",

"vj_hlr/hl2_npc/ep1/c17/ba_luckydog.wav", -- You lucky dog youuuuuuuuuuuu

]]--

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if math.random(1, 2) == 1 && ent:IsNPC() then
		if ent.IsVJBaseSNPC_Human == true then
			self:PlaySoundSystem("Alert", sdAlertHuman)
			return
		elseif ent:Classify() == CLASS_COMBINE_GUNSHIP then
			self:PlaySoundSystem("Alert", sdAlertGunship)
			return
		elseif ent:GetClass() == "npc_apcdriver" then
			self:PlaySoundSystem("Alert", sdAlertAPC)
			return
		elseif ent:GetClass() == "npc_strider" or ent:GetClass() == "npc_vj_hlr2_com_strider" then
			self:PlaySoundSystem("Alert", sdAlertStrider)
			return
		elseif ent:GetClass() == "npc_combinedropship" then
			self:PlaySoundSystem("Alert", sdAlertDropShip)
			return
		elseif ent.VJTag_ID_Headcrab then
			self:PlaySoundSystem("Alert", sdAlertHeadcrab)
			return
		elseif ent:Classify() == CLASS_MACHINE or ent.VJTag_ID_Turret or ent:GetClass() == "npc_turret_floor" then
			self:PlaySoundSystem("Alert", sdAlertTurret)
			return
		end
	end
end
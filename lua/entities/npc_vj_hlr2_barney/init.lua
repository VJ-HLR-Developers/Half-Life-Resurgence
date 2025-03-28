AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/barney.mdl"
ENT.StartHealth = 100
ENT.HealthRegenParams = {
	Enabled = true,
	Amount = 1,
	Delay = VJ.SET(0.35, 0.35),
}
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.AnimTbl_MeleeAttack = "vjseq_MeleeAttack01"
ENT.TimeUntilMeleeAttackDamage = 0.7
ENT.HasGrenadeAttack = true
ENT.AnimTbl_GrenadeAttack = ACT_RANGE_ATTACK_THROW
ENT.GrenadeAttackThrowTime = 0.87
ENT.GrenadeAttackAttachment = "anim_attachment_RH"
ENT.HasOnPlayerSight = true
ENT.BecomeEnemyToPlayer = 2

ENT.CanFlinch = true

ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav", "npc/footsteps/hardboot_generic2.wav", "npc/footsteps/hardboot_generic3.wav", "npc/footsteps/hardboot_generic4.wav", "npc/footsteps/hardboot_generic5.wav", "npc/footsteps/hardboot_generic6.wav", "npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_Idle = {
	"vo/streetwar/sniper/ba_hauntsme.wav",
}
ENT.SoundTbl_IdleDialogue = {
	"vo/k_lab/ba_itsworking04.wav",
	"vo/streetwar/sniper/ba_hearcat.wav",
	"vj_hlr/src/npc/ep1/c17/ba_knowevac.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vo/k_lab/ba_saidlasttime.wav",
	"vj_hlr/src/npc/ep1/c17/ba_deceiving01.wav",
}
ENT.SoundTbl_CombatIdle = {
	"vo/npc/barney/ba_goingdown.wav",
	"vo/streetwar/rubble/ba_damnitall.wav",
	"vj_hlr/src/npc/ep1/c17/ba_comeon01.wav",
	"vj_hlr/src/npc/ep1/c17/ba_herewego.wav",
}
ENT.SoundTbl_ReceiveOrder = {
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
	"vj_hlr/src/npc/ep1/c17/ba_areyousure.wav",
	"vj_hlr/src/npc/ep1/c17/ba_dontletmedown.wav",
	"vj_hlr/src/npc/ep1/c17/ba_donttakelong.wav",
	"vj_hlr/src/npc/ep1/c17/ba_ifyousayso.wav",
	"vo/streetwar/rubble/ba_seeya.wav",
}
ENT.SoundTbl_YieldToPlayer = {
	"vo/k_lab/ba_whoops.wav",
}
ENT.SoundTbl_OnPlayerSight = {
	"vo/npc/barney/ba_followme01.wav",
	"vo/npc/barney/ba_followme02.wav",
	"vo/npc/barney/ba_followme03.wav",
	"vo/npc/barney/ba_followme05.wav",
	"vo/k_lab/ba_thereyouare.wav",
	"vo/trainyard/ba_heygordon.wav",
	"vo/trainyard/ba_rememberme.wav",
	"vo/streetwar/rubble/ba_gordon.wav",
	"vj_hlr/src/npc/ep1/c17/ba_greeting01.wav",
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
	"vj_hlr/src/npc/barney/ba_fuckyou.wav"
}
ENT.SoundTbl_Suppressing = {
	"vj_hlr/src/npc/barney/ba_fuckyou.wav",
}
ENT.SoundTbl_WeaponReload = {
	"vo/npc/barney/ba_covermegord.wav",
	"vo/npc/barney/ba_damnit.wav",
	"vo/k_lab/ba_getitoff01.wav",
}
ENT.SoundTbl_GrenadeSight = {
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
ENT.SoundTbl_DangerSight = {
	"vo/npc/barney/ba_damnit.wav",
	"vo/npc/barney/ba_duck.wav",
	"vo/npc/barney/ba_getaway.wav",
	"vo/npc/barney/ba_getdown.wav",
	"vo/npc/barney/ba_getoutofway.wav",
	"vo/npc/barney/ba_lookout.wav",
	"vo/k_lab/ba_headhumper02.wav",
	"vo/k_lab/ba_thingaway02.wav",
}
ENT.SoundTbl_KilledEnemy = {
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
	"vj_hlr/src/npc/ep1/c17/ba_hellyeah.wav",
	"vj_hlr/src/npc/ep1/c17/ba_ohyeah01.wav",
	"vj_hlr/src/npc/ep1/c17/ba_woo.wav",
	"vj_hlr/src/npc/ep1/c17/ba_yeah01.wav",
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
local sdAlertHuman = "vo/npc/barney/ba_soldiers.wav"
local sdAlertGunship = "vj_hlr/src/npc/ep1/c17/ba_wrinkleship.wav"
local sdAlertAPC = "vj_hlr/src/npc/ep1/c17/ba_ohmanapc.wav"
local sdAlertStrider = {"vj_hlr/src/npc/ep1/c17/ba_kiddingstrider.wav", "vj_hlr/src/npc/ep1/c17/ba_takedownstrider.wav"}
local sdAlertDropShip = "vo/streetwar/nexus/ba_uhohdropships.wav"
local sdAlertHeadcrab = "vo/npc/barney/ba_headhumpers.wav"
local sdAlertTurret = "vo/npc/barney/ba_turret.wav"

--[[ UNUSED

-- Complementing the player
"vo/k_lab/ba_sarcastic01.wav",
"vo/k_lab/ba_sarcastic02.wav",
"vo/k_lab/ba_sarcastic03.wav",
"vo/streetwar/sniper/ba_returnhero.wav",
"vj_hlr/src/npc/ep1/c17/ba_asskicking.wav",
"vj_hlr/src/npc/ep1/c17/ba_goodjob.wav",
"vj_hlr/src/npc/ep1/c17/ba_gordoniknow.wav",
"vj_hlr/src/npc/ep1/c17/ba_nicework.wav",
"vj_hlr/src/npc/ep1/c17/ba_tellemdoc.wav",
"vj_hlr/src/npc/ep1/c17/ba_yougothim.wav",

-- Soldier with RPG
"vj_hlr/src/npc/ep1/c17/ba_soldierrpg.wav",

"vj_hlr/src/npc/ep1/c17/ba_luckydog.wav", -- You lucky dog youuuuuuuuuuuu

]]--

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
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
		elseif ent.VJ_ID_Headcrab then
			self:PlaySoundSystem("Alert", sdAlertHeadcrab)
			return
		elseif ent:Classify() == CLASS_MACHINE or ent.VJ_ID_Turret or ent:GetClass() == "npc_turret_floor" then
			self:PlaySoundSystem("Alert", sdAlertTurret)
			return
		end
	end
end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/alyx_ep1.mdl","models/vj_hlr/hl2/alyx_ep2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 100
ENT.HasHealthRegeneration = true -- Can the SNPC regenerate its health?
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.AnimTbl_MeleeAttack = {"vjseq_MeleeAttack01"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
/*ENT.AnimTbl_GrenadeAttack = {"vjseq_ThrowItem"} -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 1.1 -- Time until the grenade is released
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl" -- The model for the grenade entity
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will spawn at*/
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {"vjges_flinch_head"} -- If it uses normal based animation, use this
ENT.HasHitGroupFlinching = true -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = {
	{HitGroup = {HITGROUP_LEFTARM}, Animation = {"vjges_flinch_leftarm"}},
	{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjges_flinch_rightarm"}},
}
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}
/*
ENT.SoundTbl_Idle = {
	"vo/eli_lab/al_hums.wav",
	"vo/eli_lab/al_hums_b.wav",
}
ENT.SoundTbl_IdleDialogue = { -- Needs more lines, I'll let you guys add some more
	"vo/k_lab/al_wontlook.wav",
	"vo/novaprospekt/al_drkleiner01_e.wav",
	"vo/novaprospekt/al_flyingblind.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vo/k_lab2/al_optimism.wav",
	"vo/k_lab2/al_whatdoyoumean.wav",
	"vo/k_lab2/al_whee_b.wav",
	"vo/eli_lab/al_allright01.wav",
	"vo/eli_lab/al_awesome.wav",
	"vo/eli_lab/al_blamingme.wav",
	"vo/eli_lab/al_laugh01.wav",
	"vo/eli_lab/al_laugh02.wav",
	"vo/novaprospekt/al_betyoudid01.wav",
	"vo/novaprospekt/al_elevator02.wav",
	"vo/novaprospekt/al_notexactly.wav",
}
ENT.SoundTbl_OnReceiveOrder = {"vo/episode_1/npc/alyx/al_comingtohelp01.wav","vo/episode_1/npc/alyx/al_comingtohelp02.wav","vo/episode_1/npc/alyx/al_comingtohelp03.wav","vo/episode_1/npc/alyx/al_comingtohelp04.wav"}
ENT.SoundTbl_FollowPlayer = {"vo/streetwar/alyx_gate/al_letsgo.wav","vo/streetwar/alyx_gate/al_letsgo01.wav","vo/streetwar/alyx_gate/al_readywhenyou.wav","vo/episode_1/npc/alyx/al_follow01.wav","vo/episode_1/npc/alyx/al_follow02.wav","vo/episode_1/npc/alyx/al_follow03.wav","vo/episode_1/npc/alyx/al_follow04.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vo/episode_1/npc/alyx/al_affirm_sarc01.wav","vo/episode_1/npc/alyx/al_affirm_sarc02.wav","vo/episode_1/npc/alyx/al_affirm_sarc03.wav","vo/episode_1/npc/alyx/al_affirm_sarc04.wav","vo/episode_1/npc/alyx/al_affirm_sarc05.wav"}
ENT.SoundTbl_OnPlayerSight = {"vo/k_lab/al_heydoc.wav","vo/episode_1/npc/alyx/al_playerfalls01.wav",}
ENT.SoundTbl_Alert = {"vo/episode_1/npc/alyx/al_startcombat01.wav","vo/episode_1/npc/alyx/al_combat_sudden01.wav","vo/episode_1/npc/alyx/al_combat_sudden02.wav","vo/episode_1/npc/alyx/al_combat_sudden03.wav","vo/episode_1/npc/alyx/al_combat_sudden04.wav","vo/episode_1/npc/alyx/al_combat_sudden05.wav","vo/episode_1/npc/alyx/al_combat_sudden06.wav"}
ENT.SoundTbl_CallForHelp = {"vo/episode_1/npc/alyx/al_surround01.wav","vo/episode_1/npc/alyx/al_surround02.wav","vo/episode_1/npc/alyx/al_swamped04.wav"}
ENT.SoundTbl_WeaponReload = {"vo/episode_1/npc/alyx/al_reload01.wav","vo/episode_1/npc/alyx/al_reload02.wav","vo/episode_1/npc/alyx/al_reload03.wav","vo/episode_1/npc/alyx/al_reload04.wav","vo/episode_1/npc/alyx/al_reload05.wav","vo/episode_1/npc/alyx/al_reload06.wav","vo/episode_1/npc/alyx/al_reloading_new02.wav","vo/episode_1/npc/alyx/al_reloading_new03.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vo/episode_1/npc/alyx/al_grenade_warn02.wav","vo/episode_1/npc/alyx/al_grenade_warn_new_02.wav","vo/npc/alyx/lookout01.wav","vo/npc/alyx/lookout03.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vo/novaprospekt/al_gotyounow01.wav","vo/eli_lab/al_sweet.wav","vo/npc/alyx/brutal02.wav","vo/episode_1/npc/alyx/al_laugh02.wav","vo/episode_1/npc/alyx/al_laugh04.wav",}
ENT.SoundTbl_Pain = {"vo/npc/alyx/gasp02.wav","vo/npc/alyx/gasp03.wav","vo/npc/alyx/hurt04.wav","vo/npc/alyx/hurt05.wav","vo/episode_1/npc/alyx/al_post_combat01.wav","vo/episode_1/npc/alyx/al_post_combat03.wav","vo/episode_1/npc/alyx/al_post_combat04.wav"}
ENT.SoundTbl_DamageByPlayer = {"vo/npc/alyx/gordon_dist01.wav"}
ENT.SoundTbl_Death = {"vo/npc/alyx/uggh01.wav","vo/npc/alyx/uggh02.wav"}
ENT.SoundTbl_AllyDeath = {
	"vo/streetwar/alyx_gate/al_no.wav",
	"vo/novaprospekt/al_horrible01.wav",
}
ENT.SoundTbl_MoveOutOfPlayersWay = {
	"vo/npc/alyx/al_excuse01.wav",
	"vo/npc/alyx/al_excuse02.wav",
	"vo/npc/alyx/al_excuse03.wav",
}
*/


ENT.SoundTbl_Idle = {
	"vo/eli_lab/al_hums.wav",
	"vo/eli_lab/al_hums_b.wav",
	"vo/k_lab/al_buyyoudrink01.wav",
	"vo/k_lab/al_hmm.wav",
}
ENT.SoundTbl_IdleDialogue = {
	"vo/novaprospekt/al_drkleiner01_e.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vo/eli_lab/al_blamingme.wav",
	"vo/k_lab2/al_whatdoyoumean.wav",
	"vo/novaprospekt/al_betyoudid01.wav",
	"vo/novaprospekt/al_notexactly.wav",
}
ENT.SoundTbl_CombatIdle = {
	"vo/citadel/al_comeon.wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"vo/eli_lab/al_dadwhatsup.wav",
	"vo/k_lab/al_whatsgoingon.wav",
	"vo/novaprospekt/al_holdon.wav",
}
ENT.SoundTbl_FollowPlayer = {
	"vo/eli_lab/al_allright01.wav",
	"vo/eli_lab/al_gravgun.wav",
	"vo/k_lab/al_letsdoit.wav",
}
ENT.SoundTbl_UnFollowPlayer = {
	"vo/eli_lab/al_thyristor02.wav",
	"vo/k_lab/al_careful02.wav",
	"vo/novaprospekt/al_careofyourself.wav",
}
ENT.SoundTbl_MoveOutOfPlayersWay = {
	"vo/npc/alyx/al_excuse01.wav",
	"vo/npc/alyx/al_excuse02.wav",
	"vo/npc/alyx/al_excuse03.wav",
}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {
	"vo/eli_lab/al_soquickly01.wav",
	"vo/eli_lab/al_soquickly02.wav",
	"vo/eli_lab/al_soquickly03.wav",
	"vo/k_lab/al_heydoc.wav",
	"vo/trainyard/al_imalyx.wav",
	"vo/trainyard/al_nicetomeet_b.wav",
	"vo/trainyard/al_presume.wav",
	"vo/trainyard/al_thisday.wav",
}
ENT.SoundTbl_Investigate = {
	"vo/citadel/al_heylisten.wav",
	"vo/novaprospekt/al_overhere.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vo/citadel/al_notagain02.wav",
	"vo/eli_lab/al_ugh.wav",
}
ENT.SoundTbl_Alert = {
	"vo/novaprospekt/al_uhoh_np.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vo/eli_lab/al_cmongord02.wav",
	"vo/eli_lab/al_getitopen01.wav",
}
ENT.SoundTbl_BecomeEnemyToPlayer = {
	"vo/citadel/al_bitofit.wav",
}
ENT.SoundTbl_Suppressing = {
	"vo/novaprospekt/al_gotyounow01.wav",
	"vo/novaprospekt/al_holdit.wav",
	"vo/streetwar/alyx_gate/al_thatsit.wav",
}
ENT.SoundTbl_WeaponReload = {
	"vo/npc/alyx/coverme01.wav",
	"vo/npc/alyx/coverme02.wav",
	"vo/npc/alyx/coverme03.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {}
ENT.SoundTbl_OnGrenadeSight = {
	"vo/npc/alyx/getback01.wav",
	"vo/npc/alyx/getback02.wav",
	"vo/npc/alyx/lookout01.wav",
	"vo/npc/alyx/lookout03.wav",
	"vo/npc/alyx/watchout01.wav",
	"vo/npc/alyx/watchout02.wav",
	"vo/novaprospekt/al_gasp01.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vo/npc/alyx/brutal02.wav",
	"vo/citadel/al_yes_nr.wav",
	"vo/eli_lab/al_awesome.wav",
	"vo/eli_lab/al_earnedit01.wav",
	"vo/eli_lab/al_excellent01.wav",
	"vo/eli_lab/al_sweet.wav",
	"vo/k_lab2/al_whee_b.wav",
	"vo/trainyard/al_noyoudont.wav",
}
ENT.SoundTbl_AllyDeath = {
	"vo/npc/alyx/no01.wav",
	"vo/npc/alyx/no02.wav",
	"vo/npc/alyx/no03.wav",
	"vo/npc/alyx/ohgod01.wav",
	"vo/npc/alyx/ohno_startle01.wav",
	"vo/npc/alyx/ohno_startle03.wav",
	"vo/citadel/al_dadgordonno_c.wav",
	"vo/k_lab2/al_notime.wav",
	"vo/novaprospekt/al_combinespy01.wav",
	"vo/novaprospekt/al_horrible01.wav",
	"vo/novaprospekt/al_ohmygod.wav",
	"vo/streetwar/alyx_gate/al_no.wav",
}
ENT.SoundTbl_Pain = {
	"vo/npc/alyx/gasp02.wav",
	"vo/npc/alyx/gasp03.wav",
	"vo/npc/alyx/hurt04.wav",
	"vo/npc/alyx/hurt05.wav",
	"vo/npc/alyx/hurt06.wav",
	"vo/npc/alyx/hurt08.wav",
	"vo/citadel/al_struggle07.wav",
	"vo/citadel/al_struggle08.wav",
	"vo/streetwar/alyx_gate/al_ah.wav",
}
ENT.SoundTbl_DamageByPlayer = {
	"vo/npc/alyx/gordon_dist01.wav",
	"vo/novaprospekt/al_nostop.wav",
}
ENT.SoundTbl_Death = {
	"vo/npc/alyx/uggh01.wav",
	"vo/npc/alyx/uggh02.wav",
}

--[[ UNUSED

-- Complementing the player
vo/eli_lab/al_niceshot.wav

-- Player died
vo/k_lab/al_lostgordon.wav

]]--

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.Human_NextPlyReloadSd = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetupWeaponHoldTypeAnims(htype)
	timer.Simple(0.1, function() -- Make sure the base functions have ran!
		if IsValid(self) && htype == "pistol" or htype == "revolver" then
			self.WeaponAnimTranslations[ACT_COVER_LOW] 						= {ACT_CROUCHIDLE_STIMULATED, ACT_RANGE_AIM_PISTOL_LOW, "vjseq_crouchidlehide", "vjseq_blindfire_low_entry", "vjseq_crouchhide_01"}

			self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_WALK_AIM_PISTOL

			self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_PISTOL
		end
	end)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev,evTime,evCycle,evType,evOptions)
	//print(ev)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntityRelationshipCheck(argent, entisfri, entdist)
	-- Tell the player to reload their weapon
	if argent:IsPlayer() && entisfri == true && entdist <= 200 && !IsValid(self:GetEnemy()) && CurTime() > self.Human_NextPlyReloadSd then
		self.Human_NextPlyReloadSd = CurTime() + math.Rand(10,60)
		local wep = argent:GetActiveWeapon()
		if math.random(1,3) == 1 && IsValid(wep) && wep:Clip1() < wep:GetMaxClip1() && argent:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 then
			self:PlaySoundSystem("GeneralSpeech",{"vo/npc/alyx/youreload01.wav","vo/npc/alyx/youreload02.wav"})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,2) == 1 then
		if argent:Classify() == CLASS_SCANNER then
			self:PlaySoundSystem("Alert", {"vo/eli_lab/al_scanners03.wav"})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
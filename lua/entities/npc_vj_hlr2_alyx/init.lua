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
ENT.SoundTbl_Idle = {
	"vo/eli_lab/al_hums.wav",
	"vo/eli_lab/al_hums_b.wav",
	"vo/k_lab/al_buyyoudrink01.wav",
	"vo/k_lab/al_hmm.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_alert_zombies07.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_cramped01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_relief.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb1_hm.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb1_whatsthis.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_subwaymap02.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_zombine_joke01.wav",
}
ENT.SoundTbl_IdleDialogue = {
	"vo/novaprospekt/al_drkleiner01_e.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_dontseehow.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vo/eli_lab/al_blamingme.wav",
	"vo/k_lab2/al_whatdoyoumean.wav",
	"vo/novaprospekt/al_betyoudid01.wav",
	"vo/novaprospekt/al_notexactly.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_excuseminute.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_notanymore.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb_crossfingers.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb_knowthedrill.wav",
}
ENT.SoundTbl_CombatIdle = {
	"vo/citadel/al_comeon.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_comeon.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_letsgo.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_finale_herewego.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_finale_herewego_alt.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_finale_wediditg01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_gship_againagain.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb1_ohgreat.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_train_thisisit.wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"vo/eli_lab/al_dadwhatsup.wav",
	"vo/k_lab/al_whatsgoingon.wav",
	"vo/novaprospekt/al_holdon.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_whythisway.wav",
}
ENT.SoundTbl_FollowPlayer = {
	"vo/eli_lab/al_allright01.wav",
	"vo/eli_lab/al_gravgun.wav",
	"vo/k_lab/al_letsdoit.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_betterchance.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_letsgetout.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_letsgo_new.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_ok.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_eventually03.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_soundsgood01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_gotyourback.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_hospital_afteryou.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_hospital_letsgo.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_letsgo02.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_letsgo03.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_safehouse_soundgood.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_safehouse_yeah.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_safehouse_yeah_new.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_whatwegonnado.wav",
}
ENT.SoundTbl_UnFollowPlayer = {
	"vo/eli_lab/al_thyristor02.wav",
	"vo/k_lab/al_careful02.wav",
	"vo/novaprospekt/al_careofyourself.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_leaveyoutoit.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_safehouse_yeah.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_safehouse_yeah_new.wav",
}
ENT.SoundTbl_MoveOutOfPlayersWay = {
	"vo/npc/alyx/al_excuse01.wav",
	"vo/npc/alyx/al_excuse02.wav",
	"vo/npc/alyx/al_excuse03.wav",
}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {
	"vj_hlr/hl2_npc/ep1/c17/al_cit_heythanks.wav",
}
ENT.SoundTbl_OnPlayerSight = {
	"vo/eli_lab/al_soquickly01.wav",
	"vo/eli_lab/al_soquickly02.wav",
	"vo/eli_lab/al_soquickly03.wav",
	"vo/k_lab/al_heydoc.wav",
	"vo/trainyard/al_imalyx.wav",
	"vo/trainyard/al_nicetomeet_b.wav",
	"vo/trainyard/al_presume.wav",
	"vo/trainyard/al_thisday.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_backsosoon.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_madeit.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_thereyouare.wav",
}
ENT.SoundTbl_Investigate = {
	"vo/citadel/al_heylisten.wav",
	"vo/novaprospekt/al_overhere.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_hearsomething_loud01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_hearsomething01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_advisor01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_rappel_hearthat.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_rappel_hearthat_loud.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_whatsound.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vo/citadel/al_notagain02.wav",
	"vo/eli_lab/al_ugh.wav",
}
ENT.SoundTbl_Alert = {
	"vo/novaprospekt/al_uhoh_np.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_ant_uncovered03.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_ant_uncovered04.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_godnotagain.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_kidding.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_trouble.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_heretheycome.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_hospital_heretheycome.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_lasttrain_herewego.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb_herewego.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_rappel_spotted.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_train_hereitgoes.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vo/eli_lab/al_cmongord02.wav",
	"vo/eli_lab/al_getitopen01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_cits01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_strider_overhere.wav",
}
ENT.SoundTbl_BecomeEnemyToPlayer = {
	"vo/citadel/al_bitofit.wav",
}
ENT.SoundTbl_Suppressing = {
	"vo/novaprospekt/al_gotyounow01.wav",
	"vo/novaprospekt/al_holdit.wav",
	"vo/streetwar/alyx_gate/al_thatsit.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_train_thereitgoes.wav",
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
	"vj_hlr/hl2_npc/ep1/c17/al_crabpod_omg.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_garrison_omgcitadel01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_hospital_fallthru01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_hospital_zombiefall.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_lasttrain_ohno.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_strider_getdown.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_strider_watchout.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_zombieroom_lookout01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_zombieroom_lookout02.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_zombine_crap.wav",
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
	"vj_hlr/hl2_npc/ep1/c17/al_antguard_victory.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_phew.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_thatwasclose01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_elev_tooclose.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_gothim01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_notsohard01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_thatsright.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_garrison_phew.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_gship_mess.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb_gettingbetter.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb_heyimgood.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pbox_padlock01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_snipe_close01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_strider_yes.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_tougherthanithought.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_train_close.wav",
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
	"vj_hlr/hl2_npc/ep1/c17/al_gate_cantbelieve.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_gate_ohgodno.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_lasttrain_omg.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_meltdown01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_plaza_view02.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_train_omg.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_whystickaround01.wav",
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
	"vj_hlr/hl2_npc/ep1/c17/al_elev_zombiesurprise.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_flood_floodroom01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_pb1_oh.wav",
}
ENT.SoundTbl_DamageByPlayer = {
	"vo/npc/alyx/gordon_dist01.wav",
	"vo/novaprospekt/al_nostop.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_crabpod_wthell.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_watchself.wav",
}
ENT.SoundTbl_Death = {
	"vo/npc/alyx/uggh01.wav",
	"vo/npc/alyx/uggh02.wav",
}

--[[ UNUSED

-- Complementing the player
"vo/eli_lab/al_niceshot.wav",
"vj_hlr/hl2_npc/ep1/c17/al_antlions_goodwork.wav",
"vj_hlr/hl2_npc/ep1/c17/al_cit_goodshot01.wav",
"vj_hlr/hl2_npc/ep1/c17/al_cit_goodshot02.wav",
"vj_hlr/hl2_npc/ep1/c17/al_cit_goodshot03.wav",
"vj_hlr/hl2_npc/ep1/c17/al_cit_goodshot04.wav",
"vj_hlr/hl2_npc/ep1/c17/al_cit_niceshooting.wav",
"vj_hlr/hl2_npc/ep1/c17/al_crank2_done01.wav",
"vj_hlr/hl2_npc/ep1/c17/al_evac_congrat01.wav",
"vj_hlr/hl2_npc/ep1/c17/al_evac_congrat03.wav",
"vj_hlr/hl2_npc/ep1/c17/al_evac_congrat04.wav",
"vj_hlr/hl2_npc/ep1/c17/al_evac_goodjob.wav",
"vj_hlr/hl2_npc/ep1/c17/al_evac_gothim02.wav",
"vj_hlr/hl2_npc/ep1/c17/al_pb_notbad.wav",
"vj_hlr/hl2_npc/ep1/c17/al_pbox_nicejobandgun01.wav",
"vj_hlr/hl2_npc/ep1/c17/al_strider_fantastic.wav",
"vj_hlr/hl2_npc/ep1/c17/al_strider_mynewhero.wav",
"vj_hlr/hl2_npc/ep1/c17/al_strider_mynewhero_alt.wav",
"vj_hlr/hl2_npc/ep1/c17/al_strider_pummel01.wav",
"vj_hlr/hl2_npc/ep1/c17/al_strider_youdidit.wav",

"vj_hlr/hl2_npc/ep1/c17/al_antlions_goodidea.wav", -- Good idea gordon
"vj_hlr/hl2_npc/ep1/c17/al_goodthink.wav",
"vj_hlr/hl2_npc/ep1/c17/al_tow_great.wav",

-- Player died
"vo/k_lab/al_lostgordon.wav",
"vj_hlr/hl2_npc/ep1/c17/al_lasttrain_gordon.wav",
"vj_hlr/hl2_npc/ep1/c17/al_lasttrain_ohnogordon.wav",
"vj_hlr/hl2_npc/ep1/c17/al_train_gordon.wav",
"vj_hlr/hl2_npc/ep1/c17/al_train_madeit02.wav",
"vj_hlr/hl2_npc/ep1/c17/al_zombieroom_gordon.wav",

-- To dark
"vj_hlr/hl2_npc/ep1/c17/al_darkinhere.wav",

-- Enemy firing RPG
"vj_hlr/hl2_npc/ep1/c17/al_evac_lookrpg.wav",

-- Tired from moving
"vj_hlr/hl2_npc/ep1/c17/al_tunnel_catchbreath01.wav",
"vj_hlr/hl2_npc/ep1/c17/al_tunnel_catchbreath02.wav",

-- Zombine with grenade
"vj_hlr/hl2_npc/ep1/c17/al_zombine_grenade.wav",

-- We don't have time
"vj_hlr/hl2_npc/ep1/c17/al_anotherway02.wav"

"vj_hlr/hl2_npc/ep1/c17/al_zombine_wth.wav",
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
	if math.random(1,2) == 1 && argent:IsNPC() then
		if argent:Classify() == CLASS_SCANNER then
			self:PlaySoundSystem("Alert", {"vo/eli_lab/al_scanners03.wav","vj_hlr/hl2_npc/ep1/c17/al_rappel_scanners.wav"})
		elseif argent:Classify() == CLASS_COMBINE_GUNSHIP then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_anothergunship.wav","vj_hlr/hl2_npc/ep1/c17/al_evac_gunship.wav"})
		elseif argent:Classify() == CLASS_PROTOSNIPER then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_evac_sniper.wav"})
		elseif argent:GetClass() == "npc_strider" then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_strider_omg.wav","vj_hlr/hl2_npc/ep1/c17/al_evac_nowstrider.wav"})
		elseif argent:GetClass() == "npc_apcdriver " then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_ohnoapc.wav"})
		elseif argent:GetClass() == "npc_antlionguard" then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_antguard.wav"})
		elseif argent:Classify() == CLASS_MACHINE or argent.HLR_Type == "Turret" or argent:GetClass() == "npc_turret_floor" then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_turrets.wav"})
		else
			local tbl = argent.VJ_NPC_Class or {1}
			for _,v in ipairs(tbl) do
				if v == "CLASS_COMBINE" or argent:Classify() == CLASS_COMBINE then
					self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_evac_ontous01.wav"})
					break
				elseif v == "CLASS_ZOMBIE" or argent:Classify() == CLASS_ZOMBIE then
					self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_pzombie_ohno.wav","vj_hlr/hl2_npc/ep1/c17/al_hospital_morezombies.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies01.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies02.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies03.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies04.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies05.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies06.wav",})
					break
				elseif v == "CLASS_ANTLION" or argent:Classify() == CLASS_ANTLION then
					self:PlaySoundSystem("Alert", {"vj_hlr/hl2_npc/ep1/c17/al_antlions_holycrap.wav","vj_hlr/hl2_npc/ep1/c17/al_ant_uncovered01.wav","vj_hlr/hl2_npc/ep1/c17/al_ant_uncovered02.wav","vj_hlr/hl2_npc/ep1/c17/al_antlions_firstsight.wav"})
					break
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally)
	if ally:GetClass() == "npc_vj_hlr2_barney" then
		self:PlaySoundSystem("CallForHelp", {"vj_hlr/hl2_npc/ep1/c17/al_barneyoverhere.wav"})
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/alyx_ep1.mdl","models/vj_hlr/hl2/alyx_ep2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 100
ENT.HasHealthRegeneration = true -- Can the SNPC regenerate its health?
ENT.HealthRegenerationAmount = 1 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ_Set(0.1,0.1) -- How much time until the health increases
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
	"vj_hlr/hl2_npc/ep1/citadel/al_citvista_noidea01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_exhale01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_gravcharge_anotherconsole01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_roll_thinking.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_fewbolts01.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_transmit_huh.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_noplug01.wav",
	"vj_hlr/hl2_npc/ep2/outland_08/chopper/al_chop_clearup01.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_handiwork03.wav", -- So many ways to die out here
}
ENT.SoundTbl_IdleDialogue = {
	"vo/novaprospekt/al_drkleiner01_e.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_dontseehow.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_giveupnow02.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_use_findtrans01.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_use_findtrans02.wav",
	"vj_hlr/hl2_npc/ep2/outland_08/chopper/al_chop_anytools02.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_howlong.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_working.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_howlongactive01.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_idontgetit01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_random02.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_chuckle01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_dognotserious01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_dognotserious03.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_dognotserious04.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_dogshappy03.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_yeah.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_alittleclose01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_alittleclose02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_alittleclose03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_alittleclose04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_alittleclose05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_affirm01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_greet_cit01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_greet_cit13.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_greet_cit23.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_rolled05.wav",
	"vj_hlr/hl2_npc/ep2/outland_08/chopper/al_chop_nokidding02.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_wouldyoumind.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_somethings.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_platform_getready.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual_quiet_01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual_quiet_02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual_quiet_03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual_quiet_06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_seemanyfoe02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_seemanyfoe03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_seemanyfoe04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_seemanyfoe05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_seemanyfoe06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_seemanyfoe08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_seemanyfoe10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_startcombat01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_startcombat03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_startcombat04.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_heregoes.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_herecomes.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_readyforyou.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_wecandothis.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_holdemoff.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_threeatatime02.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_weresurrounded.wav",
}
ENT.SoundTbl_OnReceiveOrder = {
	"vo/eli_lab/al_dadwhatsup.wav",
	"vo/k_lab/al_whatsgoingon.wav",
	"vo/novaprospekt/al_holdon.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_whythisway.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_whatnow.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_whatthistime.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_start03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_start04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_comingtohelp01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_comingtohelp02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_comingtohelp03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_comingtohelp04.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_whatnow02.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_citvista_glad.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_core_letsgo.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_goodletsgo02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_letsgo01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_okletsgo01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_shallwe.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_stalk_okletsgetoutofhere02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_vtex_behind.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_antenna01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_cliff_afteryou02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_affirm02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_affirm03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_affirm04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_affirm05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_near02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_stayclose01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_stayclose03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_follow01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_follow02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_follow03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_follow04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_follow05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_follow06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_greet_cit08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_lead_retrieve01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_lead_start02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_lead_start03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_welcome01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_welcome02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_welcome03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_welcome04.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_catchup03.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_getgoing04.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_gettobase.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_thanksagain01.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_goodteam01.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_goodteam02.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_surething01.wav",
}
ENT.SoundTbl_UnFollowPlayer = {
	"vo/eli_lab/al_thyristor02.wav",
	"vo/k_lab/al_careful02.wav",
	"vo/novaprospekt/al_careofyourself.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_leaveyoutoit.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_safehouse_yeah.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_safehouse_yeah_new.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_cantwastetime.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_core_blowreactor02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_core_parting.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_goodluck.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_stalk_okletsgetoutofhere02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_whereyougoing.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_antenna01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_seeyousoon01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_somethingisaid.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_whatisitdog.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_affirm04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_affirm05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_hack_fail01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_hack_fail02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_lead_catchup06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_lead_comingback02.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_playerout02.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_playerout05.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_stayincar01.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_stayincar02.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_stayincar04.wav",
	"vj_hlr/hl2_npc/ep2/outland_06/bridge/al_bridge_bye01.wav",
	"vj_hlr/hl2_npc/ep2/outland_06/bridge/al_bridge_openway03.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_doyouneed01.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_everythingok.wav",
}
ENT.SoundTbl_MoveOutOfPlayersWay = {
	"vo/npc/alyx/al_excuse01.wav",
	"vo/npc/alyx/al_excuse02.wav",
	"vo/npc/alyx/al_excuse03.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_carefulgord.wav",
}
ENT.SoundTbl_MedicBeforeHeal = {
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_healplayer01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_healplayer02.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_throwmed03.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_sorry01.wav",
}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {
	"vj_hlr/hl2_npc/ep1/c17/al_cit_heythanks.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_findmap01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_random01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_thankskeepmoving01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_cliff_afteryou01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_thanksdog.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_thanks01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_thanks02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_thanks03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_thanks04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_relief01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_relief04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_ok01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_ok03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_quiet_thanks01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_quiet_thanks02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_quiet_thanks04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_thanksforhelp03.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_rolled04.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_didtrick02.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_sorry02.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_thanksagain02.wav",
	"vj_hlr/hl2_npc/ep2/outland_11a/silo/al_silo_thankreb.wav",
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
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_lead_catchup07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_rejoin01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_rejoin03.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_whathell.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_core_hellitsjudith01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_noises01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_noises02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_noises03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_noises04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_noises05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_noises06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_noises07.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_didyouhear.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_whatsthat.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_whatthat.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_sh.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_pulsewhat.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_listen.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vo/citadel/al_notagain02.wav",
	"vo/eli_lab/al_ugh.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_backtrack01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_damn01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_gravgunlosingpower02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_nothangaround.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_ugh01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_damn.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worrieder_01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worrieder_03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriederer03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriedest04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet11.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet12.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet13.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet14.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet15.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost11.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_whatnow01.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_theyreback03.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_bridge_company.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_last_upthere01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_warns05.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_warns07.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_warns08.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_platform_company.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_platform_heretheycome.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual_quiet_04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual_quiet_05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_start01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_start02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_start06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriedest02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_holycrap01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_startcombat02.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_another.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_twomore.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_morecoming.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vo/eli_lab/al_cmongord02.wav",
	"vo/eli_lab/al_getitopen01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_evac_cits01.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_strider_overhere.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_stalk_getemoff03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_gradual04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob11.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_attack02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriedest05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped05.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_help.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_attackstart01.wav",
}
ENT.SoundTbl_BecomeEnemyToPlayer = {
	"vo/citadel/al_bitofit.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_traitor.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_traitor02.wav",
}
ENT.SoundTbl_Suppressing = {
	"vo/novaprospekt/al_gotyounow01.wav",
	"vo/novaprospekt/al_holdit.wav",
	"vo/streetwar/alyx_gate/al_thatsit.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_train_thereitgoes.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_burnem01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_burnem02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_lightem.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_start05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden11.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden12.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost_quiet10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_lost07.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_combat_grim_09.wav",
}
ENT.SoundTbl_WeaponReload = {
	"vo/npc/alyx/coverme01.wav",
	"vo/npc/alyx/coverme02.wav",
	"vo/npc/alyx/coverme03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reload01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reload02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reload03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reload04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reload05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reload06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reloading_new01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reloading_new02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reloading_new03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reloading_new04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reloading_new05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reloading_new06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_reloading_new07.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight11.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight12.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight13.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight14.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight17.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight18.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight19.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_adv_panting01.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_adv_panting03.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_adv_struggles02.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_adv_struggles05.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_struggle04.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_struggle07.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_struggle08.wav",
}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_boom01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_boom02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_boom03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_boom04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_boom05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_boom06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_boom07.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_standback.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_getclear.wav",
}
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
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_gonenow01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_outofhere.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_dropship_getback02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_dropship_getback04.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_dropship_getback06.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_dropship_getback07.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_last_lookout01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_last_lookout02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_last_lookup02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_last_upthere02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_nearmiss01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_warns06.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_warns14.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_watchout.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_pod_lookout.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_postcore_hurry04.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_stalk_brace.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_stalk_derail_omg.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_strider_whoa.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_omg02.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_putdown04.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_thatwasclose01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_whoa.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_mob02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_sudden05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_explo_lookout.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_explo_whoa.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn_new_01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn_new_02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn_new_03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn_new_04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_grenade_warn04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_headcrabsurprise02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_holycrap01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_playerfalls02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped12.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_zombine_grenadewarn01.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_crazy07.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_rolled01a.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_whoa.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_crap.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_ohmygod.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_putusdown01.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_omg.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_uhoh.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_dadgetaway02.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_deadoffeasy01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_excelletsgo.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_great01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_nearmiss04.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_platform_slowthem01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_thatwasclose.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_smashscanner01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_smashscanner02.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_thatwasclose02.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_whew.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_nice.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_whoanice01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_whoanice02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_yeah01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_yeah02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_coolgravkill02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_gotcha.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_laugh10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_mobbed_thatwasclose01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_mobbed_thatwasclose02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_mobbed_thatwasclose03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_positive01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_positive02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_positive03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_positive04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_positive05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_post_combat01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_post_combat02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_post_combat03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_post_combat04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_post_combat05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_post_combat06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_thanksforhelp02.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_crazy06.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_jumpyell05.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_laughing06.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_laughing08.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_laughing10.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_combat_grim_04.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_combat_grim_05.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_didtrick.wav",
	"vj_hlr/hl2_npc/ep2/outland_06/bridge/al_bridge_tanks02.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_killedit.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_notthistime_loud.wav",
	"vj_hlr/hl2_npc/ep2/outland_08/chopper/al_chop_nokidding01.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_fine02.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_gasp.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_yeah01.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_core_fargone01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_nearmiss05.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_stalk_ohnostalkercar01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_stalkers_omg01.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_cantbelieveit.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_omg01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped10.wav",
	"vj_hlr/hl2_npc/ep2/outland_06/bridge/al_bridge_found01.wav",
	"vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_omgc17.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_explode02.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_omg.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_no01.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_no02a.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_noooo.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_whatdoing.wav",
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
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_gonenow01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_pain01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_pain02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_pain03.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_pain04.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_pain05.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_pain06.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_advisor_shaking01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_gravcharge_explo.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_postcore_atwindow01.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_traitor01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_attack05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight15.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight16.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight20.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight21.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight22.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_fight23.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_headcrabsurprise01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_headcrabsurprise03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact04.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact05.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact06.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact07.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact08.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact09.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact10.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact11.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact12.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact13.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_impact14.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped11.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_swamped13.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_uggh01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_uggh02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_uggh03.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_crash04.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_crash05.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_crash06.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_crash07.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_hunter_pain01.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_hunter_pain04.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_hunter_pain06.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_hunter_pain07.wav",
	"vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_seesgravgun01.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_agh02.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_aghno.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_oof.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_struggle01.wav",
	"vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_struggle06.wav",
	"vj_hlr/hl2_npc/ep2/outland_10/olde-inne/al_ambush_heyow01.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle03.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle05.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle06.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle08.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle09.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle12.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle21.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle22.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_struggle25.wav",
}
ENT.SoundTbl_DamageByPlayer = {
	"vo/npc/alyx/gordon_dist01.wav",
	"vo/novaprospekt/al_nostop.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_crabpod_wthell.wav",
	"vj_hlr/hl2_npc/ep1/c17/al_watchself.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_nearmiss02.wav",
	"vj_hlr/hl2_npc/ep1/citadel/al_lift_nearmiss03.wav",
	"vj_hlr/hl2_npc/ep1/intro/al_alittleclose02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_stayclose02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_explo_watchit.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_physimpact_loud01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_physimpact_loud02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_physimpact_loud03.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_physimpact01.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_physimpact02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_physimpact03.wav",
	"vj_hlr/hl2_npc/ep2/alyx/al_car_crash02.wav",
	"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_whatthehell.wav",
	"vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_dadimnot02.wav",
}
ENT.SoundTbl_Death = {
	"vo/npc/alyx/uggh01.wav",
	"vo/npc/alyx/uggh02.wav",
	"vj_hlr/hl2_npc/ep1/npc/alyx/al_explo_agh.wav",
}

local sdFreemanReload = {"vj_hlr/hl2_npc/ep1/npc/alyx/al_playerreload01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerreload02.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerreload03.wav","vo/npc/alyx/youreload01.wav","vo/npc/alyx/youreload02.wav"}
local sdKilledEnemy = {"vj_hlr/hl2_npc/ep1/citadel/al_advisor_wasthatthing.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_gross01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_gross02.wav"}
local sdAllyDeath = {"vo/k_lab/al_lostgordon.wav","vj_hlr/hl2_npc/ep1/c17/al_lasttrain_gordon.wav","vj_hlr/hl2_npc/ep1/c17/al_lasttrain_ohnogordon.wav","vj_hlr/hl2_npc/ep1/c17/al_train_gordon.wav","vj_hlr/hl2_npc/ep1/c17/al_train_madeit02.wav","vj_hlr/hl2_npc/ep1/c17/al_zombieroom_gordon.wav","vj_hlr/hl2_npc/ep1/citadel/al_advisor_breen02.wav","vj_hlr/hl2_npc/ep1/citadel/al_dropship_getback01.wav","vj_hlr/hl2_npc/ep1/citadel/al_postcore_atwindow_new02.wav","vj_hlr/hl2_npc/ep1/citadel/al_stalk_getemoff11.wav","vj_hlr/hl2_npc/ep1/intro/al_gordon.wav","vj_hlr/hl2_npc/ep1/intro/al_ohgordon.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worried01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worrieder_02.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriederer01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriederer02.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriedest01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_worriedest03.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerdeath01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerdeath02.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerdeath03.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerdeath04.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerfalls01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_playerfalls03.wav","vj_hlr/hl2_npc/ep2/outland_01/intro/al_rbed_callinggordon04.wav","vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_attackstart01.wav","vj_hlr/hl2_npc/ep2/outland_12a/launch/al_launch_ohgord.wav"}
-- Specific alert sounds
local sdAlertStrider = {"vj_hlr/hl2_npc/ep2/outland_11/dogfight/al_str_ohshistrid.wav","vj_hlr/hl2_npc/ep1/c17/al_strider_omg.wav","vj_hlr/hl2_npc/ep1/c17/al_evac_nowstrider.wav"}
local sdAlertDropship = {"vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_dropship.wav","vj_hlr/hl2_npc/ep1/citadel/al_dropship_getback03.wav","vj_hlr/hl2_npc/ep1/citadel/al_dropship_getback05.wav"}
local sdAlertAntlionGuard = {"vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_aguard.wav","vj_hlr/hl2_npc/ep1/c17/al_antguard.wav"}
local sdAlertHeadcrab = {"vj_hlr/hl2_npc/ep1/npc/alyx/al_pzcrabs_hatethings01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_pzcrabs_hatethings02.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_headcrabs01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_headcrabs02.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_headcrabs03.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_headcrabs04.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_headcrabs05.wav"}
local sdAlertBarnacle = {"vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_barnacle01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_barnacle02.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_barnacle03.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_barnacle04.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_firstbarnacle.wav"}
local sdAlertStalker = {"vj_hlr/hl2_npc/ep1/citadel/al_stalker_gasp.wav","vj_hlr/hl2_npc/ep1/citadel/al_stalkers_omg02.wav"}
local sdAlertScanner = {"vo/eli_lab/al_scanners03.wav","vj_hlr/hl2_npc/ep1/c17/al_rappel_scanners.wav"}
local sdAlertGunship = {"vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_gunship.wav","vj_hlr/hl2_npc/ep1/c17/al_anothergunship.wav","vj_hlr/hl2_npc/ep1/c17/al_evac_gunship.wav"}
local sdAlertZombie = {"vj_hlr/hl2_npc/ep1/npc/alyx/al_zombie_itsalive01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_zombie_liveone01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_zombie_liveone02.wav","vj_hlr/hl2_npc/ep1/c17/al_pzombie_ohno.wav","vj_hlr/hl2_npc/ep1/c17/al_hospital_morezombies.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies01.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies02.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies03.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies04.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies05.wav","vj_hlr/hl2_npc/ep1/c17/al_alert_zombies06.wav"}
local sdAlertAntlion = {"vj_hlr/hl2_npc/ep1/c17/al_antlions_holycrap.wav","vj_hlr/hl2_npc/ep1/c17/al_ant_uncovered01.wav","vj_hlr/hl2_npc/ep1/c17/al_ant_uncovered02.wav","vj_hlr/hl2_npc/ep1/c17/al_antlions_firstsight.wav"}
local sdAlertCreature = {"vj_hlr/hl2_npc/ep1/citadel/al_advisor_podthings.wav","vj_hlr/hl2_npc/ep1/citadel/al_gravcharge_thing.wav"}
local sdAlertHuman = {"vj_hlr/hl2_npc/ep1/c17/al_evac_ontous01.wav","vj_hlr/hl2_npc/ep2/outland_07/barn/al_barn_soldiers01.wav","vj_hlr/hl2_npc/ep1/npc/alyx/al_alert_soldiers.wav","vj_hlr/hl2_npc/ep1/citadel/al_bridge_soldiers.wav"}

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
"vj_hlr/hl2_npc/ep1/citadel/al_nothangaround.wav",
"vj_hlr/hl2_npc/ep1/citadel/al_nothangaround01.wav",
"vj_hlr/hl2_npc/ep1/citadel/al_powerball01.wav",
"vj_hlr/hl2_npc/ep1/citadel/al_powerball02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_didiseethat.wav"
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodshooting01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodshooting02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodshooting03.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodshot01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodshot02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodshot03.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodshot04.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_leavesome01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_leavesome02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_nicemove01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_niceshooting01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_niceshooting02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_niceshot01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_niceshot02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_niceshot03.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_niceshot04.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_coolgravkill01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_coolgravkill03.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_goodshot01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_goodshot02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_goodshot03.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_goodshot04.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_newweapon01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_newweapon02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_newweapon03.wav",
"vj_hlr/hl2_npc/ep2/alyx/al_car_crazy04.wav",
"vj_hlr/hl2_npc/ep2/alyx/al_combat_grim_01.wav",
"vj_hlr/hl2_npc/ep2/alyx/al_combat_grim_02.wav",
"vj_hlr/hl2_npc/ep2/alyx/al_combat_grim_03.wav",
"vj_hlr/hl2_npc/ep2/alyx/al_combat_grim_06.wav",

-- Good thinking / idea gordon
"vj_hlr/hl2_npc/ep1/c17/al_antlions_goodidea.wav", -- Good idea gordon
"vj_hlr/hl2_npc/ep1/c17/al_goodthink.wav",
"vj_hlr/hl2_npc/ep1/c17/al_tow_great.wav",
"vj_hlr/hl2_npc/ep1/citadel/al_goodthinking01.wav",
"vj_hlr/hl2_npc/ep1/citadel/al_lift_great.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodthinking01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodthinking02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_combat_goodthinking03.wav",

-- Detect enemy behind player
"vj_hlr/hl2_npc/ep1/npc/alyx/al_behindyou01.wav"
"vj_hlr/hl2_npc/ep1/npc/alyx/al_monsterbehindplayer01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_monsterbehindplayer02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_monsterbehindplayer03.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_monsterbehindplayer04.wav",

-- Player needs healing
	-- Wrong file path! =O
"vj_hlr/hl2_npc/ep1/npc/alyx/al_player_goodshot01.wav",		1  -  5

-- To dark
"vj_hlr/hl2_npc/ep1/c17/al_darkinhere.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_relief05.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_lead_start01.wav",		1  -  6
"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_out04.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_out05.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_out06.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_out09.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_light_out10.wav",		10  -  15

-- Enemy firing RPG
"vj_hlr/hl2_npc/ep1/c17/al_evac_lookrpg.wav",

-- Tired from moving
"vj_hlr/hl2_npc/ep1/c17/al_tunnel_catchbreath01.wav",
"vj_hlr/hl2_npc/ep1/c17/al_tunnel_catchbreath02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_breathing01.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_breathing02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_breathing03.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_monsterbehindplayer01.wav",		1  -  15

-- Zombine with grenade
"vj_hlr/hl2_npc/ep1/c17/al_zombine_grenade.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_zombine_grenadewarn02.wav",
"vj_hlr/hl2_npc/ep1/npc/alyx/al_zombine_grenadewarn03.wav",

-- We don't have time
"vj_hlr/hl2_npc/ep1/c17/al_anotherway02.wav"

"vj_hlr/hl2_npc/ep1/c17/al_zombine_wth.wav",

-- Creature Attacking
"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_attack01.wav", -- What? AAA
"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_attack03.wav", -- Something is one me
"vj_hlr/hl2_npc/ep1/npc/alyx/al_dark_attack02.wav", -- get it off get it off
]]--

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.Human_NextPlyReloadSd = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetupWeaponHoldTypeAnims(hType)
	timer.Simple(0.1, function() -- Make sure the base functions have ran!
		if IsValid(self) && hType == "pistol" or hType == "revolver" then
			self.WeaponAnimTranslations[ACT_IDLE] = {ACT_IDLE_STIMULATED} -- This animation set is used more often in HL2, not to mention there are multiple idle animations tied to this so it gives more variety + this syncs up with the rest of Alyx's animations better
			self.WeaponAnimTranslations[ACT_WALK] = {ACT_WALK_STIMULATED}
			self.WeaponAnimTranslations[ACT_RUN] = {ACT_RUN_STIMULATED}

			self.WeaponAnimTranslations[ACT_COVER_LOW] = {ACT_CROUCHIDLE_STIMULATED, ACT_RANGE_AIM_PISTOL_LOW, "vjseq_crouchidlehide", "vjseq_blindfire_low_entry", "vjseq_crouchhide_01"}

			self.WeaponAnimTranslations[ACT_WALK_AIM] = ACT_WALK_AIM_PISTOL

			self.WeaponAnimTranslations[ACT_RUN_AIM] = ACT_RUN_AIM_PISTOL
		end
	end)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPlayerSight(ent)
	self.Human_NextPlyReloadSd = CurTime() + math.Rand(5, 20)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntityRelationshipCheck(ent, entFri, entDist)
	-- Tell the player to reload their weapon
	if entFri == true && ent:IsPlayer() && CurTime() > self.Human_NextPlyReloadSd && !IsValid(self:GetEnemy()) && entDist <= 200 then
		self.Human_NextPlyReloadSd = CurTime() + math.Rand(10, 60)
		local wep = ent:GetActiveWeapon()
		if IsValid(wep) && math.random(1, 3) == 1 then
			local ammoType = wep:GetPrimaryAmmoType()
			if wep:GetPrimaryAmmoType() > -1 then
				-- Give ammo to player
				if ent:GetAmmoCount(ammoType) <= 255 && IsValid(self:GetActiveWeapon()) && !self:IsBusy() then
					if entDist > 100 then
						self.Human_NextPlyReloadSd = 0
					else
						self:FaceCertainPosition(ent:GetPos(), 2)
						self:VJ_ACT_PLAYACTIVITY("heal", true, false, true, 0, {OnFinish=function(interrupted, anim)
							if !interrupted then
								ent:GiveAmmo(20, ammoType)
							end
						end})
						self:PlaySoundSystem("GeneralSpeech", "vj_hlr/hl2_npc/ep1/npc/alyx/al_takeammo.wav")
					end
				-- Reload Freeman
				elseif wep:Clip1() < wep:GetMaxClip1() && ent:GetAmmoCount(ammoType) > 0 then
					self:PlaySoundSystem("GeneralSpeech", sdFreemanReload)
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if math.random(1, 1) == 1 && ent:IsNPC() then
		if ent:GetClass() == "npc_breen" then
			self:PlaySoundSystem("Alert", "vj_hlr/hl2_npc/ep1/citadel/al_advisor_breen01.wav")
			return
		elseif ent:GetClass() == "npc_rollermine" then
			self:PlaySoundSystem("Alert", "vj_hlr/hl2_npc/ep1/citadel/al_platform_rollers.wav")
			return
		elseif ent:GetClass() == "npc_strider" or ent:GetClass() == "npc_vj_hlr2_com_strider" then
			self:PlaySoundSystem("Alert", sdAlertStrider)
			return
		elseif ent:GetClass() == "npc_combinedropship" then
			self:PlaySoundSystem("Alert", sdAlertDropship)
			return
		elseif ent:GetClass() == "npc_apcdriver" then
			self:PlaySoundSystem("Alert", "vj_hlr/hl2_npc/ep1/c17/al_ohnoapc.wav")
			return
		elseif ent:GetClass() == "npc_antlionguard" then
			self:PlaySoundSystem("Alert", sdAlertAntlionGuard)
			return
		elseif ent.HLR_Type == "Headcrab" or ent:GetClass() == "npc_headcrab" or ent:GetClass() == "npc_headcrab_black" or ent:GetClass() == "npc_headcrab_fast" then
			self:PlaySoundSystem("Alert", sdAlertHeadcrab)
			return
		elseif ent:GetClass() == "npc_vj_hlr1_barnacle" or ent:GetClass() == "monster_barnacle" or ent:Classify() == CLASS_BARNACLE then
			self:PlaySoundSystem("Alert", sdAlertBarnacle)
			return
		elseif ent:Classify() == CLASS_COMBINE_HUNTER then
			self:PlaySoundSystem("Alert", "vj_hlr/hl2_npc/ep2/outland_06a/radio/al_rad_theyreback02.wav")
			return
		elseif ent:Classify() == CLASS_STALKER then
			self:PlaySoundSystem("Alert", sdAlertStalker)
			return
		elseif ent:Classify() == CLASS_SCANNER then
			self:PlaySoundSystem("Alert", sdAlertScanner)
			return
		elseif ent:Classify() == CLASS_COMBINE_GUNSHIP then
			self:PlaySoundSystem("Alert", sdAlertGunship)
			return
		elseif ent:Classify() == CLASS_PROTOSNIPER then
			self:PlaySoundSystem("Alert", "vj_hlr/hl2_npc/ep1/c17/al_evac_sniper.wav")
			return
		elseif ent:Classify() == CLASS_MACHINE or ent.HLR_Type == "Turret" or ent:GetClass() == "npc_turret_floor" then
			self:PlaySoundSystem("Alert", "vj_hlr/hl2_npc/ep1/c17/al_turrets.wav")
			return
		else
			for _,v in ipairs(ent.VJ_NPC_Class or {1}) do
				/*if v == "CLASS_COMBINE" or ent:Classify() == CLASS_COMBINE then
					self:PlaySoundSystem("Alert", "vj_hlr/hl2_npc/ep1/c17/al_evac_ontous01.wav")
					return*/
				if v == "CLASS_ZOMBIE" or ent:Classify() == CLASS_ZOMBIE then
					self:PlaySoundSystem("Alert", sdAlertZombie)
					return
				elseif v == "CLASS_ANTLION" or ent:Classify() == CLASS_ANTLION then
					self:PlaySoundSystem("Alert", sdAlertAntlion)
					return
				end
			end
		end
		-- General type (If none of the specific ones above were found)
		if  ent.IsVJBaseSNPC_Creature == true then
			self:PlaySoundSystem("Alert", sdAlertCreature)
			return
		elseif ent.IsVJBaseSNPC_Human == true or ent:Classify() == CLASS_COMBINE then
			self:PlaySoundSystem("Alert", sdAlertHuman)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCallForHelp(ally)
	if ally:GetClass() == "npc_vj_hlr2_barney" then
		self:PlaySoundSystem("CallForHelp", "vj_hlr/hl2_npc/ep1/c17/al_barneyoverhere.wav")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(ent, attacker, inflictor)
	-- Kills a unknown type (Not Zombie, Antlion or Combine) of creature SNPC
	if math.random(1,2) == 1 && ent.IsVJBaseSNPC_Creature == true then
		for _,v in ipairs(ent.VJ_NPC_Class or {1}) do
			if v != "CLASS_COMBINE" && v != "CLASS_ZOMBIE" && v != "CLASS_ANTLION" then
				self:PlaySoundSystem("OnKilledEnemy", sdKilledEnemy)
				return
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAllyDeath(ent)
	if ent:IsPlayer() or ent.VJ_HLR_Freeman then
		self:PlaySoundSystem("AllyDeath", sdAllyDeath)
	end
end
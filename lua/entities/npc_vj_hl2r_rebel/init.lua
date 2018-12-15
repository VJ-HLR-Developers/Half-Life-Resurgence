AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = GetConVarNumber("vj_hl2r_rebel_h")
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_MeleeAttack01"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = GetConVarNumber("vj_hl2r_rebel_d")
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {ACT_RANGE_ATTACK_THROW} -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 0.87 -- Time until the grenade is released
ENT.GrenadeAttackAttachment = "anim_attachment_RH" -- The attachment that the grenade will spawn at
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_Idle = {"vo/npc/male01/question01.wav","vo/npc/male01/question02.wav","vo/npc/male01/question03.wav","vo/npc/male01/question04.wav","vo/npc/male01/question05.wav","vo/npc/male01/question06.wav","vo/npc/male01/question07.wav","vo/npc/male01/question08.wav","vo/npc/male01/question09.wav","vo/npc/male01/question10.wav","vo/npc/male01/question11.wav","vo/npc/male01/question12.wav","vo/npc/male01/question13.wav","vo/npc/male01/question14.wav","vo/npc/male01/question15.wav","vo/npc/male01/question16.wav","vo/npc/male01/question17.wav","vo/npc/male01/question18.wav","vo/npc/male01/question19.wav","vo/npc/male01/question20.wav","vo/npc/male01/question21.wav","vo/npc/male01/question22.wav","vo/npc/male01/question23.wav","vo/npc/male01/question24.wav","vo/npc/male01/question25.wav","vo/npc/male01/question26.wav","vo/npc/male01/question27.wav","vo/npc/male01/question28.wav","vo/npc/male01/question29.wav","vo/npc/male01/question30.wav","vo/npc/male01/question31.wav"}
ENT.SoundTbl_CombatIdle = {"vo/episode_1/npc/male01/cit_kill07.wav","vo/npc/male02/reb2_antlions05.wav","vo/npc/male01/letsgo01.wav","vo/npc/male01/letsgo02.wav","vo/outland_12/reb1_lastwave01.wav","vo/outland_12/reb1_lastwave10.wav","vo/outland_12/reb1_lastwaveannounced05.wav","vo/outland_12/reb1_prepare_battle_01.wav"}
ENT.SoundTbl_OnReceiveOrder = {"vo/npc/male01/squad_approach02.wav","vo/npc/male01/squad_approach03.wav","vo/npc/male01/squad_approach04.wav"}
ENT.SoundTbl_FollowPlayer = {"vo/npc/male01/yougotit02.wav","vo/npc/male01/squad_follow03.wav","vo/npc/male01/squad_affirm01.wav","vo/npc/male01/squad_affirm02.wav","vo/npc/male01/squad_affirm09.wav","vo/npc/male01/leadon01.wav","vo/npc/male01/leadon02.wav","vo/npc/male01/leadtheway01.wav","vo/npc/male01/leadtheway02.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vo/npc/male01/littlecorner01.wav","vo/npc/male01/holddownspot01.wav","vo/npc/male01/holddownspot02.wav","vo/npc/male01/illstayhere01.wav","vo/npc/male01/imstickinghere01.wav"}
ENT.SoundTbl_MoveOutOfPlayersWay = {"vo/npc/male01/excuseme01.wav","vo/npc/male01/excuseme02.wav","vo/npc/male01/sorry01.wav","vo/npc/male01/sorry02.wav","vo/npc/male01/sorry03.wav","vo/npc/male01/sorrydoc01.wav","vo/npc/male01/sorrydoc02.wav","vo/npc/male01/sorrydoc04.wav","vo/npc/male01/sorryfm01.wav","vo/npc/male01/sorryfm02.wav"}
ENT.SoundTbl_MedicBeforeHeal = {"vo/outland_08/chopper/reb_chop_nothankyou.wav","vo/npc/male01/health01.wav","vo/npc/male01/health02.wav","vo/npc/male01/health03.wav","vo/npc/male01/health04.wav","vo/npc/male01/health05.wav"}
ENT.SoundTbl_Investigate = {"vo/npc/male01/startle01.wav","vo/npc/male01/startle02.wav"}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {"vo/npc/male01/hi01.wav","vo/npc/male01/hi02.wav","vo/npc/male01/heydoc01.wav","vo/npc/male01/heydoc02.wav","vo/npc/male01/hellodrfm01.wav","vo/npc/male01/hellodrfm02.wav","vo/npc/male01/freeman.wav","vo/npc/male01/docfreeman01.wav","vo/npc/male01/docfreeman02.wav","vo/npc/male01/abouttime01.wav","vo/npc/male01/abouttime02.wav","vo/npc/male01/ahgordon01.wav","vo/npc/male01/ahgordon02.wav"}
ENT.SoundTbl_Alert = {"vo/episode_1/npc/male01/cit_theyfoundus.wav","vo/episode_1/npc/male01/cit_evac_enemies01.wav","vo/outland_12/reb1_lastwave09.wav","vo/npc/male01/incoming02.wav","vo/npc/male01/upthere01.wav","vo/npc/male01/upthere02.wav","vo/npc/male01/heretheycome01.wav","vo/npc/male01/overthere01.wav","vo/npc/male01/overthere02.wav"}
ENT.SoundTbl_CallForHelp = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {"vo/npc/male01/notthemanithought01.wav","vo/npc/male01/heretohelp01.wav","vo/npc/male01/heretohelp02.wav","vo/npc/male01/wetrustedyou01.wav","vo/npc/male01/wetrustedyou02.wav"}
ENT.SoundTbl_Suppressing = {"vo/episode_1/npc/male01/cit_kill09.wav","vo/episode_1/npc/male01/cit_kill10.wav","vo/episode_1/npc/male01/cit_kill14.wav","vo/episode_1/npc/male01/cit_kill17.wav","vo/npc/male02/reb2_buddykilled13.wav","vo/outland_08/chopper/rebc_chop_hit02.wav","vo/outland_12/reb1_sawmillexplo05.wav","vo/outland_12/reb1_prepare_battle_03.wav","vo/outland_12/reb1_striderdown05.wav","vo/outland_12/reb1_striderdown12.wav"}
ENT.SoundTbl_WeaponReload = {"vo/npc/male01/gottareload01.wav","vo/npc/male01/coverwhilereload01.wav","vo/npc/male01/coverwhilereload02.wav"}
ENT.SoundTbl_GrenadeAttack = {}
ENT.SoundTbl_OnGrenadeSight = {"vo/npc/male01/watchout.wav","vo/npc/male01/strider_run.wav","vo/npc/male01/takecover02.wav","vo/npc/male01/runforyourlife01.wav","vo/npc/male01/runforyourlife02.wav","vo/npc/male01/runforyourlife03.wav","vo/npc/male01/headsup01.wav","vo/npc/male01/headsup02.wav","vo/npc/male01/getdown02.wav","vo/npc/male01/gethellout.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vo/episode_1/npc/male01/cit_kill01.wav","vo/episode_1/npc/male01/cit_kill02.wav","vo/episode_1/npc/male01/cit_kill03.wav","vo/episode_1/npc/male01/cit_kill04.wav","vo/episode_1/npc/male01/cit_kill05.wav","vo/episode_1/npc/male01/cit_kill06.wav","vo/episode_1/npc/male01/cit_kill15.wav","vo/outland_12/reb1_striderdown06.wav","vo/outland_12/reb1_striderdown07.wav","vo/outland_12/reb1_striderdown08.wav","vo/npc/male01/gotone01.wav","vo/npc/male01/gotone02.wav","vo/npc/male01/likethat.wav","vo/npc/male01/nice.wav"}
ENT.SoundTbl_Pain = {"vo/episode_1/npc/male01/cit_pain01.wav","vo/episode_1/npc/male01/cit_pain02.wav","vo/episode_1/npc/male01/cit_pain03.wav","vo/episode_1/npc/male01/cit_pain04.wav","vo/episode_1/npc/male01/cit_pain05.wav","vo/episode_1/npc/male01/cit_pain06.wav","vo/episode_1/npc/male01/cit_pain07.wav","vo/episode_1/npc/male01/cit_pain08.wav","vo/episode_1/npc/male01/cit_pain09.wav","vo/episode_1/npc/male01/cit_pain10.wav","vo/episode_1/npc/male01/cit_pain11.wav","vo/episode_1/npc/male01/cit_pain12.wav","vo/episode_1/npc/male01/cit_pain13.wav","vo/npc/male01/ow01.wav","vo/npc/male01/ow02.wav","vo/npc/male01/hitingut01.wav","vo/npc/male01/hitingut02.wav","vo/npc/male01/imhurt01.wav","vo/npc/male01/imhurt02.wav"}
ENT.SoundTbl_DamageByPlayer = {"vo/npc/male01/onyourside.wav","vo/npc/male01/stopitfm.wav","vo/npc/male01/watchwhat.wav"}
ENT.SoundTbl_Death = {"vo/npc/male01/pain01.wav","vo/npc/male01/pain02.wav","vo/npc/male01/pain03.wav","vo/npc/male01/pain04.wav","vo/npc/male01/pain05.wav","vo/npc/male01/pain06.wav","vo/npc/male01/pain07.wav","vo/npc/male01/pain08.wav","vo/npc/male01/pain09.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if math.random(1,5) == 1 then
		self.Model = {"models/Humans/Group03m/Male_01.mdl","models/Humans/Group03m/male_02.mdl","models/Humans/Group03m/male_03.mdl","models/Humans/Group03m/male_04.mdl","models/Humans/Group03m/male_05.mdl","models/Humans/Group03m/male_06.mdl","models/Humans/Group03m/male_07.mdl","models/Humans/Group03m/male_08.mdl","models/Humans/Group03m/male_09.mdl"}
		self.IsMedicSNPC = true
	else
		self.Model = {"models/Humans/Group03/male_01.mdl","models/Humans/Group03/male_02.mdl","models/Humans/Group03/male_03.mdl","models/Humans/Group03/male_04.mdl","models/Humans/Group03/male_05.mdl","models/Humans/Group03/male_06.mdl","models/Humans/Group03/male_07.mdl","models/Humans/Group03/male_08.mdl","models/Humans/Group03/male_09.mdl"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	self:VJ_ACT_PLAYACTIVITY({"vjseq_cheer1"},false,false,false,0,{vTbl_SequenceInterruptible=true})
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
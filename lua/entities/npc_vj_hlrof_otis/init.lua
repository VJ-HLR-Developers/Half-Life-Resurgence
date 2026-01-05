include("entities/npc_vj_hlr1_securityguard/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/otis.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, -30),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(4, 0, 5),
	FirstP_ShrinkBone = false,
}
ENT.StartHealth = 100

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/otis/stupidmachines.wav", "vj_hlr/gsrc/npc/otis/mmmm.wav", "vj_hlr/gsrc/npc/otis/janitor.wav", "vj_hlr/gsrc/npc/otis/insurance.wav", "vj_hlr/gsrc/npc/otis/candy.wav", "vj_hlr/gsrc/npc/otis/chili.wav", "vj_hlr/gsrc/npc/otis/cousin.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/gsrc/npc/otis/wuss.wav", "vj_hlr/gsrc/npc/otis/somethingmoves.wav", "vj_hlr/gsrc/npc/otis/quarter.wav", "vj_hlr/gsrc/npc/otis/aliencombat.wav", "vj_hlr/gsrc/npc/otis/ass.wav", "vj_hlr/gsrc/npc/otis/beer.wav", "vj_hlr/gsrc/npc/otis/bigboned.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/gsrc/npc/otis/yup.wav", "vj_hlr/gsrc/npc/otis/youbet.wav", "vj_hlr/gsrc/npc/otis/yes.wav", "vj_hlr/gsrc/npc/otis/yessir.wav", "vj_hlr/gsrc/npc/otis/yeah.wav", "vj_hlr/gsrc/npc/otis/talkmuch.wav", "vj_hlr/gsrc/npc/otis/suppose.wav", "vj_hlr/gsrc/npc/otis/noway.wav", "vj_hlr/gsrc/npc/otis/nope.wav", "vj_hlr/gsrc/npc/otis/nosir.wav", "vj_hlr/gsrc/npc/otis/no.wav", "vj_hlr/gsrc/npc/otis/maybe.wav", "vj_hlr/gsrc/npc/otis/hell.wav", "vj_hlr/gsrc/npc/otis/doubt.wav", "vj_hlr/gsrc/npc/otis/dontask.wav", "vj_hlr/gsrc/npc/otis/dejavu.wav", "vj_hlr/gsrc/npc/otis/cantfigure.wav", "vj_hlr/gsrc/npc/otis/dontguess.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/gsrc/npc/otis/die.wav", "vj_hlr/gsrc/npc/otis/bridge.wav", "vj_hlr/gsrc/npc/otis/tooyoung.wav", "vj_hlr/gsrc/npc/otis/virgin.wav", "vj_hlr/gsrc/npc/otis/mom.wav", "vj_hlr/gsrc/npc/otis/mall.wav", "vj_hlr/gsrc/npc/otis/leftovers.wav", "vj_hlr/gsrc/npc/otis/getanyworse.wav", "vj_hlr/gsrc/npc/otis/job.wav"}
ENT.SoundTbl_FollowPlayer = {"vj_hlr/gsrc/npc/otis/yourback.wav", "vj_hlr/gsrc/npc/otis/youbet.wav", "vj_hlr/gsrc/npc/otis/yeah.wav", "vj_hlr/gsrc/npc/otis/together.wav", "vj_hlr/gsrc/npc/otis/teamup.wav", "vj_hlr/gsrc/npc/otis/rightdirection.wav", "vj_hlr/gsrc/npc/otis/of1a1_ot04.wav", "vj_hlr/gsrc/npc/otis/live.wav", "vj_hlr/gsrc/npc/otis/letsgo.wav", "vj_hlr/gsrc/npc/otis/joinyou.wav", "vj_hlr/gsrc/npc/otis/gladof.wav", "vj_hlr/gsrc/npc/otis/alright.wav", "vj_hlr/gsrc/npc/otis/diealone.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/gsrc/npc/otis/standguard.wav", "vj_hlr/gsrc/npc/otis/slowingyoudown.wav", "vj_hlr/gsrc/npc/otis/seeya.wav", "vj_hlr/gsrc/npc/otis/ot_intro_seeya.wav", "vj_hlr/gsrc/npc/otis/of1a1_ot03.wav", "vj_hlr/gsrc/npc/otis/notalone.wav", "vj_hlr/gsrc/npc/otis/illwait.wav", "vj_hlr/gsrc/npc/otis/help.wav", "vj_hlr/gsrc/npc/otis/closet.wav", "vj_hlr/gsrc/npc/otis/go_on.wav"}
ENT.SoundTbl_MedicReceiveHeal = {"vj_hlr/gsrc/npc/otis/medic.wav"}
ENT.SoundTbl_OnPlayerSight = {"vj_hlr/gsrc/npc/otis/soldier.wav", "vj_hlr/gsrc/npc/otis/ot_intro_hello1.wav", "vj_hlr/gsrc/npc/otis/ot_intro_hello2.wav", "vj_hlr/gsrc/npc/otis/hiya.wav", "vj_hlr/gsrc/npc/otis/hello.wav", "vj_hlr/gsrc/npc/otis/hey.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/gsrc/npc/otis/soundsbad.wav", "vj_hlr/gsrc/npc/otis/noise.wav", "vj_hlr/gsrc/npc/otis/hearsomething.wav"}
ENT.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/gsrc/npc/otis/tomb.wav", "vj_hlr/gsrc/npc/otis/somuch.wav", "vj_hlr/gsrc/npc/otis/donthurtem.wav", "vj_hlr/gsrc/npc/otis/bring.wav", "vj_hlr/gsrc/npc/otis/bully.wav"}
ENT.SoundTbl_KilledEnemy = {"vj_hlr/gsrc/npc/otis/seethat.wav", "vj_hlr/gsrc/npc/otis/reputation.wav", "vj_hlr/gsrc/npc/otis/gotone.wav", "vj_hlr/gsrc/npc/otis/close.wav", "vj_hlr/gsrc/npc/otis/another.wav", "vj_hlr/gsrc/npc/otis/buttugly.wav", "vj_hlr/gsrc/npc/otis/firepl.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/gsrc/npc/otis/of1a5_ot01.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/otis/scar.wav", "vj_hlr/gsrc/npc/otis/hitbad.wav", "vj_hlr/gsrc/npc/otis/imdead.wav", "vj_hlr/gsrc/npc/otis/imhit.wav"}
ENT.SoundTbl_DamageByPlayer = {"vj_hlr/gsrc/npc/otis/yourside.wav", "vj_hlr/gsrc/npc/otis/watchit.wav", "vj_hlr/gsrc/npc/otis/quitit.wav", "vj_hlr/gsrc/npc/otis/onry.wav", "vj_hlr/gsrc/npc/otis/dontmake.wav", "vj_hlr/gsrc/npc/otis/damn.wav", "vj_hlr/gsrc/npc/otis/chump.wav", "vj_hlr/gsrc/npc/otis/friends.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/barney/ba_die1.wav", "vj_hlr/gsrc/npc/barney/ba_die2.wav", "vj_hlr/gsrc/npc/barney/ba_die3.wav"}

/*
-- cant follow
vj_hlr/gsrc/npc/otis/behind.wav

vj_hlr/gsrc/npc/otis/breath.wav
vj_hlr/gsrc/npc/otis/leavealone.wav
vj_hlr/gsrc/npc/otis/of1a1_ot01.wav
vj_hlr/gsrc/npc/otis/of1a1_ot02.wav
vj_hlr/gsrc/npc/otis/of2a6_ot01.wav
vj_hlr/gsrc/npc/otis/of3a2_ot01.wav
vj_hlr/gsrc/npc/otis/of6a3_ot01.wav
*/

ENT.Security_Type = 1
---------------------------------------------------------------------------------------------------------------------------------------------
local baseInit = ENT.Init
--
function ENT:Init()
	baseInit(self)
	self:Give("weapon_vj_hlrof_desert_eagle")
	self:SetBodygroup(2, math.random(0, 2))
end
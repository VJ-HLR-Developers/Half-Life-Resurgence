AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/otis.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -30), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(4, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
ENT.StartHealth = 100

/*
-- cant follow
vj_hlr/hl1_npc/otis/behind.wav

vj_hlr/hl1_npc/otis/breath.wav
vj_hlr/hl1_npc/otis/leavealone.wav
vj_hlr/hl1_npc/otis/of1a1_ot01.wav
vj_hlr/hl1_npc/otis/of1a1_ot02.wav
vj_hlr/hl1_npc/otis/of2a6_ot01.wav
vj_hlr/hl1_npc/otis/of3a2_ot01.wav
vj_hlr/hl1_npc/otis/of6a3_ot01.wav
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_CustomOnInitialize()
	self.SoundTbl_Idle = {"vj_hlr/hl1_npc/otis/stupidmachines.wav","vj_hlr/hl1_npc/otis/mmmm.wav","vj_hlr/hl1_npc/otis/janitor.wav","vj_hlr/hl1_npc/otis/insurance.wav","vj_hlr/hl1_npc/otis/candy.wav","vj_hlr/hl1_npc/otis/chili.wav","vj_hlr/hl1_npc/otis/cousin.wav"}
	self.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/otis/wuss.wav","vj_hlr/hl1_npc/otis/somethingmoves.wav","vj_hlr/hl1_npc/otis/quarter.wav","vj_hlr/hl1_npc/otis/aliencombat.wav","vj_hlr/hl1_npc/otis/ass.wav","vj_hlr/hl1_npc/otis/beer.wav","vj_hlr/hl1_npc/otis/bigboned.wav"}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/otis/yup.wav","vj_hlr/hl1_npc/otis/youbet.wav","vj_hlr/hl1_npc/otis/yes.wav","vj_hlr/hl1_npc/otis/yessir.wav","vj_hlr/hl1_npc/otis/yeah.wav","vj_hlr/hl1_npc/otis/talkmuch.wav","vj_hlr/hl1_npc/otis/suppose.wav","vj_hlr/hl1_npc/otis/noway.wav","vj_hlr/hl1_npc/otis/nope.wav","vj_hlr/hl1_npc/otis/nosir.wav","vj_hlr/hl1_npc/otis/no.wav","vj_hlr/hl1_npc/otis/maybe.wav","vj_hlr/hl1_npc/otis/hell.wav","vj_hlr/hl1_npc/otis/doubt.wav","vj_hlr/hl1_npc/otis/dontask.wav","vj_hlr/hl1_npc/otis/dejavu.wav","vj_hlr/hl1_npc/otis/cantfigure.wav","vj_hlr/hl1_npc/otis/dontguess.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/otis/die.wav","vj_hlr/hl1_npc/otis/bridge.wav","vj_hlr/hl1_npc/otis/tooyoung.wav","vj_hlr/hl1_npc/otis/virgin.wav","vj_hlr/hl1_npc/otis/mom.wav","vj_hlr/hl1_npc/otis/mall.wav","vj_hlr/hl1_npc/otis/leftovers.wav","vj_hlr/hl1_npc/otis/getanyworse.wav","vj_hlr/hl1_npc/otis/job.wav"}
	self.SoundTbl_FollowPlayer = {"vj_hlr/hl1_npc/otis/yourback.wav","vj_hlr/hl1_npc/otis/youbet.wav","vj_hlr/hl1_npc/otis/yeah.wav","vj_hlr/hl1_npc/otis/together.wav","vj_hlr/hl1_npc/otis/teamup.wav","vj_hlr/hl1_npc/otis/rightdirection.wav","vj_hlr/hl1_npc/otis/of1a1_ot04.wav","vj_hlr/hl1_npc/otis/live.wav","vj_hlr/hl1_npc/otis/letsgo.wav","vj_hlr/hl1_npc/otis/joinyou.wav","vj_hlr/hl1_npc/otis/gladof.wav","vj_hlr/hl1_npc/otis/alright.wav","vj_hlr/hl1_npc/otis/diealone.wav"}
	self.SoundTbl_UnFollowPlayer = {"vj_hlr/hl1_npc/otis/standguard.wav","vj_hlr/hl1_npc/otis/slowingyoudown.wav","vj_hlr/hl1_npc/otis/seeya.wav","vj_hlr/hl1_npc/otis/ot_intro_seeya.wav","vj_hlr/hl1_npc/otis/of1a1_ot03.wav","vj_hlr/hl1_npc/otis/notalone.wav","vj_hlr/hl1_npc/otis/illwait.wav","vj_hlr/hl1_npc/otis/help.wav","vj_hlr/hl1_npc/otis/closet.wav","vj_hlr/hl1_npc/otis/go_on.wav"}
	self.SoundTbl_MedicReceiveHeal = {"vj_hlr/hl1_npc/otis/medic.wav"}
	self.SoundTbl_OnPlayerSight = {"vj_hlr/hl1_npc/otis/soldier.wav","vj_hlr/hl1_npc/otis/ot_intro_hello1.wav","vj_hlr/hl1_npc/otis/ot_intro_hello2.wav","vj_hlr/hl1_npc/otis/hiya.wav","vj_hlr/hl1_npc/otis/hello.wav","vj_hlr/hl1_npc/otis/hey.wav"}
	self.SoundTbl_Investigate = {"vj_hlr/hl1_npc/otis/soundsbad.wav","vj_hlr/hl1_npc/otis/noise.wav","vj_hlr/hl1_npc/otis/hearsomething.wav"}
	self.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hl1_npc/otis/tomb.wav","vj_hlr/hl1_npc/otis/somuch.wav","vj_hlr/hl1_npc/otis/donthurtem.wav","vj_hlr/hl1_npc/otis/bring.wav","vj_hlr/hl1_npc/otis/bully.wav"}
	self.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/otis/seethat.wav","vj_hlr/hl1_npc/otis/reputation.wav","vj_hlr/hl1_npc/otis/gotone.wav","vj_hlr/hl1_npc/otis/close.wav","vj_hlr/hl1_npc/otis/another.wav","vj_hlr/hl1_npc/otis/buttugly.wav","vj_hlr/hl1_npc/otis/firepl.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/otis/of1a5_ot01.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hl1_npc/otis/scar.wav","vj_hlr/hl1_npc/otis/hitbad.wav","vj_hlr/hl1_npc/otis/imdead.wav","vj_hlr/hl1_npc/otis/imhit.wav"}
	self.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/otis/yourside.wav","vj_hlr/hl1_npc/otis/watchit.wav","vj_hlr/hl1_npc/otis/quitit.wav","vj_hlr/hl1_npc/otis/onry.wav","vj_hlr/hl1_npc/otis/dontmake.wav","vj_hlr/hl1_npc/otis/damn.wav","vj_hlr/hl1_npc/otis/chump.wav","vj_hlr/hl1_npc/otis/friends.wav"}
	self.SoundTbl_Death = {"vj_hlr/hl1_npc/barney/ba_die1.wav","vj_hlr/hl1_npc/barney/ba_die2.wav","vj_hlr/hl1_npc/barney/ba_die3.wav"}
	
	self.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIE_GUTSHOT,ACT_DIE_HEADSHOT,ACT_DIESIMPLE} -- Death Animations
	self:Give("weapon_vj_hlrof_desert_eagle")
	self:SetBodygroup(2,math.random(0,2))
end

// vj_hlr/hl1_npc/otis/aliens.wav
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
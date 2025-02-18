include("entities/npc_vj_hlr1_scientist/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/decay/wheelchair_sci.mdl"
ENT.StartHealth = 100
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, -20),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(3, 0, 3.3),
	FirstP_ShrinkBone = false,
}
ENT.IsMedic = false
ENT.AnimTbl_Death = ACT_DIESIMPLE

ENT.SoundTbl_FootStep = "vj_hlr/hl1_npc/keller/wheelchair_walk.wav"
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/keller/dk_idle0.wav", "vj_hlr/hl1_npc/keller/dk_idle1.wav", "vj_hlr/hl1_npc/keller/dk_idle3.wav", "vj_hlr/hl1_npc/keller/dk_idle4.wav", "vj_hlr/hl1_npc/keller/dk_04_letssee.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/keller/dk_01_kleiner.wav", "vj_hlr/hl1_npc/keller/dk_hevchair.wav", "vj_hlr/hl1_npc/keller/dk_idle2.wav", "vj_hlr/hl1_npc/keller/dk_rugurinate.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/keller/dk_iknowyouare.wav", "vj_hlr/hl1_npc/keller/dk_stare0.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/keller/dk_help0.wav", "vj_hlr/hl1_npc/keller/dk_help1.wav", "vj_hlr/hl1_npc/keller/dk_help2.wav", "vj_hlr/hl1_npc/keller/dk_fear0.wav", "vj_hlr/hl1_npc/keller/dk_fear1.wav", "vj_hlr/hl1_npc/keller/dk_fear2.wav", "vj_hlr/hl1_npc/keller/dk_fear3.wav", "vj_hlr/hl1_npc/keller/dk_fear4.wav", "vj_hlr/hl1_npc/keller/dk_fear5.wav", "vj_hlr/hl1_npc/keller/dk_fear6.wav"}
ENT.SoundTbl_FollowPlayer = {"vj_hlr/hl1_npc/keller/dk_stare1.wav", "vj_hlr/hl1_npc/keller/dk_stare2.wav", "vj_hlr/hl1_npc/keller/dk_04_goonway.wav", "vj_hlr/hl1_npc/keller/dk_04_onwaythen.wav", "vj_hlr/hl1_npc/keller/dk_leads0.wav", "vj_hlr/hl1_npc/keller/dk_ok0.wav", "vj_hlr/hl1_npc/keller/dk_ok1.wav", "vj_hlr/hl1_npc/keller/dk_ok2.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/hl1_npc/keller/dk_plfear2.wav", "vj_hlr/hl1_npc/keller/dk_wait0.wav", "vj_hlr/hl1_npc/keller/dk_wait1.wav", "vj_hlr/hl1_npc/keller/dk_wait2.wav", "vj_hlr/hl1_npc/keller/dk_wait3.wav"}
ENT.SoundTbl_OnPlayerSight = {"vj_hlr/hl1_npc/keller/dk_hello0.wav", "vj_hlr/hl1_npc/keller/dk_hello1.wav", "vj_hlr/hl1_npc/keller/dk_hello2.wav", "vj_hlr/hl1_npc/keller/dk_hello3.wav", "vj_hlr/hl1_npc/keller/dk_hello4.wav", "vj_hlr/hl1_npc/keller/dk_01_late.wav", "vj_hlr/hl1_npc/keller/dk_newstuff.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/keller/dk_04_monsters.wav", "vj_hlr/hl1_npc/keller/dk_help0.wav", "vj_hlr/hl1_npc/keller/dk_help1.wav", "vj_hlr/hl1_npc/keller/dk_help2.wav"}
ENT.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hl1_npc/keller/dk_screwyou.wav"}
ENT.SoundTbl_GrenadeSight = {"vj_hlr/hl1_npc/keller/dk_fear0.wav", "vj_hlr/hl1_npc/keller/dk_fear1.wav", "vj_hlr/hl1_npc/keller/dk_fear2.wav", "vj_hlr/hl1_npc/keller/dk_fear3.wav", "vj_hlr/hl1_npc/keller/dk_fear4.wav", "vj_hlr/hl1_npc/keller/dk_fear5.wav", "vj_hlr/hl1_npc/keller/dk_fear6.wav"}
ENT.SoundTbl_DangerSight = {"vj_hlr/hl1_npc/keller/dk_fear0.wav", "vj_hlr/hl1_npc/keller/dk_fear1.wav", "vj_hlr/hl1_npc/keller/dk_fear2.wav", "vj_hlr/hl1_npc/keller/dk_fear3.wav", "vj_hlr/hl1_npc/keller/dk_fear4.wav", "vj_hlr/hl1_npc/keller/dk_fear5.wav", "vj_hlr/hl1_npc/keller/dk_fear6.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/keller/dk_condolences.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/keller/dk_pain1.wav", "vj_hlr/hl1_npc/keller/dk_pain2.wav", "vj_hlr/hl1_npc/keller/dk_pain3.wav", "vj_hlr/hl1_npc/keller/dk_pain4.wav", "vj_hlr/hl1_npc/keller/dk_pain5.wav", "vj_hlr/hl1_npc/keller/dk_pain6.wav", "vj_hlr/hl1_npc/keller/dk_pain7.wav"}
ENT.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/keller/dk_plfear0.wav", "vj_hlr/hl1_npc/keller/dk_plfear1.wav", "vj_hlr/hl1_npc/keller/dk_plfear3.wav", "vj_hlr/hl1_npc/keller/dk_scared0.wav", "vj_hlr/hl1_npc/keller/dk_scared1.wav", "vj_hlr/hl1_npc/keller/dk_scared2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/keller/dk_die1.wav", "vj_hlr/hl1_npc/keller/dk_die2.wav", "vj_hlr/hl1_npc/keller/dk_die3.wav", "vj_hlr/hl1_npc/keller/dk_die3.wav", "vj_hlr/hl1_npc/keller/dk_die4.wav", "vj_hlr/hl1_npc/keller/dk_die5.wav", "vj_hlr/hl1_npc/keller/dk_die6.wav", "vj_hlr/hl1_npc/keller/dk_die7.wav"}

/*
-- Can't reach player, unfollow
vj_hlr/hl1_npc/keller/dk_stop0.wav
vj_hlr/hl1_npc/keller/dk_stop1.wav
vj_hlr/hl1_npc/keller/dk_stop2.wav

-- vj_hlr/hl1_npc/keller/dk_01_cascade.wav ---> vj_hlr/hl1_npc/keller/dk_01_gottodeal.wav
-- vj_hlr/hl1_npc/keller/dk_01_needspect.wav ---> vj_hlr/hl1_npc/keller/dk_04_excellent.wav
vj_hlr/hl1_npc/keller/dk_04_ididit.wav
vj_hlr/hl1_npc/keller/dk_04_interfere.wav
-- vj_hlr/hl1_npc/keller/dk_04_otherdamp.wav ---> vj_hlr/hl1_npc/keller/dk_12_whenstart.wav
vj_hlr/hl1_npc/keller/dk_furher.wav
vj_hlr/hl1_npc/keller/dk_kellerfrog.wav
vj_hlr/hl1_npc/keller/dk_leads1.wav
vj_hlr/hl1_npc/keller/dk_leads2.wav

vj_hlr/hl1_npc/keller/wheelchair_jog.wav
vj_hlr/hl1_npc/keller/wheelchair_run.wav
vj_hlr/hl1_npc/keller/wheelchair_walk.wav
*/

ENT.SCI_Type = 3

-- Custom
ENT.Keller_WheelChair = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init() end -- Here to override the base class
---------------------------------------------------------------------------------------------------------------------------------------------
local baseThink = ENT.OnThink
--
function ENT:OnThink()
	-- Is the wheel chair gone? Then kill Dr. Keller!
	if self:GetBodygroup(0) == 1 then
		self.HasDeathAnimation = false
		self:TakeDamage(self:Health(), self, self)
	end
	baseThink(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local parentDeathFunc = ENT.OnDeath
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	parentDeathFunc(self, dmginfo, hitgroup, status)
	if status == "Finish" then
		if self:GetBodygroup(0) == 1 then
			self.Keller_WheelChair = false
		end
		self:SetBodygroup(0, 1)
		self:SetPos(self:GetPos() + self:GetUp() * 5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
	if self.Keller_WheelChair == true then
		self:CreateExtraDeathCorpse("prop_physics", "models/vj_hlr/decay/wheelchair.mdl")
	end
end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/roach.mdl"
ENT.StartHealth = 1
ENT.TurningSpeed = 120
ENT.HullType = HULL_TINY
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, 20),
    FirstP_Bone = "Dummy01",
    FirstP_Offset = Vector(0, 0, 4),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = false
ENT.FootstepTimerRun = 3
ENT.FootstepTimerWalk = 3
ENT.HasImpactSounds = false

ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/roach/rch_walk.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/roach/rch_die.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(2, 2, 2), Vector(-2, -2, 0))
	self.HasDeathSounds = math.random(0, 4) == 1 -- 1 in 5 chance to play a death squeak sound | Based on: https://github.com/ValveSoftware/halflife/blob/master/dlls/roach.cpp#L166
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTouch(ent)
	if ent:IsPlayer() or ent:IsNPC() then
		self:TakeDamage(self:Health() + 1, ent, ent)
		-- Based on:   EMIT_SOUND_DYN(ENT(pev), CHAN_BODY, "roach/rch_smash.wav", 0.7, ATTN_NORM, 0, 80 + RANDOM_LONG(0,39) );
		VJ.EmitSound(self, "vj_hlr/hl1_npc/roach/rch_smash.wav", 60, 80 + math.random(0, 39))
	end
end
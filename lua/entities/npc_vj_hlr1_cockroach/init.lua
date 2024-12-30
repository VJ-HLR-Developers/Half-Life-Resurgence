AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/roach.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 1
ENT.TurningSpeed = 120
ENT.HullType = HULL_TINY
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy01", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 4), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = false -- Can it open doors?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE -- Type of AI behavior to use for this NPC
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
ENT.FootStepTimeRun = 3 -- Delay between footstep sounds while it is running | false = Disable while running
ENT.FootStepTimeWalk = 3 -- Delay between footstep sounds while it is walking | false = Disable while walking
ENT.HasImpactSounds = false
	-- ====== Sound Paths ====== --
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
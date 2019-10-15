AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/roach.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 5
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = false -- Can it open doors?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE -- The behavior of the SNPC
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
--ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.FootStepTimeRun = 3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 3 -- Next foot step sound when it is walking
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/roach/rch_walk.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/roach/rch_die.wav"}

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Dummy01"
ENT.Controller_FirstPersonOffset = Vector(2,0,2)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(2, 2, 2), Vector(-2, -2, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(entity)
	if entity:IsPlayer() or entity:IsNPC() then
		self:TakeDamage(999999999,entity,entity)
		VJ_EmitSound(self,"vj_hlr/hl1_npc/roach/rch_smash.wav",70)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
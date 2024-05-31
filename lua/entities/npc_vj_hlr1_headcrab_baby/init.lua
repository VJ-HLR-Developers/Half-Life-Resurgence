include("entities/npc_vj_hlr1_headcrab/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/headcrab_baby.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.TurningSpeed = 60 -- How fast it can turn
ENT.StartHealth = 5
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Neck", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 4), -- The offset for the controller when the camera is in first person
}
ENT.LeapDistance = 180 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.NoChaseAfterCertainRange_FarDistance = 150 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.LeapAttackVelocityForward = 40 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 150 -- How much upward force should it apply?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LeapAttackDamage = 5

ENT.GeneralSoundPitch1 = 120
ENT.GeneralSoundPitch2 = 120

-- Custom
ENT.HeadCrab_IsBaby = true
ENT.BabyH_MotherEnt = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(5, 5, 10), Vector(-5, -5, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	-- ALERT MY MOM THAT I HAVE DIED ;(
	if IsValid(self.BabyH_MotherEnt) then
		self.BabyH_MotherEnt:Gonarch_BabyDeath()
	end
end
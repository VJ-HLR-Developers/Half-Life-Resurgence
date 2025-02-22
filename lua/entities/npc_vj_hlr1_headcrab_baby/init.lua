include("entities/npc_vj_hlr1_headcrab/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/headcrab_baby.mdl"
ENT.TurningSpeed = 60
ENT.StartHealth = 5
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, 0),
    FirstP_Bone = "Bip01 Neck",
    FirstP_Offset = Vector(0, 0, 4),
}
ENT.LeapAttackMaxDistance = 180
ENT.LeapAttackDamage = 5
ENT.LimitChaseDistance_Max = 150

ENT.MainSoundPitch = 120

-- Custom
ENT.HeadCrab_IsBaby = true
ENT.BabyH_MotherEnt = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(5, 5, 10), Vector(-5, -5, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	-- ALERT MY MOM THAT I HAVE DIED ;(
	if status == "Init" && IsValid(self.BabyH_MotherEnt) then
		self.BabyH_MotherEnt:Gonarch_BabyDeath()
	end
end
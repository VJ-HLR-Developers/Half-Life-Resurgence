AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 35), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy06", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 8), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"} -- NPCs with the same class with be allied to each other

ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)

-- Custom
ENT.Sentry_MuzzleAttach = "gun"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_Type = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	local ang = self:GetAngles()
	self:SetAngles(Angle(ang.x, ang.y, 180))
	
	self:SetCollisionBounds(Vector(25, 25, 50), Vector(-25, -25, 0)) // -50
end
// Use VJ_CreateTestObject(self:EyePos()) to test the fix
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:SetNearestPointToEntityPosition()
	-- Take care of the nearest point starting position
	return self:GetPos() + self:GetUp()*50 -- Override this to use a different position
end*/
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/gturret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy02", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 2), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"} -- NPCs with the same class with be allied to each other

//ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
//ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)

-- Custom
ENT.Sentry_MuzzleAttach = "gun"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_Type = 1
ENT.Sentry_OrientationType = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(25, 25, 50), Vector(-25, -25, 0))
	self:AddFlags(FL_NOTARGET) -- Starts retracted, so make it no target
end
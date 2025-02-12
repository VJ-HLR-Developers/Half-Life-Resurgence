include("entities/npc_vj_hlr1_sentry/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/turret.mdl"
ENT.StartHealth = 150
ENT.ControllerParameters = {
    ThirdP_Offset = Vector(0, 0, -90),
    FirstP_Bone = "Dummy02",
    FirstP_Offset = Vector(0, 0, 2),
	FirstP_ShrinkBone = false,
}
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
//ENT.PoseParameterLooking_InvertPitch = false
//ENT.PoseParameterLooking_InvertYaw = false

-- Custom
ENT.Sentry_MuzzleAttach = "gun"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_Type = 1
ENT.Sentry_OrientationType = 1
---------------------------------------------------------------------------------------------------------------------------------------------
local baseInit = ENT.Init
--
function ENT:Init()
	baseInit(self)
	//local ang = self:GetAngles()
	//self:SetAngles(Angle(ang.x, ang.y, 180))
	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(25, 25, 0), Vector(-25, -25, -50))
	self:AddFlags(FL_NOTARGET) -- Starts retracted, so make it no target
end
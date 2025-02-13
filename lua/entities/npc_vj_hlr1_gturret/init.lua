include("entities/npc_vj_hlr1_sentry/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/gturret.mdl"
ENT.StartHealth = 150
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "Dummy02",
    FirstP_Offset = Vector(0, 0, 2),
	FirstP_ShrinkBone = false,
}
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}

-- Custom
ENT.Sentry_MuzzleAttach = "gun"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_Type = 1
ENT.Sentry_OrientationType = 0
---------------------------------------------------------------------------------------------------------------------------------------------
local baseInit = ENT.Init
--
function ENT:Init()
	baseInit(self)
	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(25, 25, 50), Vector(-25, -25, 0))
	self:AddFlags(FL_NOTARGET) -- Starts retracted, so make it no target
end
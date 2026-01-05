include("entities/npc_vj_hlr1_sentry/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/gturret_mini.mdl"
ENT.StartHealth = 50
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, 10),
    FirstP_Bone = "Dummy02",
    FirstP_Offset = Vector(0, 0, 0),
	FirstP_ShrinkBone = false,
}
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.NextAnyAttackTime_Range = 0.03

-- Custom
ENT.Sentry_MuzzleAttach = "muzzle"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_Type = 2
ENT.Sentry_OrientationType = 0
---------------------------------------------------------------------------------------------------------------------------------------------
local baseInit = ENT.Init
--
function ENT:Init()
	baseInit(self)
	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(15, 15, 40), Vector(-15, -15, 0))
	self:AddFlags(FL_NOTARGET) -- Starts retracted, so make it no target
end
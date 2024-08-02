include("entities/npc_vj_hlr1_sentry/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/gturret_mini.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 50
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 10), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy02", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.NextAnyAttackTime_Range = 0.03

-- Custom
ENT.Sentry_MuzzleAttach = "muzzle"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_Type = 2
ENT.Sentry_OrientationType = 0
---------------------------------------------------------------------------------------------------------------------------------------------
local baseInit = ENT.CustomOnInitialize
--
function ENT:CustomOnInitialize()
	baseInit(self)
	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(15, 15, 40), Vector(-15, -15, 0))
	self:AddFlags(FL_NOTARGET) -- Starts retracted, so make it no target
end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/gturret_mini.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 10), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy02", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}

-- Custom
ENT.Sentry_MuzzleAttach = "muzzle"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_Type = 2
ENT.Sentry_SubType = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:DrawShadow(false)
	self:SetCollisionBounds(Vector(15, 15, 40), Vector(-15, -15, 0))
	self:AddFlags(FL_NOTARGET) -- Starts retracted, so make it no target
	
	self.NextAnyAttackTime_Range = 0.03
end
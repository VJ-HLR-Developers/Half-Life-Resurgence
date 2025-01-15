include("entities/npc_vj_hlr1_snark/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/penguin.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.EntitiesToNoCollide = {"npc_vj_hlrof_penguin"} -- Set to a table of entity class names for the NPC to not collide with otherwise leave it to false
ENT.VJC_Data = {
    FirstP_Bone = "Bone22", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(4, 0, 30), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PENGUIN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR_Blood_Red"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Snark_CustomOnInitialize()
	self:SetCollisionBounds(Vector(7, 7, 25), Vector(-7, -7, 0))
	self.Snark_Type = 1
end
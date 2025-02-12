include("entities/npc_vj_hlr1_snark/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/penguin.mdl"
ENT.EntitiesToNoCollide = {"npc_vj_hlrof_penguin"}
ENT.ControllerParameters = {
    FirstP_Bone = "Bone22",
    FirstP_Offset = Vector(4, 0, 30),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PENGUIN"}
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR_Blood_Red"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Snark_CustomOnInitialize()
	self:SetCollisionBounds(Vector(7, 7, 25), Vector(-7, -7, 0))
	self.Snark_Type = 1
end
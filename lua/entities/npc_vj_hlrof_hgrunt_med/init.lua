include("entities/npc_vj_hlrof_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/hgrunt_medic.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 1), -- The offset for the controller when the camera is in first person
}
ENT.IsMedic = true -- Is this NPC a medic? It will heal friendly players and NPCs

-- Custom
ENT.HECUMedic_HealBG = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	-- Medic bodygroup starts from 2
	self:SetBodygroup(2, math.random(0, 1))
	
	self:SetBodygroup(3, math.random(0, 1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMedicBehavior(status, statusData)
	if status == "BeforeHeal" then
		self.HECUMedic_HealBG = self:GetBodygroup(3)
		self:PlayAnim("pull_needle", true, false, false, 0, {OnFinish=function(interrupted, anim)
			if interrupted then return end
			self:PlayAnim("give_shot", true, false, false, 0, {OnFinish=function(interrupted2, anim2)
				self:PlayAnim("store_needle", true, false)
			end})
		end})
	end
end
include("entities/npc_vj_hlrof_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/hgrunt_medic.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(5, 0, 1),
}
ENT.IsMedic = true

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
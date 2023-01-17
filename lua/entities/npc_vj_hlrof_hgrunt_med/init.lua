AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/hgrunt_medic.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 1), -- The offset for the controller when the camera is in first person
}
ENT.IsMedicSNPC = true -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)

-- Custom
ENT.HECUMedic_HealBG = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	-- Medic bodygroup starts from 2
	self:SetBodygroup(2, math.random(0, 1))
	
	self:SetBodygroup(3, math.random(0, 1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_BeforeHeal()
	self.HECUMedic_HealBG = self:GetBodygroup(3)
	self:VJ_ACT_PLAYACTIVITY("pull_needle", true, false, false, 0, {OnFinish=function(interrupted, anim)
		if interrupted then return end
		self:VJ_ACT_PLAYACTIVITY("give_shot", true, false, false, 0, {OnFinish=function(interrupted2, anim2)
			self:VJ_ACT_PLAYACTIVITY("store_needle", true, false)
		end})
	end})
end
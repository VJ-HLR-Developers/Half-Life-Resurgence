AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2b/merkava.mdl" -- Model(s) to spawn with | Picks a random one if it's a table 
ENT.StartHealth = 500
ENT.ControllerVars = {
    ThirdP_Offset = Vector(-40, 0, 20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "body", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 70), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.FriendsWithAllPlayerAllies = true

ENT.Tank_GunnerENT = "npc_vj_hlr2b_merkava_gun"
ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 100
ENT.Tank_DeathDriverCorpse = {"models/Humans/Group03m/male_01.mdl","models/Humans/Group03m/male_02.mdl","models/Humans/Group03m/male_03.mdl","models/Humans/Group03m/male_04.mdl","models/Humans/Group03m/male_05.mdl","models/Humans/Group03m/male_06.mdl","models/Humans/Group03m/male_07.mdl","models/Humans/Group03m/male_08.mdl","models/Humans/Group03m/male_09.mdl"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Init()
	self:SetSkin(math.random(0, 1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos() + self:GetUp() * 69
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateIdleParticles()
	local effectData = EffectData()
	effectData:SetScale(2)
	effectData:SetEntity(self)
	effectData:SetOrigin(self:GetPos() + self:GetForward() * -130 + self:GetRight() * 25  + self:GetUp() * 45)
	util.Effect("VJ_VehicleExhaust", effectData, true, true)
	effectData:SetOrigin(self:GetPos() + self:GetForward() * -130 + self:GetRight() * -28 + self:GetUp() * 45)
	util.Effect("VJ_VehicleExhaust", effectData, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateMoveParticles()
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetEntity(self)
	effectData:SetOrigin(self:GetPos() + self:GetForward() * -115 + self:GetRight() * 58)
	util.Effect("VJ_VehicleMove", effectData, true, true)
	effectData:SetOrigin(self:GetPos() + self:GetForward() * -115 + self:GetRight() * -58)
	util.Effect("VJ_VehicleMove", effectData, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThink()
	-- Keep the skin of the gunner the same!
	if IsValid(self.Gunner) then
		self.Gunner:SetSkin(self:GetSkin())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randPos = math.random(1, 5)
	if randPos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*15 + self:GetForward()*-16 + self:GetUp()*120)
	elseif randPos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 3 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 4 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*60 + self:GetForward()*-40 + self:GetUp()*81)
	elseif randPos == 5 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-60 + self:GetForward()*-40 + self:GetUp()*81)
	end
end
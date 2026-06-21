/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Xen Plant Light"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.XenPlant_Retracted = false
ENT.XenPlant_NextDeployT = 0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/vj_hlr/hl1/light.mdl")
	self:SetCollisionBounds(Vector(8, 8, 22), Vector(-8, -8, 0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:ResetSequence("Idle1")

	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "6")
	dynLight:SetKeyValue("distance", "150")
	dynLight:SetLocalPos(self:GetPos())
	dynLight:SetLocalAngles(self:GetAngles())
	dynLight:Fire("Color", "255 128 0")
	dynLight:SetParent(self)
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:SetParent(self)
	dynLight:Fire("SetParentAttachment", "0", 0)
	dynLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(dynLight)
	self.DynamicLight = dynLight

	local flareSpr = ents.Create("env_sprite")
	flareSpr:SetKeyValue("model", "vj_hl/sprites/flare3.vmt")
	flareSpr:SetKeyValue("rendercolor", "255 128 0")
	flareSpr:SetKeyValue("GlowProxySize", "5.0")
	flareSpr:SetKeyValue("HDRColorScale", "1.0")
	flareSpr:SetKeyValue("renderfx", "14")
	flareSpr:SetKeyValue("rendermode", "3")
	flareSpr:SetKeyValue("renderamt", "255")
	flareSpr:SetKeyValue("disablereceiveshadows", "0")
	flareSpr:SetKeyValue("mindxlevel", "0")
	flareSpr:SetKeyValue("maxdxlevel", "0")
	flareSpr:SetKeyValue("framerate", "10.0")
	flareSpr:SetKeyValue("spawnflags", "0")
	flareSpr:SetKeyValue("scale", "0.5")
	flareSpr:SetPos(self:GetPos())
	flareSpr:Spawn()
	flareSpr:SetParent(self)
	flareSpr:Fire("SetParentAttachment", "0", 0)
	self:DeleteOnRemove(flareSpr)
	self.FlareSprite = flareSpr
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local curTime = CurTime()
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 80)) do
		if v.VJ_ID_Living && v:Alive() then
			if !self.XenPlant_Retracted then
				self:ResetSequence("Retract")
				self.FlareSprite:Fire("HideSprite", "", 0.1)
				self.DynamicLight:Fire("TurnOff", "", 0)
				self:SetSkin(1)
			end
			self.XenPlant_Retracted = true
			self.XenPlant_NextDeployT = curTime + math.Rand(3, 5)
			self:NextThink(curTime)
			return true
		end
	end

	if self.XenPlant_Retracted && self.XenPlant_NextDeployT < curTime then
		self.XenPlant_Retracted = false
		self:ResetSequence("Delpoy")
		timer.Simple(1, function()
			if IsValid(self) && !self.XenPlant_Retracted then
				self.FlareSprite:Fire("ShowSprite", "", 0)
				self.DynamicLight:Fire("TurnOn", "", 0)
				self:SetSkin(0)
			end
		end)
		timer.Simple(1.85, function()
			if IsValid(self) && !self.XenPlant_Retracted then
				self:ResetSequence("Idle1")
			end
		end)
	end
	self:NextThink(curTime)
	return true
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
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
	
	self.DynamicLight = ents.Create("light_dynamic")
	self.DynamicLight:SetKeyValue("brightness", "6")
	self.DynamicLight:SetKeyValue("distance", "150")
	self.DynamicLight:SetLocalPos(self:GetPos())
	self.DynamicLight:SetLocalAngles(self:GetAngles())
	self.DynamicLight:Fire("Color", "255 128 0")
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Spawn()
	self.DynamicLight:Activate()
	self.DynamicLight:SetParent(self)
	self.DynamicLight:Fire("SetParentAttachment", "0", 0)
	self.DynamicLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.DynamicLight)
	
	self.FlareSprite = ents.Create("env_sprite")
	self.FlareSprite:SetKeyValue("model","vj_hl/sprites/flare3.vmt")
	self.FlareSprite:SetKeyValue("rendercolor","255 128 0")
	self.FlareSprite:SetKeyValue("GlowProxySize","5.0")
	self.FlareSprite:SetKeyValue("HDRColorScale","1.0")
	self.FlareSprite:SetKeyValue("renderfx","14")
	self.FlareSprite:SetKeyValue("rendermode","3")
	self.FlareSprite:SetKeyValue("renderamt","255")
	self.FlareSprite:SetKeyValue("disablereceiveshadows","0")
	self.FlareSprite:SetKeyValue("mindxlevel","0")
	self.FlareSprite:SetKeyValue("maxdxlevel","0")
	self.FlareSprite:SetKeyValue("framerate","10.0")
	self.FlareSprite:SetKeyValue("spawnflags","0")
	self.FlareSprite:SetKeyValue("scale","0.5")
	self.FlareSprite:SetPos(self:GetPos())
	self.FlareSprite:Spawn()
	self.FlareSprite:SetParent(self)
	self.FlareSprite:Fire("SetParentAttachment", "0", 0)
	self:DeleteOnRemove(self.FlareSprite)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 80)) do
		if v.VJ_ID_Living && v:Alive() then
			if self.XenPlant_Retracted == false then
				self:ResetSequence("Retract")
				self.FlareSprite:Fire("HideSprite", "", 0.1)
				self.DynamicLight:Fire("TurnOff", "", 0)
				self:SetSkin(1)
			end
			self.XenPlant_Retracted = true
			self.XenPlant_NextDeployT = CurTime() + math.Rand(3, 5)
			self:NextThink(CurTime())
			return true
		end
	end
	
	if self.XenPlant_Retracted == true && self.XenPlant_NextDeployT < CurTime() then
		self.XenPlant_Retracted = false
		self:ResetSequence("Delpoy")
		timer.Simple(1, function()
			if IsValid(self) && self.XenPlant_Retracted == false then
				self.FlareSprite:Fire("ShowSprite", "", 0)
				self.DynamicLight:Fire("TurnOn", "", 0)
				self:SetSkin(0)
			end
		end)
		timer.Simple(1.85, function()
			if IsValid(self) && self.XenPlant_Retracted == false then
				self:ResetSequence("Idle1")
			end
		end)
	end
	self:NextThink(CurTime())
	return true
end
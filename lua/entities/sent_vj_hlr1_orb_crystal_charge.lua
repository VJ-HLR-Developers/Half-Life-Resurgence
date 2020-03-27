/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "prop_vj_animatable"
ENT.PrintName		= "Crystal Charge Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if (CLIENT) then
	local Name = "Crystal Charge Orb"
	local LangName = "sent_vj_hlr1_orb_crystal_charge"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end

ENT.Model = {"models/spitball_large.mdl"} -- The models it should spawn with | Picks a random one from the table

-- Custom
ENT.EO_Enemy = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	/*phys:Wake()
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	phys:EnableGravity(false)*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetModel("models/spitball_large.mdl")
	self:SetNoDraw(true)
	
	self.StartGlow1 = ents.Create("env_sprite")
	self.StartGlow1:SetKeyValue("model","vj_hl/sprites/muzzleflash3.vmt")
	//self.StartGlow1:SetKeyValue("rendercolor","255 128 0")
	self.StartGlow1:SetKeyValue("GlowProxySize","2.0")
	self.StartGlow1:SetKeyValue("HDRColorScale","1.0")
	self.StartGlow1:SetKeyValue("renderfx","14")
	self.StartGlow1:SetKeyValue("rendermode","3")
	self.StartGlow1:SetKeyValue("renderamt","255")
	self.StartGlow1:SetKeyValue("disablereceiveshadows","0")
	self.StartGlow1:SetKeyValue("mindxlevel","0")
	self.StartGlow1:SetKeyValue("maxdxlevel","0")
	self.StartGlow1:SetKeyValue("framerate","10.0")
	self.StartGlow1:SetKeyValue("spawnflags","0")
	self.StartGlow1:SetKeyValue("scale","3.5")
	self.StartGlow1:SetPos(self:GetPos())
	self.StartGlow1:Spawn()
	self.StartGlow1:SetParent(self)
	self:DeleteOnRemove(self.StartGlow1)
end
ENT.TestPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.TestPos == 0 then
		self:SetPos(self:GetPos() + self:GetForward() * 5 + self:GetRight() * 5)
		self.TestPos = 1
	elseif self.TestPos == 1 then
		self:SetPos(self:GetPos() + self:GetForward() * -5 + self:GetRight() * -5)
		self.TestPos = 2
	elseif self.TestPos == 2 then
		self:SetPos(self:GetPos() + self:GetForward() * -5 + self:GetRight() * -5)
		self.TestPos = 3
	elseif self.TestPos == 3 then
		self:SetPos(self:GetPos() + self:GetForward() * 5 + self:GetRight() * 5)
		self.TestPos = 0
	end
	if IsValid(self.EO_Enemy) then -- Homing Behavior
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.EO_Enemy:GetPos() + self.EO_Enemy:OBBCenter(), 700))
		end
	end
	self:NextThink(CurTime())
	return true
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
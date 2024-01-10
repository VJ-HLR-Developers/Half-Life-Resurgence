/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Energy Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if CLIENT then
	local Name = "Energy Orb"
	local LangName = "obj_vj_hlr1_energyorb"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/spitball_large.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 5 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SHOCK -- Damage type
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav","vj_hlr/hl1_weapon/gauss/electro5.wav","vj_hlr/hl1_weapon/gauss/electro6.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Enemy = NULL
ENT.Track_Position = defVec
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	phys:EnableGravity(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNoDraw(true)
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("model","vj_hl/sprites/xspark4.vmt")
	//sprite:SetKeyValue("rendercolor","255 128 0")
	sprite:SetKeyValue("GlowProxySize","2.0")
	sprite:SetKeyValue("HDRColorScale","1.0")
	sprite:SetKeyValue("renderfx","14")
	sprite:SetKeyValue("rendermode","3")
	sprite:SetKeyValue("renderamt","255")
	sprite:SetKeyValue("disablereceiveshadows","0")
	sprite:SetKeyValue("mindxlevel","0")
	sprite:SetKeyValue("maxdxlevel","0")
	sprite:SetKeyValue("framerate","10.0")
	sprite:SetKeyValue("spawnflags","0")
	sprite:SetKeyValue("scale","1")
	sprite:SetPos(self:GetPos())
	sprite:Spawn()
	sprite:SetParent(self)
	self:DeleteOnRemove(sprite)
	self.GlowSprite = sprite
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local trackedEnt = self.Track_Enemy
	if IsValid(trackedEnt) then -- Homing Behavior
		self.DirectDamage = 25
		if IsValid(self.GlowSprite) then
			self.GlowSprite:SetKeyValue("scale", "1.5")
		end
		local pos = trackedEnt:GetPos() + trackedEnt:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.Track_Position, 700))
		end
	end
end
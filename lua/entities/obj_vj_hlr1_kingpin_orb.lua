/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Kingpin Energy Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

ENT.VJTag_ID_Danger = true

if CLIENT then
	local Name = "Kingpin Energy Orb"
	local LangName = "obj_vj_hlr1_kingpin_orb"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/spitball_large.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 30 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_DISSOLVE -- Damage type
ENT.DelayedRemove = 1.5 -- Change this to a number greater than 0 to delay the removal of the entity
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav","vj_hlr/hl1_weapon/gauss/electro5.wav","vj_hlr/hl1_weapon/gauss/electro6.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/kingpin/kingpin_seeker_amb.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Enemy = NULL
ENT.Track_Position = defVec
ENT.Track_OrbSpeed = 200
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
	
	self.StartGlow1 = ents.Create("env_sprite")
	self.StartGlow1:SetKeyValue("model","vj_hl/sprites/nhth1.vmt")
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
	self.StartGlow1:SetKeyValue("scale","1")
	self.StartGlow1:SetPos(self:GetPos())
	self.StartGlow1:Spawn()
	self.StartGlow1:SetParent(self)
	self:DeleteOnRemove(self.StartGlow1)
	util.SpriteTrail(self, 0, Color(255,127,223,180), true, 50, 0, 1.5, 1/(6 + 0)*0.5, "vj_hl/sprites/laserbeam.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self:GetOwner()) then
		self.Track_Enemy = self:GetOwner():GetEnemy()
	end
	if IsValid(self.Track_Enemy) then
		local pos = (self.Track_Enemy:EyePos()) or (self.Track_Enemy:GetPos() + self.Track_Enemy:OBBCenter())
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			-- phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.Track_Enemy:GetPos() + self.Track_Enemy:OBBCenter(), 200))
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.Track_Position, self.Track_OrbSpeed))
		end
	end
	self.Track_OrbSpeed = math.Clamp(self.Track_OrbSpeed + 10, 200, 2000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data, phys)
	self.StartGlow1:Remove()
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Kingpin Energy Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

ENT.VJ_ID_Danger = true

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_kingpin_orb", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 30
ENT.DirectDamageType = DMG_DISSOLVE
ENT.RemoveDelay = 1.5
ENT.SoundTbl_Idle = "vj_hlr/gsrc/npc/kingpin/kingpin_seeker_amb.wav"
ENT.SoundTbl_OnCollide = {"vj_hlr/gsrc/wep/gauss/electro4.wav", "vj_hlr/gsrc/wep/gauss/electro5.wav", "vj_hlr/gsrc/wep/gauss/electro6.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Ent = NULL
ENT.Track_Position = defVec
ENT.Track_OrbSpeed = 200
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	
	self.MainSprite = ents.Create("env_sprite")
	self.MainSprite:SetKeyValue("model", "vj_hl/sprites/nhth1.vmt")
	self.MainSprite:SetKeyValue("GlowProxySize", "2.0")
	self.MainSprite:SetKeyValue("HDRColorScale", "1.0")
	self.MainSprite:SetKeyValue("renderfx", "14")
	self.MainSprite:SetKeyValue("rendermode", "3")
	self.MainSprite:SetKeyValue("renderamt", "255")
	self.MainSprite:SetKeyValue("disablereceiveshadows", "0")
	self.MainSprite:SetKeyValue("mindxlevel", "0")
	self.MainSprite:SetKeyValue("maxdxlevel", "0")
	self.MainSprite:SetKeyValue("framerate", "10.0")
	self.MainSprite:SetKeyValue("spawnflags", "0")
	self.MainSprite:SetKeyValue("scale", "1")
	self.MainSprite:SetPos(self:GetPos())
	self.MainSprite:Spawn()
	self.MainSprite:SetParent(self)
	self:DeleteOnRemove(self.MainSprite)
	util.SpriteTrail(self, 0, Color(255, 127, 223, 180), true, 50, 0, 1.5, 1/(6 + 0)*0.5, "vj_hl/sprites/laserbeam.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if IsValid(self:GetOwner()) then
		self.Track_Ent = self:GetOwner():GetEnemy()
	end
	if IsValid(self.Track_Ent) then
		local pos = (self.Track_Ent:EyePos()) or (self.Track_Ent:GetPos() + self.Track_Ent:OBBCenter())
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self, self.Track_Ent, "Line", self:GetPos(), self.Track_Position, self.Track_OrbSpeed))
		end
	end
	self.Track_OrbSpeed = math.Clamp(self.Track_OrbSpeed + 10, 200, 2000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	self.MainSprite:Remove()
end
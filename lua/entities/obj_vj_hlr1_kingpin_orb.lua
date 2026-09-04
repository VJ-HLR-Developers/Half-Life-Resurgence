/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "obj_vj_projectile_base"
ENT.PrintName = "Kingpin Energy Orb"
ENT.Author = "DrVrej"
ENT.Contact = "http://steamcommunity.com/groups/vrejgaming"

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
local defVec = Vector()

ENT.Track_Ent = NULL
ENT.Track_Position = defVec
ENT.Track_OrbSpeed = 200
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)

	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "vj_hl/sprites/nhth1.vmt")
	spr:SetKeyValue("GlowProxySize", "2.0")
	spr:SetKeyValue("HDRColorScale", "1.0")
	spr:SetKeyValue("renderfx", "14")
	spr:SetKeyValue("rendermode", "3")
	spr:SetKeyValue("renderamt", "255")
	spr:SetKeyValue("disablereceiveshadows", "0")
	spr:SetKeyValue("mindxlevel", "0")
	spr:SetKeyValue("maxdxlevel", "0")
	spr:SetKeyValue("framerate", "10.0")
	spr:SetKeyValue("spawnflags", "0")
	spr:SetKeyValue("scale", "1")
	spr:SetPos(self:GetPos())
	spr:Spawn()
	spr:SetParent(self)
	self.MainSprite = spr
	self:DeleteOnRemove(spr)
	util.SpriteTrail(self, 0, Color(255, 127, 223, 180), true, 50, 0, 1.5, 1 / (6 + 0) * 0.5, "vj_hl/sprites/laserbeam.vmt")
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
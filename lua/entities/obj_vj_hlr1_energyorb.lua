/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Energy Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_energyorb", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 5
ENT.DirectDamageType = DMG_SHOCK
ENT.SoundTbl_OnCollide = {"vj_hlr/gsrc/wep/gauss/electro4.wav", "vj_hlr/gsrc/wep/gauss/electro5.wav", "vj_hlr/gsrc/wep/gauss/electro6.wav"}

-- Custom
local defVec = Vector()

ENT.Track_Ent = NULL
ENT.Track_Position = defVec
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)

	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "vj_hl/sprites/xspark4.vmt")
	//spr:SetKeyValue("rendercolor", "255 128 0")
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
	self:DeleteOnRemove(spr)
	self.GlowSprite = spr
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local trackedEnt = self.Track_Ent
	-- Homing Behavior
	if IsValid(trackedEnt) then
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
			phys:SetVelocity(VJ.CalculateTrajectory(self, trackedEnt, "Line", self:GetPos(), self.Track_Position, 700))
		end
	end
end
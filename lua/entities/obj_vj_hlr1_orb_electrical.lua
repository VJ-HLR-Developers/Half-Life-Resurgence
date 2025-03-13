/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Electrical Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_orb_electrical", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 30
ENT.DirectDamageType = DMG_SHOCK
ENT.SoundTbl_OnCollide = {"vj_hlr/gsrc/wep/gauss/electro4.wav", "vj_hlr/gsrc/wep/gauss/electro5.wav", "vj_hlr/gsrc/wep/gauss/electro6.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Ent = NULL
ENT.Track_Position = defVec
ENT.Track_SpriteScale = 1.2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("model", "vj_hl/sprites/nhth1.vmt")
	//sprite:SetKeyValue("rendercolor", "255 128 0")
	sprite:SetKeyValue("GlowProxySize", "2.0")
	sprite:SetKeyValue("HDRColorScale", "1.0")
	sprite:SetKeyValue("renderfx", "14")
	sprite:SetKeyValue("rendermode", "3")
	sprite:SetKeyValue("renderamt", "255")
	sprite:SetKeyValue("disablereceiveshadows", "0")
	sprite:SetKeyValue("mindxlevel", "0")
	sprite:SetKeyValue("maxdxlevel", "0")
	sprite:SetKeyValue("framerate", "10.0")
	sprite:SetKeyValue("spawnflags", "0")
	sprite:SetKeyValue("scale", ""..self.Track_SpriteScale)
	sprite:SetPos(self:GetPos())
	sprite:Spawn()
	sprite:SetParent(self)
	self:DeleteOnRemove(sprite)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if IsValid(self.Track_Ent) then -- Homing Behavior
		local pos = self.Track_Ent:GetPos() + self.Track_Ent:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self, self.Track_Ent, "Line", self:GetPos(), self.Track_Position, 700))
		end
	end
end
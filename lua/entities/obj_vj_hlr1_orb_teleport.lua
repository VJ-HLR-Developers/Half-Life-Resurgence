/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Teleportation Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

ENT.VJ_ID_Danger = true

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_orb_teleport", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 25
ENT.DirectDamageType = DMG_SHOCK
ENT.SoundTbl_Idle = "vj_hlr/gsrc/npc/x/x_teleattack1.wav"
ENT.SoundTbl_OnCollide = {"vj_hlr/gsrc/wep/gauss/electro4.wav", "vj_hlr/gsrc/wep/gauss/electro5.wav", "vj_hlr/gsrc/wep/gauss/electro6.wav"}

-- Custom
local defVec = Vector()

ENT.Track_Ent = NULL
ENT.Track_Position = defVec
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)

	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "vj_hl/sprites/exit1.vmt")
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
	spr:SetKeyValue("scale", "1.5")
	spr:SetPos(self:GetPos())
	spr:Spawn()
	spr:SetParent(self)
	self:DeleteOnRemove(spr)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Homing Behavior
	local trackedEnt = self.Track_Ent
	if IsValid(trackedEnt) then
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
---------------------------------------------------------------------------------------------------------------------------------------------
local colorGreen = Color(0, 255, 0, 255)
--
function ENT:OnDealDamage(data, phys, hitEnts)
	if !hitEnts then return end
	local owner = self:GetOwner()
	if !IsValid(owner) then
		owner = self
	end
	for _, ent in ipairs(hitEnts) do
		if !ent.VJ_ID_Boss && !ent.Dead && ent:GetClass() != "sent_vj_xen_crystal" then
			local tr = util.TraceLine({
				start = owner:GetPos(),
				endpos = owner:GetPos() + owner:GetForward() * math.Rand(-10000, 10000) + owner:GetRight() * math.Rand(-10000, 10000) + owner:GetUp() * -3000,
				filter = owner,
			})
			local pos = tr.HitPos + tr.HitNormal * ent:OBBMaxs()

			if ent:IsPlayer() then
				ent:ScreenFade(SCREENFADE.IN, colorGreen, 2, 1)
			end

			VJ.HLR1_Effect_Portal(self:GetPos())
			VJ.HLR1_Effect_Portal(pos, nil, nil, function()
				-- onSpawn
				if IsValid(ent) then
					ent:SetPos(pos)
				end
			end)
		end
	end
end
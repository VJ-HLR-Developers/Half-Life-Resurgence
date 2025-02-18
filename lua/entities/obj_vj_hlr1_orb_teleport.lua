/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Teleportation Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "Projectiles"

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
ENT.SoundTbl_Idle = "vj_hlr/hl1_npc/x/x_teleattack1.wav"
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav", "vj_hlr/hl1_weapon/gauss/electro5.wav", "vj_hlr/hl1_weapon/gauss/electro6.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Enemy = NULL
ENT.Track_Position = defVec
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("model","vj_hl/sprites/exit1.vmt")
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
	sprite:SetKeyValue("scale","1.5")
	sprite:SetPos(self:GetPos())
	sprite:Spawn()
	sprite:SetParent(self)
	self:DeleteOnRemove(sprite)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if IsValid(self.Track_Enemy) then -- Homing Behavior
		local pos = self.Track_Enemy:GetPos() + self.Track_Enemy:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self, self.Track_Enemy, "Line", self:GetPos(), self.Track_Position, 700))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorGreen = Color(0, 255, 0, 255)
--
function ENT:OnDealDamage(data, phys, hitEnts)
	if !hitEnts then return end
	local owner = self:GetOwner()
	for _, ent in ipairs(hitEnts) do
		if !ent.VJ_ID_Boss && !ent.Dead && ent:GetClass() != "sent_vj_xen_crystal" then
			local tr = util.TraceLine({
				start = owner:GetPos(),
				endpos = owner:GetPos() + owner:GetForward() * math.Rand(-10000, 10000) + owner:GetRight() * math.Rand(-10000, 10000) + owner:GetUp() * -3000, //math.Rand(-10000, 10000),
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
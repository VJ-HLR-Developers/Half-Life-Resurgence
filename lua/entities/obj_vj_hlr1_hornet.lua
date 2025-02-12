/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Hornet"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

ENT.VJ_ID_Danger = true
ENT.PhysicsSolidMask = MASK_SHOT

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_hornet", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/hl1/hornet.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 5
ENT.DirectDamageType = DMG_SLASH
ENT.CollisionBehavior = VJ.PROJ_COLLISION_PERSIST
ENT.CollisionDecal = "VJ_HLR_Blood_Yellow"
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/hornet/ag_hornethit1.wav", "vj_hlr/hl1_npc/hornet/ag_hornethit2.wav", "vj_hlr/hl1_npc/hornet/ag_hornethit3.wav"}

ENT.IdleSoundPitch = VJ.SET(100, 100)

local sdIdle = {"vj_hlr/hl1_npc/hornet/ag_buzz1.wav", "vj_hlr/hl1_npc/hornet/ag_buzz2.wav", "vj_hlr/hl1_npc/hornet/ag_buzz3.wav"}
local sdCollideAlpha = {"vj_hlr/hla_npc/hornet/ag_buzz1.wav", "vj_hlr/hla_npc/hornet/ag_buzz2.wav", "vj_hlr/hla_npc/hornet/ag_buzz3.wav"}

local defVec = Vector(0, 0, 0)

local HORNET_TYPE_RED = 0
local HORNET_TYPE_ORANGE = 1
local HORNET_TYPE_ALPHA = 2

-- Custom
ENT.Track_Enemy = NULL
ENT.Track_Position = defVec
ENT.Hornet_Alpha = false
ENT.Hornet_ChaseSpeed = 600
ENT.Hornet_Type = HORNET_TYPE_RED
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = Color(179, 39, 14)
local colorOrange = Color(255, 128, 0)
--
function ENT:Init()
	timer.Simple(5, function() if IsValid(self) then self:Remove() end end)
	
	if self.Hornet_Alpha then
		self.SoundTbl_OnCollide = sdCollideAlpha
		self.Hornet_Type = HORNET_TYPE_ALPHA
		self.Hornet_ChaseSpeed = 400
	else
		self.SoundTbl_Idle = sdIdle
		self.Hornet_Type = math.random(1, 5) <= 2 and HORNET_TYPE_RED or HORNET_TYPE_ORANGE
		self.Hornet_ChaseSpeed = (self.Hornet_Type == HORNET_TYPE_RED and 600) or 800
		util.SpriteTrail(self, 0, (self.Hornet_Type == HORNET_TYPE_RED and colorRed) or colorOrange, true, 6, 0, 1.5, 1 / (6 * 0.5), "vj_hl/sprites/laserbeam.vmt")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local phys = self:GetPhysicsObject()
	local trackedEnt = self.Track_Enemy
	-- Homing Behavior
	if IsValid(trackedEnt) then
		local pos = trackedEnt:GetPos() + trackedEnt:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.Track_Position + trackedEnt:GetUp()*math.random(-50,50) + trackedEnt:GetRight()*math.random(-50,50), self.Hornet_ChaseSpeed))
			self:SetAngles(self:GetVelocity():GetNormal():Angle())
		end
	-- Not tracking, go in straight line
	else
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self:GetPos() + self:GetForward()*math.random(-80, 80)+ self:GetRight()*math.random(-80, 80) + self:GetUp()*math.random(-80, 80), self.Hornet_ChaseSpeed / 2))
			self:SetAngles(self:GetVelocity():GetNormal():Angle())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	local lastVel = math.max(data.OurOldVelocity:Length(), data.Speed) -- Get the last velocity and speed
	local newVel = phys:GetVelocity():GetNormal()
	lastVel = math.max(newVel:Length(), lastVel)
	phys:SetVelocity(newVel * lastVel * 0.3)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
	
	-- Remove if it's a living being
	if data.HitEntity.VJ_ID_Living then
		self.CollisionBehavior = VJ.PROJ_COLLISION_REMOVE
	end
end
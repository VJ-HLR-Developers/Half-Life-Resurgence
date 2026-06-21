/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Crystal Charge Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("sent_vj_hlr1_orb_crystal_charge", ENT.PrintName)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

-- Custom
ENT.Assignee = NULL
ENT.NextMoveT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self:SetNoDraw(true)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	//ParticleEffectAttach("vj_hlr_nihilanth_chargeorb", PATTACH_ABSORIGIN_FOLLOW, self, 0)

	local glowSpr = ents.Create("env_sprite")
	glowSpr:SetKeyValue("model", "vj_hl/sprites/muzzleflash3.vmt")
	glowSpr:SetKeyValue("GlowProxySize", "2.0")
	glowSpr:SetKeyValue("HDRColorScale", "1.0")
	glowSpr:SetKeyValue("renderfx", "14")
	glowSpr:SetKeyValue("rendermode", "3")
	glowSpr:SetKeyValue("renderamt", "255")
	glowSpr:SetKeyValue("disablereceiveshadows", "0")
	glowSpr:SetKeyValue("mindxlevel", "0")
	glowSpr:SetKeyValue("maxdxlevel", "0")
	glowSpr:SetKeyValue("framerate", "10.0")
	glowSpr:SetKeyValue("spawnflags", "0")
	glowSpr:SetKeyValue("scale", "3.5")
	glowSpr:SetPos(self:GetPos())
	glowSpr:Spawn()
	glowSpr:SetParent(self)
	self:DeleteOnRemove(glowSpr)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableGravity(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local curTime = CurTime()
	local assignee = self.Assignee
	if IsValid(assignee) && curTime > self.NextMoveT then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self, assignee, "Line", self:GetPos(), assignee:GetPos() + assignee:GetUp() * math.Rand(200, 250) + assignee:GetRight() * math.Rand(-150, 150) + assignee:GetForward() * math.Rand(-150, 150), 500))
			phys:AddAngleVelocity(self:GetPos() + Vector(50, 50, 50)) -- Rotate randomly
		end
		self.NextMoveT = curTime + math.Rand(1, 2)
	end
	self:NextThink(curTime)
	return true
end
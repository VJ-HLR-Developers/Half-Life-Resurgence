/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
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
	
	local StartGlow1 = ents.Create("env_sprite")
	StartGlow1:SetKeyValue("model", "vj_hl/sprites/muzzleflash3.vmt")
	//StartGlow1:SetKeyValue("rendercolor", "255 128 0")
	StartGlow1:SetKeyValue("GlowProxySize", "2.0")
	StartGlow1:SetKeyValue("HDRColorScale", "1.0")
	StartGlow1:SetKeyValue("renderfx", "14")
	StartGlow1:SetKeyValue("rendermode", "3")
	StartGlow1:SetKeyValue("renderamt", "255")
	StartGlow1:SetKeyValue("disablereceiveshadows", "0")
	StartGlow1:SetKeyValue("mindxlevel", "0")
	StartGlow1:SetKeyValue("maxdxlevel", "0")
	StartGlow1:SetKeyValue("framerate", "10.0")
	StartGlow1:SetKeyValue("spawnflags", "0")
	StartGlow1:SetKeyValue("scale", "3.5")
	StartGlow1:SetPos(self:GetPos())
	StartGlow1:Spawn()
	StartGlow1:SetParent(self)
	self:DeleteOnRemove(StartGlow1)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableGravity(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local assignee = self.Assignee
	if IsValid(assignee) && CurTime() > self.NextMoveT then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(self, assignee, "Line", self:GetPos(), assignee:GetPos() + assignee:GetUp() * math.Rand(200, 250) + assignee:GetRight() * math.Rand(-150, 150) + assignee:GetForward() * math.Rand(-150, 150), 500))
			phys:AddAngleVelocity(self:GetPos() + Vector(50, 50, 50)) -- Rotate randomly
		end
		self.NextMoveT = CurTime() + math.Rand(1, 2)
	end
	self:NextThink(CurTime())
	return true
end
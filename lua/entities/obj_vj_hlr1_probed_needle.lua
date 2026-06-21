/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Probe Droid Needle"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_probed_needle", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/hla/pb_dart.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 15
ENT.DirectDamageType = DMG_POISON
ENT.CollisionDecal = "Impact.Concrete"
ENT.OnCollideSoundPitch = VJ.SET(100, 100)

local sdOnCollideEnt = {"vj_hlr/gsrc/wep/crossbow/xbow_hitbod1.wav", "vj_hlr/gsrc/wep/crossbow/xbow_hitbod2.wav"}
local defAng = Angle(0 , 0, 0)

-- Custom
ENT.Needle_Heal = false -- Is this a healing needle?
ENT.NextBubbles = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	if self.Needle_Heal then
		self.CollisionFilter = false
		self.DoesDirectDamage = false
	else
		ParticleEffect("vj_hlr_spit_drone_spawn_old", self:GetPos(), defAng)
		ParticleEffectAttach("vj_hlr_spit_drone", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local curTime = CurTime()
	if self:WaterLevel() == 3 && self.NextBubbles < curTime then
		local myPos = self:GetPos()
		effects.BubbleTrail(myPos - self:GetAbsVelocity() * 0.1, myPos, 2, -150, 20) -- height = -150 to prevent it from going out of water (bug with BubbleTrail)
		self.NextBubbles = curTime + 0.02
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	local hitEnt = data.HitEntity
	if IsValid(hitEnt) then
		self.SoundTbl_OnCollide = sdOnCollideEnt
		-- Only for healing
		if !self.Needle_Heal or !IsValid(self:GetOwner()) then return end
		if self:GetOwner():Disposition(hitEnt) then
			self.SoundTbl_OnCollide = "items/smallmedkit1.wav"
			hitEnt:RemoveAllDecals()
			local friHP = hitEnt:Health()
			hitEnt:SetHealth(math.Clamp(friHP + 40, friHP, hitEnt:GetMaxHealth()))
		end
	else
		self.SoundTbl_OnCollide = "vj_hlr/gsrc/wep/crossbow/xbow_hit1.wav"
		local spike = ents.Create("prop_dynamic")
		spike:SetModel("models/vj_hlr/hla/pb_dart.mdl")
		spike:SetPos(data.HitPos + data.HitNormal + self:GetForward()*-5)
		spike:SetAngles(self:GetAngles())
		spike:Activate()
		spike:Spawn()
		timer.Simple(6, function() if IsValid(spike) then spike:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDealDamage(data, phys, hitEnts)
	-- Only for attacks
	if !hitEnts or self.Needle_Heal then return end
	for _, ent in ipairs(hitEnts) do
		VJ.ApplySpeedEffect(ent, 0.2, 5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	if self.Needle_Heal then return end
	ParticleEffect("vj_hlr_spit_drone_impact", self:GetPos(), defAng)
end
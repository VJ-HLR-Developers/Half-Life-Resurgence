/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Probe Droid Needle"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

if CLIENT then
	local Name = "Probe Droid Needle"
	local LangName = "obj_vj_hlr1_probed_needle"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/hla/pb_dart.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.DoesDirectDamage = true -- Should it deal direct damage when it collides with something?
ENT.DirectDamage = 15
ENT.DirectDamageType = DMG_POISON
ENT.CollisionDecals = "Impact.Concrete"
ENT.OnCollideSoundPitch = VJ.SET(100, 100)

local sdOnCollideEnt = {"vj_hlr/hl1_weapon/crossbow/xbow_hitbod1.wav", "vj_hlr/hl1_weapon/crossbow/xbow_hitbod2.wav"}
local defAng = Angle(0 ,0, 0)

-- Custom
ENT.Needle_Heal = false -- Is this a healing needle?
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
function ENT:OnCollision(data, phys)
	local hitEnt = data.HitEntity
	if IsValid(hitEnt) then
		self.SoundTbl_OnCollide = sdOnCollideEnt
		-- Only for healing
		if self.Needle_Heal == false or !IsValid(self:GetOwner()) then return end
		if self:GetOwner():Disposition(hitEnt) then
			self.SoundTbl_OnCollide = "items/smallmedkit1.wav"
			hitEnt:RemoveAllDecals()
			local friHP = hitEnt:Health()
			hitEnt:SetHealth(math.Clamp(friHP + 40, friHP, hitEnt:GetMaxHealth()))
		end
	else
		self.SoundTbl_OnCollide = "vj_hlr/hl1_weapon/crossbow/xbow_hit1.wav"
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
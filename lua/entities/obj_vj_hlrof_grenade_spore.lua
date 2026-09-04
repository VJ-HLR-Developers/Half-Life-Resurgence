/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "obj_vj_projectile_base"
ENT.PrintName = "Spore Grenade"
ENT.Author = "DrVrej"
ENT.Contact = "http://steamcommunity.com/groups/vrejgaming"
ENT.Category = "Half-Life Resurgence"

ENT.VJ_ID_Grenade = true

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlrof_grenade_spore", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/weapons/spore.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_PROP
ENT.CollisionBehavior = VJ.PROJ_COLLISION_NONE
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 150
ENT.RadiusDamage = 80
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_RADIATION
ENT.RadiusDamageForce = 90
ENT.SoundTbl_OnCollide = {"vj_hlr/gsrc/wep/sporelauncher/spore_hit1.wav", "vj_hlr/gsrc/wep/sporelauncher/spore_hit2.wav", "vj_hlr/gsrc/wep/sporelauncher/spore_hit3.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	self:PhysicsInitSphere(4, "gmod_bouncy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffectAttach("vj_hlr_spore_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	timer.Simple(3, function() if IsValid(self) then self:Destroy() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	-- If the grenade is going faster than 100, then play the touch sound
	if phys:GetVelocity():Length() > 100 then
		self:PlaySound("OnCollide")
	end

	-- Don't bounce when hitting a living thing
	local ent = data.HitEntity
	if IsValid(ent) && ent.VJ_ID_Living then
		self:OnDestroy()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle()
--
function ENT:OnDestroy()
	ParticleEffect("vj_hlr_spore", self:GetPos(), defAng, nil)
	//ParticleEffect("vj_hl_spore_splash1", self:GetPos(), defAng, nil)
	//ParticleEffect("vj_hl_spore_splash2", self:GetPos(), defAng, nil)
	self:EmitSound("vj_hlr/gsrc/wep/sporelauncher/splauncher_impact.wav", 100, 100)
	self:DealDamage()
end
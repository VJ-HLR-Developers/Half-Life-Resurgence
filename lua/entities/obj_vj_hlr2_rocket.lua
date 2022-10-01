/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Rocket"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

ENT.VJ_IsDetectableDanger = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local Name = "Rocket"
	local LangName = "obj_vj_hlr2_rocket"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))

	function ENT:Think()
		if self:IsValid() then
			self.Emitter = ParticleEmitter(self:GetPos())
			self.SmokeEffect1 = self.Emitter:Add("particles/flamelet2",self:GetPos() +self:GetForward()*-7)
			self.SmokeEffect1:SetVelocity(self:GetForward() * math.Rand(0, -50) + Vector(math.Rand(5, -5), math.Rand(5, -5), math.Rand(5, -5)) + self:GetVelocity())
			self.SmokeEffect1:SetDieTime(0.2)
			self.SmokeEffect1:SetStartAlpha(100)
			self.SmokeEffect1:SetEndAlpha(0)
			self.SmokeEffect1:SetStartSize(10)
			self.SmokeEffect1:SetEndSize(1)
			self.SmokeEffect1:SetRoll(math.Rand(-0.2,0.2))
			self.SmokeEffect1:SetAirResistance(200)
			self.Emitter:Finish()
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/weapons/w_missile_launch.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 250 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 150 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 90 -- Put the force amount it should apply | false = Don't apply any force
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"weapons/rpg/rocket1.wav"}
ENT.SoundTbl_OnCollide = {"ambient/explosions/explode_8.wav"}

-- Custom
ENT.Rocket_Follow = true
ENT.Speed = 1200
ENT.TurnSpeed = 40
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	ParticleEffectAttach("vj_rpg1_fulltrail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("vj_rpg2_fulltrail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local owner = self:GetOwner()
	local phys = self:GetPhysicsObject()
	local ent = self.Target or owner:IsNPC() && owner:GetEnemy()
	local pos;
	local turnSpeed = self.TurnSpeed
	if owner:IsNPC() && IsValid(ent) && (owner.VJ_ForceRocketFollow or IsValid(owner:GetActiveWeapon())) then
		pos = (ent:GetPos() + ent:OBBCenter()) + ent:GetVelocity() * 0.25
	else
		if owner:IsPlayer() && self.Rocket_Follow then
			local shootPos = owner:GetShootPos()
			local tr = util.TraceLine({
				start = shootPos,
				endpos = shootPos + owner:GetAimVector() * 32768,
				filter = {owner, self}
			})
			pos = tr.HitPos
		else
			pos = self:GetPos() + (self:GetForward() * self.Speed + VectorRand(-1, 1))
			turnSpeed = 3
		end
	end
	if IsValid(phys) then
		local angVel = self:WorldToLocalAngles((pos - self:GetPos()):GetNormalized():Angle())
		angVel.p = math.Clamp(angVel.p * 800, -turnSpeed, turnSpeed)
		angVel.y = math.Clamp(angVel.y * 800, -turnSpeed, turnSpeed)
		angVel.r = math.Clamp(angVel.r * 800, -turnSpeed, turnSpeed)
		phys:AddAngleVelocity(Vector(angVel.r, angVel.p, angVel.y) - phys:GetAngleVelocity())
		phys:SetVelocityInstantaneous(self:GetForward() * self.Speed)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data, phys)
	util.ScreenShake(data.HitPos, 16, 200, 1, 3000)
	
	local effectdata = EffectData()
	effectdata:SetOrigin(data.HitPos)
	util.Effect("HelicopterMegaBomb", effectdata)
	util.Effect("ThumperDust", effectdata)
	util.Effect("Explosion", effectdata)
	util.Effect("VJ_Small_Explosion1", effectdata)

	local lightdyn = ents.Create("light_dynamic")
	lightdyn:SetKeyValue("brightness", "4")
	lightdyn:SetKeyValue("distance", "300")
	lightdyn:SetLocalPos(data.HitPos)
	lightdyn:SetLocalAngles(self:GetAngles())
	lightdyn:Fire("Color", "255 150 0")
	lightdyn:SetParent(self)
	lightdyn:Spawn()
	lightdyn:Activate()
	lightdyn:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(lightdyn)
end
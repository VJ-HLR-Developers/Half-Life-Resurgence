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
ENT.ShakeWorldOnDeath = true -- Should the world shake when the projectile hits something?
ENT.ShakeWorldOnDeathAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.ShakeWorldOnDeathRadius = 3000 -- How far the screen shake goes, in world units
ENT.ShakeWorldOnDeathFrequency = 200 -- The frequency
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"weapons/rpg/rocket1.wav"}
ENT.SoundTbl_OnCollide = {"ambient/explosions/explode_8.wav"}

-- Custom
ENT.Rocket_Follow = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
//	ParticleEffectAttach("vj_rpg1_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	//ParticleEffectAttach("vj_rpg2_smoke2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	
	self.LastAngle = self:GetAngles()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local owner = self:GetOwner()
	local phys = self:GetPhysicsObject()
	if IsValid(owner) && IsValid(phys) then
		local pos = self:GetPos() + self:GetForward()*200
		if owner:IsNPC() && IsValid(owner:GetEnemy()) && (owner.VJ_ForceRocketFollow or IsValid(owner:GetActiveWeapon())) then
			pos = owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter()
		elseif (owner:IsPlayer()) && self.Rocket_Follow == true then
			pos = owner:GetEyeTrace().HitPos
		end
		self.LastAngle = LerpAngle(FrameTime()*42, self.LastAngle, (pos - self:GetPos()):Angle())
		-- self:SetAngles((pos - self:GetPos()):Angle())
		phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self:GetPos() + self.LastAngle:Forward(), 2000))
		self:SetAngles(self.LastAngle)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data, phys)
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
/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Rocket"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

ENT.VJTag_ID_Danger = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local Name = "Rocket"
	local LangName = "obj_vj_hlr2_rocket"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
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
			pos = self:GetPos() + (self:GetForward() * self.Speed + VectorRand(-10, 10))
			-- turnSpeed = 20
		end
	end
	if IsValid(phys) then
		local dir = (pos - self:GetPos()):GetNormalized()
		local ang = dir:Angle()
		self.TargetAngle = LerpAngle(FrameTime() * turnSpeed, self.TargetAngle or ang, ang)

		phys:ApplyForceCenter(self:GetForward() * self.Speed)
		phys:SetAngles(self.TargetAngle)
	end

	sound.EmitHint(SOUND_DANGER, self:GetPos() + self:GetAbsVelocity() * 2, 100, 0.2, self)
	-- Source: CSoundEnt::InsertSound( SOUND_DANGER, tr.endpos, 100, 0.2, this, SOUNDENT_CHANNEL_REPEATED_DANGER );

	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle(0, 0, 0)
--
function ENT:DeathEffects(data, phys)
	VJ.EmitSound(self, "VJ.Explosion")
	ParticleEffect("vj_explosion3", data.HitPos, defAngle)
	util.ScreenShake(data.HitPos, 16, 200, 1, 3000)
	
	local effectData = EffectData()
	effectData:SetOrigin(data.HitPos)
	//effectData:SetScale(500)
	//util.Effect("HelicopterMegaBomb", effectData)
	//util.Effect("ThumperDust", effectData)
	//util.Effect("Explosion", effectData)
	util.Effect("VJ_Small_Explosion1", effectData)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "300")
	expLight:SetLocalPos(data.HitPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "255 150 0")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)
end
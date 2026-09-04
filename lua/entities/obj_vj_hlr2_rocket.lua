/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "obj_vj_projectile_base"
ENT.PrintName = "Rocket"
ENT.Author = "DrVrej"
ENT.Contact = "http://steamcommunity.com/groups/vrejgaming"

ENT.VJ_ID_Danger = true
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr2_rocket", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/weapons/w_missile_launch.mdl"
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 250
ENT.RadiusDamage = 150
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_BLAST
ENT.RadiusDamageForce = 90
ENT.CollisionDecal = "Scorch"
ENT.SoundTbl_Idle = "weapons/rpg/rocket1.wav"
ENT.SoundTbl_OnCollide = "ambient/explosions/explode_8.wav"

-- Custom
ENT.Rocket_Follow = true
ENT.Speed = 1800
ENT.TurnSpeed = 40
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffectAttach("vj_rocket_idle1", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("vj_rocket_idle2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local myPos = self:GetPos()
	local owner = self:GetOwner()
	local phys = self:GetPhysicsObject()
	local ent = self.Target or owner:IsNPC() && owner:GetEnemy()
	local pos;
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
			pos = myPos + (self:GetForward() * self.Speed + VectorRand(-10, 10))
		end
	end

	if IsValid(phys) then
		local dir = (pos - myPos):GetNormalized()
		self:SetAngles(LerpAngle(FrameTime() * self.TurnSpeed, self:GetAngles(), dir:Angle()))
		phys:SetVelocity(self:GetForward() * self.Speed)
	end

	sound.EmitHint(SOUND_DANGER, myPos + self:GetAbsVelocity() * 2, 100, 0.2, self)
	-- Source: CSoundEnt::InsertSound( SOUND_DANGER, tr.endpos, 100, 0.2, this, SOUNDENT_CHANNEL_REPEATED_DANGER );

	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAngle = Angle()
--
function ENT:OnDestroy(data, phys)
	VJ.EmitSound(self, "VJ.Explosion")
	ParticleEffect("vj_explosion3", data.HitPos, defAngle)
	util.ScreenShake(data.HitPos, 16, 200, 1, 3000)

	local effectData = EffectData()
	effectData:SetOrigin(data.HitPos)
	util.Effect("VJ_Small_Explosion1", effectData)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "300")
	expLight:SetPos(data.HitPos)
	expLight:Fire("Color", "255 150 0")
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn")
	expLight:Fire("Kill", nil, 0.15)
end
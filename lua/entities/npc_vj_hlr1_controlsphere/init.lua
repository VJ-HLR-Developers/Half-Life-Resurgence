AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/sphere.mdl"
ENT.StartHealth = 60
ENT.SightAngle = 100
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 50
ENT.Aerial_FlyingSpeed_Alerted = 80
ENT.ControllerParams = {
    FirstP_Bone = "Bone02",
    FirstP_Offset = Vector(5, 0, 7),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.ConstantlyFaceEnemy = true
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeDistance = 1020
ENT.RangeToMeleeDistance = 1
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 3
ENT.DisableDefaultRangeAttackCode = true

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.SoundTbl_Breath = "vj_hlr/hl1_npc/sphere/sph_motor1.wav"
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/sphere/sph_idle1.wav", "vj_hlr/hl1_npc/sphere/sph_idle2.wav"}
ENT.SoundTbl_Alert = "vj_hlr/hl1_npc/sphere/sph_alert1.wav"
ENT.SoundTbl_BeforeRangeAttack = "vj_hlr/fx/zap4.wav"
ENT.SoundTbl_RangeAttack = "vj_hlr/hl1_npc/hassault/hw_shoot1.wav"
ENT.SoundTbl_Pain = "vj_hlr/hl1_npc/sphere/sph_pain1.wav"
ENT.SoundTbl_Death = "vj_hlr/hl1_npc/sphere/sph_pain1.wav"

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(8, 8, 12), Vector(-8, -8, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "shoot" then
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && (self:GetNPCState() == NPC_STATE_ALERT or self:GetNPCState() == NPC_STATE_COMBAT) then
		return ACT_IDLE_ANGRY
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Make it use the bright skin when it's low health
	self:SetSkin((self:Health() <= (self:GetMaxHealth() / 2.2)) and 1 or 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CSphere_DoElecEffect(startPos, hitPos, hitNormal)
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetNormal(hitNormal)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	elec:SetScale(0.8)
	util.Effect("VJ_HLR_Electric_Charge", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	local myPos = self:GetPos()
	local myForward = self:GetForward()
	local myRight = self:GetRight()
	local myUp = self:GetUp()
	
	-- Tsakh --------------------------
	local tsakhSpawn = myPos + myUp*45 + myRight*20
	local tsakhLocations = {
		myPos + myRight*math.Rand(150, 500) + myUp*-200,
		myPos + myRight*math.Rand(150, 500) + myUp*-200 + myForward*-math.Rand(150, 500),
		myPos + myRight*math.Rand(150, 500) + myUp*-200 + myForward*math.Rand(150, 500),
		myPos + myRight*math.Rand(1, 150) + myUp*200 + myForward*math.Rand(-100, 100),
	}
	for i = 1, 4 do
		local tr = util.TraceLine({
			start = tsakhSpawn,
			endpos = tsakhLocations[i],
			filter = self
		})
		if tr.Hit == true then self:CSphere_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal) end
	end
	-- Ach --------------------------
	local achSpawn = myPos + myUp*45 + myRight*-20
	local achLocations = {
		myPos + myRight*-math.Rand(150, 500) + myUp*-200,
		myPos + myRight*-math.Rand(150, 500) + myUp*-200 + myForward*-math.Rand(150, 500),
		myPos + myRight*-math.Rand(150, 500) + myUp*-200 + myForward*math.Rand(150, 500),
		myPos + myRight*-math.Rand(1, 150) + myUp*200 + myForward*math.Rand(-100, 100),
	}
	for i = 1, 4 do
		local tr = util.TraceLine({
			start = achSpawn,
			endpos = achLocations[i],
			filter = self
		})
		if tr.Hit == true then self:CSphere_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local startPos = self:GetPos() + self:GetForward()*8
	local tr = util.TraceLine({
		start = startPos,
		endpos = self:GetAimPosition(self:GetEnemy(), startPos, 0),
		filter = self
	})
	local hitPos = tr.HitPos
	
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	util.Effect("VJ_HLR_Electric", elec)
	
	VJ.ApplyRadiusDamage(self, self, hitPos, 30, 10, DMG_SHOCK, true, false, {Force = 90})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(2) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(40)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 0))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 0))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 0))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 1))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
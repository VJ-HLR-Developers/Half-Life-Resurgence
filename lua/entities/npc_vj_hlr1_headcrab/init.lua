AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/headcrab.mdl"
ENT.StartHealth = 10
ENT.SightAngle = 120
ENT.HullType = HULL_TINY
ENT.EntitiesToNoCollide = {"npc_vj_hlr1_gonarch"}
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, 0),
    FirstP_Bone = "Bip01 Neck",
    FirstP_Offset = Vector(2, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = false

ENT.HasLeapAttack = true
ENT.LeapAttackDamage = 10
ENT.AnimTbl_LeapAttack = ACT_RANGE_ATTACK1
ENT.LeapAttackMaxDistance = 256
ENT.LeapAttackMinDistance = 1
ENT.LeapAttackDamageDistance = 50
ENT.TimeUntilLeapAttackDamage = 0.4
ENT.TimeUntilLeapAttackVelocity = 0.4
ENT.NextLeapAttackTime = 1
ENT.LeapAttackExtraTimers = {0.6, 0.8, 1, 1.2, 1.4}
ENT.NextAnyAttackTime_Leap = 3
ENT.LeapAttackStopOnHit = true

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = 200
ENT.LimitChaseDistance_Min = 0

ENT.CanFlinch = true
ENT.FlinchChance = 3
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH

ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/headcrab/hc_idle1.wav", "vj_hlr/hl1_npc/headcrab/hc_idle2.wav", "vj_hlr/hl1_npc/headcrab/hc_idle3.wav", "vj_hlr/hl1_npc/headcrab/hc_idle4.wav", "vj_hlr/hl1_npc/headcrab/hc_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/headcrab/hc_alert1.wav", "vj_hlr/hl1_npc/headcrab/hc_alert2.wav"}
ENT.SoundTbl_LeapAttackJump = {"vj_hlr/hl1_npc/headcrab/hc_attack1.wav", "vj_hlr/hl1_npc/headcrab/hc_attack2.wav", "vj_hlr/hl1_npc/headcrab/hc_attack3.wav"}
ENT.SoundTbl_LeapAttackDamage = "vj_hlr/hl1_npc/headcrab/hc_headbite.wav"
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/headcrab/hc_pain1.wav", "vj_hlr/hl1_npc/headcrab/hc_pain2.wav", "vj_hlr/hl1_npc/headcrab/hc_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/headcrab/hc_die1.wav", "vj_hlr/hl1_npc/headcrab/hc_die2.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.HeadCrab_IsBaby = false -- Is it a baby headcrab?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(10, 10, 18), Vector(-10, -10, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- When in deep water, drown by slowly taking damage
	if self:WaterLevel() > 2 then
		self:SetHealth(self:Health() - 1)
		if self:Health() <= 0 then
			self.Bleeds = false
			self:TakeDamage(1, self, self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled or self.HeadCrab_IsBaby then return end
	if math.random(1, 2) == 1 then
		self:PlayAnim("angry", true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "Init" then
		return !self:IsOnGround() -- If it's not on ground, then don't play flinch so it won't cut off leap attacks mid air!
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnLeapAttack(status, enemy)
	if status == "Jump" then
		return VJ.CalculateTrajectory(self, NULL, "Curve", self:GetPos() + self:OBBCenter(), self:GetEnemy():EyePos(), 1) + self:GetForward() * 80 - self:GetUp() * 30
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
local gibs_regular_extra = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib3.mdl"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local effectData = EffectData()
		effectData:SetOrigin(myCenterPos)
		effectData:SetColor(colorYellow)
		effectData:SetScale(50)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetOrigin(myCenterPos)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	if !self.HeadCrab_IsBaby then
		self:CreateGibEntity("obj_vj_gib", gibs_regular_extra, {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 5))})
	end
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1,0,5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,1,5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(2,0,5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,2,5))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs_baby = {"models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
local gibs_regular = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, self.HeadCrab_IsBaby and gibs_baby or gibs_regular)
end
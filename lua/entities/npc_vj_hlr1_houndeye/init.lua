AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/houndeye.mdl"
ENT.StartHealth = 80
ENT.SightAngle = 120
ENT.HullType = HULL_WIDE_SHORT
ENT.ControllerParameters = {
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(0, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.Immune_Sonic = true
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK1
ENT.MeleeAttackDistance = 164
ENT.TimeUntilMeleeAttackDamage = 2.35
ENT.NextMeleeAttackTime = 2
ENT.MeleeAttackDamageType = DMG_SONIC
ENT.MeleeAttackDSPSoundType = 34
ENT.MeleeAttackDSPSoundUseDamage = false
ENT.DisableDefaultMeleeAttackDamageCode = true
ENT.HasDeathAnimation = true
ENT.DisableFootStepSoundTimer = true

ENT.CanFlinch = 1
ENT.AnimTbl_Flinch = "vjseq_flinch_small"

ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/houndeye/he_hunt1.wav", "vj_hlr/hl1_npc/houndeye/he_hunt2.wav", "vj_hlr/hl1_npc/houndeye/he_hunt3.wav", "vj_hlr/hl1_npc/houndeye/he_hunt4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/houndeye/he_idle1.wav", "vj_hlr/hl1_npc/houndeye/he_idle2.wav", "vj_hlr/hl1_npc/houndeye/he_idle3.wav", "vj_hlr/hl1_npc/houndeye/he_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/houndeye/he_alert1.wav", "vj_hlr/hl1_npc/houndeye/he_alert2.wav", "vj_hlr/hl1_npc/houndeye/he_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/houndeye/he_attack1.wav", "vj_hlr/hl1_npc/houndeye/he_attack2.wav", "vj_hlr/hl1_npc/houndeye/he_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/houndeye/he_pain1.wav", "vj_hlr/hl1_npc/houndeye/he_pain2.wav", "vj_hlr/hl1_npc/houndeye/he_pain3.wav", "vj_hlr/hl1_npc/houndeye/he_pain4.wav", "vj_hlr/hl1_npc/houndeye/he_pain5.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/houndeye/he_die1.wav", "vj_hlr/hl1_npc/houndeye/he_die2.wav", "vj_hlr/hl1_npc/houndeye/he_die3.wav"}

local blastSd = {"vj_hlr/hl1_npc/houndeye/he_blast1.wav", "vj_hlr/hl1_npc/houndeye/he_blast2.wav", "vj_hlr/hl1_npc/houndeye/he_blast3.wav"}
local madSd = {"vj_hlr/hl1_npc/houndeye/he_alert1.wav", "vj_hlr/hl1_npc/houndeye/he_hunt4.wav"}

ENT.FootStepSoundLevel = 80
ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Houndeye_BlinkingT = 0
ENT.Houndeye_NextSleepT = 0
ENT.Houndeye_Sleeping = false
ENT.Houndeye_Type = 0
	-- 0 = Original / Default
	-- 1 = Alpha
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_houndeye" then
		self.Model = "models/vj_hlr/hl_hd/houndeye.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20 , 40), Vector(-20, -20, 0))
	
	self.Houndeye_NextSleepT = CurTime() + math.Rand(0, 15)
	
	if self.Houndeye_Type == 1 then
		self.AnimTbl_Death = ACT_DIESIMPLE
		self.NextMeleeAttackTime = 0.5
	else
		self.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD, ACT_DIEBACKWARD}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "he_hunt" then -- step
		self:PlayFootstepSound()
	elseif key == "woof" then
		self:PlaySoundSystem("Speech", "vj_hlr/hl1_npc/houndeye/he_pain3.wav")
	elseif key == "woooof" then
		self:PlaySoundSystem("Speech", "vj_hlr/hl1_npc/houndeye/he_pain1.wav")
	elseif key == "mad" then
		self:PlaySoundSystem("Speech", madSd)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defIdle = {ACT_IDLE, ACT_IDLE, ACT_IDLE, ACT_IDLE, ACT_IDLE_PACKAGE}
--
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		-- Sleeping
		if self.Houndeye_Sleeping then
			return ACT_CROUCHIDLE
		-- Barking
		elseif IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled then
			return ACT_IDLE_ANGRY
		end
		-- Default idle
		return self:ResolveAnimation(defIdle)
	-- Limp Walking
	elseif act == ACT_WALK && (self:GetMaxHealth() * 0.35) > self:Health() then
		return ACT_WALK_HURT
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Blinking
	if !self.Dead && CurTime() > self.Houndeye_BlinkingT && self.Houndeye_Sleeping == false then
		self:SetSkin(1)
		timer.Simple(0.1, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.2, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(0) end end)
		self.Houndeye_BlinkingT = CurTime() + math.Rand(2, 3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.VJ_IsBeingControlled then return end
	
	-- Sleep system
	if !self.Alerted && !IsValid(self:GetEnemy()) && !self:IsMoving() && CurTime() > self.Houndeye_NextSleepT && !self.Houndeye_Sleeping && !self:IsBusy() then
		local sleepTime = math.Rand(15, 30) -- How long it should sleep
		self.Houndeye_Sleeping = true
		self:PlayAnim(ACT_CROUCH, true, false, false)
		self:SetState(VJ_STATE_ONLY_ANIMATION, sleepTime)
		timer.Simple(7, function() if IsValid(self) && self.Houndeye_Sleeping == true then self:SetSkin(2) end end) -- Close eyes
		timer.Simple(sleepTime, function() -- Reset after sleepTime expires
			if IsValid(self) && self.Houndeye_Sleeping == true then
				self.Houndeye_Sleeping = false
				self:PlayAnim(ACT_STAND, true, false, false)
				self.Houndeye_NextSleepT = CurTime() + math.Rand(15, 45)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local alertAnims = {"vjseq_madidle1", "vjseq_madidle2", "vjseq_madidle3"}
--
function ENT:OnAlert(ent)
	if self.Houndeye_Sleeping == true then -- Wake up if sleeping and play a special alert animation
		if self:GetState() == VJ_STATE_ONLY_ANIMATION then self:SetState() end
		self.Houndeye_Sleeping = false
		self:PlayAnim(ACT_HOP, true, false, false)
		self.Houndeye_NextSleepT = CurTime() + 20
	elseif math.random(1, 2) == 1 then -- Random alert animation
		self:PlayAnim(alertAnims, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnResetEnemy()
	self.Houndeye_NextSleepT = CurTime() + math.Rand(15, 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local houndeyeClasses = {npc_vj_hlr1_houndeye = true, npc_vj_hlr1a_houndeye = true}
local beamEffectTbl = {material = "vj_hl/sprites/shockwave", framerate = 20, flags = 0}
--
function ENT:CustomOnMeleeAttack_BeforeChecks()
	local friNum = 0 -- How many allies exist around the Houndeye
	local color = Color(188, 220, 255) -- The shock wave color
	local dmg = 15 -- How much damage should the shock wave do?
	local myPos = self:GetPos()
	for _, v in ipairs(ents.FindInSphere(myPos, 400)) do
		if v != self && houndeyeClasses[v:GetClass()] then
			friNum = friNum + 1
		end
	end
	-- More allies = more damage and different colors
	if friNum == 1 then
		color = Color(101, 133, 221)
		dmg = 30
	elseif friNum == 2 then
		color = Color(67, 85, 255)
		dmg = 45
	elseif friNum >= 3 then
		color = Color(62, 33, 211)
		dmg = 60
	end
	
	-- flags 0 = No fade!
	effects.BeamRingPoint(myPos, 0.3, 2, 400, 16, 0, color, beamEffectTbl)
	effects.BeamRingPoint(myPos, 0.3, 2, 200, 16, 0, color, beamEffectTbl)
	
	if self.HasSounds && self.HasMeleeAttackSounds then
		VJ.EmitSound(self, blastSd, 100, math.random(80, 100))
	end
	VJ.ApplyRadiusDamage(self, self, myPos, 400, dmg, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=80})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "PriorExecution" then
		-- Houndeye shouldn't have its sonic attack interrupted by a flinch animation!
		return self.AttackAnimTime > CurTime()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PostDamage" && self.Houndeye_Type != 1 then
		self.Houndeye_NextSleepT = CurTime() + math.Rand(15, 45)
		if self.Houndeye_Sleeping == true then -- Wake up if sleeping and play a special alert animation
			if self:GetState() == VJ_STATE_ONLY_ANIMATION then self:SetState() end
			self.Houndeye_Sleeping = false
			self:PlayAnim(ACT_HOP, true, false, false)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		self:SetSkin(math.random(1, 2))
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
		effectData:SetScale(100)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
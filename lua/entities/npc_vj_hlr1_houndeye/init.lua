AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/houndeye.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 80
ENT.HullType = HULL_WIDE_SHORT
ENT.VJC_Data = {
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_Sonic = true -- Immune to sonic damage
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 164 -- How close does it have to be until it attacks?
ENT.TimeUntilMeleeAttackDamage = 2.35 -- This counted in seconds | This calculates the time until it hits something
ENT.NextMeleeAttackTime = 2
ENT.MeleeAttackDamageType = DMG_SONIC -- Type of Damage
ENT.MeleeAttackDSPSoundType = 34 -- What type of DSP effect? | Search online for the types
ENT.MeleeAttackDSPSoundUseDamage = false -- Should it only do the DSP effect if gets damaged x or greater amount
ENT.DisableDefaultMeleeAttackDamageCode = true -- Disables the default melee attack damage code
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {"vjseq_flinch_small"} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/houndeye/he_hunt1.wav","vj_hlr/hl1_npc/houndeye/he_hunt2.wav","vj_hlr/hl1_npc/houndeye/he_hunt3.wav","vj_hlr/hl1_npc/houndeye/he_hunt4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/houndeye/he_idle1.wav","vj_hlr/hl1_npc/houndeye/he_idle2.wav","vj_hlr/hl1_npc/houndeye/he_idle3.wav","vj_hlr/hl1_npc/houndeye/he_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/houndeye/he_alert1.wav","vj_hlr/hl1_npc/houndeye/he_alert2.wav","vj_hlr/hl1_npc/houndeye/he_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/houndeye/he_attack1.wav","vj_hlr/hl1_npc/houndeye/he_attack2.wav","vj_hlr/hl1_npc/houndeye/he_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/houndeye/he_pain1.wav","vj_hlr/hl1_npc/houndeye/he_pain2.wav","vj_hlr/hl1_npc/houndeye/he_pain3.wav","vj_hlr/hl1_npc/houndeye/he_pain4.wav","vj_hlr/hl1_npc/houndeye/he_pain5.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/houndeye/he_die1.wav","vj_hlr/hl1_npc/houndeye/he_die2.wav","vj_hlr/hl1_npc/houndeye/he_die3.wav"}

local blastSd = {"vj_hlr/hl1_npc/houndeye/he_blast1.wav","vj_hlr/hl1_npc/houndeye/he_blast2.wav","vj_hlr/hl1_npc/houndeye/he_blast3.wav"}
local madSd = {"vj_hlr/hl1_npc/houndeye/he_alert1.wav","vj_hlr/hl1_npc/houndeye/he_hunt4.wav"}

ENT.FootStepSoundLevel = 80
ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Houndeye_BlinkingT = 0
ENT.Houndeye_NextSleepT = 0
ENT.Houndeye_Sleeping = false
ENT.Houndeye_LimpWalking = false -- Used for optimization
ENT.Houndeye_CurIdleAnim = 0 -- 0 = regular | 1 = sleeping | 2 = angry
ENT.Houndeye_Type = 0
	-- 0 = Original / Default
	-- 1 = Alpha
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_houndeye" then
		self.Model = "models/vj_hlr/hl_hd/houndeye.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20 , 40), Vector(-20, -20, 0))
	
	self.Houndeye_NextSleepT = CurTime() + math.Rand(0, 15)
	
	if self.Houndeye_Type == 1 then
		self.AnimTbl_Death = {ACT_DIESIMPLE}
		self.NextMeleeAttackTime = 0.5
	else
		self.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD, ACT_DIEBACKWARD}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "he_hunt" then -- step
		self:FootStepSoundCode()
	elseif key == "woof" then
		self:StopAllCommonSpeechSounds()
		self:PlaySoundSystem("GeneralSpeech", "vj_hlr/hl1_npc/houndeye/he_pain3.wav")
	elseif key == "woooof" then
		self:StopAllCommonSpeechSounds()
		self:PlaySoundSystem("GeneralSpeech", "vj_hlr/hl1_npc/houndeye/he_pain1.wav")
	elseif key == "mad" then
		self:PlaySoundSystem("GeneralSpeech", madSd)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	-- Idle animations
	if self.VJ_IsBeingControlled then
		self.AnimTbl_IdleStand = {ACT_IDLE, ACT_IDLE_PACKAGE}
		self.DisableWandering = false
	else
		if IsValid(self:GetEnemy()) then
			if self.Houndeye_CurIdleAnim != 2 then
				self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY}
				self.Houndeye_CurIdleAnim = 2
				self.DisableWandering = true
			end
		elseif !self.Houndeye_Sleeping && self.Houndeye_CurIdleAnim != 0 then
			self.Houndeye_CurIdleAnim = 0
			self.AnimTbl_IdleStand = {ACT_IDLE, ACT_IDLE_PACKAGE}
			self.DisableWandering = false
		end
	end
	
	-- Limp walking
	if (self:GetMaxHealth() * 0.35) > self:Health() then
		if !self.Houndeye_LimpWalking then
			self.AnimTbl_Walk = {ACT_WALK_HURT}
			self.Houndeye_LimpWalking = true
		end
	elseif self.Houndeye_LimpWalking then
		self.AnimTbl_Walk = {ACT_WALK}
		self.Houndeye_LimpWalking = false
	end
	
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
function ENT:CustomOnThink_AIEnabled()
	if self.VJ_IsBeingControlled then return end
	
	-- Sleep system
	if !self.Alerted && !IsValid(self:GetEnemy()) && !self:IsMoving() && CurTime() > self.Houndeye_NextSleepT && !self.Houndeye_Sleeping && !self:IsBusy() then
		local sleept = math.Rand(15, 30) -- How long it should sleep
		self.Houndeye_Sleeping = true
		self.AnimTbl_IdleStand = {ACT_CROUCHIDLE}
		self.Houndeye_CurIdleAnim = 1
		self:VJ_ACT_PLAYACTIVITY(ACT_CROUCH, true, false, false)
		self:SetState(VJ_STATE_ONLY_ANIMATION, sleept)
		timer.Simple(7, function() if IsValid(self) && self.Houndeye_Sleeping == true then self:SetSkin(2) end end) -- Close eyes
		timer.Simple(sleept, function() -- Reset after sleept seconds
			if IsValid(self) && self.Houndeye_Sleeping == true then
				self.Houndeye_Sleeping = false
				self:VJ_ACT_PLAYACTIVITY(ACT_STAND, true, false, false)
				self.Houndeye_NextSleepT = CurTime() + math.Rand(15, 45)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local alertAnims = {"vjseq_madidle1", "vjseq_madidle2", "vjseq_madidle3"}
--
function ENT:CustomOnAlert(ent)
	if self.Houndeye_Sleeping == true then -- Wake up if sleeping and play a special alert animation
		if self:GetState() == VJ_STATE_ONLY_ANIMATION then self:SetState() end
		self.Houndeye_Sleeping = false
		self:VJ_ACT_PLAYACTIVITY(ACT_HOP, true, false, false)
		self.Houndeye_NextSleepT = CurTime() + 20
	elseif math.random(1,2) == 1 then -- Random alert animation
		self:VJ_ACT_PLAYACTIVITY(alertAnims, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnResetEnemy()
	self.Houndeye_NextSleepT = CurTime() + math.Rand(15, 45)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local houndeyeClasses = {npc_vj_hlr1_houndeye=true, npc_vj_hlr1a_houndeye=true}
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
	effects.BeamRingPoint(myPos, 0.3, 2, 400, 16, 0, color, {material="vj_hl/sprites/shockwave", framerate=20, flags=0})
	effects.BeamRingPoint(myPos, 0.3, 2, 200, 16, 0, color, {material="vj_hl/sprites/shockwave", framerate=20, flags=0})
	
	if self.HasSounds && self.HasMeleeAttackSounds then
		VJ.EmitSound(self, blastSd, 100, math.random(80, 100))
	end
	VJ.ApplyRadiusDamage(self, self, myPos, 400, dmg, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=80})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup)
	-- Houndeye shouldn't have its sonic attack interrupted by a flinch animation!
	return self.CurrentAttackAnimationTime < CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	self.Houndeye_NextSleepT = CurTime() + math.Rand(15, 45)
	if self.Houndeye_Sleeping == true then -- Wake up if sleeping and play a special alert animation
		if self:GetState() == VJ_STATE_ONLY_ANIMATION then self:SetState() end
		self.Houndeye_Sleeping = false
		self:VJ_ACT_PLAYACTIVITY(ACT_HOP, true, false, false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	self:SetSkin(math.random(1, 2))
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles then
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
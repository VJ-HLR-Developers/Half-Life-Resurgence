AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/panthereye.mdl"
ENT.StartHealth = 150
ENT.SightAngle = 220
ENT.HullType = HULL_WIDE_SHORT
ENT.ControllerParams = {
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(4, 0, 6),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 20
ENT.AnimTbl_MeleeAttack = {"vjseq_attack_main_claw", "vjseq_attack_primary", "vjseq_attack_simple_claw"}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 80

ENT.HasLeapAttack = true
ENT.LeapAttackDamage = 35
ENT.AnimTbl_LeapAttack = "vjseq_crouch_to_jump"
ENT.LeapAttackMaxDistance = 300
ENT.LeapAttackMinDistance = 100
ENT.LeapAttackDamageDistance = 100
ENT.TimeUntilLeapAttackDamage = 1.1
ENT.TimeUntilLeapAttackVelocity = 0.9
ENT.NextLeapAttackTime = VJ.SET(3, 4)
ENT.LeapAttackExtraTimers = {1.3}

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DisableFootStepSoundTimer = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH, ACT_FLINCH_PHYSICS}

ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/aslave/vort_foot1.wav", "vj_hlr/hl1_npc/aslave/vort_foot2.wav", "vj_hlr/hl1_npc/aslave/vort_foot3.wav", "vj_hlr/hl1_npc/aslave/vort_foot4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/panther/p_idle1.wav", "vj_hlr/hl1_npc/panther/p_idle2.wav", "vj_hlr/hl1_npc/panther/p_idle3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/panther/p_alert1.wav", "vj_hlr/hl1_npc/panther/p_alert2.wav", "vj_hlr/hl1_npc/panther/p_alert3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/panther/pclaw_strike1.wav", "vj_hlr/hl1_npc/panther/pclaw_strike2.wav", "vj_hlr/hl1_npc/panther/pclaw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/panther/pclaw_miss1.wav", "vj_hlr/hl1_npc/panther/pclaw_miss2.wav"}
ENT.SoundTbl_LeapAttackDamage = {"vj_hlr/hl1_npc/panther/pclaw_strike1.wav", "vj_hlr/hl1_npc/panther/pclaw_strike2.wav", "vj_hlr/hl1_npc/panther/pclaw_strike3.wav"}
ENT.SoundTbl_LeapAttackDamageMiss = {"vj_hlr/hl1_npc/panther/pclaw_miss1.wav", "vj_hlr/hl1_npc/panther/pclaw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/panther/p_pain1.wav", "vj_hlr/hl1_npc/panther/p_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/panther/p_die1.wav", "vj_hlr/hl1_npc/panther/p_die2.wav"}

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(25, 25, 55), Vector(-25, -25, 0))
	self:SetSkin(math.random(0, 1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "attack" then
		self:ExecuteMeleeAttack()
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnLeapAttack(status, enemy)
	if status == "Jump" then
		return VJ.CalculateTrajectory(self, enemy, "Curve", self:GetPos() + self:OBBCenter(), enemy:GetPos() + enemy:OBBCenter(), 10) + self:GetForward() * 500 + self:GetUp() * 100
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" then
		if dmginfo:GetDamage() > 30 then
			self.FlinchChance = 8
			self.AnimTbl_Flinch = ACT_BIG_FLINCH
		else
			self.FlinchChance = 16
			self.AnimTbl_Flinch = {ACT_SMALL_FLINCH, ACT_FLINCH_PHYSICS}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" && dmginfo:GetDamage() > 30 then
		self.AnimTbl_Death = ACT_DIEVIOLENT
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
		effectData:SetScale(120)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
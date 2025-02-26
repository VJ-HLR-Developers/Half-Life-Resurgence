AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/gonome.mdl"
ENT.StartHealth = 160
ENT.HullType = HULL_HUMAN
ENT.ControllerParams = {
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(1, 0, 4),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.HasMeleeAttack = true
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 80

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_gonomegut"
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackMaxDistance = 784
ENT.RangeAttackMinDistance = 200
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 6

ENT.HasExtraMeleeAttackSounds = true
ENT.DisableFootStepSoundTimer = true
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
//ENT.DeathAnimationTime = 2.2

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH

ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav", "vj_hlr/pl_step2.wav", "vj_hlr/pl_step3.wav", "vj_hlr/pl_step4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/gonome/gonome_idle1.wav", "vj_hlr/hl1_npc/gonome/gonome_idle2.wav", "vj_hlr/hl1_npc/gonome/gonome_idle3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/zombie/zo_alert10.wav", "vj_hlr/hl1_npc/zombie/zo_alert20.wav", "vj_hlr/hl1_npc/zombie/zo_alert30.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav", "vj_hlr/hl1_npc/zombie/claw_strike2.wav", "vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/gonome/gonome_melee1.wav", "vj_hlr/hl1_npc/gonome/gonome_melee2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/gonome/gonome_pain1.wav", "vj_hlr/hl1_npc/gonome/gonome_pain2.wav", "vj_hlr/hl1_npc/gonome/gonome_pain3.wav", "vj_hlr/hl1_npc/gonome/gonome_pain4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/gonome/gonome_death2.wav", "vj_hlr/hl1_npc/gonome/gonome_death3.wav", "vj_hlr/hl1_npc/gonome/gonome_death4.wav"}

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlrof_gonome" then
		self.Model = "models/vj_hlr/opfor_hd/gonome.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 85), Vector(-20, -20, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "melee" or key == "chest_bite" then
		self:ExecuteMeleeAttack()
	elseif key == "acidthrow" then
		self:ExecuteRangeAttack()
	elseif key == "acidtake" then
		local att = self:GetAttachment(2)
		ParticleEffect("vj_hlr_spit_red_spawn", att.Pos, att.Ang, self)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("0")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projectile:GetPos(), 1, 10)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*math.random(-100, -200) + self:GetUp()*20
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdClawMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav", "vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
--
function ENT:CustomOnMeleeAttack_BeforeStartTimer(seed)
	if self.MeleeAttack_IsPropAttack or math.random(1, 2) == 1 then
		self.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
		self.MeleeAttackDamage = 20
		self.HasMeleeAttackKnockBack = false
		self.SoundTbl_BeforeMeleeAttack = "vj_hlr/hl1_npc/gonome/gonome_melee1.wav"
		self.SoundTbl_MeleeAttackMiss = sdClawMiss
	else -- Grab and eat!
		self.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK2
		self.MeleeAttackDamage = 14
		self.HasMeleeAttackKnockBack = true
		self.SoundTbl_BeforeMeleeAttack = "vj_hlr/hl1_npc/gonome/gonome_melee2.wav"
		self.SoundTbl_MeleeAttackMiss = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	-- Only scale damage deal to the host, headcrab takes full damage
	if status == "PreDamage" && hitgroup != HITGROUP_HEAD && dmginfo:IsBulletDamage() then
		dmginfo:ScaleDamage(0.15)
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
		effectData:SetScale(140)
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
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" && hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = ACT_DIE_HEADSHOT
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = gibs})
end
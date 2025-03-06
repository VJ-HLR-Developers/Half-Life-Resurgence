AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/bullsquid.mdl"
ENT.StartHealth = 80
ENT.HullType = HULL_WIDE_SHORT
ENT.ControllerParams = {
    FirstP_Bone = "Bip01 Spine1",
    FirstP_Offset = Vector(10, 0, 11.5),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.Immune_Toxic = true

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.TimeUntilMeleeAttackDamage = false
ENT.HasMeleeAttackKnockBack = true

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackProjectiles = "obj_vj_hlr1_toxicspit"
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 1.5
ENT.RangeAttackMaxDistance = 784
ENT.RangeAttackMinDistance = 256

ENT.LimitChaseDistance = "OnlyRange"
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD}
ENT.DisableFootStepSoundTimer = true

ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/pl_step1.wav", "vj_hlr/gsrc/pl_step2.wav", "vj_hlr/gsrc/pl_step3.wav", "vj_hlr/gsrc/pl_step4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/bullchicken/bc_idle1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle3.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/bullchicken/bc_idle1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle3.wav", "vj_hlr/gsrc/npc/bullchicken/bc_idle4.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/gsrc/npc/bullchicken/bc_attackgrowl.wav", "vj_hlr/gsrc/npc/bullchicken/bc_attackgrowl2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_attackgrowl3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/gsrc/npc/bullchicken/bc_bite1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_bite2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_bite3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav", "vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/gsrc/npc/bullchicken/bc_attack2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/bullchicken/bc_pain1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_pain2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_pain3.wav", "vj_hlr/gsrc/npc/bullchicken/bc_pain4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/bullchicken/bc_die1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_die2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_die3.wav"}

-- Custom
ENT.Bullsquid_Type = 0 -- 0 = Retail Half-Life 1 | Alpha Half-Life 1
ENT.Bullsquid_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	if self.Bullsquid_Type == 1 then
		self:SetCollisionBounds(Vector(35, 35 , 60), Vector(-35, -35, 0))
	else
		self:SetCollisionBounds(Vector(30, 30 , 44), Vector(-30, -30, 0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "melee_whip" then
		self.MeleeAttackDamage = 35
		self:ExecuteMeleeAttack()
	elseif key == "melee_bite" then
		self.MeleeAttackDamage = 25
		self:ExecuteMeleeAttack()
	elseif key == "rangeattack" then
		self:ExecuteRangeAttack()
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/gsrc/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.Bullsquid_Type == 1 then return end
	if !self.Dead && CurTime() > self.Bullsquid_BlinkingT then
		self:SetSkin(1)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(0) end end)
		self.Bullsquid_BlinkingT = CurTime() + math.Rand(2, 3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.Bullsquid_Type == 1 then return end -- Alpha doesn't have alert animations!
	if math.random(1, 3) == 1 then
		if ent.VJ_ID_Headcrab then
			self:PlayAnim("seecrab", true, false, true)
		else
			self:PlayAnim(ACT_HOP, true, false, true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	local projPos = projectile:GetPos()
	ParticleEffect("vj_hlr_spit_acid_spawn", self:GetPos() + self:OBBCenter() + self:GetForward() * 35, self:GetForward():Angle(), projectile)
	if self.Bullsquid_BullSquidding == true then
		return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projPos, 1, 250000)
	else
		return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projPos, 1, 10)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward() * 55 + self:GetUp() * 255
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		if self.Bullsquid_Type != 0 then return end
		if dmginfo:GetDamage() > 35 then
			self.AnimTbl_Death = ACT_DIEBACKWARD
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetSkin(1)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,1,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
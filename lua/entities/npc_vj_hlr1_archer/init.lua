AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/archer.mdl"
ENT.StartHealth = 50
ENT.SightAngle = 250
ENT.HullType = HULL_TINY
ENT.TurningUseAllAxis = true
ENT.MovementType = VJ_MOVETYPE_AQUATIC
ENT.Aquatic_SwimmingSpeed_Calm = 80
ENT.Aquatic_SwimmingSpeed_Alerted = 350
ENT.Aquatic_AnimTbl_Calm = ACT_WALK
ENT.Aquatic_AnimTbl_Alerted = ACT_RUN
ENT.ControllerParams = {
	FirstP_Bone = "bip01 neck",
	FirstP_Offset = Vector(1, 0, 9),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 15
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 40
ENT.MeleeAttackDamageDistance = 50

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_archerspit"
ENT.RangeAttackMaxDistance = 1500
ENT.RangeAttackMinDistance = 100
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(2.5, 3)

ENT.LimitChaseDistance = "OnlyRange"
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"
ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_MinDistance = 1500
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH

ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/archer/arch_idle1.wav", "vj_hlr/hl1_npc/archer/arch_idle2.wav", "vj_hlr/hl1_npc/archer/arch_idle3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/archer/arch_alert1.wav", "vj_hlr/hl1_npc/archer/arch_alert2.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/archer/arch_attack1.wav", "vj_hlr/hl1_npc/archer/arch_attack2.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/archer/arch_bite1.wav", "vj_hlr/hl1_npc/archer/arch_bite2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/archer/arch_attack1.wav", "vj_hlr/hl1_npc/archer/arch_attack2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/archer/arch_pain1.wav", "vj_hlr/hl1_npc/archer/arch_pain2.wav", "vj_hlr/hl1_npc/archer/arch_pain3.wav", "vj_hlr/hl1_npc/archer/arch_pain4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/archer/arch_die1.wav", "vj_hlr/hl1_npc/archer/arch_die2.wav", "vj_hlr/hl1_npc/archer/arch_die3.wav"}

-- Custom
ENT.Archer_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 20), Vector(-20, -20, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "bite" then
		self:ExecuteMeleeAttack()
	end
	if key == "shoot" then
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if !self.Dead && CurTime() > self.Archer_BlinkingT then
		timer.Simple(0.2, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.5, function() if IsValid(self) then self:SetSkin(0) end end)
		self.Archer_BlinkingT = CurTime() + math.Rand(3, 4.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 2000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibPos = Vector(0, 0, 5)
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(70)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	local spawnPos = self:LocalToWorld(gibPos)
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=spawnPos})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=spawnPos})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=spawnPos})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetSkin(2)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
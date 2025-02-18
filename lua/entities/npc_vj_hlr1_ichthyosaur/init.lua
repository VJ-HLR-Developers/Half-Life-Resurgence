AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/icky.mdl"
ENT.StartHealth = 200
ENT.SightAngle = 225
ENT.HullType = HULL_LARGE
ENT.TurningUseAllAxis = true
ENT.MovementType = VJ_MOVETYPE_AQUATIC
ENT.Aquatic_SwimmingSpeed_Calm = 80
ENT.Aquatic_SwimmingSpeed_Alerted = 500
ENT.Aquatic_AnimTbl_Calm = ACT_WALK
ENT.Aquatic_AnimTbl_Alerted = ACT_RUN
ENT.ControllerParams = {
    ThirdP_Offset = Vector(-25, 0, 0),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(12, 0, 5),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 120
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_HOVER, ACT_DIEVIOLENT, ACT_DIESIMPLE}

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH

ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/ichy/ichy_idle1.wav", "vj_hlr/hl1_npc/ichy/ichy_idle2.wav", "vj_hlr/hl1_npc/ichy/ichy_idle3.wav", "vj_hlr/hl1_npc/ichy/ichy_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/ichy/ichy_alert1.wav", "vj_hlr/hl1_npc/ichy/ichy_alert2.wav", "vj_hlr/hl1_npc/ichy/ichy_alert3.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/ichy/ichy_alert1.wav", "vj_hlr/hl1_npc/ichy/ichy_alert2.wav", "vj_hlr/hl1_npc/ichy/ichy_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/ichy/ichy_attack1.wav", "vj_hlr/hl1_npc/ichy/ichy_attack2.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/ichy/ichy_bite1.wav", "vj_hlr/hl1_npc/ichy/ichy_bite2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/ichy/ichy_pain1.wav", "vj_hlr/hl1_npc/ichy/ichy_pain2.wav", "vj_hlr/hl1_npc/ichy/ichy_pain3.wav", "vj_hlr/hl1_npc/ichy/ichy_pain5.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/ichy/ichy_die1.wav", "vj_hlr/hl1_npc/ichy/ichy_die2.wav", "vj_hlr/hl1_npc/ichy/ichy_die3.wav", "vj_hlr/hl1_npc/ichy/ichy_die4.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.Icky_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(40, 40 , 60), Vector(-40, -40, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "mm_tasty" then
		self:ExecuteMeleeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Blinking system
	if !self.Dead && CurTime() > self.Icky_BlinkingT then
		self:SetSkin(4)
		timer.Simple(0.2, function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4, function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.5, function()
			if IsValid(self) then 
				if IsValid(self:GetEnemy()) then
					self:SetSkin(0)
				else
					self:SetSkin(1)
				end
			end
		end)
		self.Icky_BlinkingT = CurTime() + math.Rand(2, 3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt)
	-- Increase its health when it deals damage (Up to 2x its max health)
		-- If the enemy is less health than its melee attack, then use the enemy's health as the addition
	self:SetHealth(math.Clamp(self:Health() + ((self.MeleeAttackDamage > hitEnt:Health() and hitEnt:Health()) or self.MeleeAttackDamage), self:Health(), self:GetMaxHealth()*2))
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(2, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(3, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(4, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 2, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 3, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 4, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 5, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 2, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(2, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(2, 2, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(3, 2, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(2, 3, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 3, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(3, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetSkin(2)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = gibs})
end
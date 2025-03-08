AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/doctor.mdl"
ENT.StartHealth = 100
ENT.HealthRegenParams = {
	Enabled = true,
	Amount = 2,
	Delay = VJ.SET(0.5, 0.5),
}
ENT.HullType = HULL_HUMAN
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "unnamed021",
    FirstP_Offset = Vector(8, 0, 7),
	FirstP_ShrinkBone = true,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Red"}
ENT.HasOnPlayerSight = true
ENT.HasBloodPool = false
ENT.HasMeleeAttack = false
ENT.HasGrenadeAttack = false
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.Weapon_IgnoreSpawnMenu = true
ENT.DisableFootStepSoundTimer = true
ENT.BecomeEnemyToPlayer = 2
ENT.DropDeathLoot = false
ENT.Weapon_Strafe = false
ENT.Weapon_CanReload = false
ENT.CanTurnWhileMoving = false

ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/pl_step1.wav", "vj_hlr/gsrc/pl_step2.wav", "vj_hlr/gsrc/pl_step3.wav", "vj_hlr/gsrc/pl_step4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/ivan_alpha/hoot5.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot6.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot5.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot6.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot5.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot6.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav"}
ENT.SoundTbl_FollowPlayer = "vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav"
ENT.SoundTbl_MedicReceiveHeal = "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav"
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav"}
ENT.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav"}
ENT.SoundTbl_OnPlayerSight = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot4.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot5.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot6.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot4.wav"}
ENT.SoundTbl_DangerSight = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav"}
ENT.SoundTbl_KilledEnemy = {"vj_hlr/gsrc/npc/ivan_alpha/hoot5.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot6.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/gsrc/npc/ivan_alpha/hoot1.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot2.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot3.wav", "vj_hlr/gsrc/npc/ivan_alpha/hoot4.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/ivan_alpha/pl_pain2.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain4.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain5.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain6.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain7.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/ivan_alpha/pl_pain2.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain4.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain5.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain6.wav", "vj_hlr/gsrc/npc/ivan_alpha/pl_pain7.wav"}

-- Custom
ENT.Ivan_LastBodyGroup = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSkin(math.random(0, 3))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "hlag_fire" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/gsrc/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
	self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_PISTOL
	self.AnimationTranslations[ACT_IDLE_ANGRY] = ACT_COMBAT_IDLE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local bodyGroup = self:GetBodygroup(0)
	if self.Ivan_LastBodyGroup != bodyGroup then
		self.Ivan_LastBodyGroup = bodyGroup
		if bodyGroup == 0 then
			self:DoChangeWeapon("weapon_vj_hlr1a_ivanglock")
		elseif bodyGroup == 1 && IsValid(self:GetActiveWeapon()) then
			self:GetActiveWeapon():Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorRed)
		effectData:SetScale(100)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(0)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(1, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_bone.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_gib.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(2, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_guts.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 2, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_hmeat.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_lung.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(1, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_skull.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 60))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_legbone.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		self:SetBodygroup(0, 1)
	elseif status == "DeathAnim" then
		self:DeathWeaponDrop(dmginfo, hitgroup)
		if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
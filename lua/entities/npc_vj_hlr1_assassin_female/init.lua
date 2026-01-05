AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/hassassin.mdl"
ENT.StartHealth = 60
ENT.TurningSpeed = 50
ENT.HullType = HULL_HUMAN
ENT.JumpParams = {
	MaxRise = 620,
	MaxDrop = 620,
	MaxDistance = 620,
}
ENT.ControllerParams = {
	//FirstP_Bone = "bip01 head",
	//FirstP_Offset = Vector(6, 0, 2.5),
	FirstP_Bone = "bone10",
    FirstP_Offset = Vector(-1, 0, -1),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Red"}
ENT.HasBloodPool = false
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.MeleeAttackDamage = 15
ENT.TimeUntilMeleeAttackDamage = false

ENT.HasGrenadeAttack = true
ENT.GrenadeAttackEntity = "obj_vj_hlr1_grenade"
ENT.AnimTbl_GrenadeAttack = ACT_RANGE_ATTACK2
ENT.GrenadeAttackAttachment = "grenadehand"
ENT.GrenadeAttackThrowTime = 0.4

ENT.Weapon_CanReload = false
ENT.Weapon_IgnoreSpawnMenu = true
ENT.Weapon_Strafe = false
ENT.Weapon_Accuracy = 0.6
ENT.Weapon_CanCrouchAttack = false
ENT.AnimTbl_WeaponAttackGesture = false
ENT.AnimTbl_TakingCover = ACT_LAND
ENT.Weapon_OcclusionDelayTime = VJ.SET(1, 2)
ENT.DisableFootStepSoundTimer = true
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false
ENT.CanTurnWhileMoving = false

ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/pl_step1.wav", "vj_hlr/gsrc/pl_step2.wav", "vj_hlr/gsrc/pl_step3.wav", "vj_hlr/gsrc/pl_step4.wav"}

ENT.FootstepSoundLevel = 55

-- Custom
ENT.BOA_CanCloak = true
ENT.BOA_CloakLevel = 1
ENT.BOA_NextJumpT = 0
ENT.BOA_NextRunT = 0
ENT.BOA_ShotsSinceRun = 0
ENT.BOA_OffGround = false
ENT.BOA_ForceJumpShoot = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	if GetConVar("vj_hlr1_assassin_cloaks"):GetInt() == 0 then
		self.BOA_CanCloak = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "melee" then
		self:ExecuteMeleeAttack()
	elseif key == "shooty"  or key == "shoot" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	elseif key == "land" then
		VJ.EmitSound(self, "vj_hlr/gsrc/npc/player/pl_jumpland2.wav", 70)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/gsrc/fx/bodydrop" .. math.random(3, 4) .. ".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsBusy(checkType)
	-- Override base function to not see jumping as a busy activity when it should jump-fire
	if (!checkType or checkType == "Activities") && self:GetNavType() == NAV_JUMP && self.BOA_ForceJumpShoot then
		self.WeaponAttackState = VJ.WEP_ATTACK_STATE_FIRE -- Make the gun actually shoot
		return false
	end
	return self.BaseClass.IsBusy(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	-- Stay under 1.4 to make sure that it will do jump behavior rather then run behavior most of the time | 1.2 = Always jump behavior
	self.BOA_NextJumpT = CurTime() + math.Rand(0.8, 1.4)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.Dead then return end
	local curTime = CurTime()
	
	-- Unlimited ammo + weapon body group change
	local activeWep = self:GetActiveWeapon()
	local bGroup = self:GetBodygroup(1)
	if IsValid(activeWep) then
		if bGroup == 1 then
			self:GetActiveWeapon():Remove()
		end
	elseif bGroup == 0 then
		self:DoChangeWeapon("weapon_vj_hlr1_glock17_sup")
	end
	
	-- Cloaking system
	if self.BOA_CanCloak then
		local prevClockLvl = self:GetColor().a
		local cloakLvl = math.Clamp(self.BOA_CloakLevel * 255, 40, 255)
		self:SetColor(Color(255, 255, 255, cloakLvl))
		self.BOA_CloakLevel = math.Clamp(self.BOA_CloakLevel + 0.05, 0, 1)
		if cloakLvl <= 220 then -- NPCs can't seem me!
			self:DrawShadow(false)
			self:AddFlags(FL_NOTARGET)
		else -- NPCs can see me! =(
			self:DrawShadow(true)
			self:RemoveFlags(FL_NOTARGET)
		end
		-- Make it play a sound effect when it first starts cloaking, as seen here: https://github.com/ValveSoftware/halflife/blob/master/dlls/hassassin.cpp#L728
		if prevClockLvl == 255 && cloakLvl < 255 then
			VJ.EmitSound(self, "vj_hlr/gsrc/fx/beamstart1.wav", 75, 100, 0.2, CHAN_BODY)
		end
	end
	
	-- If not on ground, make it play fly shooting anim if velocity's z is negative (falling)
	if self:IsOnGround() then
		if self.BOA_ForceJumpShoot then
			self.AnimTbl_WeaponAttack = ACT_RANGE_ATTACK1
			self.BOA_ForceJumpShoot = false
		end
	elseif !self.BOA_ForceJumpShoot && self:GetVelocity().z < 0 then
		local flyAct = VJ.SequenceToActivity(self, "fly_attack")
		self:SetIdealActivity(flyAct)
		self.AnimTbl_WeaponAttack = {flyAct}
		self.BOA_ForceJumpShoot = true
		self.BOA_OffGround = true
	end
	
	if self.BOA_OffGround == true && self:GetVelocity().z == 0 then -- Velocity is 0, so we have landed, play land anim
		self.BOA_OffGround = false
		self:PlayAnim(ACT_LAND, true, false, false)
		//VJ.EmitSound(self, "vj_hlr/gsrc/npc/player/pl_jumpland2.wav", 80) -- Done through event now
	end
	
	-- Jump while attacking
	if IsValid(self:GetEnemy()) && curTime > self.BOA_NextJumpT && self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND && !self:IsMoving() && self.EnemyData.Distance < 1400 && !self.VJ_IsBeingControlled then
		self:ForceMoveJump(((self:GetPos() + self:GetRight()*(math.random(1, 2) == 1 and 100 or -100) + self:GetForward()*(math.random(1, 2) == 1 and 1 or -100)) - (self:GetPos() + self:OBBCenter())):GetNormal()*200 + self:GetUp()*600)
		/*self:StopMoving()
		self:SetGroundEntity(NULL)
		self:SetLocalVelocity(((self:GetPos() + self:GetRight()*(math.random(1, 2) == 1 and 100 or -100)) - (self:GetPos() + self:OBBCenter())):GetNormal()*200 +self:GetUp()*600)
		self:PlayAnim(ACT_JUMP, true, false, true, 0, {}, function(sched)
			self.BOA_OffGround = true
			//sched.RunCode_OnFinish = function()
				//self:PlayAnim("fly_attack", true, false, false)
			//end
		end)*/
		self.BOA_NextRunT = curTime + math.Rand(2, 4)
		self.BOA_NextJumpT = curTime + math.Rand(7, 11)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFireBullet(data)
	self.BOA_CloakLevel = 0
	if self.VJ_IsBeingControlled then return end
	local curTime = CurTime()
	self.BOA_ShotsSinceRun = self.BOA_ShotsSinceRun + 1
	if self:GetNavType() != NAV_JUMP && curTime > self.BOA_NextRunT && self.BOA_ShotsSinceRun >= 4 then -- Yete amenan keche chors ankam zenke zargadz e, ere vor vaz e!
		self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
		self.BOA_ShotsSinceRun = 0
		self.BOA_NextJumpT = curTime + math.Rand(2, 4)
		self.BOA_NextRunT = curTime + math.Rand(4, 6)
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
		effectData:SetScale(120)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(0)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(1, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_bone.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_gib.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(1, 2, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_guts.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(2, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_hmeat.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_lung.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(0, 1, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_skull.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(0, 0, 60))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_legbone.mdl", {CollisionDecal = "VJ_HLR1_Blood_Red", Pos = self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		self:DeathWeaponDrop(dmginfo, hitgroup)
		self:SetBodygroup(1, 1)
		if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
	elseif status == "Finish" then
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	VJ.HLR_ApplyCorpseSystem(self, corpse)
end
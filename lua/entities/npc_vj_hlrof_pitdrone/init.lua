AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/pit_drone.mdl"
ENT.StartHealth = 80
ENT.SightAngle = 230
ENT.HullType = HULL_HUMAN
ENT.ControllerParams = {
    ThirdP_Offset = Vector(15, 0, 0),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(7, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.MeleeAttackDamage = 15
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 40
ENT.MeleeAttackDamageDistance = 70

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_pitspike"
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackMaxDistance = 1500
ENT.RangeAttackMinDistance = 100
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(1, 5)

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false
ENT.DisableFootStepSoundTimer = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH

ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/player/boots1.wav", "vj_hlr/hl1_npc/player/boots2.wav", "vj_hlr/hl1_npc/player/boots3.wav", "vj_hlr/hl1_npc/player/boots4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/pitdrone/pit_drone_communicate1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_communicate2.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_communicate3.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_communicate4.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_idle3.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/pitdrone/pit_drone_idle1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_idle2.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_hunt1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_hunt2.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_hunt3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/pitdrone/pit_drone_alert1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_alert2.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_alert3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/pitdrone/pit_drone_melee_attack1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_melee_attack2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav", "vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/pitdrone/pit_drone_attack_spike1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_attack_spike2.wav"}
ENT.SoundTbl_KilledEnemy = {"vj_hlr/hl1_npc/pitdrone/pit_drone_eat.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/pitdrone/pit_drone_pain1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_pain2.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_pain3.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_pain4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/pitdrone/pit_drone_die1.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_die2.wav", "vj_hlr/hl1_npc/pitdrone/pit_drone_die3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(18, 18, 55), Vector(-18, -18, 0))
	self:SetBodygroup(1, 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("RELOAD: Reload all the spikes")
	
	function controlEnt:OnKeyBindPressed(key)
		local npc = self.VJCE_NPC
		if key == IN_RELOAD && npc:GetBodygroup(1) != 1 then
			npc:PlayAnim(ACT_RELOAD, true, false, true, 0, {OnFinish=function(interrupted2, anim2)
				npc.HasRangeAttack = true
				npc:SetBodygroup(1, 1)
			end})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	end
	if key == "single" or key == "both" then
		self:ExecuteMeleeAttack()
	end
	if key == "shooty" then
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 40
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	local projPos = projectile:GetPos()
	ParticleEffect("vj_hlr_spit_drone_spawn", projPos + projectile:GetForward() * 30, self:GetForward():Angle(), projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projPos, 1, 2000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PostProjSpawn" then
		-- Behavior: If spikes are empty, go hide and reload
		local bg = self:GetBodygroup(1)
		if bg == 0 or bg == 6 then
			self:SetBodygroup(1, 0)
			self.HasRangeAttack = false
			if !self.VJ_IsBeingControlled then
				-- Run from the enemy, then play the reload animation and set the body group
				self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
				timer.Simple(0.1, function()
					if IsValid(self) then
						self.TakingCoverT = CurTime() + self:GetPathTimeToGoal()
						timer.Simple(self:GetPathTimeToGoal(), function()
							if IsValid(self) then
								self:PlayAnim(ACT_RELOAD, true, false, true, 0, {OnFinish=function(interrupted2, anim2)
									self.HasRangeAttack = true
									self:SetBodygroup(1, 1)
								end})
							end
						end)
					end
				end)
			end
		else
			self:SetBodygroup(1, bg + 1)
		end
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
		effectData:SetScale(80)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pitdrone_gib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pitdrone_gib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pitdrone_gib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pitdrone_gib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pitdrone_gib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 21))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pitdrone_gib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 21))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pitdrone_gib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 21))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/pitdrone_gib1.mdl", "models/vj_hlr/gibs/pitdrone_gib2.mdl", "models/vj_hlr/gibs/pitdrone_gib3.mdl", "models/vj_hlr/gibs/pitdrone_gib4.mdl", "models/vj_hlr/gibs/pitdrone_gib5.mdl", "models/vj_hlr/gibs/pitdrone_gib6.mdl", "models/vj_hlr/gibs/pitdrone_gib7.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = gibs})
end
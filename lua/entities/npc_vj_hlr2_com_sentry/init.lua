AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/combine_turrets/floor_turret.mdl"
ENT.StartHealth = 200
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 2000
ENT.SightAngle = 132.84
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanTurnWhileStationary = false
ENT.ControllerParams = {
    FirstP_Bone = "barrel",
    FirstP_Offset = Vector(0, 6, 6),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.AlertTimeout = VJ.SET(0, 0)
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = false
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 1
ENT.RangeAttackAngleRadius = 132.84
ENT.TimeUntilRangeAttackProjectileRelease = 0.015
ENT.NextRangeAttackTime = 0
ENT.NextAnyAttackTime_Range = 0.04

ENT.CanReceiveOrders = false
ENT.VJ_ID_Healable = false
ENT.EnemyTimeout = 5

ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = "npc/turret_floor/die.wav"

local sdFiring = {"^npc/turret_floor/shoot1.wav", "^npc/turret_floor/shoot2.wav", "^npc/turret_floor/shoot3.wav"}

local TURRET_STATUS_UNKNOWN = -1 -- Usually for transitioning from deploying to another status
local TURRET_STATUS_IDLE = 0 -- Was last detected as idle
local TURRET_STATUS_DEPLOYING = 1 -- Was last detected attempting to deploy the gun
local TURRET_STATUS_SEEKING = 2 -- Was last detected seeking / scanning a target
local TURRET_STATUS_TARGETING = 3 -- Was last detected targeting an active enemy

-- Custom
ENT.Turret_HasLOS = false -- Has line of sight
ENT.Turret_Status = TURRET_STATUS_UNKNOWN
ENT.Turret_StandDown = true
ENT.Turret_CurrentParameter = 0
ENT.Turret_ScanDirSide = 0
ENT.Turret_ScanDirUp = 0
ENT.Turret_NextScanBeepT = 0
ENT.Turret_ControllerStatus = 0 -- Current status of the controller | 0 = Idle | 1 = Alerted
ENT.Turret_IdleAnim = ACT_IDLE -- Will be replaced on initialize
ENT.Turret_IdleAngryAnim = ACT_IDLE -- Will be replaced on initialize

-- Pose Parameters:
	-- aim_yaw -60 / 60
	-- aim_pitch -15 / 15
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 63), Vector(-13, -13, 0))
	
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "sprites/glow1.vmt")
	spr:SetKeyValue("scale", "0.4")
	spr:SetKeyValue("rendermode", "9") -- kRenderWorldGlow
	spr:SetKeyValue("renderfx", "14") -- kRenderFxNoDissipation
	spr:SetKeyValue("rendercolor", "255 0 0")
	spr:SetKeyValue("renderamt", "192")
	spr:SetParent(self)
	spr:Fire("SetParentAttachment", "light")
	spr:Spawn()
	spr:Activate()
	spr:Fire("HideSprite")
	self:DeleteOnRemove(spr)
	self.Turret_Sprite = spr
	
	-- For resistance turrets
	if self:GetModel() == "models/vj_hlr/hl2/floor_turret.mdl" then
		self:SetSkin(math.random(1, 3))
	end
	
	self.Turret_IdleAnim = self:GetSequenceActivity(self:LookupSequence("idle"))
	self.Turret_IdleAngryAnim = self:GetSequenceActivity(self:LookupSequence("idlealert"))
	self.TurretSD_Turning = CreateSound(self, "npc/turret_wall/turret_loop1.wav")
	self.TurretSD_Turning:SetSoundLevel(60)
	self.TurretSD_Alarm = CreateSound(self, "npc/turret_floor/alarm.wav")
	self.TurretSD_Alarm:SetSoundLevel(75)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Activate / Deactivate")
	
	self.Turret_ControllerStatus = 0
	self.HasPoseParameterLooking = false -- Initially, we are going to start as idle, we do NOT want the turret turning!
	self.NextAlertSoundT = CurTime() + 1 -- So it doesn't play the alert sound as soon as it enters the NPC!
	
	function controlEnt:OnKeyPressed(key)
		local npc = self.VJCE_NPC
		if key == KEY_SPACE then
			if npc.Turret_ControllerStatus == 0 then
				npc.Turret_ControllerStatus = 1
				npc.HasPoseParameterLooking = true
				npc:PlaySoundSystem("Alert")
				npc:Turret_Activate()
			else
				npc.Turret_ControllerStatus = 0
				npc.HasPoseParameterLooking = false
			end
		end
	end
	
	function controlEnt:OnStopControlling(keyPressed)
		local npc = self.VJCE_NPC
		if IsValid(npc) then
			npc.HasPoseParameterLooking = true
			npc.Turret_ControllerStatus = 0
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if !self.Turret_StandDown then
			return self.Turret_IdleAngryAnim
		else
			return self.Turret_IdleAnim
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Turning sound
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Turret_CurrentParameter then
		self.TurretSD_Turning:PlayEx(1, 100)
	else
		VJ.STOPSOUND(self.TurretSD_Turning)
	end
	self.Turret_CurrentParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	local eneValid = IsValid(self:GetEnemy())
	if self.Turret_Status != TURRET_STATUS_DEPLOYING then
		-- Alerted behavior
		if ((self.Turret_ControllerStatus == 1) or (!self.VJ_IsBeingControlled && (eneValid or (self.Alerted && !self.EnemyData.Reset)))) then
			self.Turret_StandDown = false
			-- Handle the light sprite
			if self.Turret_HasLOS && eneValid then
				self.Turret_Sprite:Fire("Color", "255 0 0") -- Red
				self.Turret_Sprite:Fire("ShowSprite")
			elseif self.HasPoseParameterLooking == true then -- So when the alert animation is playing, it won't replace the activating light (green)
				self.Turret_Sprite:Fire("Color", "255 128 0") -- Orange
				self.Turret_Sprite:Fire("ShowSprite")
			end
			
			local doScan = false
			
			-- Make it scan around if the enemy is behind, which is unreachable for it!
			if eneValid && !self.Turret_HasLOS && (math.abs(self.EnemyData.VisibleTime - CurTime()) >= 1) then
				doScan = true
				self.HasPoseParameterLooking = false
			else
				-- If it just started targeting, then play the gun "activate" sound
				if self.Turret_Status != TURRET_STATUS_TARGETING then
					VJ.EmitSound(self, "npc/turret_floor/active.wav", 70, 100)
					self.NextDoAnyAttackT = CurTime() + 0.5
				end
				self.Turret_Status = TURRET_STATUS_TARGETING
				self.HasPoseParameterLooking = true
			end
			
			-- Look around randomly when the enemy is not found or hidden
			if !eneValid or doScan == true then
				self.Turret_Status = TURRET_STATUS_SEEKING
				-- Playing a beeping noise
				if self.Turret_NextScanBeepT < CurTime() then
					VJ.EmitSound(self, "npc/turret_floor/ping.wav", 75, 100)
					self.Turret_NextScanBeepT = CurTime() + 1
				end
				-- LEFT TO RIGHT
				-- Change the rotation direction when the max number is reached for a direction
				local yaw = self:GetPoseParameter("aim_yaw")
				if yaw >= 60 then
					self.Turret_ScanDirSide = 1
				elseif yaw <= -60 then
					self.Turret_ScanDirSide = 0
				end
				self:SetPoseParameter("aim_yaw", yaw + (self.Turret_ScanDirSide == 1 and -5 or 5))
				-- UP AND DOWN
				-- Change the rotation direction when the max number is reached for a direction
				local pitch = self:GetPoseParameter("aim_pitch")
				if pitch >= 15 then
					self.Turret_ScanDirUp = 1
				elseif pitch <= -15 then
					self.Turret_ScanDirUp = 0
				end
				self:SetPoseParameter("aim_pitch", pitch + (self.Turret_ScanDirUp == 1 and -1 or 1))
			end
		else -- Idle behavior
			self.Turret_Status = TURRET_STATUS_IDLE
			-- Play the retracting sequence and sound
			if ((self.Turret_ControllerStatus == 0) or (!self.VJ_IsBeingControlled && !self.Alerted)) && !self.Turret_StandDown then
				if self.VJ_IsBeingControlled then
					self.Turret_Sprite:Fire("HideSprite")
				else
					self.Turret_Sprite:Fire("Color", "0 255 0") -- Green
					self.Turret_Sprite:Fire("ShowSprite")
				end
				self.Turret_StandDown = true
				self.HasPoseParameterLooking = true
				self:PlayAnim("retract", true, 1)
				VJ.EmitSound(self, "npc/turret_floor/retract.wav", 70, 100)
			end
			if self.Turret_StandDown && self:GetPoseParameter("aim_yaw") == 0 then -- Hide the green light once it fully rests
				self.Turret_Sprite:Fire("HideSprite")
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdatePoseParamTracking(resetPoses)
	-- Alerted with no active enemy, so don't reset its pose parameters (Ex: Transitioning from Alert to Idle)
	if self:GetNPCState() == NPC_STATE_ALERT then return end
	return self.BaseClass.UpdatePoseParamTracking(self, resetPoses)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	-- Otherwise "self.Turret_HasLOS" will true all the time when it's deploying, retracting, etc. (Basically whenever its not supposed to aim)
	if !self.HasPoseParameterLooking or self:GetNPCState() != NPC_STATE_COMBAT then
		self.Turret_HasLOS = false
		return
	end
	
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10) then
		self.Turret_HasLOS = false
	else
		self.Turret_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	self:Turret_Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Turret_Activate()
	self.Turret_Sprite:Fire("Color", "0 255 0") -- Green
	self.Turret_Sprite:Fire("ShowSprite")
	self.HasPoseParameterLooking = false -- Make it not aim at the enemy right away!
	self.Turret_Status = TURRET_STATUS_DEPLOYING
	timer.Simple(0.6, function()
		if IsValid(self) then
			self.Turret_Status = TURRET_STATUS_UNKNOWN
		end
	end)
	self:PlayAnim("deploy", true, false)
	VJ.EmitSound(self, "npc/turret_floor/deploy.wav", 70, 100)
	self.TurretSD_Alarm:PlayEx(1, 100)
	timer.Simple(0.8, function() VJ.STOPSOUND(self.TurretSD_Alarm) end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "PreInit" then
		-- Only fire if we have LOS and not in stand down mode!
		return self.Turret_StandDown or !self.Turret_HasLOS
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local bulletSpread = Vector(0.08716, 0.08716, 0.08716) * 1.25 -- VECTOR_CONE_10DEGREES * WEAPON_PROFICIENCY_VERY_GOOD
--
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "Init" then
		self:PlayAnim("vjseq_fire", false)
		
		-- Bullet
		local startPos = self:GetAttachment(self:LookupAttachment("eyes")).Pos
		local bullet = {}
		bullet.Num = 1
		bullet.Src = startPos
		bullet.Dir = (self:GetAimPosition(enemy, startPos) - startPos):GetNormal()
		bullet.Spread = bulletSpread
		bullet.Tracer = 1
		bullet.TracerName = "AR2Tracer"
		bullet.Force = 5
		bullet.Damage = 2
		bullet.AmmoType = "AR2"
		self:FireBullets(bullet)
		
		VJ.EmitSound(self, sdFiring, 90, math.random(100, 110))
		
		-- Effects & Light
		//ParticleEffect("vj_rifle_full_blue", startPos, self:GetAngles(), self)
		local fireLight = ents.Create("light_dynamic")
		fireLight:SetKeyValue("brightness", "4")
		fireLight:SetKeyValue("distance", "120")
		fireLight:SetPos(startPos)
		fireLight:SetLocalAngles(self:GetAngles())
		fireLight:Fire("Color", "0 31 225")
		fireLight:SetParent(self)
		fireLight:Spawn()
		fireLight:Activate()
		fireLight:Fire("TurnOn", "", 0)
		fireLight:Fire("Kill", "", 0.07)
		self:DeleteOnRemove(fireLight)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle(0, 0, 0)
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Finish" then
		ParticleEffect("explosion_turret_break", self:WorldSpaceCenter() + self:GetUp() * 12, defAng, NULL)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdGibCollide = {"physics/metal/metal_box_impact_hard1.wav", "physics/metal/metal_box_impact_hard2.wav", "physics/metal/metal_box_impact_hard3.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	util.BlastDamage(self, self, self:WorldSpaceCenter() + self:GetUp() * 12, 120, 15)
	self:CreateGibEntity("obj_vj_gib", "models/combine_turrets/floor_turret_gib1.mdl", {BloodType = "", Pos = self:LocalToWorld(Vector(0, 0, 40)), CollisionSound = sdGibCollide})
	self:CreateGibEntity("obj_vj_gib", "models/combine_turrets/floor_turret_gib2.mdl", {BloodType = "", Pos = self:LocalToWorld(Vector(0, 0, 20)), CollisionSound = sdGibCollide})
	self:CreateGibEntity("obj_vj_gib", "models/combine_turrets/floor_turret_gib3.mdl", {BloodType = "", Pos = self:LocalToWorld(Vector(0, 0, 30)), CollisionSound = sdGibCollide})
	self:CreateGibEntity("obj_vj_gib", "models/combine_turrets/floor_turret_gib4.mdl", {BloodType = "", Pos = self:LocalToWorld(Vector(0, 0, 35)), CollisionSound = sdGibCollide})
	self:CreateGibEntity("obj_vj_gib", "models/combine_turrets/floor_turret_gib5.mdl", {BloodType = "", Pos = self:LocalToWorld(Vector(0, 0, 37)), CollisionSound = sdGibCollide})
	self:PlaySoundSystem("Gib", "vj_hlr/src/npc/turret/detonate.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	-- Exaggerate the damage force to make the turret fall!
	local phys = corpse:GetPhysicsObject()
	if IsValid(phys) then
		local velLength = phys:GetVelocity():Length()
		phys:SetVelocity(corpse:GetVelocity() * ((velLength < 10 and 25) or ((velLength < 30 and 10) or ((velLength < 100 and 3) or 1))))
		-- Below 10: x25 | Below 30: x10 | Below 100: x3 | Above 300: No change!
	end
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpse, 2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.TurretSD_Turning)
	VJ.STOPSOUND(self.TurretSD_Alarm)
end
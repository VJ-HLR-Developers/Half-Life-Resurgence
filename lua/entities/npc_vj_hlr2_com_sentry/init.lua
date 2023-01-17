AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
-- ENT.Model = {"models/vj_combine/floor_turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.Model = {"models/combine_turrets/floor_turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 2000 -- How far it can see
ENT.SightAngle = 75 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.VJC_Data = {
    FirstP_Bone = "barrel", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 6, 6), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.AlertedToIdleTime = VJ_Set(5, 5) -- How much time until it calms down after the enemy has been killed/disappeared | Sets self.Alerted to false after the timer expires
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 75 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.06 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.01 -- How much time until it can use any attack again? | Counted in Seconds

ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"npc/turret_floor/die.wav"}

local sdFiring = {"^npc/turret_floor/shoot1.wav","^npc/turret_floor/shoot2.wav","^npc/turret_floor/shoot3.wav"}

-- Custom
ENT.Turret_HasLOS = false -- Has line of sight
ENT.Turret_StandDown = true
ENT.Turret_CurrentParameter = 0
ENT.Turret_ScanDirSide = 0
ENT.Turret_ScanDirUp = 0
ENT.Turret_NextScanBeepT = 0
ENT.Turret_ControllerStatus = 0 -- Current status of the controller, 0 = Idle | 1 = Alerted

-- Pose Parameters:
	-- aim_yaw -60 / 60
	-- aim_pitch -15 / 15
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 63), Vector(-13, -13, 0))
	
	self:VJTags_Add(VJ_TAG_TURRET)
	
	self.Turret_Sprite = ents.Create("env_sprite")
	self.Turret_Sprite:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	self.Turret_Sprite:SetKeyValue("scale","0.1")
	self.Turret_Sprite:SetKeyValue("rendermode","5")
	self.Turret_Sprite:SetKeyValue("rendercolor","255 0 0")
	self.Turret_Sprite:SetKeyValue("spawnflags","1") -- If animated
	self.Turret_Sprite:SetParent(self)
	self.Turret_Sprite:Fire("SetParentAttachment", "light")
	self.Turret_Sprite:Spawn()
	self.Turret_Sprite:Activate()
	self.Turret_Sprite:Fire("HideSprite")
	self:DeleteOnRemove(self.Turret_Sprite)
	
	-- For resistance turrets
	if self:GetModel() == "models/vj_hlr/hl2/floor_turret.mdl" then
		self:SetSkin(math.random(1, 3))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	self.Turret_ControllerStatus = 0
	self.HasPoseParameterLooking = false -- Initially, we are going to start as idle, we do NOT want the turret turning!
	self.NextAlertSoundT = CurTime() + 1 -- So it doesn't play the alert sound as soon as it enters the NPC!
	
	function controlEnt:CustomOnKeyPressed(key)
		if key == KEY_SPACE then
			if self.VJCE_NPC.Turret_ControllerStatus == 0 then
				self.VJCE_NPC.Turret_ControllerStatus = 1
				self.VJCE_NPC.HasPoseParameterLooking = true
				self.VJCE_NPC:PlaySoundSystem("Alert")
				self.VJCE_NPC:Turret_Activate()
			else
				self.VJCE_NPC.Turret_ControllerStatus = 0
				self.VJCE_NPC.HasPoseParameterLooking = false
			end
		end
	end
	
	function controlEnt:CustomOnStopControlling()
		if IsValid(self.VJCE_NPC) then
			self.VJCE_NPC.HasPoseParameterLooking = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("SPACE: Activate / Deactivate")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	-- Turning sound
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Turret_CurrentParameter then
		self.turret_turningsd = CreateSound(self, "npc/turret_wall/turret_loop1.wav") 
		self.turret_turningsd:SetSoundLevel(60)
		self.turret_turningsd:PlayEx(1, 100)
	else
		VJ_STOPSOUND(self.turret_turningsd)
	end
	self.Turret_CurrentParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local eneValid = IsValid(self:GetEnemy())
	-- Make it not reset its pose parameters while its transitioning from Alert to Idle
	if self.Alerted && !eneValid then
		self.PoseParameterLooking_CanReset = false
	else
		self.PoseParameterLooking_CanReset = true
	end
	if (self.Turret_ControllerStatus == 1) or (!self.VJ_IsBeingControlled && (eneValid or self.Alerted == true)) then
		self.Turret_StandDown = false
		self.AnimTbl_IdleStand = {"idlealert"}
		-- Handle the light sprite
		if self.Turret_HasLOS == true && eneValid then
			self.Turret_Sprite:Fire("Color","255 0 0") -- Red
			self.Turret_Sprite:Fire("ShowSprite")
		elseif self.HasPoseParameterLooking == true then -- So when the alert animation is playing, it won't replace the activating light (green)
			self.Turret_Sprite:Fire("Color","255 165 0") -- Orange
			self.Turret_Sprite:Fire("ShowSprite")
		end
		
		local scan = false
		local pyaw = self:GetPoseParameter("aim_yaw")
		
		-- Make it scan around if the enemy is behind, which is unreachable for it!
		if eneValid && self.Turret_HasLOS == false && (self.EnemyData.SightDiff <= math.cos(math.rad(self.RangeAttackAngleRadius))) then
			scan = true
			self.HasPoseParameterLooking = false
		else
			self.HasPoseParameterLooking = true
		end
		
		 -- Look around randomly when the enemy is not found
		if !eneValid or scan == true then
			-- Playing a beeping noise
			if self.Turret_NextScanBeepT < CurTime() then
				VJ_EmitSound(self, "npc/turret_floor/ping.wav", 75, 100)
				self.Turret_NextScanBeepT = CurTime() + 1
			end
			-- LEFT TO RIGHT
			-- Change the rotation direction when the max number is reached for a direction
			if pyaw >= 60 then
				self.Turret_ScanDirSide = 1
			elseif pyaw <= -60 then
				self.Turret_ScanDirSide = 0
			end
			self:SetPoseParameter("aim_yaw", pyaw + (self.Turret_ScanDirSide == 1 and -8 or 8))
			-- UP AND DOWN
			-- Change the rotation direction when the max number is reached for a direction
			if self:GetPoseParameter("aim_pitch") >= 15 then
				self.Turret_ScanDirUp = 1
			elseif self:GetPoseParameter("aim_pitch") <= -15 then
				self.Turret_ScanDirUp = 0
			end
			self:SetPoseParameter("aim_pitch", self:GetPoseParameter("aim_pitch") + (self.Turret_ScanDirUp == 1 and -3 or 3))
		end
	else
		-- Play the retracting sequence and sound
		if ((self.Turret_ControllerStatus == 0) or (!self.VJ_IsBeingControlled && self.Alerted == false)) && self.Turret_StandDown == false then
			if self.VJ_IsBeingControlled then
				self.Turret_Sprite:Fire("HideSprite")
			else
				self.Turret_Sprite:Fire("Color","0 150 0") -- Green
				self.Turret_Sprite:Fire("ShowSprite")
			end
			self.Turret_StandDown = true
			self:VJ_ACT_PLAYACTIVITY({"retire"}, true, 1)
			VJ_EmitSound(self, "npc/turret_floor/retract.wav", 70, 100)
		end
		if self.Turret_StandDown == true then
			if self:GetPoseParameter("aim_yaw") == 0 then -- Hide the green light once it fully rests
				self.Turret_Sprite:Fire("HideSprite")
			end
			self.AnimTbl_IdleStand = {ACT_IDLE}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOn_PoseParameterLookingCode(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10) then
		self.Turret_HasLOS = false
	else
		-- If it just got LOS, then play the gun "activate" sound
		if self.Turret_HasLOS == false && IsValid(self:GetEnemy()) then
			VJ_EmitSound(self, "npc/turret_floor/active.wav", 70, 100)
		end
		self.Turret_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.VJ_IsBeingControlled == true then return end
	self:Turret_Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Turret_Activate()
	self.Turret_Sprite:Fire("Color","0 150 0") -- Green
	self.Turret_Sprite:Fire("ShowSprite")
	self.HasPoseParameterLooking = false -- Make it not aim at the enemy right away!
	timer.Simple(0.6, function()
		if IsValid(self) then
			self.HasPoseParameterLooking = true
		end
	end)
	//self.NextResetEnemyT = CurTime() + 1 -- Make sure it doesn't reset the enemy right away
	self:VJ_ACT_PLAYACTIVITY({"deploy"}, true, false)
	VJ_EmitSound(self, "npc/turret_floor/deploy.wav", 70, 100)
	self.turret_alertsd = VJ_CreateSound(self, "npc/turret_floor/alarm.wav", 75, 100)
	timer.Simple(0.8, function() VJ_STOPSOUND(self.turret_alertsd) end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	-- Only fire if we have LOS and not in stand down mode!
	return self.Turret_HasLOS && !self.Turret_StandDown
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	self:VJ_ACT_PLAYACTIVITY("vjseq_fire", false)
	
	-- Bullet
	local startpos = self:GetAttachment(self:LookupAttachment("eyes")).Pos
	local bullet = {}
	bullet.Num = 1
	bullet.Src = startpos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) - startpos
	bullet.Spread = Vector(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))
	bullet.Tracer = 1
	bullet.TracerName = "AR2Tracer"
	bullet.Force = 5
	bullet.Damage = 3
	bullet.AmmoType = "AR2"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self, sdFiring, 90, self:VJ_DecideSoundPitch(100, 110))
	
	-- Effects & Light
	//ParticleEffect("vj_rifle_full_blue", startpos, self:GetAngles(), self)
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(startpos)
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color", "0 31 225")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn", "", 0)
	FireLight1:Fire("Kill", "", 0.07)
	self:DeleteOnRemove(FireLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle(0, 0, 0)
--
function ENT:CustomOnKilled(dmginfo, hitgroup)
	local startPos = self:GetPos() + self:OBBCenter()
	ParticleEffect("explosion_turret_break_fire", startPos, defAng, NULL)
	ParticleEffect("explosion_turret_break_flash", startPos, defAng, NULL)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", startPos, defAng, NULL)
	ParticleEffect("explosion_turret_break_sparks", startPos, defAng, NULL)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdGibCollide = {"physics/metal/metal_box_impact_hard1.wav", "physics/metal/metal_box_impact_hard2.wav", "physics/metal/metal_box_impact_hard3.wav"}
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hl2/Floor_turret_gib1.mdl", {BloodType="",Pos=self:LocalToWorld(Vector(0,0,40)), CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hl2/Floor_turret_gib2.mdl", {BloodType="",Pos=self:LocalToWorld(Vector(0,0,20)), CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hl2/Floor_turret_gib3.mdl", {BloodType="",Pos=self:LocalToWorld(Vector(0,0,30)), CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hl2/Floor_turret_gib4.mdl", {BloodType="",Pos=self:LocalToWorld(Vector(0,0,35)), CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hl2/Floor_turret_gib5.mdl", {BloodType="",Pos=self:LocalToWorld(Vector(0,0,37)), CollideSound=sdGibCollide})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_hlr/hl2_npc/turret/detonate.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	-- Exagerate the damage force to make the turret fall!
	local phys = corpseEnt:GetPhysicsObject()
	if IsValid(phys) then
		local velLength = phys:GetVelocity():Length()
		phys:SetVelocity(corpseEnt:GetVelocity() * ((velLength < 10 and 25) or ((velLength < 30 and 10) or ((velLength < 100 and 3) or 1))))
		-- Below 10: x25 | Below 30: x10 | Below 100: x3 | Above 300: No change!
	end
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, 2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.turret_turningsd)
	VJ_STOPSOUND(self.turret_alertsd)
end
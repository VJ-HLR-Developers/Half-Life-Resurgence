AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
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
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 75 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.06 -- How much time until the projectile code is ran?
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.01 -- How much time until it can use any attack again? | Counted in Seconds

ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"npc/turret_floor/die.wav"}

-- Custom
ENT.Turret_HasLOS = false -- Has line of sight
ENT.Turret_StandDown = true
ENT.Turret_CurrentParameter = 0
ENT.Turret_ScanDirSide = 0
ENT.Turret_ScanDirUp = 0
ENT.Turret_NextScanBeepT = 0

-- Pose Parameters:
-- aim_yaw -60 / 60
-- aim_pitch -15 / 15
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 63), Vector(-13, -13, 0))
	
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
		self:SetSkin(math.random(1,2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
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
	if IsValid(self:GetEnemy()) or self.Alerted == true then
		self.Turret_StandDown = false
		self.AnimTbl_IdleStand = {"idlealert"}
		if self.Turret_HasLOS == true && IsValid(self:GetEnemy()) then
			self.Turret_Sprite:Fire("Color","255 0 0")
			self.Turret_Sprite:Fire("ShowSprite")
		else
			self.Turret_Sprite:Fire("Color","255 165 0")
			self.Turret_Sprite:Fire("ShowSprite")
		end
		
		 -- Look around randomly when the enemy is not found
		if !IsValid(self:GetEnemy()) then
			-- Playing a beeping noise
			if self.Turret_NextScanBeepT < CurTime() then
				VJ_EmitSound(self, {"npc/turret_floor/ping.wav"}, 75, 100)
				self.Turret_NextScanBeepT = CurTime() + 1
			end
			-- Change the rotation direction when the max number is reached for a direction
			if self:GetPoseParameter("aim_yaw") >= 60 then
				self.Turret_ScanDirSide = 1
			elseif self:GetPoseParameter("aim_yaw") <= -60 then
				self.Turret_ScanDirSide = 0
			end
			self:SetPoseParameter("aim_yaw", self:GetPoseParameter("aim_yaw") + (self.Turret_ScanDirSide == 1 and -8 or 8))
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
		if CurTime() > self.NextResetEnemyT && self.Alerted == false && self.Turret_StandDown == false then
			self.Turret_Sprite:Fire("Color","0 150 0")
			self.Turret_Sprite:Fire("ShowSprite")
			self.Turret_StandDown = true
			self:VJ_ACT_PLAYACTIVITY({"retire"}, true, 1)
			VJ_EmitSound(self,{"npc/turret_floor/retract.wav"}, 70, 100)
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
function ENT:CustomOn_PoseParameterLookingCode(pitch,yaw,roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10 then
		self.Turret_HasLOS = false
	else
		if self.Turret_HasLOS == false && IsValid(self:GetEnemy()) then
			VJ_EmitSound(self,{"npc/turret_floor/active.wav"}, 70, 100)
		end
		self.Turret_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	if self.Turret_HasLOS == true then return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnResetEnemy()
	-- Make it look around for couple seconds before sleeping
	self.PoseParameterLooking_CanReset = false -- Used for looking around when enemy isn't found
	self.Alerted = true -- Set it back to alerted (Since it gets turned off in reset enemy)
	timer.Simple(5, function() -- After the timer, make it actually not alerted
		if IsValid(self) then
			self.PoseParameterLooking_CanReset = true
			if !IsValid(self:GetEnemy()) then
				self.Alerted = false
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	self.HasPoseParameterLooking = false -- Make it not aim at the enemy right away!
	timer.Simple(0.6, function()
		if IsValid(self) then
			self.HasPoseParameterLooking = true
		end
	end)
	self.NextResetEnemyT = CurTime() + 1 -- Make sure it doesn't reset the enemy right away
	self:VJ_ACT_PLAYACTIVITY({"deploy"}, true, false)
	VJ_EmitSound(self,{"npc/turret_floor/deploy.wav"}, 70, 100)
	local turret_alert = VJ_CreateSound(self, "npc/turret_floor/alarm.wav", 75, 100)
	timer.Simple(0.8, function() VJ_STOPSOUND(turret_alert) end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	self:VJ_ACT_PLAYACTIVITY("vjseq_fire", false)
	
	local startpos = self:GetAttachment(self:LookupAttachment("eyes")).Pos
	local bullet = {}
	bullet.Num = 1
	bullet.Src = startpos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) - startpos
	bullet.Spread = Vector(math.random(-15,15), math.random(-15,15), math.random(-15,15))
	bullet.Tracer = 1
	bullet.TracerName = "AR2Tracer"
	bullet.Force = 5
	bullet.Damage = 3
	bullet.AmmoType = "AR2"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self, {"npc/turret_floor/shoot1.wav","npc/turret_floor/shoot2.wav","npc/turret_floor/shoot3.wav"}, 90, self:VJ_DecideSoundPitch(100,110))
	
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
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",0.07)
	self:DeleteOnRemove(FireLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	ParticleEffect("explosion_turret_break_fire", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_flash", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_sparks", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,GetCorpse,2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.turret_turningsd)
end
/*ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.TimeUntilRangeAttackProjectileRelease = 0.001 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 0.001 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.001 -- How much time until it can use any attack again? | Counted in Seconds
ENT.SightDistance = 5000 -- How far it can see
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.AnimTbl_RangeAttack = {"fire"} -- Range Attack Animations
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 60 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Alert = {"npc/turret_floor/active.wav"}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"npc/turret_floor/die.wav"}

ENT.AlertSoundLevel = 75

	-- ====== Custom ====== --
ENT.Turret_StandDown = true
ENT.Turret_CurrentParameter = 0
ENT.Turret_NextAlarmT = 0

ENT.Turret_HasAlarm = true
ENT.Turret_AlarmAttachment = "light"
ENT.Turret_BulletAttachment = "eyes"
ENT.Turret_BulletAttachmentParticle = 1
ENT.Turret_BulletForce = 5
ENT.Turret_BulletDamage = 6
ENT.Turret_FireSoundVolume = 90
ENT.BulletSpread = 15

ENT.Turret_IdleActivated = {"idlealert"}
ENT.Turret_Retract = {"retract"}
ENT.Turret_Fire = {"fire"}

ENT.Turret_TurningSound = "npc/turret_wall/turret_loop1.wav"
ENT.Turret_AlarmSound = {"npc/turret_floor/ping.wav"}
ENT.Turret_RetractSound = {"npc/turret_floor/retract.wav"}
ENT.Turret_FireSound = {"npc/turret_floor/shoot1.wav","npc/turret_floor/shoot2.wav","npc/turret_floor/shoot3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
	self.RangeDistance = self.SightDistance
	self.RangeAttackAngleRadius = 75
	self.SightAngle = 70
	self.Turret_AlarmTimes = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Turret_CurrentParameter then
		self.turret_turningsd = CreateSound(self,self.Turret_TurningSound) 
		self.turret_turningsd:SetSoundLevel(70)
		self.turret_turningsd:PlayEx(1,100)
	else
		VJ_STOPSOUND(self.turret_turningsd)
	end
	self.Turret_CurrentParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:GetEnemy() != nil then
		self.Turret_StandDown = false
		self.AnimTbl_IdleStand = self.Turret_IdleActivated
		if self:GetEnemy():Visible(self) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.RangeAttackAngleRadius))) then
			self.Turret_AlarmTimes = 0
		else
			if self.Turret_HasAlarm == true then
				if CurTime() > self.Turret_NextAlarmT then
					local glow = ents.Create("env_sprite")
					glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
					glow:SetKeyValue("scale","0.125")
					glow:SetKeyValue("rendermode","5")
					glow:SetKeyValue("rendercolor","255 0 0")
					glow:SetKeyValue("spawnflags","1") -- If animated
					glow:SetParent(self)
					glow:Fire("SetParentAttachment",self.Turret_AlarmAttachment,0)
					glow:Spawn()
					glow:Activate()
					glow:Fire("Kill","",0.1)
					self:DeleteOnRemove(glow)
					self.Turret_NextAlarmT = CurTime() + 1
					self.Turret_AlarmTimes = self.Turret_AlarmTimes +1
					VJ_EmitSound(self,self.Turret_AlarmSound,75,100)
				end
			end
			if self.ResetedEnemy == false && self.Turret_AlarmTimes >= 10 then
				self.ResetedEnemy = true
				self:ResetEnemy(true)
				self.Turret_AlarmTimes = 0
			end
		end
	else
		if CurTime() > self.NextResetEnemyT && self.Alerted == false then
			if self.Turret_StandDown == false then
				self.Turret_StandDown = true
				self:VJ_ACT_PLAYACTIVITY(self.Turret_Retract,true,0.7)
				VJ_EmitSound(self,self.Turret_RetractSound,65,self:VJ_DecideSoundPitch(100,110))
			end
			self.AnimTbl_IdleStand = {"idle"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	-- if self:GetEnemy():Visible(self) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.Turret_FiringRadius))) && (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.SightDistance) then
		return true
	-- else
		-- return false
	-- end
	-- local pospara = self:GetPoseParameter("aim_yaw")
	-- local viewcode = ((self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) - (self:GetPos() + self:OBBCenter())):Angle()
	-- local viewniger = math.abs(viewcode.y - (self:GetAngles().y + pospara))
	-- if viewniger >= 330 then viewniger = viewniger - 360 end
	-- if math.abs(viewniger) <= 10 then return true end
	-- return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	self:VJ_ACT_PLAYACTIVITY({"deploy"},true,0.7)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetAttachment(self:LookupAttachment(self.Turret_BulletAttachment)).Pos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-self:GetAttachment(self:LookupAttachment(self.Turret_BulletAttachment)).Pos +Vector(math.random(-self.BulletSpread,self.BulletSpread),math.random(-self.BulletSpread,self.BulletSpread),math.random(-self.BulletSpread,self.BulletSpread))
	bullet.Spread = self.BulletSpread
	bullet.Tracer = 1
	bullet.TracerName = "AR2Tracer"
	bullet.Force = self.Turret_BulletForce
	bullet.Damage = self.Turret_BulletDamage
	bullet.AmmoType = "AR2"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self,self.Turret_FireSound,self.Turret_FireSoundVolume,self:VJ_DecideSoundPitch(100,110))
	self:VJ_ACT_PLAYACTIVITY(self.Turret_Fire,true,0.06)
	-- local gest = self:AddGestureSequence(self:LookupSequence("fire"))
	-- self:SetLayerPriority(gest,1)
	-- self:SetLayerPlaybackRate(gest,1)
	
	ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self,self.Turret_BulletAttachmentParticle)
	timer.Simple(0.2,function() if IsValid(self) then self:StopParticles() end end)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(self:GetAttachment(self:LookupAttachment(self.Turret_BulletAttachment)).Pos)
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color", "0 31 225")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",0.07)
	self:DeleteOnRemove(FireLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	ParticleEffect("explosion_turret_break_fire", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_flash", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_sparks", self:GetPos() +self:OBBCenter(), Angle(0,0,0), GetCorpse)
	ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,GetCorpse,2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.turret_turningsd)
end*/
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
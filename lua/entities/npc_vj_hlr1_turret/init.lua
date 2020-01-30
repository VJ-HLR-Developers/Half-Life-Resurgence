AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 1300 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"/*"CLASS_UNITED_STATES"*/} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 1300 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.08 -- How much time until the projectile code is ran?
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.RangeAttackExtraTimers = {0}
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.01-- How much time until it can use any attack again? | Counted in Seconds

ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/turret/tu_alert.wav"}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/turret/tu_die.wav","vj_hlr/hl1_npc/turret/tu_die2.wav","vj_hlr/hl1_npc/turret/tu_die2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Sentry_MuzzleAttach = "gun"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_StandDown = true
ENT.Sentry_CurrentParameter = 0
ENT.Sentry_NextAlarmT = 0
ENT.HasSpunUp = false
ENT.IsSpinning = false
ENT.PlayingSpinSound = false
ENT.LastShotT = CurTime()
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(25, 25, 50), Vector(-25, -25, -50))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local ang = self:GetAngles()
	self:SetAngles(Angle(ang.x,ang.y,180))
	local parameter = self:GetPoseParameter("aim_yaw")
	if self.IsSpinning then
		self.sentry_turningsd2 = CreateSound(self, "vj_hlr/hl1_npc/turret/tu_active2.wav") 
		self.sentry_turningsd2:SetSoundLevel(70)
		self.sentry_turningsd2:PlayEx(1,100)
	elseif self.Sentry_StandDown then
		VJ_STOPSOUND(self.sentry_turningsd2)
	else
		VJ_STOPSOUND(self.sentry_turningsd2)
	end
	if parameter != self.Sentry_CurrentParameter then
		self.sentry_turningsd = CreateSound(self, "vj_hlr/hl1_npc/turret/motor_loop.wav") 
		self.sentry_turningsd:SetSoundLevel(70)
		self.sentry_turningsd:PlayEx(1,100)
	else
		VJ_STOPSOUND(self.sentry_turningsd)
	end
	self.Sentry_CurrentParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if CurTime() > self.LastShotT && self.HasSpunUp then
		self.IsSpinning = false
		if self.PlayingSpinSound then
			self.PlayingSpinSound = false
			VJ_EmitSound(self,"vj_hlr/hl1_npc/turret/tu_spindown.wav",80,100)
			timer.Simple(0.7,function()
				if IsValid(self) then
					self.HasSpunUp = false
				end
			end)
		end
	end
	if IsValid(self:GetEnemy()) then
		self.Sentry_StandDown = false
		self.AnimTbl_IdleStand = {"spin"}
		
		if CurTime() > self.Sentry_NextAlarmT then
			local glow = ents.Create("env_sprite")
			glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
			glow:SetKeyValue("scale","0.1")
			glow:SetKeyValue("rendermode","5")
			glow:SetKeyValue("rendercolor","255 0 0")
			glow:SetKeyValue("spawnflags","1") -- If animated
			glow:SetParent(self)
			glow:Fire("SetParentAttachment",self.Sentry_AlarmAttach)
			glow:Spawn()
			glow:Activate()
			glow:Fire("Kill","",0.1)
			self:DeleteOnRemove(glow)
			self.Sentry_NextAlarmT = CurTime() + 1
			VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_ping.wav"},75,100)
		end
	else
		if CurTime() > self.NextResetEnemyT && self.Alerted == false then
			if self.Sentry_StandDown == false then
				self.Sentry_StandDown = true
				self:VJ_ACT_PLAYACTIVITY({"retire"},true,1)
				VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_retract.wav"},65,self:VJ_DecideSoundPitch(100,110))
			end
		end
		if self.Sentry_StandDown == true then
			self.AnimTbl_IdleStand = {"idle_off"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	if !self.HasSpunUp then
		self.LastShotT = CurTime() +4
		if !self.PlayingSpinSound then
			self.PlayingSpinSound = true
			VJ_EmitSound(self,"vj_hlr/hl1_npc/turret/tu_spinup.wav",80,100)
			timer.Simple(1,function()
				if IsValid(self) then
					self.HasSpunUp = true
					self.IsSpinning = true
				end
			end)
		end
	end
	if !self.IsSpinning then return end
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos +VectorRand() *8
	bullet.Spread = 14
	bullet.Tracer = 1
	bullet.TracerName = "Tracer"
	bullet.Force = 12
	bullet.Damage = 7
	bullet.AmmoType = "SMG1"
	self:FireBullets(bullet)
	self.LastShotT = CurTime() +4
	
	VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_fire1.wav"},90,self:VJ_DecideSoundPitch(92,100))
	
	muz = ents.Create("env_sprite_oriented")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash3.vmt")
	muz:SetKeyValue("scale",""..math.Rand(0.5,0.9))
	muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt","255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags","0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment",self.Sentry_MuzzleAttach)
	muz:SetAngles(Angle(math.random(-100,100),math.random(-100,100),math.random(-100,100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",0.08)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos)
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color", "255 150 60")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",0.07)
	self:DeleteOnRemove(FireLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.sentry_turningsd)
	VJ_STOPSOUND(self.sentry_turningsd2)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
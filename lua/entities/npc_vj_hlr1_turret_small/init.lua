AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/turret_mini.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 40
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"/*"CLASS_UNITED_STATES"*/}

ENT.TimeUntilRangeAttackProjectileRelease = 0 -- How much time until the projectile code is ran?
ENT.RangeAttackReps = 1
ENT.RangeAttackExtraTimers = {0.12}
ENT.NextRangeAttackTime = 0.2 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.2 -- How much time until it can use any attack again? | Counted in Seconds

ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/turret/tu_die.wav","vj_hlr/hl1_npc/turret/tu_die2.wav","vj_hlr/hl1_npc/turret/tu_die2.wav"}

-- Custom
ENT.Sentry_MuzzleAttach = "muzzle"
ENT.Sentry_AlarmAttach = "frame"
ENT.Sentry_StandDown = true
ENT.Sentry_CurrentParameter = 0
ENT.Sentry_NextAlarmT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(25,25,40), Vector(-25,-25,-40))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local ang = self:GetAngles()
	self:SetAngles(Angle(ang.x,ang.y,180))
	local parameter = self:GetPoseParameter("aim_yaw")
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
	if IsValid(self:GetEnemy()) then
		self.Sentry_StandDown = false
		self.AnimTbl_IdleStand = {"spin"}
		
		if CurTime() > self.Sentry_NextAlarmT then
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
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos +VectorRand() *6
	bullet.Spread = 14
	bullet.Tracer = 1
	bullet.TracerName = "Tracer"
	bullet.Force = 4
	bullet.Damage = 4
	bullet.AmmoType = "SMG1"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_fire1.wav"},90,self:VJ_DecideSoundPitch(110,118))
	
	muz = ents.Create("env_sprite_oriented")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash1.vmt")
	muz:SetKeyValue("scale",""..math.Rand(0.6,1))
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
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/sentry.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = GetConVarNumber("vj_bms_turret_h")
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 1300 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 1300 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.1 -- How much time until the projectile code is ran?
ENT.RangeAttackReps = 3 -- How many times does it run the projectile code?
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.1 -- How much time until it can use any attack again? | Counted in Seconds

ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw poseparameters (Y)
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/turret/tu_die.wav"}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/turret/tu_die.wav","vj_hlr/hl1_npc/turret/tu_die2.wav","vj_hlr/hl1_npc/turret/tu_die2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.HECUTurret_StandDown = true
ENT.HECUTurret_CurrentParameter = 0
ENT.HECUTurret_NextAlarmT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.HECUTurret_CurrentParameter then
		self.hecuturret_turningsd = CreateSound(self, "vj_hlr/hl1_npc/turret/motor_loop.wav") 
		self.hecuturret_turningsd:SetSoundLevel(70)
		self.hecuturret_turningsd:PlayEx(1,100)
	else
		VJ_STOPSOUND(self.hecuturret_turningsd)
	end
	self.HECUTurret_CurrentParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) then
		self.HECUTurret_StandDown = false
		self.AnimTbl_IdleStand = {"spin"}
		
		if CurTime() > self.HECUTurret_NextAlarmT then
			local glow = ents.Create("env_sprite")
			glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
			glow:SetKeyValue("scale","0.1")
			glow:SetKeyValue("rendermode","5")
			glow:SetKeyValue("rendercolor","255 0 0")
			glow:SetKeyValue("spawnflags","1") -- If animated
			glow:SetParent(self)
			glow:Fire("SetParentAttachment","1",0)
			glow:Spawn()
			glow:Activate()
			glow:Fire("Kill","",0.1)
			self:DeleteOnRemove(glow)
			self.HECUTurret_NextAlarmT = CurTime() + 1
			VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_ping.wav"},75,100)
		end
		
		if self:CustomAttackCheck_RangeAttack() == true && (self.RangeAttacking == true or self:GetEnemy():Visible(self)) then
			self:SetSkin(0)
		else
			self:SetSkin(1)
		end
	else
		if CurTime() > self.NextResetEnemyT && self.Alerted == false then
			self:SetSkin(0)
			if self.HECUTurret_StandDown == false then
				self.HECUTurret_StandDown = true
				self:VJ_ACT_PLAYACTIVITY({"retire"},true,1)
				VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_retract.wav"},65,self:VJ_DecideSoundPitch(100,110))
			end
		end
		if self.HECUTurret_StandDown == true then
			self.AnimTbl_IdleStand = {"idle_off"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	return true
	
	/*local pospara = self:GetPoseParameter("aim_yaw")
	local viewcode = ((self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()) - (self:GetPos() + self:OBBCenter())):Angle()
	local viewniger = math.abs(viewcode.y - (self:GetAngles().y + pospara))
	if viewniger >= 330 then viewniger = viewniger - 360 end
	if math.abs(viewniger) <= 10 then return true end
	return false*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert()
	self.HECUTurret_NextAlarmT = CurTime() + 3
	self.NextResetEnemyT = CurTime() + 0.7
	self:VJ_ACT_PLAYACTIVITY({"deploy"},true,false)
	VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_deploy.wav"},75,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetAttachment(self:LookupAttachment("0")).Pos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-self:GetAttachment(self:LookupAttachment("0")).Pos
	bullet.Spread = 0.001
	bullet.Tracer = 1
	bullet.TracerName = "Tracer"
	bullet.Force = 5
	bullet.Damage = GetConVarNumber("vj_bms_turret_d")
	bullet.AmmoType = "SMG1"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_fire1.wav"},90,self:VJ_DecideSoundPitch(100,110))
	
	ParticleEffectAttach("vj_bms_turret_full",PATTACH_POINT_FOLLOW,self,1)
	timer.Simple(0.2,function() if IsValid(self) then self:StopParticles() end end)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(self:GetAttachment(self:LookupAttachment("0")).Pos)
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
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,GetCorpse,2)
	ParticleEffect("explosion_turret_break_fire", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("1")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_flash", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("1")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("1")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_sparks", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("1")).Pos, Angle(0,0,0), GetCorpse)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.hecuturret_turningsd)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
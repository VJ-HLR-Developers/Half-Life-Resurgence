AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/sentry.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 1300 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How the NPC moves around
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy03", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 4), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.AlertedToIdleTime = VJ.SET(16, 16) -- How much time until it calms down after the enemy has been killed/disappeared | Sets self.Alerted to false after the timer expires
ENT.HasMeleeAttack = false -- Can this NPC melee attack?

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 1300 -- How far can it range attack?
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the NPC | 180 = All around the NPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.06 -- How much time until the projectile code is ran?
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.01 -- How much time until it can use any attack again? | Counted in Seconds

ENT.Medic_CanBeHealed = false -- Can this NPC be healed by medics?
ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch pose parameters (X)
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw pose parameters (Y)
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/turret/tu_deploy.wav"}
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/turret/tu_die.wav", "vj_hlr/hl1_npc/turret/tu_die2.wav", "vj_hlr/hl1_npc/turret/tu_die2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Sentry_MuzzleAttach = "0" -- The bullet attachment
ENT.Sentry_AlarmAttach = "1" -- Attachment that the alarm sprite spawns
ENT.Sentry_Type = 0 -- 0 = Regular Ground Sentry | 1 = Big Ceiling/Ground Turret | 2 = Mini Ceiling/Ground Turret
ENT.Sentry_OrientationType = 0 -- 0 = Ground | 1 = Ceiling
ENT.Sentry_GroundType = 0 -- 0 = Regular Ground Sentry | 1 = Decay Ground Sentry
ENT.Sentry_DeployedAnim = "spin" -- Animation to play when it's deployed, idle angry basically | This is auto translated it to an activity on initialize!
-- Regular = ACT_SPIN | Decay = ACT_IDLE_RELAXED | Big & Mini ceiling/ground = ACT_IDLE_ANGRY

ENT.Sentry_HasLOS = false -- Has line of sight
ENT.Sentry_StandDown = true
ENT.Sentry_SpunUp = false
ENT.Sentry_CurrentYawParameter = 0
ENT.Sentry_NextAlarmT = 0
ENT.Sentry_ControllerStatus = 0 -- Current status of the controller, 0 = Idle | 1 = Alerted
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
	self.Sentry_DeployedAnim = VJ.SequenceToActivity(self, self.Sentry_DeployedAnim)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Activate / Deactivate")
	
	self.Sentry_ControllerStatus = 0
	self.HasPoseParameterLooking = false -- Initially, we are going to start as idle, we do NOT want the sentry turning!
	self.NextAlertSoundT = CurTime() + 1 -- So it doesn't play the alert sound as soon as it enters the NPC!
	
	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE then
			local npc = self.VJCE_NPC
			if npc.Sentry_ControllerStatus == 0 then
				npc.Sentry_ControllerStatus = 1
				npc.HasPoseParameterLooking = true
				npc:PlaySoundSystem("Alert")
				npc:Sentry_Activate()
			elseif npc.Sentry_SpunUp then -- Do NOT become idle if we are playing an activate routine!
				npc.Sentry_ControllerStatus = 0
				npc.HasPoseParameterLooking = false
			end
		end
	end
	
	function controlEnt:OnStopControlling(keyPressed)
		local npc = self.VJCE_NPC
		if IsValid(npc) then
			npc.HasPoseParameterLooking = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && !self.Sentry_StandDown then
		return self.Sentry_DeployedAnim
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Sentry_CurrentYawParameter then
		self.CurrentSentryTurnSound = CreateSound(self, "vj_hlr/hl1_npc/turret/motor_loop_.wav")
		self.CurrentSentryTurnSound:SetSoundLevel(70)
		self.CurrentSentryTurnSound:PlayEx(1, 100)
		if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
			self.CurrentSentryTurnSound2 = CreateSound(self, "vj_hlr/hl1_npc/turret/tu_active2.wav")
			self.CurrentSentryTurnSound2:SetSoundLevel(70)
			self.CurrentSentryTurnSound2:PlayEx(1, 100)
		end
	else
		VJ.STOPSOUND(self.CurrentSentryTurnSound)
		if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
			VJ.STOPSOUND(self.CurrentSentryTurnSound2)
		end
	end
	self.Sentry_CurrentYawParameter = parameter
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Dead then return end
	local eneValid = IsValid(self:GetEnemy())
	-- Don't reset pose parameters while its transitioning from Alert to Idle
	self.PoseParameterLooking_CanReset = (!self.Alerted && eneValid)
	
	if (self.Sentry_ControllerStatus == 1) or (!self.VJ_IsBeingControlled && (eneValid or self.Alerted)) then
		self.Sentry_StandDown = false
		if CurTime() > self.Sentry_NextAlarmT && self.Sentry_Type != 2 then
			local glow = ents.Create("env_sprite")
			glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
			glow:SetKeyValue("scale", self.Sentry_Type == 1 and "0.35" or "0.15")
			glow:SetKeyValue("rendermode","5")
			glow:SetKeyValue("rendercolor","255 0 0")
			glow:SetKeyValue("spawnflags","1") -- If animated
			glow:SetParent(self)
			glow:Fire("SetParentAttachment", self.Sentry_AlarmAttach)
			glow:Spawn()
			glow:Activate()
			glow:Fire("Kill", "", 0.1)
			self:DeleteOnRemove(glow)
			self.Sentry_NextAlarmT = CurTime() + 1
			VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_ping.wav", 75, 100)
		end
		if !eneValid then -- Look around randomly when the enemy is not found
			self:SetPoseParameter("aim_yaw", self.Sentry_CurrentYawParameter + 4)
		end
	else
		if ((self.Sentry_ControllerStatus == 0) or (!self.VJ_IsBeingControlled && !self.Alerted)) && self.Sentry_StandDown == false then
			if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
				self:AddFlags(FL_NOTARGET) -- Make it not targetable
			end
			self.Sentry_StandDown = true
			self:VJ_ACT_PLAYACTIVITY("retire", true, 1)
			VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_retract.wav", 65, math.random(100, 110))
			if self.Sentry_Type == 1 then
				self.Sentry_SpunUp = false
				VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_spindown.wav", 80, 100)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	self.Sentry_HasLOS = !((math.abs(math.AngleDifference(self.Sentry_CurrentYawParameter, math.ApproachAngle(self.Sentry_CurrentYawParameter, yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	return self.Sentry_HasLOS == true && self.Sentry_SpunUp == true && !self.Sentry_StandDown
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(2) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	self:Sentry_Activate()
	if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
		self:RemoveFlags(FL_NOTARGET) -- Other NPCs should now target it!
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Sentry_Activate()
	if self.Sentry_Type == 1 then -- If it's big turret, then make sure it's not looking until it has fully deployed
		self.HasPoseParameterLooking = false
	end
	self.Sentry_NextAlarmT = CurTime() + 3 -- Make sure the Alarm light doesn't play right away
	self:VJ_ACT_PLAYACTIVITY("deploy", true, false)
	if self.Sentry_Type == 1 then -- If it's a big turret then do a spin up action
		timer.Simple(1, function()
			if IsValid(self) && IsValid(self:GetEnemy()) then
				self.HasPoseParameterLooking = true
				VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_spinup.wav", 80, 100)
				timer.Simple(1, function()
					if IsValid(self) && IsValid(self:GetEnemy()) then
						self.Sentry_SpunUp = true
					end
				end)
			end
		end)
	else
		self.Sentry_SpunUp = true
	end
	VJ.EmitSound(self, {"vj_hlr/hl1_npc/turret/tu_alert.wav"}, 75, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local attPos = self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos
	self:FireBullets({
		Num = 1,
		Src = attPos,
		Dir = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - attPos,
		Spread = Vector(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15)),
		Tracer = 1,
		TracerName = "VJ_HLR_Tracer",
		Force = 5,
		Damage = (self.Sentry_Type == 1 and 7) or 3,
		AmmoType = "SMG1"
	})
	
	VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_fire1.wav", 90, math.random(100, 110))
	VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_fire1_distant.wav", 140, math.random(100, 110))
	
	local muz = ents.Create("env_sprite_oriented")
	muz:SetKeyValue("model", "vj_hl/sprites/muzzleflash3.vmt")
	if self.Sentry_Type == 1 then
		muz:SetKeyValue("scale", ""..math.Rand(0.8, 1))
	else
		muz:SetKeyValue("scale", ""..math.Rand(0.3, 0.5))
	end
	muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt","255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags","0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment", self.Sentry_MuzzleAttach)
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill", "", 0.08)
	
	local muzzleLight = ents.Create("light_dynamic")
	muzzleLight:SetKeyValue("brightness", "4")
	muzzleLight:SetKeyValue("distance", "120")
	muzzleLight:SetPos(attPos)
	muzzleLight:SetLocalAngles(self:GetAngles())
	muzzleLight:Fire("Color", "255 150 60")
	muzzleLight:SetParent(self)
	muzzleLight:Spawn()
	muzzleLight:Activate()
	muzzleLight:Fire("TurnOn")
	muzzleLight:Fire("Kill", "", 0.07)
	self:DeleteOnRemove(muzzleLight)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecUp20 = Vector(0, 0, 20)
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	print('TEST')
	if status == "Finish" then
		-- Explosion sprite
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("GlowProxySize","2.0")
		spr:SetKeyValue("HDRColorScale","1.0")
		spr:SetKeyValue("renderfx","14")
		spr:SetKeyValue("rendermode","5")
		spr:SetKeyValue("renderamt","255")
		spr:SetKeyValue("disablereceiveshadows","0")
		spr:SetKeyValue("mindxlevel","0")
		spr:SetKeyValue("maxdxlevel","0")
		spr:SetKeyValue("framerate","15.0")
		spr:SetKeyValue("spawnflags","0")
		spr:SetKeyValue("scale","1.5")
		if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
			self.DeathCorpseEntityClass = "prop_vj_animatable"
			spr:SetPos(self:GetPos() + self:GetUp()*(self.Sentry_OrientationType == 1 and -30 or 20))
		elseif self.Sentry_GroundType == 1 then -- Decay sentry gun
			local pos = self:GetAttachment(self:LookupAttachment("center")).Pos + vecUp20
			spr:SetPos(pos)
			util.BlastDamage(self, self, pos, 50, 30)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris"..math.random(1, 3)..".wav", 80, 100)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3, 5).."_dist.wav", 140, 100)
			self.GibOnDeathDamagesTable = {"All"}
			self:DoGibOnDeath(DamageInfo(), hitgroup) -- Do NOT use "dmginfo", it will be corrupted by now because GMod can only have 1!
		else
			spr:SetPos(self:GetPos() + self:GetUp()*60)
		end
		spr:Spawn()
		spr:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function()
			if IsValid(spr) then
				spr:Remove()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibsCollideSd = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	local upPos = self.Sentry_OrientationType == 1 and -30 or 20
	local attPos = self.Sentry_GroundType == 1 and self:GetAttachment(self:LookupAttachment("center")).Pos or nil -- Decay sentry gun
	if self.Sentry_Type == 1 or self.Sentry_Type == 2 then -- Big Ceiling/Ground Turret and Mini Ceiling/Ground Turret
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(1,0,upPos)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0,1,upPos)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(2,0,upPos)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0,2,upPos)), CollideSound=gibsCollideSd})
		if self.Sentry_Type == 1 then -- Big Ceiling/Ground Turret
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(3,0,upPos)), CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0,3,upPos)), CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(4,0,upPos)), CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0,4,upPos)), CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(5,0,upPos)), CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0,5,upPos)), CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(6,0,upPos)), CollideSound=gibsCollideSd})
		end
	else -- All other turrets
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(1,0,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,1,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(2,0,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,2,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(3,0,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,3,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(4,0,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,4,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(5,0,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,5,20)), CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11_g.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(6,0,20)), CollideSound=gibsCollideSd})
	end
	
	-- General gibs for all turrets
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog1.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(1,0,upPos)), CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog2.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,1,upPos)), CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_rib.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(2,0,upPos)), CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,2,upPos)), CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(3,0,upPos)), CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(0,3,upPos)), CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_spring.mdl", {BloodDecal="", Pos=attPos or self:LocalToWorld(Vector(4,0,upPos)), CollideSound=""}) -- Shad ge sharji, ere vor tsayn chi hane
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 100, 100)
	VJ.EmitSound(self, "vj_hlr/hl1_npc/rgrunt/rb_gib.wav", 80, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/metalgib_p1_g.mdl", "models/vj_hlr/gibs/metalgib_p2_g.mdl", "models/vj_hlr/gibs/metalgib_p3_g.mdl", "models/vj_hlr/gibs/metalgib_p4_g.mdl", "models/vj_hlr/gibs/metalgib_p5_g.mdl", "models/vj_hlr/gibs/metalgib_p6_g.mdl", "models/vj_hlr/gibs/metalgib_p7_g.mdl", "models/vj_hlr/gibs/metalgib_p8_g.mdl", "models/vj_hlr/gibs/metalgib_p9_g.mdl", "models/vj_hlr/gibs/metalgib_p10_g.mdl", "models/vj_hlr/gibs/metalgib_p11_g.mdl", "models/vj_hlr/gibs/rgib_cog1.mdl", "models/vj_hlr/gibs/rgib_cog2.mdl", "models/vj_hlr/gibs/rgib_rib.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, self.Sentry_Type == 2 and 1 or 2)
	if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
		corpseEnt:DrawShadow(false)
		corpseEnt:ResetSequence("die")
	end
	if self.Sentry_Type == 0 then
		VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs, {CollideSound = gibsCollideSd, ExpSound = {"vj_hlr/hl1_npc/rgrunt/rb_gib.wav"}})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.CurrentSentryTurnSound)
	VJ.STOPSOUND(self.CurrentSentryTurnSound2)
end
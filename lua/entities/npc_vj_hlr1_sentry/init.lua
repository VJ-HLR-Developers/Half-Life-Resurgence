AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/sentry.mdl"
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 1300
ENT.SightAngle = 360
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanTurnWhileStationary = false
ENT.ControllerParams = {
	ThirdP_Offset = Vector(0, 0, -15),
	FirstP_Bone = "Dummy03",
	FirstP_Offset = Vector(0, 0, 4)
}

ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.AlertTimeout = VJ.SET(16, 16)
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = false
ENT.RangeAttackMaxDistance = 1300
ENT.RangeAttackMinDistance = 1
ENT.RangeAttackAngleRadius = 180
ENT.TimeUntilRangeAttackProjectileRelease = 0.06
ENT.RangeAttackReps = 1
ENT.NextRangeAttackTime = 0
ENT.NextAnyAttackTime_Range = 0.01

ENT.VJ_ID_Healable = false
ENT.PoseParameterLooking_InvertPitch = true
ENT.PoseParameterLooking_InvertYaw = true

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE

ENT.SoundTbl_Alert = "vj_hlr/gsrc/npc/turret/tu_deploy.wav"
ENT.SoundTbl_Impact = {"vj_hlr/gsrc/fx/spark1.wav", "vj_hlr/gsrc/fx/spark2.wav", "vj_hlr/gsrc/fx/spark3.wav", "vj_hlr/gsrc/fx/spark4.wav", "vj_hlr/gsrc/fx/spark5.wav", "vj_hlr/gsrc/fx/spark6.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/turret/tu_die.wav", "vj_hlr/gsrc/npc/turret/tu_die2.wav", "vj_hlr/gsrc/npc/turret/tu_die3.wav"}

ENT.MainSoundPitch = 100

-- Custom
local SENTRY_TYPE_REGULAR = 0 -- Regular Ground Sentry
local SENTRY_TYPE_BM_BIG = 1 -- Big Ceiling/Ground Turret
local SENTRY_TYPE_BM_MINI = 2 -- Mini Ceiling/Ground Turret

local SENTRY_ORIENTATION_GROUND = 0 -- Ground Sentry
local SENTRY_ORIENTATION_CEILING = 1 -- Ceiling Sentry

local SENTRY_REGULAR_TYPE_NORMAL = 0 -- Regular Ground Sentry
local SENTRY_REGULAR_TYPE_DECAY = 1 -- Decay Ground Sentry

ENT.Sentry_MuzzleAttach = "0" -- The bullet attachment
ENT.Sentry_AlarmAttach = "1" -- Attachment that the alarm sprite spawns
ENT.Sentry_Type = SENTRY_TYPE_REGULAR
ENT.Sentry_OrientationType = SENTRY_ORIENTATION_GROUND
ENT.Sentry_RegularType = SENTRY_REGULAR_TYPE_NORMAL
ENT.Sentry_DeployedAnim = "spin" -- Animation to play when it's deployed, idle angry basically | This is auto translated it to an activity on initialize!
-- Regular = ACT_SPIN | Decay = ACT_IDLE_RELAXED | Big & Mini ceiling/ground = ACT_IDLE_ANGRY

ENT.Sentry_HasLOS = false -- Has line of sight
ENT.Sentry_StandDown = true
ENT.Sentry_SpunUp = false
ENT.Sentry_CurrentYawParameter = 0
ENT.Sentry_NextAlarmT = 0
ENT.Sentry_ControllerStatus = 0 -- Current status of the controller, 0 = Idle | 1 = Alerted

function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
	self.Sentry_DeployedAnim = VJ.SequenceToActivity(self, self.Sentry_DeployedAnim)
	VJ.HLR_ApplyFactionOptions(self)
end

function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Activate / Deactivate")

	self.Sentry_ControllerStatus = 0
	self.HasPoseParameterLooking = false -- Initially, we are going to start as idle, we do NOT want the sentry turning!
	self.NextAlertSoundT = CurTime() + 1 -- So it doesn't play the alert sound as soon as it enters the NPC!

	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE then
			local npc = self:GetNPC()
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
		local npc = self:GetNPC()
		if IsValid(npc) then
			npc.HasPoseParameterLooking = true
		end
	end
end

function ENT:TranslateActivity(act)
	if act == ACT_IDLE and !self.Sentry_StandDown then
		return self.Sentry_DeployedAnim
	end
	return self.BaseClass.TranslateActivity(self, act)
end

function ENT:OnThink()
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Sentry_CurrentYawParameter then
		self.CurrentSentryTurnSound = CreateSound(self, "vj_hlr/gsrc/npc/turret/motor_loop_.wav")
		self.CurrentSentryTurnSound:SetSoundLevel(70)
		self.CurrentSentryTurnSound:Play()
		if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then
			self.CurrentSentryTurnSound2 = CreateSound(self, "vj_hlr/gsrc/npc/turret/tu_active2.wav")
			self.CurrentSentryTurnSound2:SetSoundLevel(70)
			self.CurrentSentryTurnSound2:Play()
		end
	else
		VJ.STOPSOUND(self.CurrentSentryTurnSound)
		if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then
			VJ.STOPSOUND(self.CurrentSentryTurnSound2)
		end
	end
	self.Sentry_CurrentYawParameter = parameter
end

function ENT:OnThinkActive()
	if self.Dead then return end
	local eneValid = IsValid(self:GetEnemy())
	-- Don't reset pose parameters while its transitioning from Alert to Idle
	self.PoseParameterLooking_CanReset = (!self.Alerted and eneValid)

	if (self.Sentry_ControllerStatus == 1) or (!self.VJ_Controlled and (eneValid or self.Alerted)) then
		self.Sentry_StandDown = false
		if CurTime() > self.Sentry_NextAlarmT and self.Sentry_Type != SENTRY_TYPE_BM_MINI then
			local glow = ents.Create("env_sprite")
			glow:SetKeyValue("model", "vj_base/sprites/glow.vmt")
			glow:SetKeyValue("scale", self.Sentry_Type == SENTRY_TYPE_BM_BIG and "0.35" or "0.15")
			glow:SetKeyValue("rendermode", "5")
			glow:SetKeyValue("rendercolor", "255 0 0")
			glow:SetKeyValue("spawnflags", "1") -- If animated
			glow:SetParent(self)
			glow:Fire("SetParentAttachment", self.Sentry_AlarmAttach)
			glow:Spawn()
			glow:Activate()
			glow:Fire("Kill", nil, 0.1)
			self:DeleteOnRemove(glow)
			self.Sentry_NextAlarmT = CurTime() + 1
			VJ.EmitSound(self, "vj_hlr/gsrc/npc/turret/tu_ping.wav", 75, 100)
		end
		if !eneValid then -- Look around randomly when the enemy is not found
			self:SetPoseParameter("aim_yaw", self.Sentry_CurrentYawParameter + 4)
		end
	else
		if ((self.Sentry_ControllerStatus == 0) or (!self.VJ_Controlled and !self.Alerted)) and !self.Sentry_StandDown then
			if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then
				self:AddFlags(FL_NOTARGET) -- Make it not targetable
			end
			self.Sentry_StandDown = true
			self:PlayAnim("retire", true, 1)
			VJ.EmitSound(self, "vj_hlr/gsrc/npc/turret/tu_retract.wav", 65, math.random(100, 110))
			if self.Sentry_Type == SENTRY_TYPE_BM_BIG then
				self.Sentry_SpunUp = false
				VJ.EmitSound(self, "vj_hlr/gsrc/npc/turret/tu_spindown.wav", 80, 100)
			end
		end
	end
end

function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	self.Sentry_HasLOS = !((math.abs(math.AngleDifference(self.Sentry_CurrentYawParameter, math.ApproachAngle(self.Sentry_CurrentYawParameter, yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10))
end

function ENT:OnRangeAttack(status, enemy)
	if status == "PreInit" then
		return self.Sentry_StandDown or !(self.Sentry_HasLOS and self.Sentry_SpunUp)
	end
end

local vec = Vector()
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Init" and dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(2) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end

function ENT:OnAlert(ent)
	if self.VJ_Controlled then return end
	self:Sentry_Activate()
	if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then
		self:RemoveFlags(FL_NOTARGET) -- Other NPCs should now target it!
	end
end

function ENT:Sentry_Activate()
	if self.Sentry_Type == SENTRY_TYPE_BM_BIG then -- If it's big turret, then make sure it's not looking until it has fully deployed
		self.HasPoseParameterLooking = false
	end
	self.Sentry_NextAlarmT = CurTime() + 3 -- Make sure the Alarm light doesn't play right away
	self:PlayAnim("deploy", true, false)
	if self.Sentry_Type == SENTRY_TYPE_BM_BIG then -- If it's a big turret then do a spin up action
		timer.Simple(1, function()
			if IsValid(self) and IsValid(self:GetEnemy()) then
				self.HasPoseParameterLooking = true
				VJ.EmitSound(self, "vj_hlr/gsrc/npc/turret/tu_spinup.wav", 80, 100)
				timer.Simple(1, function()
					if IsValid(self) and IsValid(self:GetEnemy()) then
						self.Sentry_SpunUp = true
					end
				end)
			end
		end)
	else
		self.Sentry_SpunUp = true
	end
	VJ.EmitSound(self, "vj_hlr/gsrc/npc/turret/tu_alert.wav", 75, 100)
end

function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "Init" then
		local attPos = self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos
		self:FireBullets({
			Src = attPos,
			Dir = (enemy:GetPos() + enemy:OBBCenter()) - attPos,
			Spread = Vector(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15)),
			Tracer = 1,
			TracerName = "VJ_HLR_Tracer",
			Force = 5,
			Damage = (self.Sentry_Type == SENTRY_TYPE_BM_BIG and 7) or 3,
			AmmoType = "SMG1"
		})

		VJ.EmitSound(self, ((self.Sentry_Type == SENTRY_TYPE_REGULAR or self.Sentry_Type == SENTRY_TYPE_BM_MINI) and "vj_hlr/gsrc/wep/mp5/hks" .. math.random(1, 3) .. ".wav") or "vj_hlr/gsrc/npc/turret/tu_fire1.wav", 90, math.random(100, 110))
		VJ.EmitSound(self, ((self.Sentry_Type == SENTRY_TYPE_REGULAR or self.Sentry_Type == SENTRY_TYPE_BM_MINI) and "vj_hlr/gsrc/wep/mp5/hks_distant_new.wav") or "vj_hlr/gsrc/npc/turret/tu_fire1_distant.wav", 140, math.random(100, 110))

		local muz = ents.Create("env_sprite_oriented")
		muz:SetKeyValue("model", "vj_hl/sprites/muzzleflash3.vmt")
		if self.Sentry_Type == SENTRY_TYPE_BM_BIG then
			muz:SetKeyValue("scale", math.Rand(0.8, 1))
		else
			muz:SetKeyValue("scale", math.Rand(0.3, 0.5))
		end
		muz:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
		muz:SetKeyValue("HDRColorScale", "1.0")
		muz:SetKeyValue("renderfx", "14")
		muz:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
		muz:SetKeyValue("renderamt", "255") -- Transparency
		muz:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
		muz:SetKeyValue("framerate", "10.0") -- Rate at which the sprite should animate, if at all.
		muz:SetKeyValue("spawnflags", "0")
		muz:SetParent(self)
		muz:Fire("SetParentAttachment", self.Sentry_MuzzleAttach)
		muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
		muz:Spawn()
		muz:Activate()
		muz:Fire("Kill", nil, 0.08)

		local muzLight = ents.Create("light_dynamic")
		muzLight:SetKeyValue("brightness", "4")
		muzLight:SetKeyValue("distance", "120")
		muzLight:Fire("Color", "255 150 60")
		muzLight:SetParent(self)
		muzLight:Fire("SetParentAttachment", self.Sentry_MuzzleAttach)
		muzLight:Spawn()
		muzLight:Activate()
		muzLight:Fire("TurnOn")
		muzLight:Fire("Kill", nil, 0.07)
		self:DeleteOnRemove(muzLight)
		return true
	end
end

function ENT:DoImpactEffect(tr, damageType)
	return VJ.HLR1_Effect_Impact(tr)
end

function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		if self.Sentry_RegularType == SENTRY_REGULAR_TYPE_DECAY then return end -- Decay has its own death behavior
		-- Explosion sprite
		local myPos = self:GetPos()
		local myUp = self:GetUp()
		local myUpPos = myPos + myUp * (self.Sentry_OrientationType == SENTRY_ORIENTATION_CEILING and -30 or 30)
		local myUpPos2 = myPos + myUp * 60
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("GlowProxySize", "2.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "5")
		spr:SetKeyValue("renderamt", "255")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "15.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "1.5")
		if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then
			self.DeathCorpseEntityClass = "prop_vj_animatable"
			spr:SetPos(myUpPos)
		else
			spr:SetPos(myUpPos2)
		end
		spr:Spawn()
		spr:Fire("Kill", nil, 0.9)

		local expLight = ents.Create("light_dynamic")
		expLight:SetKeyValue("brightness", "4")
		expLight:SetKeyValue("distance", "300")
		if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then
			expLight:SetPos(myUpPos)
		else
			expLight:SetPos(myUpPos2)
		end
		expLight:Fire("Color", "255 150 0")
		expLight:Spawn()
		expLight:Activate()
		expLight:Fire("TurnOn")
		expLight:Fire("Kill", nil, 0.15)
	elseif status == "DeathAnim" then
		-- Set a random Y angle for death animation like in HL1
		if self.Sentry_Type == SENTRY_TYPE_REGULAR and self.Sentry_RegularType == SENTRY_REGULAR_TYPE_NORMAL then
			self:SetAngles(Angle(0, math.random(0, 360), 0))
		end
	end
end

local gibsCollideSd = {"vj_hlr/gsrc/fx/metal1.wav", "vj_hlr/gsrc/fx/metal2.wav", "vj_hlr/gsrc/fx/metal3.wav", "vj_hlr/gsrc/fx/metal4.wav", "vj_hlr/gsrc/fx/metal5.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	local upPos = self.Sentry_OrientationType == SENTRY_ORIENTATION_CEILING and -30 or 20
	local attPos = self.Sentry_RegularType == SENTRY_REGULAR_TYPE_DECAY and self:GetAttachment(self:LookupAttachment("center")).Pos or nil -- Decay sentry gun
	if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then -- Big Ceiling/Ground Turret and Mini Ceiling/Ground Turret
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 0, upPos)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 1, upPos)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(2, 0, upPos)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 2, upPos)), CollisionSound = gibsCollideSd})
		if self.Sentry_Type == SENTRY_TYPE_BM_BIG then -- Big Ceiling/Ground Turret
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(3, 0, upPos)), CollisionSound = gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 3, upPos)), CollisionSound = gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(4, 0, upPos)), CollisionSound = gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 4, upPos)), CollisionSound = gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(5, 0, upPos)), CollisionSound = gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 5, upPos)), CollisionSound = gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(6, 0, upPos)), CollisionSound = gibsCollideSd})
		end
	else -- All other turrets
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(1, 0, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 1, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(2, 0, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 2, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(3, 0, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 3, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(4, 0, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 4, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(5, 0, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 5, 20)), CollisionSound = gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11_g.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(6, 0, 20)), CollisionSound = gibsCollideSd})
	end

	-- General gibs for all turrets
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog1.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(1, 0, upPos)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog2.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 1, upPos)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_rib.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(2, 0, upPos)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 2, upPos)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(3, 0, upPos)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(0, 3, upPos)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_spring.mdl", {CollisionDecal = false, Pos = attPos or self:LocalToWorld(Vector(4, 0, upPos)), CollisionSound = false}) -- Shad ge sharji, ere vor tsayn chi hane

	VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris3.wav", 100, 100)
	self:PlaySoundSystem("Gib", "vj_hlr/gsrc/npc/rgrunt/rb_gib.wav")
	return true, {AllowSound = false}
end

local gibs = {"models/vj_hlr/gibs/metalgib_p1_g.mdl", "models/vj_hlr/gibs/metalgib_p2_g.mdl", "models/vj_hlr/gibs/metalgib_p3_g.mdl", "models/vj_hlr/gibs/metalgib_p4_g.mdl", "models/vj_hlr/gibs/metalgib_p5_g.mdl", "models/vj_hlr/gibs/metalgib_p6_g.mdl", "models/vj_hlr/gibs/metalgib_p7_g.mdl", "models/vj_hlr/gibs/metalgib_p8_g.mdl", "models/vj_hlr/gibs/metalgib_p9_g.mdl", "models/vj_hlr/gibs/metalgib_p10_g.mdl", "models/vj_hlr/gibs/metalgib_p11_g.mdl", "models/vj_hlr/gibs/rgib_cog1.mdl", "models/vj_hlr/gibs/rgib_cog2.mdl", "models/vj_hlr/gibs/rgib_rib.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpse, self.Sentry_Type == SENTRY_TYPE_BM_MINI and 1 or 2)
	if self.Sentry_Type == SENTRY_TYPE_BM_BIG or self.Sentry_Type == SENTRY_TYPE_BM_MINI then
		corpse:DrawShadow(false)
		corpse:ResetSequence("die")
		corpse:SetCycle(1)
	end
	if self.Sentry_Type == SENTRY_TYPE_REGULAR then
		VJ.HLR_ApplyCorpseSystem(self, corpse, gibs, {CollisionSound = gibsCollideSd, ExpSound = "vj_hlr/gsrc/npc/rgrunt/rb_gib.wav", SplatDecal = "VJ_HLR1_Scorch"})
	end
end

function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.CurrentSentryTurnSound)
	VJ.STOPSOUND(self.CurrentSentryTurnSound2)
end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/sentry.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 1300 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy03", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 4), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.AlertedToIdleTime = VJ_Set(16, 16) -- How much time until it calms down after the enemy has been killed/disappeared | Sets self.Alerted to false after the timer expires
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 1300 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.06 -- How much time until the projectile code is ran?
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.01 -- How much time until it can use any attack again? | Counted in Seconds

ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw poseparameters (Y)
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/turret/tu_deploy.wav"}
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/turret/tu_die.wav","vj_hlr/hl1_npc/turret/tu_die2.wav","vj_hlr/hl1_npc/turret/tu_die2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Sentry_MuzzleAttach = "0" -- The bullet attachment
ENT.Sentry_AlarmAttach = "1" -- Attachment that the alarm sprite spawns
ENT.Sentry_Type = 0 -- 0 = Regular Ground Sentry | 1 = Big Ceiling/Ground Turret | 2 = Mini Ceiling/Ground Turret
ENT.Sentry_SubType = 0 -- 0 = Ground | 1 = Ceiling

ENT.Sentry_HasLOS = false -- Has line of sight
ENT.Sentry_StandDown = true
ENT.Sentry_SpunUp = false
ENT.Sentry_CurrentParameter = 0
ENT.Sentry_NextAlarmT = 0
ENT.Sentry_ControllerStatus = 0 -- Current status of the controller, 0 = Idle | 1 = Alerted
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	self.Sentry_ControllerStatus = 0
	self.HasPoseParameterLooking = false -- Initially, we are going to start as idle, we do NOT want the sentry turning!
	self.NextAlertSoundT = CurTime() + 1 -- So it doesn't play the alert sound as soon as it enters the NPC!
	
	function controlEnt:CustomOnKeyPressed(key)
		if key == KEY_SPACE then
			if self.VJCE_NPC.Sentry_ControllerStatus == 0 then
				self.VJCE_NPC.Sentry_ControllerStatus = 1
				self.VJCE_NPC.HasPoseParameterLooking = true
				self.VJCE_NPC:PlaySoundSystem("Alert")
				self.VJCE_NPC:Sentry_Activate()
			elseif self.VJCE_NPC.Sentry_SpunUp then -- Do NOT become idle if we are playing an activate routine!
				self.VJCE_NPC.Sentry_ControllerStatus = 0
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
	local parameter = self:GetPoseParameter("aim_yaw")
	if parameter != self.Sentry_CurrentParameter then
		self.sentry_turningsd = CreateSound(self, "vj_hlr/hl1_npc/turret/motor_loop.wav") 
		self.sentry_turningsd:SetSoundLevel(70)
		self.sentry_turningsd:PlayEx(1,100)
		if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
			self.sentry_turningsd2 = CreateSound(self, "vj_hlr/hl1_npc/turret/tu_active2.wav") 
			self.sentry_turningsd2:SetSoundLevel(70)
			self.sentry_turningsd2:PlayEx(1,100)
		end
	else
		VJ_STOPSOUND(self.sentry_turningsd)
		if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
			VJ_STOPSOUND(self.sentry_turningsd2)
		end
	end
	self.Sentry_CurrentParameter = parameter
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
	if (self.Sentry_ControllerStatus == 1) or (!self.VJ_IsBeingControlled && (eneValid or self.Alerted == true)) then
		self.Sentry_StandDown = false
		self.AnimTbl_IdleStand = {"spin"}
		
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
			VJ_EmitSound(self, "vj_hlr/hl1_npc/turret/tu_ping.wav", 75, 100)
		end
		
		if !eneValid then -- Look around randomly when the enemy is not found
			self:SetPoseParameter("aim_yaw", self:GetPoseParameter("aim_yaw") + 4)
		end
	else
		if ((self.Sentry_ControllerStatus == 0) or (!self.VJ_IsBeingControlled && self.Alerted == false)) && self.Sentry_StandDown == false then
			self.Sentry_StandDown = true
			self:VJ_ACT_PLAYACTIVITY("retire", true, 1)
			VJ_EmitSound(self, {"vj_hlr/hl1_npc/turret/tu_retract.wav"}, 65, self:VJ_DecideSoundPitch(100, 110))
			if self.Sentry_Type == 1 then
				self.Sentry_SpunUp = false
				VJ_EmitSound(self, "vj_hlr/hl1_npc/turret/tu_spindown.wav", 80, 100)
			end
		end
		if self.Sentry_StandDown == true then
			self.AnimTbl_IdleStand = {"idle_off"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOn_PoseParameterLookingCode(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10) then
		self.Sentry_HasLOS = false
	else
		self.Sentry_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	return self.Sentry_HasLOS == true && self.Sentry_SpunUp == true && !self.Sentry_StandDown
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(2) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.VJ_IsBeingControlled == true then return end
	self:Sentry_Activate()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Sentry_Activate()
	if self.Sentry_Type == 1 then -- If it's big turret, then make sure it's not looking until it has fully deployed
		self.HasPoseParameterLooking = false
	end
	self.Sentry_NextAlarmT = CurTime() + 3 -- Make sure the Alarm light doesn't play right away
	//self.NextResetEnemyT = CurTime() + 1 -- Make sure it doesn't reset the enemy right away
	self:VJ_ACT_PLAYACTIVITY("deploy", true, false)
	if self.Sentry_Type == 1 then -- If it's a big turret then do a spin up action
		timer.Simple(1, function()
			if IsValid(self) && IsValid(self:GetEnemy()) then
				self.HasPoseParameterLooking = true
				VJ_EmitSound(self, "vj_hlr/hl1_npc/turret/tu_spinup.wav", 80, 100)
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
	VJ_EmitSound(self, {"vj_hlr/hl1_npc/turret/tu_alert.wav"}, 75, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local gunPos = self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos
	local bullet = {}
	bullet.Num = 1
	bullet.Src = gunPos
	bullet.Dir = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - gunPos
	bullet.Spread = Vector(math.random(-15,15), math.random(-15,15), math.random(-15,15))
	bullet.Tracer = 1
	bullet.TracerName = "VJ_HLR_Tracer"
	bullet.Force = 5
	bullet.Damage = (self.Sentry_Type == 1 and 7) or 3
	bullet.AmmoType = "SMG1"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self, {"vj_hlr/hl1_npc/turret/tu_fire1.wav"}, 90, self:VJ_DecideSoundPitch(100, 110))
	
	local muz = ents.Create("env_sprite_oriented")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash3.vmt")
	if self.Sentry_Type == 1 then
		muz:SetKeyValue("scale",""..math.Rand(0.8, 1))
	else
		muz:SetKeyValue("scale",""..math.Rand(0.3, 0.5))
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
	muz:Fire("Kill","",0.08)
	
	local muzzleLight = ents.Create("light_dynamic")
	muzzleLight:SetKeyValue("brightness", "4")
	muzzleLight:SetKeyValue("distance", "120")
	muzzleLight:SetPos(gunPos)
	muzzleLight:SetLocalAngles(self:GetAngles())
	muzzleLight:Fire("Color", "255 150 60")
	muzzleLight:SetParent(self)
	muzzleLight:Spawn()
	muzzleLight:Activate()
	muzzleLight:Fire("TurnOn","",0)
	muzzleLight:Fire("Kill","",0.07)
	self:DeleteOnRemove(muzzleLight)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo, hitgroup)
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
		spr:SetPos(self:GetPos() + self:GetUp()*(self.Sentry_SubType == 1 and -30 or 20))
	else
		spr:SetPos(self:GetPos() + self:GetUp()*60)
	end
	spr:Spawn()
	spr:Fire("Kill","",0.9)
	timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibsCollideSd = {"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	local upPos = self.Sentry_SubType == 1 and -30 or 20
	if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p1.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(1,0,upPos)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p2.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,1,upPos)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p3.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(2,0,upPos)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p4.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,2,upPos)),CollideSound=gibsCollideSd})
		if self.Sentry_Type == 1 then
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(3,0,upPos)),CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,3,upPos)),CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(4,0,upPos)),CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,4,upPos)),CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p9.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(5,0,upPos)),CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p10.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,5,upPos)),CollideSound=gibsCollideSd})
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p11.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(6,0,upPos)),CollideSound=gibsCollideSd})
		end
	else
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p1_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(1,0,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p2_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,1,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p3_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(2,0,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p4_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,2,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(3,0,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,3,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(4,0,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,4,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p9_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(5,0,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p10_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,5,20)),CollideSound=gibsCollideSd})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p11_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(6,0,20)),CollideSound=gibsCollideSd})
	end
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog1.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(1,0,upPos)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog2.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,1,upPos)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_rib.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(2,0,upPos)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,2,upPos)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(3,0,upPos)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,3,upPos)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_spring.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(4,0,upPos)),CollideSound=""}) -- Shad ge sharji, ere vor tsayn chi hane
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 150, 100)
	VJ_EmitSound(self, "vj_hlr/hl1_npc/rgrunt/rb_gib.wav", 80, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/metalgib_p1_g.mdl", "models/vj_hlr/gibs/metalgib_p2_g.mdl", "models/vj_hlr/gibs/metalgib_p3_g.mdl", "models/vj_hlr/gibs/metalgib_p4_g.mdl", "models/vj_hlr/gibs/metalgib_p5_g.mdl", "models/vj_hlr/gibs/metalgib_p6_g.mdl", "models/vj_hlr/gibs/metalgib_p7_g.mdl", "models/vj_hlr/gibs/metalgib_p8_g.mdl", "models/vj_hlr/gibs/metalgib_p9_g.mdl", "models/vj_hlr/gibs/metalgib_p10_g.mdl", "models/vj_hlr/gibs/metalgib_p11_g.mdl", "models/vj_hlr/gibs/rgib_cog1.mdl", "models/vj_hlr/gibs/rgib_cog2.mdl", "models/vj_hlr/gibs/rgib_rib.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl"}
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, self.Sentry_Type == 2 and 1 or 2)
	if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
		corpseEnt:DrawShadow(false)
		corpseEnt:ResetSequence("die")
	end
	if self.Sentry_Type == 0 then
		VJ_HLR_ApplyCorpseEffects(self, corpseEnt, gibs, {CollideSound = gibsCollideSd, ExpSound = {"vj_hlr/hl1_npc/rgrunt/rb_gib.wav"}})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.sentry_turningsd)
	if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
		VJ_STOPSOUND(self.sentry_turningsd2)
	end
end
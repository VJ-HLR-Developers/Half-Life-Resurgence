AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local combatDistance = 5000 -- When closer then this, it will stop chasing and start firing

ENT.Model = {"models/vj_hlr/hl1/apache.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_IsHugeMonster = true
ENT.StartHealth = 400 -- The starting health of the NPC
ENT.HullType = HULL_LARGE
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 2 -- How fast it can turn
	-- ====== Movement Variables ====== --
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Alerted = 400 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Calm = ENT.Aerial_FlyingSpeed_Alerted -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {nil} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {nil} -- Animations it plays when it's moving while alerted
ENT.AA_GroundLimit = 1200 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 1000 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 8 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
ENT.AA_MoveDecelerate = 4 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x
ENT.VJC_Data = {
    FirstP_Bone = "Bone14", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(-50, 0, -40), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.AnimTbl_IdleStand = {ACT_FLY} -- The idle animation table when AI is enabled | DEFAULT: {ACT_IDLE}
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw poseparameters (Y)
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it"s between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = combatDistance -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Fire = true -- Immune to fire-type damages
ENT.ImmuneDamagesTable = {DMG_PHYSGUN}
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_rocket" -- The entity that is spawned when range attacking
ENT.RangeDistance = combatDistance -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 10 -- How much time until it can use a range attack?
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.RangeAttackExtraTimers = {0} -- Extra range attack timers, EX: {1, 1.4} | it will run the projectile code after the given amount of seconds
ENT.RangeUseAttachmentForPos = true -- Should the projectile spawn on a attachment?
ENT.RangeUseAttachmentForPosID = "missile_left"
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code

ENT.HasDeathRagdoll = false
ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!\
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Death = {"vj_hlr/hl1_weapon/mortar/mortarhit.wav"}
local sdExplosions = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.DeathSoundLevel = 100

/* https://github.com/ValveSoftware/halflife/blob/master/dlls/apache.cpp
	EMIT_SOUND_DYN(ENT(pev), CHAN_STATIC, "apache/ap_rotor2.wav", 1.0, 0.3, 0, 110 );
	firing: tu_fire1.wav, EMIT_SOUND(ENT(pev), CHAN_WEAPON, "turret/tu_fire1.wav", 1, 0.3);
	death: EMIT_SOUND(ENT(pev), CHAN_STATIC, "weapons/mortarhit.wav", 1.0, 0.3);
	
	- Fires 2 rockets (1 on each side) at the same time, Delay: 10 seconds
	- Chain gun: Continuos fire as long as front is visible
*/
-- Custom
ENT.Apache_HasLOS = false -- Does the Apache's chain gun have sight on the enemy?
ENT.Heli_SmokeStatus = 0 -- 0 = No smoke | 1 = Tail smoke | 2 = Tail & Rotor smoke
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 400)
--
function ENT:CustomOnInitialize()
	self:SetNW2Int("Heli_SmokeLevel", 0)
	self.ConstantlyFaceEnemyDistance = self.SightDistance
	
	self:SetCollisionBounds(Vector(150, 150, 180), Vector(-150, -150, 0))
	self:SetPos(self:GetPos() + spawnPos)
	
	self.HeliSD_Rotor = VJ_CreateSound(self, "vj_hlr/hl1_npc/apache/ap_rotor2.wav", 120)
	self.HeliSD_Whine = VJ_CreateSound(self, "vj_hlr/hl1_npc/apache/ap_whine1.wav", 70)
	
	local tailLight = ents.Create("env_sprite")
	tailLight:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	tailLight:SetKeyValue("scale", "0.3")
	tailLight:SetKeyValue("rendermode","5")
	tailLight:SetKeyValue("rendercolor","255 191 0")
	tailLight:SetKeyValue("spawnflags","1") -- If animated
	tailLight:SetParent(self)
	tailLight:Fire("SetParentAttachment", "light_1")
	tailLight:Spawn()
	tailLight:Activate()
	self:DeleteOnRemove(tailLight)
	
	local sideLight1 = ents.Create("env_sprite")
	sideLight1:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	sideLight1:SetKeyValue("scale", "0.5")
	sideLight1:SetKeyValue("rendermode","5")
	sideLight1:SetKeyValue("renderfx","9")
	sideLight1:SetKeyValue("rendercolor","255 0 0")
	sideLight1:SetKeyValue("spawnflags","1") -- If animated
	sideLight1:SetParent(self)
	sideLight1:Fire("SetParentAttachment", "light_2")
	sideLight1:Spawn()
	sideLight1:Activate()
	self:DeleteOnRemove(sideLight1)
	
	local sideLight2 = ents.Create("env_sprite")
	sideLight2:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	sideLight2:SetKeyValue("scale", "0.5")
	sideLight2:SetKeyValue("rendermode","5")
	sideLight2:SetKeyValue("renderfx","9")
	sideLight2:SetKeyValue("rendercolor","255 0 0")
	sideLight2:SetKeyValue("spawnflags","1") -- If animated
	sideLight2:SetParent(self)
	sideLight2:Fire("SetParentAttachment", "light_3")
	sideLight2:Spawn()
	sideLight2:Activate()
	self:DeleteOnRemove(sideLight2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("MOUSE1: Fire chain gun")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOn_PoseParameterLookingCode(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	-- Using 20 for "aim_pitch" to make it a little more forgiving
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= self.PoseParameterLooking_TurningSpeed) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, 20))) >= 20) then
		self.Apache_HasLOS = false
	else
		self.Apache_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	-- Flying tilt (X & Y)
	local velNorm = self:GetVelocity():GetNormal()
	local speed = FrameTime()*4
	self:SetPoseParameter("tilt_x", Lerp(speed, self:GetPoseParameter("tilt_x"), velNorm.x))
	self:SetPoseParameter("tilt_y", Lerp(speed, self:GetPoseParameter("tilt_y"), velNorm.y))
	
	-- If the helicopter healed, then make sure to stop the smoke particles as well!
	if self.Heli_SmokeStatus > 0 && self:Health() > (self:GetMaxHealth() * 0.25) then
		self:SetNW2Int("Heli_SmokeLevel", 0)
		self.Heli_SmokeStatus = 0
		//self:StopParticles()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:GetForward()*400
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
	projectile.Model = "models/vj_hlr/hl1/hvr.mdl"
	projectile.Rocket_HelicopterMissile = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(ent)
	self.RangeUseAttachmentForPosID = self.RangeUseAttachmentForPosID == "missile_left" and "missile_right" or "missile_left"
	VJ_CreateSound(ent, "vj_hlr/hl1_weapon/rpg/rocketfire1.wav", 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local bulletSpread = Vector(0.03490, 0.03490, 0.03490)
--
-- Firing Delay: Checked in Half-Life 1 (GoldSrc), there is NO delay as long as the gun is facing the enemy!
function ENT:CustomAttack()
	local ene = self:GetEnemy()
	if self.Apache_HasLOS && self.NearestPointToEnemyDistance <= combatDistance && self:Visible(ene) && ((!self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_ATTACK))) then
		local att = self:GetAttachment(1)
		self:FireBullets({
			Num = 1,
			Src = att.Pos,
			Dir = (ene:GetPos() + ene:OBBCenter() - att.Pos):Angle():Forward(),
			Spread = bulletSpread,
			Tracer = 1,
			TracerName = "VJ_HLR_Tracer",
			Force = 3,
			Damage = self:VJ_GetDifficultyValue(8),
			AmmoType = "HelicopterGun"
		})
		VJ_EmitSound(self, "vj_hlr/hl1_npc/turret/tu_fire1.wav", 120, 100, 1, CHAN_WEAPON)

		local muz = ents.Create("env_sprite")
		muz:SetKeyValue("model","vj_hl/sprites/muzzleflash2.vmt")
		muz:SetKeyValue("scale",""..math.Rand(0.3, 0.5))
		muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
		muz:SetKeyValue("HDRColorScale","1.0")
		muz:SetKeyValue("renderfx","14")
		muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
		muz:SetKeyValue("renderamt","255") -- Transparency
		muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
		muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
		muz:SetKeyValue("spawnflags","0")
		muz:SetParent(self)
		muz:Fire("SetParentAttachment","muzzle")
		muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
		muz:Spawn()
		muz:Activate()
		muz:Fire("Kill","",0.08)

		local flash = ents.Create("light_dynamic")
		flash:SetKeyValue("brightness", 8)
		flash:SetKeyValue("distance", 300)
		flash:SetLocalPos(att.Pos)
		flash:SetLocalAngles(self:GetAngles())
		flash:Fire("Color","255 60 9 255")
		flash:Spawn()
		flash:Activate()
		flash:Fire("TurnOn", "", 0)
		flash:Fire("Kill", "", 0.07)
		self:DeleteOnRemove(flash)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	-- If hit in the engine area, then get damage by bullets!
	if dmginfo:IsBulletDamage() && hitgroup == 2 then
		dmginfo:ScaleDamage(0.05)
		self.Immune_Bullet = false -- To counter the dmginfo:IsBulletDamage() function
	else
		self.Immune_Bullet = true
	end
	
	if dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self.Heli_SmokeStatus == 2 then return end
	local maxHP = self:GetMaxHealth()
	local hp = self:Health()
	if hp <= (maxHP * 0.25) then
		-- Only set the tail smoke if we haven't set it already
		if self.Heli_SmokeStatus == 0 then
			self:SetNW2Int("Heli_SmokeLevel", 1)
			self.Heli_SmokeStatus = 1
			//ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("rotor_tail"))
		end
		-- If even lower, then make the rotor smoke too
		if hp <= (maxHP * 0.15) then
			self:SetNW2Int("Heli_SmokeLevel", 2)
			self.Heli_SmokeStatus = 2
			//ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("rotor"))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorHeliExp = Color(255, 255, 192, 128)
local sdGibCollide = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
local heliExpGibs_Green = { -- For HECU
	"models/vj_hlr/gibs/metalgib_p1_g.mdl",
	"models/vj_hlr/gibs/metalgib_p2_g.mdl",
	"models/vj_hlr/gibs/metalgib_p3_g.mdl",
	"models/vj_hlr/gibs/metalgib_p4_g.mdl",
	"models/vj_hlr/gibs/metalgib_p5_g.mdl",
	"models/vj_hlr/gibs/metalgib_p6_g.mdl",
	"models/vj_hlr/gibs/metalgib_p7_g.mdl",
	"models/vj_hlr/gibs/metalgib_p8_g.mdl",
	"models/vj_hlr/gibs/metalgib_p9_g.mdl",
	"models/vj_hlr/gibs/metalgib_p10_g.mdl",
	"models/vj_hlr/gibs/metalgib_p11_g.mdl",
	"models/vj_hlr/gibs/rgib_screw.mdl",
	"models/vj_hlr/gibs/rgib_screw.mdl"
}
local heliExpGibs_Gray = { -- For Black Ops
	"models/vj_hlr/gibs/metalgib_p1.mdl",
	"models/vj_hlr/gibs/metalgib_p2.mdl",
	"models/vj_hlr/gibs/metalgib_p3.mdl",
	"models/vj_hlr/gibs/metalgib_p4.mdl",
	"models/vj_hlr/gibs/metalgib_p5.mdl",
	"models/vj_hlr/gibs/metalgib_p6.mdl",
	"models/vj_hlr/gibs/metalgib_p7.mdl",
	"models/vj_hlr/gibs/metalgib_p8.mdl",
	"models/vj_hlr/gibs/metalgib_p9.mdl",
	"models/vj_hlr/gibs/metalgib_p10.mdl",
	"models/vj_hlr/gibs/metalgib_p11.mdl",
	"models/vj_hlr/gibs/rgib_screw.mdl",
	"models/vj_hlr/gibs/rgib_screw.mdl"
}
--
function ENT:CustomOnInitialKilled(dmginfo, hitgroup)
	-- Spawn a animated model of the helicopter that explodes constantly and gets destroyed when it collides with something
	-- Based on source code
	local deathCorpse = ents.Create("prop_vj_animatable")
	deathCorpse:SetModel(self:GetModel())
	deathCorpse:SetPos(self:GetPos())
	deathCorpse:SetAngles(self:GetAngles())
	function deathCorpse:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetSolid(SOLID_CUSTOM)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableGravity(true)
			phys:SetBuoyancyRatio(0)
			phys:SetVelocity(self:GetVelocity())
			phys:AddAngleVelocity(Vector(math.Rand(-20, 20), math.Rand(-20, 20), 200))
		end
	end
	deathCorpse.NextExpT = 0
	deathCorpse:Spawn()
	deathCorpse:Activate()
	
	-- Explode as it goes down
	function deathCorpse:Think()
		self:ResetSequence("idle_move")
		if CurTime() > self.NextExpT then
			self.NextExpT = CurTime() + 0.2
			local expPos = self:GetPos() + Vector(math.Rand(-150, 150), math.Rand(-150, 150), math.Rand(-150, -50))
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
			spr:SetKeyValue("scale","5")
			spr:SetPos(expPos)
			spr:Spawn()
			spr:Fire("Kill", "", 0.9)
			timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
			
			util.BlastDamage(self, self, expPos, 300, 100)
			VJ_EmitSound(self, sdExplosions, 100, 100)
		end
	
		self:NextThink(CurTime())
		return true
	end
	
	-- Get destroyed when it collides with something
	function deathCorpse:PhysicsCollide(data, phys)
		if self.Dead then return end
		self.Dead = true
		
		-- Create gibs
		local gibTbl = self:GetModel() == "models/vj_hlr/hl1/apache_blkops.mdl" and heliExpGibs_Gray or heliExpGibs_Green
		for _ = 1, 50 do
			local gib = ents.Create("obj_vj_gib")
			gib:SetModel(VJ_PICK(gibTbl))
			gib:SetPos(self:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), math.random(20, 150)))
			gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
			gib.Collide_Decal = ""
			gib.CollideSound = sdGibCollide
			gib:Spawn()
			gib:Activate()
			local myPhys = gib:GetPhysicsObject()
			if IsValid(myPhys) then
				myPhys:AddVelocity(Vector(math.Rand(-300, 300), math.Rand(-300, 300), math.Rand(150, 250)))
				myPhys:AddAngleVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
			end
			if GetConVar("vj_npc_fadegibs"):GetInt() == 1 then
				timer.Simple(GetConVar("vj_npc_fadegibstime"):GetInt(), function() SafeRemoveEntity(gib) end)
			end
		end
		
		local expPos = self:GetPos() + Vector(0,0,math.Rand(150, 150))
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
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
		spr:SetKeyValue("scale","15")
		spr:SetPos(expPos)
		spr:Spawn()
		spr:Fire("Kill", "", 1.19)
		timer.Simple(1.19, function() if IsValid(spr) then spr:Remove() end end)
		util.BlastDamage(self, self, expPos, 600, 200)
		VJ_EmitSound(self, "vj_hlr/hl1_weapon/mortar/mortarhit.wav", 100, 100)
		
		-- flags 0 = No fade!
		effects.BeamRingPoint(self:GetPos(), 0.4, 0, 1500, 32, 0, colorHeliExp, {material="vj_hl/sprites/shockwave", framerate=0, flags=0})
		
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	local expPos = self:GetAttachment(self:LookupAttachment("rotor")).Pos
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
	spr:SetKeyValue("scale","5")
	spr:SetPos(expPos)
	spr:Spawn()
	spr:Fire("Kill", "", 0.9)
	timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
	
	util.BlastDamage(self, self, expPos, 300, 100)
	VJ_EmitSound(self, sdExplosions, 100, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.HeliSD_Rotor)
	VJ_STOPSOUND(self.HeliSD_Whine)
end
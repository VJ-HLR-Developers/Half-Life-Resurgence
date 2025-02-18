AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local combatDistance = 5000 -- When closer then this, it will stop chasing and start firing

ENT.Model = "models/vj_hlr/hl1/apache.mdl"
ENT.VJ_ID_Boss = true
ENT.StartHealth = 400
ENT.HullType = HULL_LARGE
ENT.SightAngle = 360
ENT.TurningSpeed = 2
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Alerted = 400
ENT.Aerial_FlyingSpeed_Calm = ENT.Aerial_FlyingSpeed_Alerted
ENT.AA_GroundLimit = 1200
ENT.AA_MinWanderDist = 1000
ENT.AA_MoveAccelerate = 8
ENT.AA_MoveDecelerate = 4
ENT.ControllerParams = {
    FirstP_Bone = "Bone14",
    FirstP_Offset = Vector(-50, 0, -40),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.PoseParameterLooking_InvertYaw = true
ENT.ConstantlyFaceEnemy = true
ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = combatDistance
ENT.LimitChaseDistance_Min = 0
ENT.Bleeds = false
ENT.Immune_Toxic = true
ENT.Immune_Bullet = true
ENT.Immune_Fire = true
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_rocket"
ENT.RangeAttackMaxDistance = combatDistance
ENT.RangeAttackMinDistance = 1
ENT.RangeAttackAngleRadius = 100
ENT.TimeUntilRangeAttackProjectileRelease = 0
ENT.NextRangeAttackTime = 10
ENT.RangeAttackReps = 1
ENT.RangeAttackExtraTimers = {0}
ENT.AnimTbl_RangeAttack = false

ENT.DeathAllyResponse = "OnlyAlert"
ENT.HasDeathCorpse = false
ENT.VJ_ID_Healable = false

ENT.SoundTbl_Death = "vj_hlr/hl1_weapon/mortar/mortarhit.wav"
local sdExplosions = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}

ENT.MainSoundPitch = 100
ENT.DeathSoundLevel = 100

/* https://github.com/ValveSoftware/halflife/blob/master/dlls/apache.cpp
	Rotor sound: EMIT_SOUND_DYN(ENT(pev), CHAN_STATIC, "apache/ap_rotor2.wav", 1.0, 0.3, 0, 110 );
	Firing sound: tu_fire1.wav, EMIT_SOUND(ENT(pev), CHAN_WEAPON, "turret/tu_fire1.wav", 1, 0.3);
	Death sound: EMIT_SOUND(ENT(pev), CHAN_STATIC, "weapons/mortarhit.wav", 1.0, 0.3);
	
	- Fires 2 rockets (1 on each side) at the same time, Delay: 10 seconds
	- Chain gun: Continuous fire as long as front is visible
*/
-- Custom
ENT.Heli_HasLOS = false -- Does the Apache's chain gun have sight on the enemy?
ENT.Heli_SmokeStatus = 0 -- 0 = No smoke | 1 = Tail smoke | 2 = Tail & Rotor smoke
ENT.Heli_RangeAttach = "missile_left"
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 400)
--
function ENT:Init()
	self:SetNW2Int("Heli_SmokeLevel", 0)
	self.ConstantlyFaceEnemy_MinDistance = self:GetMaxLookDistance()
	
	self:SetCollisionBounds(Vector(150, 150, 180), Vector(-150, -150, 0))
	self:SetPos(self:GetPos() + spawnPos)
	
	self.HeliSD_Rotor = VJ.CreateSound(self, "vj_hlr/hl1_npc/apache/ap_rotor2.wav", 120)
	self.HeliSD_Whine = VJ.CreateSound(self, "vj_hlr/hl1_npc/apache/ap_whine1.wav", 70)
	self.HeliSD_Distant = VJ.CreateSound(self, "vj_hlr/hl1_npc/apache/ap_rotor1.wav", 160)
	
	local tailLight = ents.Create("env_sprite")
	tailLight:SetKeyValue("model", "vj_base/sprites/glow.vmt")
	tailLight:SetKeyValue("scale", "0.3")
	tailLight:SetKeyValue("rendermode", "5")
	tailLight:SetKeyValue("rendercolor", "255 191 0")
	tailLight:SetKeyValue("spawnflags", "1") -- If animated
	tailLight:SetParent(self)
	tailLight:Fire("SetParentAttachment", "light_1")
	tailLight:Spawn()
	tailLight:Activate()
	self:DeleteOnRemove(tailLight)
	
	local sideLight1 = ents.Create("env_sprite")
	sideLight1:SetKeyValue("model", "vj_base/sprites/glow.vmt")
	sideLight1:SetKeyValue("scale", "0.5")
	sideLight1:SetKeyValue("rendermode", "5")
	sideLight1:SetKeyValue("renderfx", "9")
	sideLight1:SetKeyValue("rendercolor", "255 0 0")
	sideLight1:SetKeyValue("spawnflags", "1") -- If animated
	sideLight1:SetParent(self)
	sideLight1:Fire("SetParentAttachment", "light_2")
	sideLight1:Spawn()
	sideLight1:Activate()
	self:DeleteOnRemove(sideLight1)
	
	local sideLight2 = ents.Create("env_sprite")
	sideLight2:SetKeyValue("model", "vj_base/sprites/glow.vmt")
	sideLight2:SetKeyValue("scale", "0.5")
	sideLight2:SetKeyValue("rendermode", "5")
	sideLight2:SetKeyValue("renderfx", "9")
	sideLight2:SetKeyValue("rendercolor", "255 0 0")
	sideLight2:SetKeyValue("spawnflags", "1") -- If animated
	sideLight2:SetParent(self)
	sideLight2:Fire("SetParentAttachment", "light_3")
	sideLight2:Spawn()
	sideLight2:Activate()
	self:DeleteOnRemove(sideLight2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	return ACT_FLY -- We don't want it do anything else! Ex: "ACT_IDLE" has slower rotating rotors, we don't want that!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("MOUSE1: Fire chain gun")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	-- Using 20 for "aim_pitch" to make it a little more forgiving
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= self.PoseParameterLooking_TurningSpeed) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, 20))) >= 20) then
		self.Heli_HasLOS = false
	else
		self.Heli_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
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
function ENT:RangeAttackProjPos(projectile)
	self.Heli_RangeAttach = self.Heli_RangeAttach == "missile_left" and "missile_right" or "missile_left"
	return self:GetAttachment(self:LookupAttachment(self.Heli_RangeAttach)).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return self:GetForward()*400
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
	projectile.Model = "models/vj_hlr/hl1/hvr.mdl"
	projectile.Rocket_HelicopterMissile = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(ent)
	VJ.CreateSound(ent, "vj_hlr/hl1_weapon/rpg/rocketfire1.wav", 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local bulletSpread = Vector(0.03490, 0.03490, 0.03490)
--
-- Firing Delay: Checked in Half-Life 1 (GoldSrc), there is NO delay as long as the gun is facing the enemy!
function ENT:CustomAttack()
	local ene = self:GetEnemy()
	if self.Heli_HasLOS && self.NearestPointToEnemyDistance <= combatDistance && self:Visible(ene) && ((!self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_ATTACK))) then
		local att = self:GetAttachment(1)
		self:FireBullets({
			Num = 1,
			Src = att.Pos,
			Dir = (ene:GetPos() + ene:OBBCenter() - att.Pos):Angle():Forward(),
			Spread = bulletSpread,
			Tracer = 1,
			TracerName = "VJ_HLR_Tracer",
			Force = 3,
			Damage = self:ScaleByDifficulty(8),
			AmmoType = "HelicopterGun"
		})
		VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_fire1.wav", 120, 100, 1, CHAN_WEAPON)
		VJ.EmitSound(self, "vj_hlr/hl1_npc/turret/tu_fire1_distant.wav", 140, 100, 1, bit.band(CHAN_AUTO, CHAN_WEAPON))

		local muz = ents.Create("env_sprite")
		muz:SetKeyValue("model", "vj_hl/sprites/muzzleflash2.vmt")
		muz:SetKeyValue("scale", ""..math.Rand(0.3, 0.5))
		muz:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
		muz:SetKeyValue("HDRColorScale", "1.0")
		muz:SetKeyValue("renderfx", "14")
		muz:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
		muz:SetKeyValue("renderamt", "255") -- Transparency
		muz:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
		muz:SetKeyValue("framerate", "10.0") -- Rate at which the sprite should animate, if at all.
		muz:SetKeyValue("spawnflags", "0")
		muz:SetParent(self)
		muz:Fire("SetParentAttachment", "muzzle")
		muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
		muz:Spawn()
		muz:Activate()
		muz:Fire("Kill", "",0.08)

		local flash = ents.Create("light_dynamic")
		flash:SetKeyValue("brightness", 8)
		flash:SetKeyValue("distance", 300)
		flash:SetLocalPos(att.Pos)
		flash:SetLocalAngles(self:GetAngles())
		flash:Fire("Color", "255 60 9 255")
		flash:Spawn()
		flash:Activate()
		flash:Fire("TurnOn", "", 0)
		flash:Fire("Kill", "", 0.07)
		self:DeleteOnRemove(flash)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoImpactEffect(tr, damageType)
	return VJ.HLR1_Effect_Impact(tr)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Initial" then
		-- If hit in the engine area, then get damage by bullets!
		if dmginfo:IsBulletDamage() && hitgroup == 2 then
			dmginfo:ScaleDamage(0.05)
			self.Immune_Bullet = false -- To counter the "dmginfo:IsBulletDamage()" function
		else
			self.Immune_Bullet = true
		end
		
		-- If hit by physgun, then don't take damage
		if dmginfo:IsDamageType(DMG_PHYSGUN) then
			dmginfo:SetDamage(0)
		end
		
		if dmginfo:GetDamagePosition() != vec then
			local rico = EffectData()
			rico:SetOrigin(dmginfo:GetDamagePosition())
			rico:SetScale(4) -- Size
			rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
			util.Effect("VJ_HLR_Rico", rico)
		end
	elseif status == "PostDamage" then
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
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		local expPos = self:GetAttachment(self:LookupAttachment("rotor")).Pos
		local expSpr = ents.Create("env_sprite")
		expSpr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
		expSpr:SetKeyValue("GlowProxySize", "2.0")
		expSpr:SetKeyValue("HDRColorScale", "1.0")
		expSpr:SetKeyValue("renderfx", "14")
		expSpr:SetKeyValue("rendermode", "5")
		expSpr:SetKeyValue("renderamt", "255")
		expSpr:SetKeyValue("disablereceiveshadows", "0")
		expSpr:SetKeyValue("mindxlevel", "0")
		expSpr:SetKeyValue("maxdxlevel", "0")
		expSpr:SetKeyValue("framerate", "15.0")
		expSpr:SetKeyValue("spawnflags", "0")
		expSpr:SetKeyValue("scale", "5")
		expSpr:SetPos(expPos)
		expSpr:Spawn()
		expSpr:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function() if IsValid(expSpr) then expSpr:Remove() end end)
		
		util.BlastDamage(self, self, expPos, 300, 100)
		VJ.EmitSound(self, sdExplosions, 100, 100)
		VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3,5).."_dist.wav", 100, 100, 100, 1)
		
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
				local expPos2 = self:GetPos() + Vector(math.Rand(-150, 150), math.Rand(-150, 150), math.Rand(-150, -50))
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
				spr:SetKeyValue("scale", "5")
				spr:SetPos(expPos2)
				spr:Spawn()
				spr:Fire("Kill", "", 0.9)
				timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
				
				util.BlastDamage(self, self, expPos2, 300, 100)
				VJ.EmitSound(self, sdExplosions, 100, 100)
				VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3,5).."_dist.wav", 140, 100)
			end
		
			self:NextThink(CurTime())
			return true
		end
		
		-- Get destroyed when it collides with something
		function deathCorpse:PhysicsCollide(data, phys)
			if self.Dead then return end
			local myPos = self:GetPos()
			self.Dead = true
			
			-- Create gibs
			local gibTbl = self:GetModel() == "models/vj_hlr/hl1/apache_blkops.mdl" and heliExpGibs_Gray or heliExpGibs_Green
			for _ = 1, 50 do
				local gib = ents.Create("obj_vj_gib")
				gib:SetModel(VJ.PICK(gibTbl))
				gib:SetPos(myPos + Vector(math.random(-100, 100), math.random(-100, 100), math.random(20, 150)))
				gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
				gib.CollisionDecal = false
				gib.CollisionSound = sdGibCollide
				gib:Spawn()
				gib:Activate()
				local myPhys = gib:GetPhysicsObject()
				if IsValid(myPhys) then
					myPhys:AddVelocity(Vector(math.Rand(-300, 300), math.Rand(-300, 300), math.Rand(150, 250)))
					myPhys:AddAngleVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
				end
				if GetConVar("vj_npc_gib_fade"):GetInt() == 1 then
					timer.Simple(GetConVar("vj_npc_gib_fadetime"):GetInt(), function() SafeRemoveEntity(gib) end)
				end
			end
			
			local expPos2 = myPos + Vector(0, 0, math.Rand(150, 150))
			local spr = ents.Create("env_sprite")
			spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
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
			spr:SetKeyValue("scale", "15")
			spr:SetPos(expPos2)
			spr:Spawn()
			spr:Fire("Kill", "", 1.19)
			timer.Simple(1.19, function() if IsValid(spr) then spr:Remove() end end)
			util.BlastDamage(self, self, expPos2, 600, 200)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/mortar/mortarhit.wav", 100, 100)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/mortar/mortarhit_dist.wav", 140, 100)
			-- flags 0 = No fade!
			effects.BeamRingPoint(myPos, 0.4, 0, 1500, 32, 0, colorHeliExp, {material="vj_hl/sprites/shockwave", framerate=0, flags=0})
			self:Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.HeliSD_Rotor)
	VJ.STOPSOUND(self.HeliSD_Whine)
	VJ.STOPSOUND(self.HeliSD_Distant)
end
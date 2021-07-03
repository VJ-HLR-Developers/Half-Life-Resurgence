AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local combatDistance = 4000 -- When closer then this, it will stop chasing and start firing

ENT.Model = {"models/vj_hlr/hl1/osprey.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_IsHugeMonster = true
ENT.StartHealth = 800
ENT.HullType = HULL_LARGE
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 2 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
	-- ====== Movement Variables ====== --
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Alerted = 300 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Calm = ENT.Aerial_FlyingSpeed_Alerted -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {nil} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {nil} -- Animations it plays when it's moving while alerted
ENT.AA_GroundLimit = 1200 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 1000 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 8 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
ENT.AA_MoveDecelerate = 4 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x
ENT.VJC_Data = {
    FirstP_Bone = "Bone01", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(140, 0, -45), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.CombatFaceEnemy = false -- If enemy is exists and is visible
ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it"s between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = combatDistance -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Fire = true -- Immune to fire-type damages
ENT.ImmuneDamagesTable = {DMG_BULLET, DMG_BUCKSHOT, DMG_PHYSGUN}
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasDeathRagdoll = false
ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Death = {"vj_hlr/hl1_weapon/mortar/mortarhit.wav"}
local sdExplosions = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.DeathSoundLevel = 100

/* https://github.com/ValveSoftware/halflife/blob/master/dlls/osprey.cpp
	EMIT_SOUND_DYN(ENT(pev), CHAN_STATIC, "apache/ap_rotor4.wav", 1.0, 0.15, 0, 110 );
	death: EMIT_SOUND(ENT(pev), CHAN_STATIC, "weapons/mortarhit.wav", 1.0, 0.3);
*/
-- Custom
ENT.Osprey_DropPos = nil
ENT.Osprey_DropStatus = 0 -- -1 = Can NOT deploy | 0 = Not dropped off | 1 = Moving to drop zone | 2 = Dropping soldiers | 3 = Soldiers rappelling down | 4 = Soldiers fully on ground
ENT.Osprey_DropSoldierStatus = 0 -- if this number reaches the max amount, then it means that all soldiers are on ground, Osprey can go back to normal!
ENT.Osprey_DropSoldierStatusDead = 0 -- Similar to the one above, but this one keeps track of how many of the 4 soldiers have died!
ENT.Osprey_NextDropT = 0
ENT.Heli_SmokeStatus = 0 -- 0 = No smoke | 1 = Left tail smoke | 2 = Left & Right tail smoke
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 400)
--
function ENT:CustomOnInitialize()
	self:SetNW2Int("Heli_SmokeLevel", 0)
	//self.ConstantlyFaceEnemyDistance = self.SightDistance -- Osprey does NOT face the enemy!
	
	self:SetCollisionBounds(Vector(300, 300, 250), Vector(-300, -300, 0))
	self:SetPos(self:GetPos() + spawnPos)
	
	self.HeliSD_Rotor = VJ_CreateSound(self, "vj_hlr/hl1_npc/apache/ap_rotor4.wav", 120)
	self.HeliSD_Whine = VJ_CreateSound(self, "vj_hlr/hl1_npc/apache/ap_whine1.wav", 70)
	
	if GetConVar("vj_hlr1_osprey_deploygrunts"):GetInt() == 0 then self.Osprey_DropStatus = -1 end
	self.Osprey_DroppedSoldiers = {}
	
	-- Create & Spawn the 2 gunners
	for i = 1, 2 do
		local att = self:GetAttachment(i)
		local gunner = ents.Create("npc_vj_hlr1_hgrunt_serg")
		gunner:SetPos(att.Pos)
		gunner:SetAngles(att.Ang)
		gunner:SetOwner(self)
		gunner:SetParent(self)
		gunner.MovementType = VJ_MOVETYPE_STATIONARY
		gunner.DisableWeapons = true
		gunner.CanTurnWhileStationary = false
		gunner.NoWeapon_UseScaredBehavior = false
		gunner.Medic_CanBeHealed = false
		gunner:Spawn()
		gunner.Weapon_FiringDistanceFar = self.SightDistance
		gunner:Fire("SetParentAttachment",i == 1 && "gunner_left" or "gunner_right",0)
		gunner:SetState(VJ_STATE_ONLY_ANIMATION)
		self:DeleteOnRemove(gunner)
	end
	
	-- 1 red tail light (Flashing) + 1 green & 1 red solid lights
	local tailLight = ents.Create("env_sprite")
	tailLight:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	tailLight:SetKeyValue("scale", "1")
	tailLight:SetKeyValue("rendermode","5")
	tailLight:SetKeyValue("renderfx","9")
	tailLight:SetKeyValue("rendercolor","255 0 0")
	tailLight:SetKeyValue("spawnflags","1") -- If animated
	tailLight:SetParent(self)
	tailLight:Fire("SetParentAttachment", "flash_red")
	tailLight:Spawn()
	tailLight:Activate()
	self:DeleteOnRemove(tailLight)
	
	local sideLight1 = ents.Create("env_sprite")
	sideLight1:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	sideLight1:SetKeyValue("scale", "0.5")
	sideLight1:SetKeyValue("rendermode","5")
	sideLight1:SetKeyValue("rendercolor","255 0 0")
	sideLight1:SetKeyValue("spawnflags","1") -- If animated
	sideLight1:SetParent(self)
	sideLight1:Fire("SetParentAttachment", "light_red")
	sideLight1:Spawn()
	sideLight1:Activate()
	self:DeleteOnRemove(sideLight1)
	
	local sideLight2 = ents.Create("env_sprite")
	sideLight2:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	sideLight2:SetKeyValue("scale", "0.5")
	sideLight2:SetKeyValue("rendermode","5")
	sideLight2:SetKeyValue("rendercolor","0 255 0")
	sideLight2:SetKeyValue("spawnflags","1") -- If animated
	sideLight2:SetParent(self)
	sideLight2:Fire("SetParentAttachment", "light_green")
	sideLight2:Spawn()
	sideLight2:Activate()
	self:DeleteOnRemove(sideLight2)
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
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local ropePos1 = Vector(0, 0, 112)
local ropePos2 = Vector(0, 0, -4096)
--
function ENT:CustomOnThink_AIEnabled()
	if self.Osprey_DropStatus == -1 then return end
	-- All have landed and died
	if self.Osprey_DropStatus == 4 then
		if self.Osprey_DropSoldierStatusDead == 4 && CurTime() > self.Osprey_NextDropT then
			self.Osprey_DropStatus = 0
			self.Osprey_DropSoldierStatusDead = 0
		else
			return
		end
	end
	local ene = self:GetEnemy()
	if self.Osprey_DropStatus == 0 && IsValid(ene) then
		self.Osprey_DropStatus = 1
		local vecRand = VectorRand() *600
		local vecZ = vecRand.z
		vecRand.z = vecZ < 0 && vecZ *-1 or vecZ
		self.Osprey_DropPos = ene:GetPos() + ene:GetUp()*600 + vecRand
		self:SetState(VJ_STATE_ONLY_ANIMATION)
		self.NoChaseAfterCertainRange = false
	elseif self.Osprey_DropStatus == 1 then
		self:AA_MoveTo(self.Osprey_DropPos, true, "Alert", {FaceDest=true, FaceDestTarget=false, IgnoreGround=true})
		if self:GetPos():Distance(self.Osprey_DropPos) < 180 then
			self.Osprey_DropStatus = 2
		end
	elseif self.Osprey_DropStatus == 2 then
		self:AA_StopMoving()
		self.Osprey_DropStatus = 3
		self.Osprey_DropSoldierStatus = 0 -- Start at 0
		self.Osprey_NextDropT = CurTime() + 30
		for i = 1, 4 do
			local att = self:GetAttachment((i % 2 == 0) && 2 or 1)
			local startPos = att.Pos + att.Ang:Forward()*100 + self:GetForward()*((i >= 3) && -30 or 60)
			local grunt = ents.Create("npc_vj_hlr1_hgrunt")
			grunt:SetPos(startPos)
			grunt:SetAngles(att.Ang)
			grunt:SetOwner(self)
			grunt.HECU_DeployedByOsprey = true
			grunt.HECU_Rappelling = true
			grunt:Spawn()
			grunt:SetLocalVelocity(Vector(0, 0, math.Rand(-196, -128)))
			grunt:SetEnemy(ene)
			
			-- Create the rope
			local ropeStart = grunt:GetPos() + ropePos1
			local tr = util.TraceLine({
				start = ropeStart,
				endpos = grunt:GetPos() + ropePos2,
				filter = {self, grunt},
			})
			local rope = EffectData()
			rope:SetStart(ropeStart)
			rope:SetOrigin(tr.HitPos)
			rope:SetEntity(grunt)
			util.Effect("VJ_HLR_Rope", rope)
			
			self.Osprey_DroppedSoldiers[i] = grunt
		end
	elseif self.Osprey_DropStatus == 3 && self.Osprey_DropSoldierStatus >= 4 then
		-- Reset Osprey to normal
		self.Osprey_DropStatus = 4
		self:SetState()
		self.NoChaseAfterCertainRange = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self.Heli_SmokeStatus == 2 then return end
	local maxHP = self:GetMaxHealth()
	local hp = self:Health()
	if hp <= (maxHP * 0.25) then
		-- Only set left tail smoke if we haven't set it already
		if self.Heli_SmokeStatus == 0 then
			self:SetNW2Int("Heli_SmokeLevel", 1)
			self.Heli_SmokeStatus = 1
		end
		-- If even lower, then make the right tail smoke too
		if hp <= (maxHP * 0.15) then
			self:SetNW2Int("Heli_SmokeLevel", 2)
			self.Heli_SmokeStatus = 2
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorHeliExp = Color(255, 255, 192, 128)
local sdGibCollide = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}

--[[
Notes for dev:
		DO NOT USE THE GREEN GIBS AND OSPREY ENGINE GIBS, USE THE GRAY METAL ONES (without the _g prefix at the end) PLUS THE NEW OSPREY BODY AND TAIL GIBS.
		FOR BLACKOPS, use SetSkin on the new osprey gibs.
		DON'T FORGET TO USE SKIN 2 on models/vj_hlr/hl1/osprey_dead.mdl FOR BLACK OPS AS WELL.
--]]

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
	deathCorpse:SetModel("models/vj_hlr/hl1/osprey_dead.mdl")
	deathCorpse:SetPos(self:GetPos() + Vector(0, 0, 100)) -- + vector fixes the positioning, because osprey_dead spawns a little below due to the way the model is. 
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
		end
	end
	deathCorpse.NextExpT = 0
	deathCorpse:Spawn()
	deathCorpse:Activate()
	
	-- Explode as it goes down
	function deathCorpse:Think()
		self:ResetSequence("idle_ground")
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
		local gibTbl = self:GetModel() == "models/vj_hlr/hl1/osprey_blkops.mdl" and heliExpGibs_Gray or heliExpGibs_Green
		for _ = 1, 90 do
			local gib = ents.Create("obj_vj_gib")
			gib:SetModel(VJ_PICK(gibTbl))
			gib:SetPos(self:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), math.random(20, 150)))
			gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
			gib.Collide_Decal = ""
			gib.CollideSound = sdGibCollide
			gib:Spawn()
			gib:Activate()
			gib:SetColor(Color(255, 223, 137))
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
	local expPos = self:GetAttachment(self:LookupAttachment("engine_left")).Pos
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
	
	expPos = self:GetAttachment(self:LookupAttachment("engine_right")).Pos
	local spr2 = ents.Create("env_sprite")
	spr2:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
	spr2:SetKeyValue("GlowProxySize","2.0")
	spr2:SetKeyValue("HDRColorScale","1.0")
	spr2:SetKeyValue("renderfx","14")
	spr2:SetKeyValue("rendermode","5")
	spr2:SetKeyValue("renderamt","255")
	spr2:SetKeyValue("disablereceiveshadows","0")
	spr2:SetKeyValue("mindxlevel","0")
	spr2:SetKeyValue("maxdxlevel","0")
	spr2:SetKeyValue("framerate","15.0")
	spr2:SetKeyValue("spawnflags","0")
	spr2:SetKeyValue("scale","5")
	spr2:SetPos(expPos)
	spr2:Spawn()
	spr2:Fire("Kill", "", 0.9)
	timer.Simple(0.9, function() if IsValid(spr2) then spr2:Remove() end end)
	util.BlastDamage(self, self, expPos, 300, 100)
	VJ_EmitSound(self, sdExplosions, 100, 100)
	
	-- right engine gibs
	-- FIXME: this needs to be implemented better, right now this is a basic idea, often causes osprey to just explode midair, but the shit looks beautiful when everything goes right.
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/osprey_enginegib1.mdl",{BloodDecal="",Pos=self:GetAttachment(self:LookupAttachment("engine_right")).Pos + Vector(90,0,-100),CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/osprey_enginegib2.mdl",{BloodDecal="",Pos=self:GetAttachment(self:LookupAttachment("engine_right")).Pos + Vector(90,0,0),CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/osprey_enginegib3.mdl",{BloodDecal="",Pos=self:GetAttachment(self:LookupAttachment("engine_right")).Pos + Vector(95,0,90),CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/osprey_enginegib9.mdl",{BloodDecal="",Pos=self:GetAttachment(self:LookupAttachment("engine_right")).Pos + Vector(95,0,93),CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/osprey_enginegib10.mdl",{BloodDecal="",Pos=self:GetAttachment(self:LookupAttachment("engine_right")).Pos + Vector(95,0,95),CollideSound=sdGibCollide})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/osprey_enginegib11.mdl",{BloodDecal="",Pos=self:GetAttachment(self:LookupAttachment("engine_right")).Pos + Vector(95,0,95),CollideSound=sdGibCollide})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.HeliSD_Rotor)
	VJ_STOPSOUND(self.HeliSD_Whine)
	
	-- Remove soldiers if Osprey was removed (Not killed)
	if !self.Dead then
		for _, v in pairs(self.Osprey_DroppedSoldiers) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end
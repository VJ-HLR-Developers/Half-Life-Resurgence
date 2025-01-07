AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local combatDistance = 4000 -- When closer then this, it will stop chasing and start firing

ENT.Model = "models/vj_hlr/hl1/osprey.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.VJ_ID_Boss = true
ENT.StartHealth = 800
ENT.HullType = HULL_LARGE
ENT.SightAngle = 360
ENT.TurningSpeed = 2 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
	-- ====== Movement Variables ====== --
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Alerted = 300 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.Aerial_FlyingSpeed_Calm = ENT.Aerial_FlyingSpeed_Alerted -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.AA_GroundLimit = 1200 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 1000 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 8 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
ENT.AA_MoveDecelerate = 4 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x
ENT.VJC_Data = {
    FirstP_Bone = "Osprey", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(365, 0, -80), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.CanTurnWhileMoving = false -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it"s between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = combatDistance -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Fire = true -- Immune to fire-type damages
ENT.BringFriendsOnDeath = false -- Should the NPC's allies come to its position while it's dying?
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
ENT.HasDeathCorpse = false
ENT.Medic_CanBeHealed = false -- Can this NPC be healed by medics?
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Death = {"vj_hlr/hl1_weapon/mortar/mortarhit.wav"}

local sdExplosions = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.DeathSoundLevel = 100

/* https://github.com/ValveSoftware/halflife/blob/master/dlls/osprey.cpp
	EMIT_SOUND_DYN(ENT(pev), CHAN_STATIC, "apache/ap_rotor4.wav", 1.0, 0.15, 0, 110 );
	death: EMIT_SOUND(ENT(pev), CHAN_STATIC, "weapons/mortarhit.wav", 1.0, 0.3);
*/
-- Custom
ENT.Osprey_IsBlackOps = false
ENT.Osprey_DropPos = nil
ENT.Osprey_DropStatus = 0 -- -1 = Can NOT deploy | 0 = Not dropped off | 1 = Moving to drop zone | 2 = Dropping soldiers | 3 = Soldiers rappelling down | 4 = Soldiers fully on ground
ENT.Osprey_DropSoldierStatus = 0 -- if this number reaches the max amount, then it means that all soldiers are on ground, Osprey can go back to normal!
ENT.Osprey_DropSoldierStatusDead = 0 -- Similar to the one above, but this one keeps track of how many of the 4 soldiers have died!
ENT.Osprey_NextDropT = 0
ENT.Heli_SmokeStatus = 0 -- 0 = No smoke | 1 = Left tail smoke | 2 = Left & Right tail smoke
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 400)
--
function ENT:Init()
	self:SetNW2Int("Heli_SmokeLevel", 0)
	//self.ConstantlyFaceEnemyDistance = self.SightDistance -- Osprey does NOT face the enemy!
	
	self:SetCollisionBounds(Vector(300, 300, 250), Vector(-300, -300, 0))
	self:SetPos(self:GetPos() + spawnPos)
	
	self.HeliSD_Rotor = VJ.CreateSound(self, "vj_hlr/hl1_npc/apache/ap_rotor4.wav", 120)
	self.HeliSD_Whine = VJ.CreateSound(self, "vj_hlr/hl1_npc/apache/ap_whine1.wav", 70)
	self.HeliSD_Distant = VJ.CreateSound(self, "vj_hlr/hl1_npc/apache/ap_rotor1.wav", 160)
	
	if GetConVar("vj_hlr1_osprey_deploysoldiers"):GetInt() == 0 then self.Osprey_DropStatus = -1 end
	self.Osprey_Gunners = {}
	self.Osprey_DroppedSoldiers = {}
	
	-- Create & Spawn the 2 gunners
	for i = 1, 2 do
		local att = self:GetAttachment(i)
		local gunner = ents.Create(self.Osprey_IsBlackOps and "npc_vj_hlrof_assassin_male" or "npc_vj_hlr1_hgrunt_serg")
		gunner:SetPos(att.Pos)
		gunner:SetAngles(att.Ang)
		gunner:SetOwner(self)
		gunner:SetParent(self)
		gunner.MovementType = VJ_MOVETYPE_STATIONARY
		gunner.DisableWeapons = true
		gunner.CanTurnWhileStationary = false
		gunner.Weapon_UnarmedBehavior = false
		gunner.Medic_CanBeHealed = false
		gunner.HasDeathAnimation = false
		gunner.VJ_NPC_Class = self.VJ_NPC_Class
		gunner:Spawn()
		table.insert(self.VJ_AddCertainEntityAsFriendly, gunner) -- In case relation class is changed dynamically!
		table.insert(gunner.VJ_AddCertainEntityAsFriendly, self) -- In case relation class is changed dynamically!
		if self.Osprey_IsBlackOps then gunner:SetBodygroup(2, 1) end -- Always give the Black Ops snipers!
		gunner.Weapon_FiringDistanceFar = self.SightDistance
		gunner:Fire("SetParentAttachment", i == 1 and "gunner_left" or "gunner_right", 0)
		gunner:SetState(VJ_STATE_ONLY_ANIMATION)
		timer.Simple(0.2, function()
			if IsValid(self) && IsValid(gunner) && IsValid(gunner:GetActiveWeapon()) then
				gunner:GetActiveWeapon().NPC_FiringCone = -1
			end
		end)
		self:DeleteOnRemove(gunner)
		self.Osprey_Gunners[i] = gunner
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
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("JUMP: Deploy soldiers, can redeploy after all die & cool down expires!")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	return ACT_IDLE -- We don't want it do anything else!
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
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local ropePos1 = Vector(0, 0, 112)
local ropePos2 = Vector(0, 0, -4096)
--
function ENT:OnThinkActive()
	if self.Osprey_DropStatus == -1 then return end
	-- All have landed and died
	if self.Osprey_DropStatus == 4 then
		if self.Osprey_DropSoldierStatusDead >= 4 && CurTime() > self.Osprey_NextDropT then
			self.Osprey_DropStatus = 0
			self.Osprey_DropSoldierStatusDead = 0
		else
			return
		end
	end
	local ene = self:GetEnemy()
	if self.Osprey_DropStatus == 0 && IsValid(ene) && ((!self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP))) then
		self.Osprey_DropStatus = 1
		local vecRand = VectorRand()*600
		vecRand.z = math.abs(vecRand.z) -- Make sure negative Zs are cancelled out
		local tr = util.TraceHull({
			start = self:GetPos() + self:OBBCenter(),
			endpos = (self.VJ_IsBeingControlled and self:GetPos()) or (ene:GetPos() + ene:GetUp()*600 + vecRand),
			filter = {self, self.Osprey_Gunners[1], self.Osprey_Gunners[2]},
			mins = self:OBBMins(),
			maxs = self:OBBMaxs()
		})
		self.Osprey_DropPos = tr.HitPos
		self:SetState(VJ_STATE_ONLY_ANIMATION)
		self.NoChaseAfterCertainRange = false
	elseif self.Osprey_DropStatus == 1 then
		self:AA_MoveTo(self.Osprey_DropPos, true, "Alert", {FaceDest=true, FaceDestTarget=false, IgnoreGround=true})
		if self:GetPos():Distance(self.Osprey_DropPos) < 180 then
			self.Osprey_DropStatus = 2
		end
	elseif self.Osprey_DropStatus == 2 then
		-- Update the relation class tables for all the gunners in case it has changed!
		if self.Osprey_Gunners[1] then
			self.Osprey_Gunners[1].VJ_NPC_Class = self.VJ_NPC_Class
		end
		if self.Osprey_Gunners[2] then
			self.Osprey_Gunners[2].VJ_NPC_Class = self.VJ_NPC_Class
		end
		self:AA_StopMoving()
		self.Osprey_DropStatus = 3
		self.Osprey_DropSoldierStatus = 0 -- Start at 0
		self.Osprey_NextDropT = CurTime() + 30
		for i = 1, 4 do
			local att = self:GetAttachment((i % 2 == 0) && 2 or 1)
			local startPos = att.Pos + att.Ang:Forward()*100 + self:GetForward()*((i >= 3) && -30 or 60)
			local soldierClass = "npc_vj_hlr1_hgrunt"
			local soldierClass_blkops = "npc_vj_hlrof_assassin_male"
			if math.random(1, 20) == 1 then	-- 5% for robot grunts to spawn
				soldierClass = "npc_vj_hlr1_rgrunt"
				soldierClass_blkops = "npc_vj_hlrof_assassin_rgrunt"
			else
				soldierClass = "npc_vj_hlr1_hgrunt"
				soldierClass_blkops = "npc_vj_hlrof_assassin_male"
			end
			local soldier = ents.Create(self.Osprey_IsBlackOps and soldierClass_blkops or soldierClass)
			soldier:SetPos(startPos)
			soldier:SetAngles(att.Ang)
			soldier:SetOwner(self)
			soldier.HECU_DeployedByOsprey = true
			soldier.HECU_Rappelling = true
			soldier.VJ_NPC_Class = self.VJ_NPC_Class
			soldier:Spawn()
			soldier:SetLocalVelocity(Vector(0, 0, math.Rand(-196, -128)))
			soldier:SetEnemy(ene)
			
			-- Create the rope
			local ropeStart = soldier:GetPos() + ropePos1
			local tr = util.TraceLine({
				start = ropeStart,
				endpos = soldier:GetPos() + ropePos2,
				filter = {self, soldier},
			})
			local rope = EffectData()
			rope:SetStart(ropeStart)
			rope:SetOrigin(tr.HitPos)
			rope:SetEntity(soldier)
			rope:SetAttachment(4)
			util.Effect("VJ_HLR_Rope", rope)
			
			self.Osprey_DroppedSoldiers[i] = soldier
		end
	elseif self.Osprey_DropStatus == 3 && self.Osprey_DropSoldierStatus >= 4 then
		-- Reset Osprey to normal
		self.Osprey_DropStatus = 4
		self:SetState()
		self.NoChaseAfterCertainRange = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Initial" then
		-- If hit in the engine area, then get damage by bullets
		if dmginfo:IsBulletDamage() && (hitgroup == 2 or hitgroup == 3) then
			dmginfo:ScaleDamage(0.05)
			self.Immune_Bullet = false -- To counter the dmginfo:IsBulletDamage() function
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorHeliExp = Color(255, 255, 192, 128)
local colorYellowOsprey = Color(255, 223, 137)
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
local heliExpGibs_Main = {
	"models/vj_hlr/gibs/osprey_bodygib1.mdl",
	"models/vj_hlr/gibs/osprey_bodygib2.mdl",
	"models/vj_hlr/gibs/osprey_bodygib3.mdl",
	"models/vj_hlr/gibs/osprey_bodygib4.mdl",
	"models/vj_hlr/gibs/osprey_bodygib5.mdl",
	"models/vj_hlr/gibs/osprey_bodygib6.mdl",
	"models/vj_hlr/gibs/osprey_bodygib7.mdl",
	"models/vj_hlr/gibs/osprey_bodygib8.mdl",
	"models/vj_hlr/gibs/osprey_bodygib9.mdl",
	"models/vj_hlr/gibs/osprey_bodygib10.mdl",
	"models/vj_hlr/gibs/osprey_bodygib11.mdl",
	"models/vj_hlr/gibs/osprey_bodygib12.mdl",
	"models/vj_hlr/gibs/osprey_bodygib13.mdl",
	"models/vj_hlr/gibs/osprey_bodygib14.mdl",
	"models/vj_hlr/gibs/osprey_bodygib15.mdl",
	"models/vj_hlr/gibs/osprey_bodygib16.mdl",
	"models/vj_hlr/gibs/osprey_bodygib17.mdl",
	"models/vj_hlr/gibs/osprey_tailgib1.mdl",
	"models/vj_hlr/gibs/osprey_tailgib4.mdl"
}
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		local expPos = self:GetAttachment(self:LookupAttachment("engine_left")).Pos
		local expSpr = ents.Create("env_sprite")
		expSpr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
		expSpr:SetKeyValue("GlowProxySize","2.0")
		expSpr:SetKeyValue("HDRColorScale","1.0")
		expSpr:SetKeyValue("renderfx","14")
		expSpr:SetKeyValue("rendermode","5")
		expSpr:SetKeyValue("renderamt","255")
		expSpr:SetKeyValue("disablereceiveshadows","0")
		expSpr:SetKeyValue("mindxlevel","0")
		expSpr:SetKeyValue("maxdxlevel","0")
		expSpr:SetKeyValue("framerate","15.0")
		expSpr:SetKeyValue("spawnflags","0")
		expSpr:SetKeyValue("scale","5")
		expSpr:SetPos(expPos)
		expSpr:Spawn()
		expSpr:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function() if IsValid(expSpr) then expSpr:Remove() end end)
		util.BlastDamage(self, self, expPos, 300, 100)
		VJ.EmitSound(self, sdExplosions, 100, 100)
		
		expPos = self:GetAttachment(self:LookupAttachment("engine_right")).Pos
		local expSpr2 = ents.Create("env_sprite")
		expSpr2:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
		expSpr2:SetKeyValue("GlowProxySize","2.0")
		expSpr2:SetKeyValue("HDRColorScale","1.0")
		expSpr2:SetKeyValue("renderfx","14")
		expSpr2:SetKeyValue("rendermode","5")
		expSpr2:SetKeyValue("renderamt","255")
		expSpr2:SetKeyValue("disablereceiveshadows","0")
		expSpr2:SetKeyValue("mindxlevel","0")
		expSpr2:SetKeyValue("maxdxlevel","0")
		expSpr2:SetKeyValue("framerate","15.0")
		expSpr2:SetKeyValue("spawnflags","0")
		expSpr2:SetKeyValue("scale","5")
		expSpr2:SetPos(expPos)
		expSpr2:Spawn()
		expSpr2:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function() if IsValid(expSpr2) then expSpr2:Remove() end end)
		util.BlastDamage(self, self, expPos, 300, 100)
		VJ.EmitSound(self, sdExplosions, 100, 100)
		
		
		-- Engine gibs (Right side)
		-- FIXME: this needs to be implemented better, right now this is a basic idea, often causes osprey to just explode midair, but the shit looks beautiful when everything goes right.
		local pos = self:GetAttachment(self:LookupAttachment("engine_right")).Pos
		local gibSkin = self:GetModel() == "models/vj_hlr/hl1/osprey_blkops.mdl" and 1 or 0
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/osprey_enginegib1.mdl", {CollisionDecal=false, Pos=pos + Vector(90,0,-100), CollisionSound=sdGibCollide}, function(gib) gib:SetSkin(gibSkin) end)
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/osprey_enginegib2.mdl", {CollisionDecal=false, Pos=pos + Vector(90,0,0), CollisionSound=sdGibCollide}, function(gib) gib:SetSkin(gibSkin) end)
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/osprey_enginegib3.mdl", {CollisionDecal=false, Pos=pos + Vector(95,0,90), CollisionSound=sdGibCollide}, function(gib) gib:SetSkin(gibSkin) end)
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/osprey_enginegib9.mdl", {CollisionDecal=false, Pos=pos + Vector(95,0,93), CollisionSound=sdGibCollide}, function(gib) gib:SetSkin(gibSkin) end)
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/osprey_enginegib10.mdl", {CollisionDecal=false, Pos=pos + Vector(95,0,95), CollisionSound=sdGibCollide}, function(gib) gib:SetSkin(gibSkin) end)
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/osprey_enginegib11.mdl", {CollisionDecal=false, Pos=pos + Vector(95,0,96), CollisionSound=sdGibCollide}, function(gib) gib:SetSkin(gibSkin) end)
		
		-- Make the gunners gib into pieces!
		-- Also unparent them because Source engine spawns them at a random location...
		local gunner1 = self.Osprey_Gunners[1]
		local gunner2 = self.Osprey_Gunners[2]
		if IsValid(gunner1) then
			gunner1:SetParent(NULL)
			gunner1:SetPos(self:GetAttachment(self:LookupAttachment("gunner_left")).Pos)
			local doDmg = DamageInfo()
			doDmg:SetDamage(gunner1:Health())
			doDmg:SetDamageType(DMG_BLAST)
			gunner1:TakeDamageInfo(doDmg)
		end
		if IsValid(gunner2) then
			gunner2:SetParent(NULL)
			gunner2:SetPos(self:GetAttachment(self:LookupAttachment("gunner_right")).Pos)
			local doDmg = DamageInfo()
			doDmg:SetDamage(gunner2:Health())
			doDmg:SetDamageType(DMG_BLAST)
			gunner2:TakeDamageInfo(doDmg)
		end
		
		-- Spawn a animated model of the helicopter that explodes constantly and gets destroyed when it collides with something
		-- Based on source code
		local deathCorpse = ents.Create("prop_vj_animatable")
		deathCorpse:SetModel("models/vj_hlr/hl1/osprey_dead.mdl")
		deathCorpse:SetPos(self:GetPos() + Vector(0, 0, 100)) -- + vector fixes the positioning, because osprey_dead spawns a little below due to the way the model is. 
		deathCorpse:SetAngles(self:GetAngles())
		deathCorpse:SetSkin(self:GetModel() == "models/vj_hlr/hl1/osprey_blkops.mdl" and 1 or 0)
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
				local expPos2 = self:GetPos() + Vector(math.Rand(-150, 150), math.Rand(-150, 150), math.Rand(-150, -50))
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
			if data.HitEntity.IsVJBaseCorpse_Gib then return end -- Do NOT explode if its an engine part
			self.Dead = true
			
			-- Create gibs
			local isBlackOps = self:GetModel() == "models/vj_hlr/hl1/osprey_dead.mdl"
			local gibTbl = isBlackOps and heliExpGibs_Gray or heliExpGibs_Green
			for _ = 1, 30 do
				local gib = ents.Create("obj_vj_gib")
				gib:SetModel(VJ.PICK(gibTbl))
				gib:SetPos(self:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), math.random(20, 150)))
				gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
				gib.CollisionDecal = false
				gib.CollisionSound = sdGibCollide
				gib:Spawn()
				gib:Activate()
				if !isBlackOps then gib:SetColor(colorYellowOsprey) end
				local myPhys = gib:GetPhysicsObject()
				if IsValid(myPhys) then
					myPhys:AddVelocity(Vector(math.Rand(-300, 300), math.Rand(-300, 300), math.Rand(150, 250)))
					myPhys:AddAngleVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
				end
				if GetConVar("vj_npc_gib_fade"):GetInt() == 1 then
					timer.Simple(GetConVar("vj_npc_gib_fadetime"):GetInt(), function() SafeRemoveEntity(gib) end)
				end
			end
			
			gibSkin = isBlackOps and 1 or 0
			for _, v in ipairs(heliExpGibs_Main) do
				local gib = ents.Create("obj_vj_gib")
				gib:SetModel(v)
				gib:SetPos(self:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), math.random(20, 150)))
				gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
				gib.CollisionDecal = false
				gib.CollisionSound = sdGibCollide
				gib:SetSkin(gibSkin)
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
			
			local expPos2 = self:GetPos() + Vector(0,0,math.Rand(150, 150))
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
			spr:SetPos(expPos2)
			spr:Spawn()
			spr:Fire("Kill", "", 1.19)
			timer.Simple(1.19, function() if IsValid(spr) then spr:Remove() end end)
			util.BlastDamage(self, self, expPos2, 600, 200)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/mortar/mortarhit.wav", 100, 100)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/mortar/mortarhit_dist.wav", 140, 100)
			
			-- flags 0 = No fade!
			effects.BeamRingPoint(self:GetPos(), 0.4, 0, 1500, 32, 0, colorHeliExp, {material="vj_hl/sprites/shockwave", framerate=0, flags=0})
			
			self:Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.HeliSD_Rotor)
	VJ.STOPSOUND(self.HeliSD_Whine)
	VJ.STOPSOUND(self.HeliSD_Distant)
	
	-- Remove soldiers if Osprey was removed (Not killed)
	if !self.Dead then
		for _, v in ipairs(self.Osprey_DroppedSoldiers) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end
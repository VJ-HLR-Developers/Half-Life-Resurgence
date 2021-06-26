AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/osprey.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500
ENT.HullType = HULL_LARGE
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 2 -- How fast it can turn
ENT.TurningUseAllAxis = false -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.VJ_IsHugeMonster = true

ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.FindEnemy_UseSphere = true

ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Alerted = 300 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Calm = ENT.Aerial_FlyingSpeed_Alerted -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {ACT_FLY} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {ACT_FLY} -- Animations it plays when it's moving while alerted
ENT.AA_GroundLimit = 1200 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 1000 -- Minimum distance that the NPC should go to when wandering
ENT.AA_MoveAccelerate = 1 -- The NPC will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
ENT.AA_MoveDecelerate = 1 -- The NPC will slow down as it approaches its destination | Calculation = MaxSpeed / x
ENT.AnimTbl_IdleStand = {ACT_FLY}

ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Fire = true -- Immune to fire-type damages
ENT.ImmuneDamagesTable = {DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN}

ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone01", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(140, 0, -45), -- The offset for the controller when the camera is in first person
}

ENT.CombatFaceEnemy = false
ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it"s visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 7500

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it"s between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 4000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it"s able to range attack

ENT.HasDeathRagdoll = false
ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
ENT.GibOnDeathDamagesTable = {"All"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage

ENT.SoundTbl_Death = {"vj_hlr/hl1_weapon/mortar/mortarhit.wav"}
local sdExplosions = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}

/* https://github.com/ValveSoftware/halflife/blob/master/dlls/osprey.cpp
	EMIT_SOUND_DYN(ENT(pev), CHAN_STATIC, "apache/ap_rotor4.wav", 1.0, 0.15, 0, 110 );
	death: EMIT_SOUND(ENT(pev), CHAN_STATIC, "weapons/mortarhit.wav", 1.0, 0.3);
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line",self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos,self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(140,140,120),Vector(-140,-140,0))
	self:SetPos(self:GetPos() +Vector(0,0,400))
	
	self.IdleLP = CreateSound(self,"vj_hlr/hl1_npc/apache/ap_rotor2.wav")
	self.IdleLP:SetSoundLevel(105)
	self.IdleLP:Play()
	self.IdleLP:ChangeVolume(1)
	
	self.DroppedSoldiers = false
	self.Dropping = false
	self.DropMax = 12
	self.DropCount = 0
	self.DropZone = false
	self.Gunners = {}
	for i = 1,2 do
		local gunner = ents.Create("npc_vj_hlr1_hgrunt_serg")
		gunner:SetPos(self:GetAttachment(i).Pos)
		gunner:SetAngles(self:GetAttachment(i).Ang)
		gunner:SetOwner(self)
		gunner:SetParent(self)
		gunner:Spawn()
		gunner:Fire("SetParentAttachment",i == 1 && "gunner_left" or "gunner_right",0)
		self:DeleteOnRemove(gunner)
		table.insert(self.Gunners,gunner)
		gunner:SetState(VJ_STATE_ONLY_ANIMATION)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.NoChaseAfterCertainRange = !self.DisableFlying
	-- self:SetPoseParameter("tilt", Lerp(FrameTime()*4, self:GetPoseParameter("tilt"), self:GetVelocity():GetNormal().y)) // Disables flight for some reason?
	if self.DisableFlying then
		self:AA_StopMoving()
		self:SetEnemy(NULL)
		self:FaceCertainPosition(self:GetPos() +self:GetForward() *200 +self:GetRight() *3)
	end
	if !self.DroppedSoldiers then
		if self.DropZone then
			self:SetEnemy(NULL)
			if (self:GetPos() +self:OBBCenter()):Distance(self.DropZone) > 100 then
				self.Aerial_FlyingSpeed_Calm = 70
				self:AA_MoveTo(self.DropZone,true,"Calm",{FaceDest=true,IgnoreGround=true})
			else
				if self.Dropping then return end
				self.Aerial_FlyingSpeed_Calm = self.Aerial_FlyingSpeed_Alert
				self:AA_StopMoving()
				self.DisableFlying = true
				self.Dropping = true
				for i = 1,self.DropMax do
					timer.Simple(i *2,function()
						if IsValid(self) then
							local att = (i % 2 == 0) && 2 or 1
							local grunt = ents.Create("npc_vj_hlr1_hgrunt")
							grunt:SetPos(self:GetAttachment(att).Pos +self:GetAttachment(att).Ang:Forward() *100)
							grunt:SetAngles(self:GetAttachment(att).Ang)
							grunt:SetOwner(self)
							grunt:Spawn()
							timer.Simple(0.1,function()
								if IsValid(grunt) then
									local tr = util.TraceLine({
										start = grunt:GetPos(),
										endpos = grunt:GetPos() +Vector(0,0,-1000),
										filter = {self,grunt},
									})
									local fallTime = ((grunt:GetPos():Distance(tr.Hit && tr.HitPos or grunt:GetPos())) /grunt:GetVelocity():Length()) or 2
									timer.Simple(fallTime,function()
										if IsValid(grunt) then
											grunt:SetLastPosition(grunt:GetPos() +grunt:GetForward() *200)
											grunt:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
										end
									end)
								end
							end)
							if i == self.DropMax then self.DroppedSoldiers = true end
						end
					end)
				end
			end
			return
		end
		if !IsValid(self:GetEnemy()) then return end
		local startPos = self:GetEnemy():GetPos()
		local tr = util.TraceLine({
			start = startPos,
			endpos = startPos +Vector(0,0,self.AA_GroundLimit),
			filter = {self:GetEnemy(),self},
		})
		self.DropZone = tr.Hit && (tr.HitPos +tr.HitNormal *150) or self:GetEnemy():GetPos() +Vector(0,0,500)
		
		local heightMax = (800 *math.Rand(0.85,1.5))
		local vecRand = VectorRand() *250
		vecRand.z = 0
		local startPos = self:GetEnemy():GetPos() +Vector(0,0,heightMax) +vecRand
		local tr = util.TraceLine({
			start = startPos,
			endpos = startPos -Vector(0,0,8000),
			filter = {self:GetEnemy(),self},
		})
		self.DropZone = startPos
		if tr.Hit && tr.HitPos:Distance(startPos) > heightMax then
			self.DropZone = tr.HitPos +Vector(0,0,heightMax)
		end
	else
		self.DisableFlying = false
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
		for _ = 1, 90 do
			local gib = ents.Create("obj_vj_gib")
			gib:SetModel(VJ_PICK(heliExpGibs_Green))
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

	local expPos = self:GetAttachment(self:LookupAttachment("engine_right")).Pos
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
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 150, 100)
	VJ_EmitSound(self, "vj_hlr/hl1_npc/rgrunt/rb_gib.wav", 80, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.IdleLP:Stop()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
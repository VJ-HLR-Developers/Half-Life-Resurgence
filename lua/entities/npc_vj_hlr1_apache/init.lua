AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
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
ENT.TurningUseAllAxis = true -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
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
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone14", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(-50, 0, -40), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.AnimTbl_IdleStand = {ACT_FLY} -- The idle animation table when AI is enabled | DEFAULT: {ACT_IDLE}
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw poseparameters (Y)
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
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

/* https://github.com/ValveSoftware/halflife/blob/master/dlls/apache.cpp
	EMIT_SOUND_DYN(ENT(pev), CHAN_STATIC, "apache/ap_rotor2.wav", 1.0, 0.3, 0, 110 );
	firing: tu_fire1.wav, EMIT_SOUND(ENT(pev), CHAN_WEAPON, "turret/tu_fire1.wav", 1, 0.3);
	death: EMIT_SOUND(ENT(pev), CHAN_STATIC, "weapons/mortarhit.wav", 1.0, 0.3);
	
	- Fires 2 rockets (1 on each side) at the same time, Delay: 10 seconds
	- Chain gun: Continuos fire as long as front is visible
*/
-- Custom
ENT.Apache_HasLOS = false
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 400)
--
function ENT:CustomOnInitialize()
	self.ConstantlyFaceEnemyDistance = self.SightDistance
	
	self:SetCollisionBounds(Vector(150, 150, 180), Vector(-150, -150, 0))
	self:SetPos(self:GetPos() + spawnPos)
	
	self.ApacheSD_Rotor = VJ_CreateSound(self, "vj_hlr/hl1_npc/apache/ap_rotor2.wav", 120)
	self.ApacheSD_Whine = VJ_CreateSound(self, "vj_hlr/hl1_npc/apache/ap_whine1.wav", 70)
	
	local glow = ents.Create("env_sprite")
	glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow:SetKeyValue("scale", "0.5")
	glow:SetKeyValue("rendermode","5")
	glow:SetKeyValue("renderfx","9")
	glow:SetKeyValue("rendercolor","255 0 0")
	glow:SetKeyValue("spawnflags","1") -- If animated
	glow:SetParent(self)
	glow:Fire("SetParentAttachment", "rotor_tail")
	glow:Spawn()
	glow:Activate()
	self:DeleteOnRemove(glow)
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
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line", projectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 2000)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(ent)
	self.RangeUseAttachmentForPosID = self.RangeUseAttachmentForPosID == "missile_left" and "missile_right" or "missile_left"
	VJ_CreateSound(ent, "vj_hlr/hl1_weapon/rpg/rocketfire1.wav", 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:SetPoseParameter("tilt", Lerp(FrameTime()*4, self:GetPoseParameter("tilt"), -self:GetVelocity():GetNormal().y))
end
---------------------------------------------------------------------------------------------------------------------------------------------
local bulletSpread = Vector(0.05, 0.05, 0)
--
function ENT:CustomAttack()
	local ene = self:GetEnemy()
	if self.Apache_HasLOS && self.NearestPointToEnemyDistance <= combatDistance && self:Visible(ene) then
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
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	ParticleEffectAttach("fire_large_01",PATTACH_POINT_FOLLOW,self,4)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,7)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,8)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,9)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	local pos,ang = self:GetBonePosition(0)
	corpseEnt:SetPos(pos)
	corpseEnt:GetPhysicsObject():SetVelocity(((self:GetPos() +self:GetRight() *-700 +self:GetForward() *-300 +self:GetUp() *-200) -self:GetPos()))
	util.BlastDamage(self, self, corpseEnt:GetPos(), 400, 40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)

	VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
	VJ_EmitSound(self,"vj_mili_tank/tank_death3.wav",100,100)
	util.BlastDamage(self,self,corpseEnt:GetPos(),200,40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)
	if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",corpseEnt:GetPos(),Angle(0,0,0),nil) end

	if math.random(1,3) == 1 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/combine_soldier.mdl",{Pos=corpseEnt:GetPos()+corpseEnt:GetUp()*90+corpseEnt:GetRight()*-30,Vel=Vector(math.Rand(-600,600), math.Rand(-600,600),500)},function(extraent) extraent:Ignite(math.Rand(8,10),0); extraent:SetColor(Color(90,90,90)) end)
	end

	if self.HasGibDeathParticles == true then
		ParticleEffect("vj_explosion3",corpseEnt:GetPos(),Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",corpseEnt:GetPos() +corpseEnt:GetForward()*-130,Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",corpseEnt:GetPos() +corpseEnt:GetForward()*130,Angle(0,0,0),nil)
		ParticleEffectAttach("fire_large_01",PATTACH_POINT_FOLLOW,corpseEnt,4)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,corpseEnt,7)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,corpseEnt,8)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,corpseEnt,9)
		
		local explosioneffect = EffectData()
		explosioneffect:SetOrigin(corpseEnt:GetPos())
		util.Effect("VJ_Medium_Explosion1",explosioneffect)
		util.Effect("Explosion", explosioneffect)
		
		local dusteffect = EffectData()
		dusteffect:SetOrigin(corpseEnt:GetPos())
		dusteffect:SetScale(800)
		util.Effect("ThumperDust",dusteffect)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.ApacheSD_Rotor)
	VJ_STOPSOUND(self.ApacheSD_Whine)
end
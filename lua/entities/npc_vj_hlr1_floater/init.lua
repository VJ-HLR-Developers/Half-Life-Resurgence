AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/floater.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 45
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Calm = 100 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_FlyingSpeed_Alerted = 180 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.Aerial_AnimTbl_Calm = ACT_WALK -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = ACT_RUN -- Animations it plays when it's moving while alerted
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone01", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.IdleAlwaysWander = true -- Should the NPC constantly wander while idling?
ENT.CanOpenDoors = false -- Can it open doors?
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_NEUTRAL -- Type of AI behavior to use for this NPC
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Can this NPC melee attack?

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.AnimTbl_RangeAttack = "vjseq_attack" -- Range Attack Animations
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_toxicspit" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.RangeDistance = 1500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 2 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.NoChaseAfterCertainRange = true -- Should the NPC stop chasing when the enemy is within the given far and close distances?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/floater/fl_idle1.wav","vj_hlr/hl1_npc/floater/fl_idle2.wav","vj_hlr/hl1_npc/floater/fl_idle3.wav","vj_hlr/hl1_npc/floater/fl_idle4.wav","vj_hlr/hl1_npc/floater/fl_idle5.wav","vj_hlr/hl1_npc/floater/fl_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/floater/fl_alert1.wav","vj_hlr/hl1_npc/floater/fl_alert2.wav","vj_hlr/hl1_npc/floater/fl_alert3.wav","vj_hlr/hl1_npc/floater/fl_alert4.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/floater/fl_attack1.wav","vj_hlr/hl1_npc/floater/fl_attack2.wav","vj_hlr/hl1_npc/floater/fl_attack3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/bullchicken/bc_attack2.wav","vj_hlr/hl1_npc/bullchicken/bc_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/floater/fl_pain1.wav","vj_hlr/hl1_npc/floater/fl_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/floater/fl_pain1.wav","vj_hlr/hl1_npc/floater/fl_pain2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Floater_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(10, 10, 50), Vector(-10, -10, 0))
	self.Floater_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))
	if !IsValid(VJ.HLR_NPC_Floater_Leader) then -- Yete ourish medzavor chiga, ere vor irzenike medzavor ene
		VJ.HLR_NPC_Floater_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "shoot" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.VJ_IsBeingControlled then return end
	local leader = VJ.HLR_NPC_Floater_Leader
	if !IsValid(self:GetEnemy()) then
		if IsValid(leader) then
			if leader != self && leader.AA_CurrentMovePos then
				self.DisableWandering = true
				self:AA_MoveTo(leader, true, "Calm", {AddPos=self.Floater_FollowOffsetPos, IgnoreGround=true}) -- Medzavorin haladz e (Kharen deghme)
			end
		else
			self.IsGuard = false
			self.DisableWandering = false
			VJ.HLR_NPC_Floater_Leader = self
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetPos() + self:GetUp() * 20 + self:GetForward() * 20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Curve", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 1500), 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(55)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 16))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_base/gib/splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
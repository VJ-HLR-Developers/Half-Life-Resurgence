AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/headcrab.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 10
ENT.HullType = HULL_TINY
ENT.EntitiesToNoCollide = {"npc_vj_hlr1_gonarch"} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Neck", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(2, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.LeapAttackDamage = 10
ENT.AnimTbl_LeapAttack = {ACT_RANGE_ATTACK1} -- Melee Attack Animations
ENT.LeapDistance = 256 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.LeapAttackDamageDistance = 50 -- How far does the damage go?
ENT.TimeUntilLeapAttackDamage = 0.4 -- How much time until it runs the leap damage code?
ENT.TimeUntilLeapAttackVelocity = 0.4 -- How much time until it runs the velocity code?
ENT.NextLeapAttackTime = 1 -- How much time until it can use a leap attack?
ENT.LeapAttackExtraTimers = {0.6, 0.8, 1, 1.2, 1.4} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.NextAnyAttackTime_Leap = 3 -- How much time until it can use any attack again? | Counted in Seconds
ENT.StopLeapAttackAfterFirstHit = true -- Should it stop the leap attack from running rest of timers when it hits an enemy?
ENT.LeapAttackVelocityForward = 70 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 200 -- How much upward force should it apply?
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 200 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/headcrab/hc_idle1.wav","vj_hlr/hl1_npc/headcrab/hc_idle2.wav","vj_hlr/hl1_npc/headcrab/hc_idle3.wav","vj_hlr/hl1_npc/headcrab/hc_idle4.wav","vj_hlr/hl1_npc/headcrab/hc_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/headcrab/hc_alert1.wav","vj_hlr/hl1_npc/headcrab/hc_alert2.wav"}
ENT.SoundTbl_LeapAttackJump = {"vj_hlr/hl1_npc/headcrab/hc_attack1.wav","vj_hlr/hl1_npc/headcrab/hc_attack2.wav","vj_hlr/hl1_npc/headcrab/hc_attack3.wav"}
ENT.SoundTbl_LeapAttackDamage = {"vj_hlr/hl1_npc/headcrab/hc_headbite.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/headcrab/hc_pain1.wav","vj_hlr/hl1_npc/headcrab/hc_pain2.wav","vj_hlr/hl1_npc/headcrab/hc_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/headcrab/hc_die1.wav","vj_hlr/hl1_npc/headcrab/hc_die2.wav"}

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(10, 10, 18), Vector(-10, -10, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:WaterLevel() > 1 then
		self:SetHealth(self:Health() - 1)
		if self:Health() <= 0 then
			self.Bleeds = false
			self:TakeDamage(1, self, self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	if math.random(1, 2) == 1 then
		self:VJ_ACT_PLAYACTIVITY("angry", true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttackVelocityCode()
	self:SetVelocity(((self:GetEnemy():EyePos()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*self.LeapAttackVelocityForward + self:GetUp()*self.LeapAttackVelocityUp)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles then
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local effectData = EffectData()
		effectData:SetOrigin(myCenterPos)
		effectData:SetColor(colorYellow)
		effectData:SetScale(50)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetOrigin(myCenterPos)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	if self:GetModel() != "models/vj_hlr/hl1/headcrab_baby.mdl" then
		self:CreateGibEntity("obj_vj_gib",{"models/vj_hlr/gibs/agib1.mdl","models/vj_hlr/gibs/agib3.mdl"},{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,5))})
	end
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,0,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,1,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(2,0,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,2,5))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs1 = {"models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
local gibs2 = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, self:GetModel() == "models/vj_hlr/hl1/headcrab_baby.mdl" and gibs1 or gibs2)
end
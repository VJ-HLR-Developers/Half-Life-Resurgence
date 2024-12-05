AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/sphere.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 60
ENT.SightAngle = 100
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Calm = 50 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_FlyingSpeed_Alerted = 80 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.VJC_Data = {
    FirstP_Bone = "Bone02", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 7), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.HasMeleeAttack = false -- Can this NPC melee attack?

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeDistance = 1020 -- How far can it range attack?
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.NoChaseAfterCertainRange = true -- Should the NPC stop chasing when the enemy is within the given far and close distances?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/sphere/sph_motor1.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/sphere/sph_idle1.wav","vj_hlr/hl1_npc/sphere/sph_idle2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/sphere/sph_alert1.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/fx/zap4.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/hassault/hw_shoot1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/sphere/sph_pain1.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/sphere/sph_pain1.wav"}

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(8, 8, 12), Vector(-8, -8, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "shoot" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && (self:GetNPCState() == NPC_STATE_ALERT or self:GetNPCState() == NPC_STATE_COMBAT) then
		return ACT_IDLE_ANGRY
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Make it use the bright skin when it's low health
	self:SetSkin((self:Health() <= (self:GetMaxHealth() / 2.2)) and 1 or 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CSphere_DoElecEffect(startPos, hitPos, hitNormal)
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetNormal(hitNormal)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	elec:SetScale(0.8)
	util.Effect("VJ_HLR_Electric_Charge", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	local myPos = self:GetPos()
	local myForward = self:GetForward()
	local myRight = self:GetRight()
	local myUp = self:GetUp()
	
	-- Tsakh --------------------------
	local tsakhSpawn = myPos + myUp*45 + myRight*20
	local tsakhLocations = {
		myPos + myRight*math.Rand(150, 500) + myUp*-200,
		myPos + myRight*math.Rand(150, 500) + myUp*-200 + myForward*-math.Rand(150, 500),
		myPos + myRight*math.Rand(150, 500) + myUp*-200 + myForward*math.Rand(150, 500),
		myPos + myRight*math.Rand(1, 150) + myUp*200 + myForward*math.Rand(-100, 100),
	}
	for i = 1, 4 do
		local tr = util.TraceLine({
			start = tsakhSpawn,
			endpos = tsakhLocations[i],
			filter = self
		})
		if tr.Hit == true then self:CSphere_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal) end
	end
	-- Ach --------------------------
	local achSpawn = myPos + myUp*45 + myRight*-20
	local achLocations = {
		myPos + myRight*-math.Rand(150, 500) + myUp*-200,
		myPos + myRight*-math.Rand(150, 500) + myUp*-200 + myForward*-math.Rand(150, 500),
		myPos + myRight*-math.Rand(150, 500) + myUp*-200 + myForward*math.Rand(150, 500),
		myPos + myRight*-math.Rand(1, 150) + myUp*200 + myForward*math.Rand(-100, 100),
	}
	for i = 1, 4 do
		local tr = util.TraceLine({
			start = achSpawn,
			endpos = achLocations[i],
			filter = self
		})
		if tr.Hit == true then self:CSphere_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local startPos = self:GetPos() + self:GetForward()*8
	local tr = util.TraceLine({
		start = startPos,
		endpos = self:GetAimPosition(self:GetEnemy(), startPos, 0),
		filter = self
	})
	local hitPos = tr.HitPos
	
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	util.Effect("VJ_HLR_Electric", elec)
	
	VJ.ApplyRadiusDamage(self, self, hitPos, 30, 10, DMG_SHOCK, true, false, {Force = 90})
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(2) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(40)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 0))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 0))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 0))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 1))})
	return true -- Return to true if it gibbed! 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_base/gib/splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
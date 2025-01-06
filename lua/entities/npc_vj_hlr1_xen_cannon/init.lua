AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/alien_cannon.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 100
ENT.HullType = HULL_WIDE_SHORT
ENT.SightDistance = 6000 -- How far it can see
ENT.SightAngle = 360
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How the NPC moves around
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.PoseParameterLooking_TurningSpeed = 5
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "joint3", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 50), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = false -- Can this NPC melee attack?

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 6000 -- How far can it range attack?
ENT.RangeToMeleeDistance = 150 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the NPC | 180 = All around the NPC
ENT.TimeUntilRangeAttackProjectileRelease = 0 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 0.5 -- How much time until it can use a range attack?

ENT.Medic_CanBeHealed = false -- Can this NPC be healed by medics?
ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch pose parameters (X)
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw pose parameters (Y)
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Melee = true -- Immune to melee-type damage | Example: Crowbar, slash damages
ENT.ForceDamageFromBosses = true -- Should the NPC get damaged by bosses regardless if it's not supposed to by skipping immunity checks, etc. | Bosses are attackers tagged with "VJ_ID_Boss"
ENT.DeathCorpseModel = "models/vj_hlr/hl1/alien_cannon_bottom.mdl" -- Model(s) to spawn as the NPC's corpse | false = Use the NPC's model | Can be a single string or a table of strings
ENT.GibOnDeathFilter = false
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Breath = "vj_hlr/hl1_npc/xencannon/alien_powernode.wav"
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/xencannon/bustconcrete1.wav", "vj_hlr/hl1_npc/xencannon/bustconcrete2.wav"}

ENT.BreathSoundLevel = 70
ENT.DeathSoundLevel = 90

-- Custom
ENT.Cannon_HasLOS = false
ENT.Cannon_LockTime = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(45, 45, 65), Vector(-45, -45, 0))
	self.Cannon_LockTime = CurTime() + 0.3 -- Prevent spawn-killing
	self:SetPhysicsDamageScale(0.001) -- Take minimum physics damage
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "shoot" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local threshold = 3
--
function ENT:OnUpdatePoseParamTracking(pitch, yaw, roll)
	local poseYaw = self:GetPoseParameter("aim_yaw")
	local posePitch = self:GetPoseParameter("aim_pitch")
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if (math.abs(math.AngleDifference(poseYaw, math.ApproachAngle(poseYaw, yaw, self.PoseParameterLooking_TurningSpeed))) >= threshold) or (math.abs(math.AngleDifference(posePitch, math.ApproachAngle(posePitch, pitch, self.PoseParameterLooking_TurningSpeed))) >= threshold) then
		self.Cannon_HasLOS = false
	else
		self.Cannon_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	if self.Cannon_HasLOS == true && (CurTime() > self.Cannon_LockTime) then return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	//local attach = self:GetAttachment(1)
	local startPos = self:GetAttachment(1).Pos
	//local endPos = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) + attach.Ang:Forward()*20000 - Vector(0, 0, 10)
	local tr = util.TraceLine({
		start = startPos,
		endpos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() + VectorRand(-15, 15),
		filter = {self} // self.extmdl
	})
	local hitPos = tr.HitPos
	VJ.ApplyRadiusDamage(self, self, hitPos, 30, 40, DMG_ENERGYBEAM, true, false, {Force=90})
	VJ.EmitSound(self, "vj_hlr/hl1_npc/xencannon/fire.wav", 90, 100)
	sound.Play("vj_hlr/hl1_npc/pitworm/pit_worm_attack_eyeblast_impact.wav", hitPos, 60)
	
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	util.Effect("VJ_HLR_XenCannon_Beam", elec)
	
	local sprMuzzleFlash = ents.Create("env_sprite")
	sprMuzzleFlash:SetKeyValue("model","vj_hl/sprites/flare3.vmt")
	sprMuzzleFlash:SetKeyValue("rendercolor","0 0 255")
	sprMuzzleFlash:SetKeyValue("GlowProxySize","5.0")
	sprMuzzleFlash:SetKeyValue("HDRColorScale","1.0")
	sprMuzzleFlash:SetKeyValue("renderfx","14")
	sprMuzzleFlash:SetKeyValue("rendermode","3")
	sprMuzzleFlash:SetKeyValue("renderamt","255")
	sprMuzzleFlash:SetKeyValue("disablereceiveshadows","0")
	sprMuzzleFlash:SetKeyValue("mindxlevel","0")
	sprMuzzleFlash:SetKeyValue("maxdxlevel","0")
	sprMuzzleFlash:SetKeyValue("framerate","10.0")
	sprMuzzleFlash:SetKeyValue("spawnflags","0")
	sprMuzzleFlash:SetKeyValue("scale","6")
	sprMuzzleFlash:SetPos(self:GetPos())
	sprMuzzleFlash:Spawn()
	sprMuzzleFlash:SetParent(self)
	sprMuzzleFlash:Fire("SetParentAttachment", "Cannon")
	self:DeleteOnRemove(sprMuzzleFlash)
	timer.Simple(0.15, function() SafeRemoveEntity(sprMuzzleFlash) end)
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
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Finish" then
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
		spr:SetKeyValue("scale","3")
		spr:SetPos(self:GetPos() + self:GetUp()*20)
		spr:Spawn()
		spr:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_ABSORIGIN_FOLLOW, corpseEnt, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibCollideSd = {"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub1.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(1, 0, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub2.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 1, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub3.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(2, 0, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub4.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 2, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub5.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(3, 0, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub1.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 3, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub2.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(4, 0, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub3.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 4, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub4.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(5, 0, 20)), CollideSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub5.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 5, 20)), CollideSound=gibCollideSd})
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 150, 100)
	return true, {AllowCorpse = true, AllowSound = false}
end
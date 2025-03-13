AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/alien_cannon.mdl"
ENT.StartHealth = 100
ENT.HullType = HULL_WIDE_SHORT
ENT.SightDistance = 6000
ENT.SightAngle = 360
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanTurnWhileStationary = false
ENT.PoseParameterLooking_TurningSpeed = 5
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "joint3",
    FirstP_Offset = Vector(0, 0, 50),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = false
ENT.RangeAttackMaxDistance = 6000
ENT.RangeAttackMinDistance = 150
ENT.RangeAttackAngleRadius = 180
ENT.TimeUntilRangeAttackProjectileRelease = 0
ENT.NextRangeAttackTime = 0.5

ENT.VJ_ID_Healable = false
ENT.PoseParameterLooking_InvertPitch = true
ENT.PoseParameterLooking_InvertYaw = true
ENT.Immune_Toxic = true
ENT.Immune_Bullet = true
ENT.Immune_Melee = true
ENT.ForceDamageFromBosses = true
ENT.DeathCorpseModel = "models/vj_hlr/hl1/alien_cannon_bottom.mdl"
ENT.GibOnDeathFilter = false

ENT.SoundTbl_Breath = "vj_hlr/gsrc/npc/xencannon/alien_powernode.wav"
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/xencannon/bustconcrete1.wav", "vj_hlr/gsrc/npc/xencannon/bustconcrete2.wav"}

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
		self:ExecuteRangeAttack()
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
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "Init" then
		local startPos = self:GetAttachment(1).Pos
		local tr = util.TraceLine({
			start = startPos,
			endpos = enemy:GetPos() + enemy:OBBCenter() + VectorRand(-15, 15),
			filter = {self} // self.extmdl
		})
		local hitPos = tr.HitPos
		VJ.ApplyRadiusDamage(self, self, hitPos, 30, 40, DMG_ENERGYBEAM, true, false, {Force=90})
		VJ.EmitSound(self, "vj_hlr/gsrc/npc/xencannon/fire.wav", 90, 100)
		sound.Play("vj_hlr/gsrc/npc/pitworm/pit_worm_attack_eyeblast_impact.wav", hitPos, 60)
		
		local elec = EffectData()
		elec:SetStart(startPos)
		elec:SetOrigin(hitPos)
		elec:SetEntity(self)
		elec:SetAttachment(1)
		util.Effect("VJ_HLR_XenCannon_Beam", elec)
		
		local sprMuzzleFlash = ents.Create("env_sprite")
		sprMuzzleFlash:SetKeyValue("model", "vj_hl/sprites/flare3.vmt")
		sprMuzzleFlash:SetKeyValue("rendercolor", "0 0 255")
		sprMuzzleFlash:SetKeyValue("GlowProxySize", "5.0")
		sprMuzzleFlash:SetKeyValue("HDRColorScale", "1.0")
		sprMuzzleFlash:SetKeyValue("renderfx", "14")
		sprMuzzleFlash:SetKeyValue("rendermode", "3")
		sprMuzzleFlash:SetKeyValue("renderamt", "255")
		sprMuzzleFlash:SetKeyValue("disablereceiveshadows", "0")
		sprMuzzleFlash:SetKeyValue("mindxlevel", "0")
		sprMuzzleFlash:SetKeyValue("maxdxlevel", "0")
		sprMuzzleFlash:SetKeyValue("framerate", "10.0")
		sprMuzzleFlash:SetKeyValue("spawnflags", "0")
		sprMuzzleFlash:SetKeyValue("scale", "6")
		sprMuzzleFlash:SetPos(self:GetPos())
		sprMuzzleFlash:Spawn()
		sprMuzzleFlash:SetParent(self)
		sprMuzzleFlash:Fire("SetParentAttachment", "Cannon")
		self:DeleteOnRemove(sprMuzzleFlash)
		timer.Simple(0.15, function() SafeRemoveEntity(sprMuzzleFlash) end)
		return true
	end
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
		spr:SetKeyValue("scale", "3")
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
local gibCollideSd = {"vj_hlr/gsrc/fx/metal1.wav", "vj_hlr/gsrc/fx/metal2.wav", "vj_hlr/gsrc/fx/metal3.wav", "vj_hlr/gsrc/fx/metal4.wav", "vj_hlr/gsrc/fx/metal5.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub1.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub2.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub3.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(2, 0, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub4.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 2, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub5.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(3, 0, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub1.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 3, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub2.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(4, 0, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub3.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 4, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub4.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(5, 0, 20)), CollisionSound=gibCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgibs_sub5.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 5, 20)), CollisionSound=gibCollideSd})
	VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris3.wav", 150, 100)
	return true, {AllowCorpse = true, AllowSound = false}
end
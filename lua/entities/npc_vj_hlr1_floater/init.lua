AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/floater.mdl"
ENT.StartHealth = 45
ENT.SightAngle = 120
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 100
ENT.Aerial_FlyingSpeed_Alerted = 180
ENT.Aerial_AnimTbl_Calm = ACT_WALK
ENT.Aerial_AnimTbl_Alerted = ACT_RUN
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bone01",
    FirstP_Offset = Vector(1, 0, 5),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.ConstantlyFaceEnemy = true
ENT.IdleAlwaysWander = true
ENT.CanOpenDoors = false
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.Behavior = VJ_BEHAVIOR_NEUTRAL
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = "vjseq_attack"
ENT.RangeAttackProjectiles = "obj_vj_hlr1_toxicspit"
ENT.RangeAttackMaxDistance = 1500
ENT.RangeAttackMinDistance = 1
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(2, 4)

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/floater/fl_idle1.wav", "vj_hlr/hl1_npc/floater/fl_idle2.wav", "vj_hlr/hl1_npc/floater/fl_idle3.wav", "vj_hlr/hl1_npc/floater/fl_idle4.wav", "vj_hlr/hl1_npc/floater/fl_idle5.wav", "vj_hlr/hl1_npc/floater/fl_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/floater/fl_alert1.wav", "vj_hlr/hl1_npc/floater/fl_alert2.wav", "vj_hlr/hl1_npc/floater/fl_alert3.wav", "vj_hlr/hl1_npc/floater/fl_alert4.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/floater/fl_attack1.wav", "vj_hlr/hl1_npc/floater/fl_attack2.wav", "vj_hlr/hl1_npc/floater/fl_attack3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/bullchicken/bc_attack2.wav", "vj_hlr/hl1_npc/bullchicken/bc_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/floater/fl_pain1.wav", "vj_hlr/hl1_npc/floater/fl_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/floater/fl_pain1.wav", "vj_hlr/hl1_npc/floater/fl_pain2.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.Floater_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(10, 10, 50), Vector(-10, -10, 0))
	self.Floater_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))
	if !IsValid(VJ.HLR_NPC_Floater_Leader) then -- Yete ourish medzavor chiga, ere vor irzenike medzavor ene
		VJ.HLR_NPC_Floater_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "shoot" then
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
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
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 20 + self:GetForward() * 20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projectile:GetPos(), 1, 10)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 16))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
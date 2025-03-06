AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/boid.mdl"
ENT.StartHealth = 25
ENT.HullType = HULL_TINY
ENT.TurningSpeed = 12
ENT.TurningUseAllAxis = true
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 130
ENT.Aerial_FlyingSpeed_Alerted = 130
ENT.AA_GroundLimit = 400
ENT.AA_MinWanderDist = 300
ENT.ControllerParams = {
	FirstP_Bone = "bone01",
	FirstP_Offset = Vector(10, 0, 0),
	FirstP_ShrinkBone = false,
}
ENT.IdleAlwaysWander = true
ENT.CanOpenDoors = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = false

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/boid/boid_idle1.wav", "vj_hlr/gsrc/npc/boid/boid_idle2.wav", "vj_hlr/gsrc/npc/boid/boid_idle3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/boid/boid_alert1.wav", "vj_hlr/gsrc/npc/boid/boid_alert2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/boid/boid_alert1.wav", "vj_hlr/gsrc/npc/boid/boid_alert2.wav"}

-- Custom
ENT.Boid_Type = 0
	-- 0 = Original / Default
	-- 1 = AFlock
ENT.Boid_FollowOffsetPos = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(18, 18, 10), Vector(-18, -18, 0))
	self.Boid_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))
	if !IsValid(VJ.HLR_NPC_Boid_Leader) then
		VJ.HLR_NPC_Boid_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		return ACT_FLY
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.VJ_IsBeingControlled then return end
	local leader = VJ.HLR_NPC_Boid_Leader
	if IsValid(leader) then
		if leader != self && leader.AA_CurrentMovePos then
			self.DisableWandering = true
			self:AA_MoveTo(leader, true, "Calm", {AddPos=self.Boid_FollowOffsetPos, IgnoreGround=true}) -- Medzavorin haladz e (Kharen deghme)
		end
	else
		self.IsGuard = false
		self.DisableWandering = false
		VJ.HLR_NPC_Boid_Leader = self
	end
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
		effectData:SetScale(90)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1,0,5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,1,5))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
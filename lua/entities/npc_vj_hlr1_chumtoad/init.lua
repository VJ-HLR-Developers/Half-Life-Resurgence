AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/chumtoad.mdl"
ENT.StartHealth = 15
ENT.HullType = HULL_TINY
ENT.SightDistance = 250
ENT.MovementType = VJ_MOVETYPE_GROUND
ENT.Aquatic_SwimmingSpeed_Calm = 80
ENT.Aquatic_SwimmingSpeed_Alerted = 80
ENT.ControllerParams = {
    ThirdP_Offset = Vector(15, 0, 10),
    FirstP_Bone = "Bip01 neck",
    FirstP_Offset = Vector(2, 0, 2),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = false
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH, ACT_BIG_FLINCH}

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/chumtoad/toad_hunt1.wav", "vj_hlr/gsrc/npc/chumtoad/toad_hunt2.wav", "vj_hlr/gsrc/npc/chumtoad/toad_hunt3.wav", "vj_hlr/gsrc/npc/chumtoad/toad_deploy1.wav"}
ENT.SoundTbl_Alert = "vj_hlr/gsrc/npc/chumtoad/toad_idle1.wav"
ENT.SoundTbl_Death = "vj_hlr/gsrc/npc/chumtoad/toad_die1.wav"

ENT.MainSoundPitch = 100

-- Custom
ENT.CT_BlinkingT = 0
ENT.CT_MoveTypeSwim = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(9, 9, 15), Vector(-9, -9, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && self.CT_MoveTypeSwim then
		return ACT_SWIM
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:WaterLevel() < 2 then
		if self.CT_MoveTypeSwim then
			self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
			self.CT_MoveTypeSwim = false
		end
	elseif !self.CT_MoveTypeSwim then
		self:DoChangeMovementType(VJ_MOVETYPE_AQUATIC)
		self.CT_MoveTypeSwim = true
	end
	
	if !self.Dead && CurTime() > self.CT_BlinkingT then
		self:SetSkin(1)
		timer.Simple(0.15, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.25, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.4, function() if IsValid(self) then self:SetSkin(0) end end)
		self.CT_BlinkingT = CurTime() + math.Rand(2, 3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	-- Don't play death animation if swimming
	if status == "Init" && self.CT_MoveTypeSwim then
		self.HasDeathAnimation = false
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
		effectData:SetScale(40)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", Pos = self:LocalToWorld(Vector(0, 0, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", Pos = self:LocalToWorld(Vector(1, 0, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", Pos = self:LocalToWorld(Vector(0, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", Pos = self:LocalToWorld(Vector(1, 1, 5))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", Pos = self:LocalToWorld(Vector(0, 0, 6))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", Pos = self:LocalToWorld(Vector(0, 0, 7))})
	self:PlaySoundSystem("Gib", "vj_hlr/gsrc/npc/chumtoad/toad_blast1.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	corpse:SetSkin(2)
	VJ.HLR_ApplyCorpseSystem(self, corpse, gibs)
end
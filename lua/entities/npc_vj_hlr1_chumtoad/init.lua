AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/chumtoad.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 15
ENT.HullType = HULL_TINY
ENT.SightDistance = 250 -- How far it can see
ENT.MovementType = VJ_MOVETYPE_GROUND -- How the NPC moves around
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 80 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.VJC_Data = {
    ThirdP_Offset = Vector(15, 0, 10), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 neck", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(2, 0, 2), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = false -- Can it open doors?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- Type of AI behavior to use for this NPC
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE -- Death Animations
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH, ACT_BIG_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/chumtoad/toad_hunt1.wav","vj_hlr/hl1_npc/chumtoad/toad_hunt2.wav","vj_hlr/hl1_npc/chumtoad/toad_hunt3.wav","vj_hlr/hl1_npc/chumtoad/toad_deploy1.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/chumtoad/toad_idle1.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/chumtoad/toad_die1.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.CT_BlinkingT = 0
ENT.CT_MoveTypeSwim = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
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
function ENT:CustomOnThink()
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
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	-- Don't play death animation if swimming
	if self.CT_MoveTypeSwim then
		self.HasDeathAnimation = false
	end
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
		effectData:SetScale(40)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1,0,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,1,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1,1,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,6))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,7))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self,"vj_hlr/hl1_npc/chumtoad/toad_blast1.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetSkin(2)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
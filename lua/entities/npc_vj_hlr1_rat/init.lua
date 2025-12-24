AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/bigrat.mdl"
ENT.StartHealth = 10
ENT.SightAngle = 120
ENT.HullType = HULL_TINY
ENT.ControllerParams = {
	FirstP_Bone = "bip01 head",
	FirstP_Offset = Vector(0, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CanOpenDoors = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Red"}
ENT.HasBloodPool = false

-- Does it ever actually attack? Who knows!
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 3
ENT.TimeUntilMeleeAttackDamage = false

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE

ENT.CanFlinch = true
ENT.FlinchChance = 4
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/rat/rat_idle1.wav", "vj_hlr/gsrc/npc/rat/rat_idle2.wav", "vj_hlr/gsrc/npc/rat/rat_idle3.wav", "vj_hlr/gsrc/npc/rat/rat_idle4.wav"}
ENT.SoundTbl_Alert = "vj_hlr/gsrc/npc/rat/rat_fear.wav"
ENT.SoundTbl_Pain = "vj_hlr/gsrc/npc/rat/rat_fear.wav"
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/rat/rat_die1.wav", "vj_hlr/gsrc/npc/rat/rat_die2.wav", "vj_hlr/gsrc/npc/rat/rat_die3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(10, 10, 10), Vector(-10, -10, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "attack" then
		self:ExecuteMeleeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorRed)
		effectData:SetScale(30)
		util.Effect("VJ_Blood1", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {BloodType = "Red", CollisionDecal = "VJ_HLR1_Blood_Red"})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/flesh3.mdl"}
--
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	VJ.HLR_ApplyCorpseSystem(self, corpse, gibs)
end
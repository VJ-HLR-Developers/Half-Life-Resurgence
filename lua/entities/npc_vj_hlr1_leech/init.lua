AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/leech.mdl"
ENT.StartHealth = 15
ENT.SightAngle = 240
ENT.HullType = HULL_TINY
ENT.TurningUseAllAxis = true
ENT.MovementType = VJ_MOVETYPE_AQUATIC
ENT.Aquatic_SwimmingSpeed_Calm = 80
ENT.Aquatic_SwimmingSpeed_Alerted = 200
ENT.Aquatic_AnimTbl_Calm = ACT_SWIM_IDLE
ENT.Aquatic_AnimTbl_Alerted = ACT_SWIM
ENT.IdleAlwaysWander = true
ENT.ControllerParameters = {
    ThirdP_Offset = Vector(29, 0, 10),
    FirstP_Bone = "Bone01",
    FirstP_Offset = Vector(0, 0, 0),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 1
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.TimeUntilMeleeAttackDamage = 0.1
ENT.MeleeAttackDistance = 5
ENT.MeleeAttackDamageDistance = 10
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
	-- Don't use ACT_DIEFORWARD as it's supposed to be played as end of death animation
ENT.PropInteraction = false

ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/leech/leech_alert1.wav", "vj_hlr/hl1_npc/leech/leech_alert2.wav"}
//ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/leech/leech_alert1.wav", "vj_hlr/hl1_npc/leech/leech_alert2.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/leech/leech_bite1.wav", "vj_hlr/hl1_npc/leech/leech_bite2.wav", "vj_hlr/hl1_npc/leech/leech_bite3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(4, 4, 3), Vector(-4, -4, -2))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if self:WaterLevel() == 0 then
			self.HasMeleeAttack = false
			self.HasDeathAnimation = false
			return ACT_HOP
		else
			self.HasMeleeAttack = true
			self.HasDeathAnimation = true
			return ACT_SWIM_IDLE
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
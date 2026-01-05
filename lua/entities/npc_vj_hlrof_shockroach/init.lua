include("entities/npc_vj_hlr1_headcrab/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/shockroach.mdl"
ENT.StartHealth = 10
ENT.EntitiesToNoCollide = false
ENT.ControllerParams = {
    ThirdP_Offset = Vector(15, 0, 0),
    FirstP_Bone = "Bone07",
    FirstP_Offset = Vector(0, 0, 0),
	//FirstP_ShrinkBone = false,
}
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
ENT.DisableFootStepSoundTimer = true

ENT.SoundTbl_FootStep = "vj_hlr/gsrc/npc/shockroach/shock_walk.wav"
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/shockroach/shock_idle1.wav", "vj_hlr/gsrc/npc/shockroach/shock_idle2.wav", "vj_hlr/gsrc/npc/shockroach/shock_idle3.wav"}
ENT.SoundTbl_Alert = "vj_hlr/gsrc/npc/shockroach/shock_angry.wav"
ENT.SoundTbl_LeapAttackJump = {"vj_hlr/gsrc/npc/shockroach/shock_jump1.wav", "vj_hlr/gsrc/npc/shockroach/shock_jump2.wav"}
ENT.SoundTbl_LeapAttackDamage = "vj_hlr/gsrc/npc/shockroach/shock_bite.wav"
ENT.SoundTbl_Pain = "vj_hlr/gsrc/npc/shockroach/shock_flinch.wav"
ENT.SoundTbl_Death = "vj_hlr/gsrc/npc/shockroach/shock_die.wav"

-- Custom --
ENT.SRoach_Life = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if self.SRoach_Life != nil then
		timer.Simple(self.SRoach_Life, function()
			if IsValid(self) && !self.Dead then
				self:TakeDamage(self:Health() + 1, self, self)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "step" then
		self:PlayFootstepSound()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	self:PlayAnim("angry", true, false, true) -- Shockroach always plays alert animation
end
include("entities/npc_vj_hlr1_headcrab/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/shockroach.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 10
ENT.EntitiesToNoCollide = false -- Set to a table of entity class names for the NPC to not collide with otherwise leave it to false
ENT.VJC_Data = {
    ThirdP_Offset = Vector(15, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone07", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
	//FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
ENT.VJ_NPC_Class = {"CLASS_RACE_X"} -- NPCs with the same class with be allied to each other
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = "vj_hlr/hl1_npc/shockroach/shock_walk.wav"
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/shockroach/shock_idle1.wav", "vj_hlr/hl1_npc/shockroach/shock_idle2.wav", "vj_hlr/hl1_npc/shockroach/shock_idle3.wav"}
ENT.SoundTbl_Alert = "vj_hlr/hl1_npc/shockroach/shock_angry.wav"
ENT.SoundTbl_LeapAttackJump = {"vj_hlr/hl1_npc/shockroach/shock_jump1.wav", "vj_hlr/hl1_npc/shockroach/shock_jump2.wav"}
ENT.SoundTbl_LeapAttackDamage = "vj_hlr/hl1_npc/shockroach/shock_bite.wav"
ENT.SoundTbl_Pain = "vj_hlr/hl1_npc/shockroach/shock_flinch.wav"
ENT.SoundTbl_Death = "vj_hlr/hl1_npc/shockroach/shock_die.wav"

-- Custom --
ENT.SRoach_Life = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self.SRoach_Life != nil then
		timer.Simple(self.SRoach_Life, function()
			if IsValid(self) && !self.Dead then
				self:TakeDamage(self:Health() + 1, self, self)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	self:VJ_ACT_PLAYACTIVITY("angry", true, false, true) -- Shockroach always plays alert animation
end
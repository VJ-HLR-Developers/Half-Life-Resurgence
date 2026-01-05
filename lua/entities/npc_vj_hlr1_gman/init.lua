AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/gman.mdl"
ENT.StartHealth = 999999
ENT.HullType = HULL_HUMAN
ENT.ControllerParams = {
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(6, 0, 5),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.Behavior = VJ_BEHAVIOR_PASSIVE
ENT.Passive_RunOnTouch = false -- Should it run away and make a alert sound when something collides with it?
ENT.DamageResponse = false
ENT.EnemyDetection = false
ENT.GodMode = true
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Red"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = false
ENT.YieldToAlliedPlayers = false
ENT.HasOnPlayerSight = true
ENT.DisableFootStepSoundTimer = true

ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/pl_step1.wav", "vj_hlr/gsrc/pl_step2.wav", "vj_hlr/gsrc/pl_step3.wav", "vj_hlr/gsrc/pl_step4.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/gsrc/npc/gman/gman_nasty.wav", "vj_hlr/gsrc/npc/gman/gman_choose1.wav", "vj_hlr/gsrc/npc/gman/gman_choose2.wav", "vj_hlr/gsrc/npc/gman/gman_otherwise.wav"}
ENT.SoundTbl_FollowPlayer = {"vj_hlr/gsrc/npc/gman/gman_potential.wav", "vj_hlr/gsrc/npc/gman/gman_wise.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/gsrc/npc/gman/gman_nowork.wav", "vj_hlr/gsrc/npc/gman/gman_noreg.wav"}
ENT.SoundTbl_OnPlayerSight = "vj_hlr/gsrc/npc/gman/gman_suit.wav"

ENT.MainSoundPitch = 100

-- Custom
ENT.GMAN_NextMouthMove = 0
ENT.GMAN_NextMouthDistance = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:AddFlags(FL_NOTARGET)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnIdleDialogue(ent, status, statusData)
	-- Only talk to players!
	if status == "CheckEnt" && !ent:IsPlayer() then
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if CurTime() < self.GMAN_NextMouthMove then
		if self.GMAN_NextMouthDistance == 0 then
			self.GMAN_NextMouthDistance = math.random(10, 70)
		else
			self.GMAN_NextMouthDistance = 0
		end
		self:SetPoseParameter("m", self.GMAN_NextMouthDistance)
	else
		self:SetPoseParameter("m", 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	self.GMAN_NextMouthMove = CurTime() + SoundDuration(sdFile)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Init" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
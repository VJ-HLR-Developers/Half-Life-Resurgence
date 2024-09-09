AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/gman.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 999999
ENT.HullType = HULL_HUMAN
ENT.VJC_Data = {
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(6, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- Doesn't attack anything
ENT.Passive_RunOnTouch = false -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_RunOnDamage = false -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.DisableMakingSelfEnemyToNPCs = true -- Disables the "AddEntityRelationship" that runs in think
ENT.GodMode = true -- Immune to everything
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
ENT.MoveOutOfFriendlyPlayersWay = false -- Should the NPC move and give space to friendly players?
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/gman/gman_nasty.wav","vj_hlr/hl1_npc/gman/gman_choose1.wav","vj_hlr/hl1_npc/gman/gman_choose2.wav","vj_hlr/hl1_npc/gman/gman_otherwise.wav"}
ENT.SoundTbl_FollowPlayer = {"vj_hlr/hl1_npc/gman/gman_potential.wav","vj_hlr/hl1_npc/gman/gman_wise.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/hl1_npc/gman/gman_nowork.wav","vj_hlr/hl1_npc/gman/gman_noreg.wav"}
ENT.SoundTbl_OnPlayerSight = {"vj_hlr/hl1_npc/gman/gman_suit.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.GMAN_NextMouthMove = 0
ENT.GMAN_NextMouthDistance = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:AddFlags(FL_NOTARGET)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnIdleDialogue(ent, status, statusInfo)
	-- Only talk to players!
	if status == "CheckEnt" && !ent:IsPlayer() then
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
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
function ENT:OnPlayCreateSound(sdData, sdFile)
	self.GMAN_NextMouthMove = CurTime() + SoundDuration(sdFile)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
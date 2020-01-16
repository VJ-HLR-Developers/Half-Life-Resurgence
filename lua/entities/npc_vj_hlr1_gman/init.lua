AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/gman.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 999999
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- Doesn't attack anything
ENT.Passive_RunOnTouch = false -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_RunOnDamage = false -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.DisableMakingSelfEnemyToNPCs = true -- Disables the "AddEntityRelationship" that runs in think
ENT.GodMode = true -- Immune to everything
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.MoveOutOfFriendlyPlayersWay = false -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound

	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
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
	self.VJ_NoTarget = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIdleDialogue(argent, CanAnswer)
	if argent:IsPlayer() then
		return true
	else
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if CurTime() < self.GMAN_NextMouthMove then
		if self.GMAN_NextMouthDistance == 0 then
			self.GMAN_NextMouthDistance = math.random(10,70)
		else
			self.GMAN_NextMouthDistance = 0
		end
		self:SetPoseParameter("m",self.GMAN_NextMouthDistance)
	else
		self:SetPoseParameter("m",0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	self.GMAN_NextMouthMove = CurTime() + SoundDuration(SoundFile)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
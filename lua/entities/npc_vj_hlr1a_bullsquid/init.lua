include("entities/npc_vj_hlr1_bullsquid/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/bullsquid.mdl"
ENT.StartHealth = 180
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1

ENT.SoundTbl_SoundTrack = "vj_hlr/hla_npc/squidding.mp3"

-- Custom
ENT.Bullsquid_Type = 1
ENT.Bullsquid_BullSquidding = false
ENT.Bullsquid_BullSquiddingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	-- BullSquidding!
	if math.random(1, 100) == 1 then
		self:Bullsquid_ActivateBullSquidding()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PreSpawn" then
		projectile.Spit_AlphaStyle = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Transform into a BullSquidding! (Irreversible!)")
	
	function controlEnt:OnKeyPressed(key)
		local npc = self.VJCE_NPC
		if key == KEY_SPACE && !npc.Bullsquid_BullSquidding then
			npc:Bullsquid_ActivateBullSquidding()
		end
	end
	function controlEnt:OnStopControlling(keyPressed)
		local npc = self.VJCE_NPC
		-- Set the bullsquidding behavior again because exiting a controller will reset some variables
		if IsValid(npc) && npc.Bullsquid_BullSquidding then
			npc:Bullsquid_ActivateBullSquidding()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self.Bullsquid_BullSquidding then
		if act == ACT_IDLE then
			return ACT_IDLE_AGITATED
		elseif act == ACT_WALK or act == ACT_RUN then
			return ACT_RUN_AGITATED
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local baseAcceptInput = ENT.OnInput
--
function ENT:OnInput(key, activator, caller, data)
	if key == "melee_bite" or key == "melee_whip" then
		self.MeleeAttackDamage = (self.Bullsquid_BullSquidding and 200) or 35
		self:ExecuteMeleeAttack()
	else
		baseAcceptInput(self, key, activator, caller, data)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Bullsquid_ActivateBullSquidding()
	self:SetMaxLookDistance(30000)
	self:SetFOV(360)
	self.Bullsquid_BullSquidding = true
	self.Bullsquid_BullSquiddingT = CurTime()
	self.VJ_ID_Boss = true
	self.StartHealth = 1500
	self.EnemyXRayDetection = true
	self.AnimTbl_RangeAttack = false
	self.RangeAttackMaxDistance = 30000
	self.RangeAttackAngleRadius = 180
	self.RangeAttackAnimationFaceEnemy = false
	self.NextRangeAttackTime = 0
	self.TimeUntilRangeAttackProjectileRelease = 0
	self.LimitChaseDistance = false
	self.HasSoundTrack = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.Bullsquid_BullSquidding == true then
		PrintMessage(HUD_PRINTCENTER, "YOU HAVE BEEN BULLSQUIDDING FOR "..math.Round(CurTime() - self.Bullsquid_BullSquiddingT, 2).." SECONDS")
	end
end
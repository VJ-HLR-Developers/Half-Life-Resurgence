AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/bullsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 180
ENT.SoundTbl_SoundTrack = {"vj_hlr/hla_npc/squidding.mp3"}

-- Custom
ENT.Bullsquid_BullSquidding = false
ENT.Bullsquid_BullSquiddingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	self.Bullsquid_Type = 1
	
	-- BullSquidding!
	if math.random(1, 100) == 1 then
		self:Bullsquid_ActivateBullSquidding()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
	projectile.Spit_AlphaStyle = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	function controlEnt:CustomOnKeyPressed(key)
		if key == KEY_SPACE && !self.VJCE_NPC.Bullsquid_BullSquidding then
			self.VJCE_NPC:Bullsquid_ActivateBullSquidding()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("SPACE: Transform into a BullSquidding! (Irreversible!)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Bullsquid_ActivateBullSquidding()
	self.Bullsquid_BullSquidding = true
	self.Bullsquid_BullSquiddingT = CurTime()
	self.VJ_IsHugeMonster = true
	self:SetSightDistance(30000)
	self.SightAngle = 180
	self.FindEnemy_UseSphere = true
	self.FindEnemy_CanSeeThroughWalls = true
	self.StartHealth = 1500
	self.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}
	self.AnimTbl_Run = {ACT_RUN_AGITATED}
	self.AnimTbl_Walk = {ACT_RUN_AGITATED}
	self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2}
	self.DisableRangeAttackAnimation = true
	self.RangeDistance = 30000
	self.RangeAttackAngleRadius = 180
	self.RangeAttackAnimationFaceEnemy = false
	self.RangeAttackAnimationStopMovement = false
	self.NextRangeAttackTime = 0
	self.TimeUntilRangeAttackProjectileRelease = 0
	self.NoChaseAfterCertainRange = false
	self.HasSoundTrack = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
	self.MeleeAttackDamage = (self.Bullsquid_BullSquidding == true and 200) or 35
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Bullsquid_BullSquidding == true then
		PrintMessage(HUD_PRINTCENTER, "YOU HAVE BEEN BULLSQUIDDING FOR "..math.Round(CurTime() - self.Bullsquid_BullSquiddingT, 2).." SECONDS")
	end
end
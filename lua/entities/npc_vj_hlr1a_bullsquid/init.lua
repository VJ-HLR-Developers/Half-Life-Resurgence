AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/bullsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.AnimTbl_Death = {"die1","die2"} -- Death Animations
ENT.SoundTbl_SoundTrack = {"vj_hlr/hla_npc/squidding.mp3"}

ENT.Bullsquid_Boss = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	local squidder = math.random(1,100)
	self:SetCollisionBounds(Vector(40, 40 , 55), Vector(-80, -40, 0))
	if squidder = 1 then
		self.SightAngle = 180
		self.Bullsquid_Boss = 1
		self.VJ_IsHugeMonster = true
		self.HasSoundTrack = true
		self:SetHealth(1500)
		self.NextRangeAttackTime = 0.2
		self.AnimTbl_IdleStand = {ACT_IDLE_AGITATED}
		self.AnimTbl_Run = {ACT_RUN_AGITATED}
		self.AnimTbl_Walk = {ACT_RUN_AGITATED}
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,2)
	if self.Bullsquid_Boss == 1 then
		if randattack == 1 then
			self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
			self.MeleeAttackDamage = 200
			self.HasMeleeAttackKnockBack = true
		elseif randattack == 2 then
			self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
			self.MeleeAttackDamage = 200
			self.HasMeleeAttackKnockBack = true
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
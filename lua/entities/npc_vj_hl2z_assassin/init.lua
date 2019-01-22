AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/zombie_assassin.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_green_01"}
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 65 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 90 -- How far does the damage go?
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackExtraTimers = {0.65}
ENT.TimeUntilMeleeAttackDamage = 0.35
ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1.55 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 88
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {
	"physics/flesh/flesh_impact_hard1.wav",
	"physics/flesh/flesh_impact_hard2.wav",
	"physics/flesh/flesh_impact_hard3.wav",
	"physics/flesh/flesh_impact_hard4.wav",
	"physics/flesh/flesh_impact_hard5.wav",
	"physics/flesh/flesh_impact_hard6.wav",
}
ENT.SoundTbl_Breath = {"npc/stalker/breathing3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/zombie_poison/pz_warn1.wav","npc/zombie_poison/pz_warn2.wav"}
ENT.SoundTbl_Pain = {"npc/barnacle/barnacle_pull1.wav","npc/barnacle/barnacle_pull2.wav","npc/barnacle/barnacle_pull3.wav","npc/barnacle/barnacle_pull4.wav"}
ENT.SoundTbl_Death = {"npc/zombie_poison/pz_die2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- self:SetCollisionBounds(Vector(13,13,60), Vector(-13,-13,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:GetMovementActivity() == ACT_RUN then
		self.SoundTbl_FootStep = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav"}
	else
		self.SoundTbl_FootStep = {
			"physics/flesh/flesh_impact_hard1.wav",
			"physics/flesh/flesh_impact_hard2.wav",
			"physics/flesh/flesh_impact_hard3.wav",
			"physics/flesh/flesh_impact_hard4.wav",
			"physics/flesh/flesh_impact_hard5.wav",
			"physics/flesh/flesh_impact_hard6.wav",
		}
	end
	local controlled = self.VJ_IsBeingControlled
	if IsValid(self:GetEnemy()) && !controlled then
		local dist = self:VJ_GetNearestPointToEntityDistance(self:GetEnemy())
		if self:GetEnemy():IsPlayer() && !(self:GetEnemy():GetForward():Dot((self:GetPos() -self:GetEnemy():GetPos()):GetNormalized()) > math.cos(math.rad(60))) && dist > 600 then
			// Stalk the player
			self.AnimTbl_Run = {ACT_WALK}
		else
			self.AnimTbl_Run = {ACT_RUN}
		end
	else
		self.AnimTbl_Run = {ACT_RUN}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
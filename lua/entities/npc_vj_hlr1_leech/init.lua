AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/leech.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 15
ENT.HullType = HULL_TINY
ENT.TurningUseAllAxis = true -- If set to true, angles will not be restricted to y-axis, it will change all axes (plural axis)
ENT.MovementType = VJ_MOVETYPE_AQUATIC -- How does the SNPC move?
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 200 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.Aquatic_AnimTbl_Calm = {"swim"} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {"swim2"} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
--ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 1
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.1 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 20 -- How far does the damage go?
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEFORWARD,ACT_DIESIMPLE} -- Death Animations
ENT.PushProps = false -- Should it push props when trying to move?
ENT.AttackProps = false -- Should it attack props when trying to move?
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/leech/leech_alert1.wav","vj_hlr/hl1_npc/leech/leech_alert2.wav"}
//ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/leech/leech_alert1.wav","vj_hlr/hl1_npc/leech/leech_alert2.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/leech/leech_bite1.wav","vj_hlr/hl1_npc/leech/leech_bite2.wav","vj_hlr/hl1_npc/leech/leech_bite3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(4, 4, 3), Vector(-4, -4, -2))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Dead == false && self:WaterLevel() == 0 then
		self.HasMeleeAttack = false
		self.AnimTbl_IdleStand = {ACT_HOP}
	else
		self.HasMeleeAttack = true
		self.AnimTbl_IdleStand = {"swim"}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
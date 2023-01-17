AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/agrunt.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
	FirstP_Bone = "unnamed034", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(12, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}

-- Custom
ENT.AGrunt_Type = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	self.SoundTbl_Idle = {"vj_hlr/hla_npc/agrunt/ag_idle1.wav","vj_hlr/hla_npc/agrunt/ag_idle2.wav","vj_hlr/hla_npc/agrunt/ag_idle3.wav","vj_hlr/hla_npc/agrunt/ag_idle4.wav","vj_hlr/hla_npc/agrunt/ag_idle5.wav","vj_hlr/hla_npc/agrunt/ag_idle6.wav","vj_hlr/hla_npc/agrunt/ag_idle7.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hla_npc/agrunt/ag_alert1.wav","vj_hlr/hla_npc/agrunt/ag_alert2.wav","vj_hlr/hla_npc/agrunt/ag_alert3.wav"}
	self.SoundTbl_MeleeAttackExtra = {"vj_hlr/hla_npc/agrunt/ag_attack1.wav"}
	self.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
	self.SoundTbl_BeforeMeleeAttack = {} // "vj_hlr/hla_npc/agrunt/ag_attack2.wav" -- Unused sound in Alpha (Sounds like it's stuttering or machine gun lol)
	self.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/agrunt/ag_attack1.wav","vj_hlr/hl1_npc/agrunt/ag_attack2.wav","vj_hlr/hl1_npc/agrunt/ag_attack3.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hla_npc/agrunt/ag_pain1.wav","vj_hlr/hla_npc/agrunt/ag_pain2.wav","vj_hlr/hla_npc/agrunt/ag_pain3.wav","vj_hlr/hla_npc/agrunt/ag_pain4.wav","vj_hlr/hla_npc/agrunt/ag_pain5.wav"}
	self.SoundTbl_Death = {"vj_hlr/hla_npc/agrunt/ag_die1.wav","vj_hlr/hla_npc/agrunt/ag_die2.wav","vj_hlr/hla_npc/agrunt/ag_die3.wav"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
	projectile.Hornet_Alpha = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	if hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = {ACT_DIEFORWARD}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	-- Overwrite it to do nothing
end
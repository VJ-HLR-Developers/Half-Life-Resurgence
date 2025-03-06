include("entities/npc_vj_hlr1_aliengrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/agrunt.mdl"
ENT.ControllerParams = {
	FirstP_Bone = "unnamed034",
	FirstP_Offset = Vector(12, 0, 5),
	FirstP_ShrinkBone = false,
}

-- Custom
ENT.AGrunt_Type = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	self.SoundTbl_Idle = {"vj_hlr/gsrc/npc/agrunt_alpha/ag_idle1.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_idle2.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_idle3.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_idle4.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_idle5.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_idle6.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_idle7.wav"}
	self.SoundTbl_Alert = {"vj_hlr/gsrc/npc/agrunt_alpha/ag_alert1.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_alert2.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_alert3.wav"}
	self.SoundTbl_MeleeAttackExtra = "vj_hlr/gsrc/npc/agrunt_alpha/ag_attack1.wav"
	self.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav", "vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
	self.SoundTbl_BeforeMeleeAttack = {} // "vj_hlr/gsrc/npc/agrunt_alpha/ag_attack2.wav" -- Unused sound in Alpha (Sounds like it's stuttering or machine gun lol)
	self.SoundTbl_BeforeRangeAttack = {"vj_hlr/gsrc/npc/agrunt/ag_attack1.wav", "vj_hlr/gsrc/npc/agrunt/ag_attack2.wav", "vj_hlr/gsrc/npc/agrunt/ag_attack3.wav"}
	self.SoundTbl_Pain = {"vj_hlr/gsrc/npc/agrunt_alpha/ag_pain1.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_pain2.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_pain3.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_pain4.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_pain5.wav"}
	self.SoundTbl_Death = {"vj_hlr/gsrc/npc/agrunt_alpha/ag_die1.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_die2.wav", "vj_hlr/gsrc/npc/agrunt_alpha/ag_die3.wav"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local orgRangeFunc = ENT.OnRangeAttackExecute
--
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PreSpawn" then
		projectile.Hornet_Alpha = true
	end
	orgRangeFunc(self, status, enemy, projectile)
end
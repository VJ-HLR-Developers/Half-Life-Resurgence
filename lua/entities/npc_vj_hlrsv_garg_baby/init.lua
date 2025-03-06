include("entities/npc_vj_hlr1_garg/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/sven/babygarg.mdl"
ENT.StartHealth = 500
ENT.HullType = HULL_HUMAN
ENT.VJ_ID_Boss = false
ENT.ControllerParams = {
    ThirdP_Offset = Vector(15, 0, -15),
}
ENT.BloodParticle = {"vj_hlr_blood_yellow"}

ENT.MeleeAttackDamage = 20
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.MeleeAttackDistance = 70
ENT.MeleeAttackDamageDistance = 75

ENT.HasRangeAttack = false

ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/npc/babygarg/gar_step1.wav", "vj_hlr/gsrc/npc/babygarg/gar_step2.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/babygarg/gar_breathe1.wav", "vj_hlr/gsrc/npc/babygarg/gar_breathe2.wav", "vj_hlr/gsrc/npc/babygarg/gar_breathe3.wav", "vj_hlr/gsrc/npc/babygarg/gar_idle1.wav", "vj_hlr/gsrc/npc/babygarg/gar_idle2.wav", "vj_hlr/gsrc/npc/babygarg/gar_idle3.wav", "vj_hlr/gsrc/npc/babygarg/gar_idle4.wav", "vj_hlr/gsrc/npc/babygarg/gar_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/babygarg/gar_alert1.wav", "vj_hlr/gsrc/npc/babygarg/gar_alert2.wav", "vj_hlr/gsrc/npc/babygarg/gar_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/gsrc/npc/babygarg/gar_attack1.wav", "vj_hlr/gsrc/npc/babygarg/gar_attack2.wav", "vj_hlr/gsrc/npc/babygarg/gar_attack3.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"weapons/cbar_hitbod1.wav", "weapons/cbar_hitbod2.wav", "weapons/cbar_hitbod3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav", "vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/babygarg/gar_pain1.wav", "vj_hlr/gsrc/npc/babygarg/gar_pain2.wav", "vj_hlr/gsrc/npc/babygarg/gar_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/babygarg/gar_die1.wav", "vj_hlr/gsrc/npc/babygarg/gar_die2.wav"}

ENT.BreathSoundPitch = VJ.SET(130, 130)

-- Custom
ENT.Garg_Type = 1
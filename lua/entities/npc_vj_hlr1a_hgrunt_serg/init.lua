include("entities/npc_vj_hlr1_hgrunt_serg/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/hassault.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2, ACT_MELEE_ATTACK_SWING} -- Melee Attack Animations
ENT.HasGrenadeAttack = false -- Should the NPC have a grenade attack?
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed_bone_020", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(3, 0, 5), -- The offset for the controller when the camera is in first person
}

ENT.GeneralSoundPitch1 = 90
ENT.GeneralSoundPitch2 = 100

ENT.Serg_Type = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	self.SoundTbl_Idle = {"vj_hlr/hla_npc/hgrunt/gr_idle1.wav","vj_hlr/hla_npc/hgrunt/gr_idle2.wav","vj_hlr/hla_npc/hgrunt/gr_idle3.wav","vj_hlr/hla_npc/hgrunt/gr_radio1.wav","vj_hlr/hla_npc/hgrunt/gr_radio2.wav","vj_hlr/hla_npc/hgrunt/gr_radio3.wav","vj_hlr/hla_npc/hgrunt/gr_radio4.wav","vj_hlr/hla_npc/hgrunt/gr_radio5.wav","vj_hlr/hla_npc/hgrunt/gr_radio6.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hla_npc/hgrunt/gr_radio1.wav","vj_hlr/hla_npc/hgrunt/gr_radio2.wav","vj_hlr/hla_npc/hgrunt/gr_radio3.wav","vj_hlr/hla_npc/hgrunt/gr_radio4.wav","vj_hlr/hla_npc/hgrunt/gr_radio5.wav","vj_hlr/hla_npc/hgrunt/gr_radio6.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hla_npc/hassault/hw_alert.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/hla_npc/hgrunt/gr_squadform.wav"}
	self.SoundTbl_WeaponReload = {"vj_hlr/hla_npc/hgrunt/gr_cover2.wav"}
	self.SoundTbl_GrenadeAttack = {"vj_hlr/hla_npc/hgrunt/gr_loadtalk.wav"}
	
	-- Melee Alpha Human Grunt Sergeant
	if self.Serg_Type == 2 then
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:GetDamage() > 30 then
		self.FlinchChance = 8
		self.AnimTbl_Flinch = ACT_BIG_FLINCH
	else
		self.FlinchChance = 16
		self.AnimTbl_Flinch = ACT_SMALL_FLINCH
	end
end
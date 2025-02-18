include("entities/npc_vj_hlr1_hgrunt_serg/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/hassault.mdl"
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2, ACT_MELEE_ATTACK_SWING}
ENT.HasGrenadeAttack = false
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "unnamed_bone_020",
    FirstP_Offset = Vector(3, 0, 5),
}

ENT.MainSoundPitch = VJ.SET(90, 100)

ENT.Serg_Type = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	self.SoundTbl_Idle = {"vj_hlr/hla_npc/hgrunt/gr_idle1.wav", "vj_hlr/hla_npc/hgrunt/gr_idle2.wav", "vj_hlr/hla_npc/hgrunt/gr_idle3.wav", "vj_hlr/hla_npc/hgrunt/gr_radio1.wav", "vj_hlr/hla_npc/hgrunt/gr_radio2.wav", "vj_hlr/hla_npc/hgrunt/gr_radio3.wav", "vj_hlr/hla_npc/hgrunt/gr_radio4.wav", "vj_hlr/hla_npc/hgrunt/gr_radio5.wav", "vj_hlr/hla_npc/hgrunt/gr_radio6.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hla_npc/hgrunt/gr_radio1.wav", "vj_hlr/hla_npc/hgrunt/gr_radio2.wav", "vj_hlr/hla_npc/hgrunt/gr_radio3.wav", "vj_hlr/hla_npc/hgrunt/gr_radio4.wav", "vj_hlr/hla_npc/hgrunt/gr_radio5.wav", "vj_hlr/hla_npc/hgrunt/gr_radio6.wav"}
	self.SoundTbl_Alert = "vj_hlr/hla_npc/hassault/hw_alert.wav"
	self.SoundTbl_CallForHelp = "vj_hlr/hla_npc/hgrunt/gr_squadform.wav"
	self.SoundTbl_WeaponReload = "vj_hlr/hla_npc/hgrunt/gr_cover2.wav"
	self.SoundTbl_GrenadeAttack = "vj_hlr/hla_npc/hgrunt/gr_loadtalk.wav"
	
	-- Melee Alpha Human Grunt Sergeant
	if self.Serg_Type == 2 then
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" then
		if dmginfo:GetDamage() > 30 then
			self.FlinchChance = 8
			self.AnimTbl_Flinch = ACT_BIG_FLINCH
		else
			self.FlinchChance = 16
			self.AnimTbl_Flinch = ACT_SMALL_FLINCH
		end
	end
end
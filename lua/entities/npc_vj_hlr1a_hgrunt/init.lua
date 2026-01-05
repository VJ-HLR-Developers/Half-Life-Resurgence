include("entities/npc_vj_hlr1_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/hgrunt.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "unnamed022",
    FirstP_Offset = Vector(2, 0, 5),
}
ENT.HasGrenadeAttack = false
ENT.Weapon_SecondaryFireTime = 1.2
ENT.Weapon_Strafe = true
ENT.CanTurnWhileMoving = true

-- Custom
ENT.AHGR_NextStrafeT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	local randSkin = math.random(0, 3)
	if randSkin == 1 then
		self:SetSkin(1)
	elseif randSkin == 2 then
		self:SetSkin(2)
	elseif randSkin == 3 then
		self:SetBodygroup(0, 1)
	end
	self.SoundTbl_Idle = {"vj_hlr/gsrc/npc/hgrunt_alpha/gr_idle1.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_idle2.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_idle3.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio1.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio2.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio3.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio4.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio5.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio6.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio1.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio2.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio3.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio4.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio5.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_radio6.wav"}
	self.SoundTbl_Alert = "vj_hlr/gsrc/npc/hgrunt_alpha/gr_alert1.wav"
	self.SoundTbl_CallForHelp = "vj_hlr/gsrc/npc/hgrunt_alpha/gr_squadform.wav"
	self.SoundTbl_WeaponReload = "vj_hlr/gsrc/npc/hgrunt_alpha/gr_cover2.wav"
	self.SoundTbl_GrenadeAttack = "vj_hlr/gsrc/npc/hgrunt_alpha/gr_loadtalk.wav"
	self.AHGR_NextStrafeT = CurTime() + 4
end
---------------------------------------------------------------------------------------------------------------------------------------------
local strafeAnims = {ACT_STRAFE_RIGHT, ACT_STRAFE_LEFT}
--
function ENT:OnWeaponStrafe()
	self:PlayAnim(strafeAnims, true, false, false)
	return false
end
include("entities/npc_vj_hlr1_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/hgrunt.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed022", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(2, 0, 5), -- The offset for the controller when the camera is in first person
}
ENT.HasGrenadeAttack = false
ENT.Weapon_SecondaryFireTime = 1.2
ENT.Weapon_StrafeWhileFiring = true -- Should it move randomly while firing a weapon?
ENT.CanTurnWhileMoving = true -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way

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
	self.SoundTbl_Idle = {"vj_hlr/hla_npc/hgrunt/gr_idle1.wav","vj_hlr/hla_npc/hgrunt/gr_idle2.wav","vj_hlr/hla_npc/hgrunt/gr_idle3.wav","vj_hlr/hla_npc/hgrunt/gr_radio1.wav","vj_hlr/hla_npc/hgrunt/gr_radio2.wav","vj_hlr/hla_npc/hgrunt/gr_radio3.wav","vj_hlr/hla_npc/hgrunt/gr_radio4.wav","vj_hlr/hla_npc/hgrunt/gr_radio5.wav","vj_hlr/hla_npc/hgrunt/gr_radio6.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hla_npc/hgrunt/gr_radio1.wav","vj_hlr/hla_npc/hgrunt/gr_radio2.wav","vj_hlr/hla_npc/hgrunt/gr_radio3.wav","vj_hlr/hla_npc/hgrunt/gr_radio4.wav","vj_hlr/hla_npc/hgrunt/gr_radio5.wav","vj_hlr/hla_npc/hgrunt/gr_radio6.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hla_npc/hgrunt/gr_alert1.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/hla_npc/hgrunt/gr_squadform.wav"}
	self.SoundTbl_WeaponReload = {"vj_hlr/hla_npc/hgrunt/gr_cover2.wav"}
	self.SoundTbl_GrenadeAttack = {"vj_hlr/hla_npc/hgrunt/gr_loadtalk.wav"}
	self.AHGR_NextStrafeT = CurTime() + 4
end
---------------------------------------------------------------------------------------------------------------------------------------------
local strafeAnims = {ACT_STRAFE_RIGHT, ACT_STRAFE_LEFT}
--
function ENT:OnWeaponStrafeWhileFiring()
	self:PlayAnim(strafeAnims, true, false, false)
	return false
end
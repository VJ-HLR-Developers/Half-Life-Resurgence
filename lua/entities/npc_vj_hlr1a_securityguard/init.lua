include("entities/npc_vj_hlr1_securityguard/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/barney.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, -20),
    FirstP_Bone = "unnamed038",
    FirstP_Offset = Vector(1, 0, 5),
}
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIEVIOLENT, "diecrump", ACT_DIESIMPLE}

ENT.SoundTbl_IdleDialogueAnswer = "vj_hlr/hla_npc/barney/ba_pain1.wav"
ENT.SoundTbl_Alert = "vj_hlr/hla_npc/barney/ba_attack1.wav"
ENT.SoundTbl_BecomeEnemyToPlayer = "vj_hlr/hla_npc/barney/ba_attack1.wav"
ENT.SoundTbl_Pain = "vj_hlr/hla_npc/barney/ba_pain1.wav"
ENT.SoundTbl_Death = {"vj_hlr/hla_npc/barney/ba_die1.wav", "vj_hlr/hla_npc/barney/ba_die2.wav", "vj_hlr/hla_npc/barney/ba_die3.wav"}

ENT.Security_Type = 2
---------------------------------------------------------------------------------------------------------------------------------------------
local baseInit = ENT.Init
--
function ENT:Init()
	baseInit(self)
	self:Give("weapon_vj_hlr1_glock17")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- We have no barnacle or guarding animations, so just override it to do nothing
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_UnHolsterGun()
	self:StopMoving()
	self:SetWeaponState()
	if math.random(1, 2) == 1 then
		self:PlayAnim(ACT_ARM, true, false, true)
		timer.Simple(0.3, function() if IsValid(self) then self:SetBodygroup(1, 1) end end)
	else
		self:PlayAnim("drawslow", true, false, true)
		timer.Simple(0.85, function() if IsValid(self) then self:SetBodygroup(1, 1) end end)
	end
end
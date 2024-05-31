include("entities/npc_vj_hlr1_securityguard/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/barney.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed038", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 5), -- The offset for the controller when the camera is in first person
}
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIEVIOLENT, "diecrump", ACT_DIESIMPLE}

ENT.SoundTbl_IdleDialogueAnswer = "vj_hlr/hla_npc/barney/ba_pain1.wav"
ENT.SoundTbl_Alert = "vj_hlr/hla_npc/barney/ba_attack1.wav"
ENT.SoundTbl_BecomeEnemyToPlayer = "vj_hlr/hla_npc/barney/ba_attack1.wav"
ENT.SoundTbl_Pain = "vj_hlr/hla_npc/barney/ba_pain1.wav"
ENT.SoundTbl_Death = {"vj_hlr/hla_npc/barney/ba_die1.wav","vj_hlr/hla_npc/barney/ba_die2.wav","vj_hlr/hla_npc/barney/ba_die3.wav"}

ENT.Security_Type = 2
---------------------------------------------------------------------------------------------------------------------------------------------
local baseInit = ENT.CustomOnInitialize
--
function ENT:CustomOnInitialize()
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
		self:VJ_ACT_PLAYACTIVITY(ACT_ARM, true, false, true)
		timer.Simple(0.3, function() if IsValid(self) then self:SetBodygroup(1, 1) end end)
	else
		self:VJ_ACT_PLAYACTIVITY("drawslow", true, false, true)
		timer.Simple(0.85, function() if IsValid(self) then self:SetBodygroup(1, 1) end end)
	end
end
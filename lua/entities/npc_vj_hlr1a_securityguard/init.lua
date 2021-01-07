AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/barney.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed038", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_CustomOnInitialize()
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hla_npc/barney/ba_pain1.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hla_npc/barney/ba_attack1.wav"}
	self.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hla_npc/barney/ba_attack1.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hla_npc/barney/ba_pain1.wav"}
	self.SoundTbl_Death = {"vj_hlr/hla_npc/barney/ba_die1.wav","vj_hlr/hla_npc/barney/ba_die2.wav","vj_hlr/hla_npc/barney/ba_die3.wav"}
	
	self.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIEVIOLENT,"diecrump",ACT_DIESIMPLE} -- Death Animations
	
	self:Give("weapon_vj_hlr1_glock17")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_UnHolsterGun()
	self:StopMoving()
	self.Security_GunHolstered = false
	if math.random(1,2) == 1 then
		self:VJ_ACT_PLAYACTIVITY(ACT_ARM, true, false, true)
		timer.Simple(0.3,function() if IsValid(self) then self:SetBodygroup(1,1) end end)
	else
		self:VJ_ACT_PLAYACTIVITY("drawslow", true, false, true)
		timer.Simple(0.85,function() if IsValid(self) then self:SetBodygroup(1,1) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Security_GunHolstered == true && IsValid(self:GetEnemy()) then
		self:Security_UnHolsterGun()
	elseif self.Security_GunHolstered == false && !IsValid(self:GetEnemy()) && self.TimeSinceLastSeenEnemy > 5 && self.IsReloadingWeapon == false then
		self:VJ_ACT_PLAYACTIVITY(ACT_DISARM, true, false, true)
		self.Security_GunHolstered = true
		timer.Simple(1,function() if IsValid(self) then self:SetBodygroup(1,0) end end)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/barney.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_CustomOnInitialize()
	self.SoundTbl_Alert = {"vj_hlr/hla_npc/barney/ba_attack1.wav"}
	self.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hla_npc/barney/ba_attack1.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hla_npc/barney/ba_pain1.wav"}
	self.SoundTbl_Death = {"vj_hlr/hla_npc/barney/ba_die1.wav","vj_hlr/hla_npc/barney/ba_die2.wav","vj_hlr/hla_npc/barney/ba_die3.wav"}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hla_npc/barney/ba_pain1.wav"}
	self.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIEVIOLENT,ACT_DIECRUMP,ACT_DIESIMPLE}
	self:Give("weapon_vj_hlr1_glock17")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_UnHolsterGun()
	self:StopMoving()
	self:VJ_ACT_PLAYACTIVITY("vjseq_draw",true,false,true)
	self.Security_GunHolstered = false
	timer.Simple(0.2,function() if IsValid(self) then self:SetBodygroup(1,1) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.Weapon_ShotsSinceLastReload = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Security_GunHolstered == true && IsValid(self:GetEnemy()) then
		self:Security_UnHolsterGun()
	elseif self.Security_GunHolstered == false && !IsValid(self:GetEnemy()) && self.TimeSinceLastSeenEnemy > 5 && self.IsReloadingWeapon == false then
		self:VJ_ACT_PLAYACTIVITY(ACT_DISARM,true,false,true)
		self.Security_GunHolstered = true
		timer.Simple(1,function() if IsValid(self) then self:SetBodygroup(1,0) end end)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
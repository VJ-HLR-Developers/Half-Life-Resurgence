AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/massn.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"}
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2,ACT_MELEE_ATTACK_SWING} -- Melee Attack Animations
ENT.HasPainSounds = false
ENT.HasDeathSounds = false

-- Custom
ENT.BOA_NextStrafeT = 0
ENT.BOA_NextRunT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	self:SetBodygroup(1,math.random(0,2))
	self:SetBodygroup(2,math.random(0,1))
	self.BOA_NextStrafeT = CurTime() + 4
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnThink()
	if IsValid(self:GetEnemy()) && self.DoingWeaponAttack_Standing == true && self.VJ_IsBeingControlled == false && CurTime() > self.BOA_NextStrafeT && !self:IsMoving() && self:GetPos():Distance(self:GetEnemy():GetPos()) < 1400 then
		self:StopMoving()
		self:VJ_ACT_PLAYACTIVITY({ACT_STRAFE_RIGHT,ACT_STRAFE_LEFT},true,false,false)
		self.BOA_NextRunT = CurTime() + 2
		//if self:GetBodygroup(2) == 1 then
			//self.BOA_NextStrafeT = CurTime() + 2
		//else
			self.BOA_NextStrafeT = CurTime() + 8
		//end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponAttack()
	if CurTime() > self.BOA_NextRunT then
		timer.Simple(0.8,function() 
			if IsValid(self) && !self:IsMoving() && self.Dead == false then
				self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
			end
		end)
		//if self:GetBodygroup(2) == 1 then
			///self.BOA_NextStrafeT = CurTime() + 5
			//self.BOA_NextRunT = CurTime() + 8
		//else
			self.BOA_NextStrafeT = CurTime() + 8
			self.BOA_NextRunT = CurTime() + 12
		//end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
include("entities/npc_vj_hlr1_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/massn.mdl"
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"}
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2, ACT_MELEE_ATTACK_SWING}
ENT.HasPainSounds = false
ENT.HasDeathSounds = false

-- Custom
ENT.BOA_NextStrafeT = 0
ENT.BOA_NextRunT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	self.SoundTbl_IdleDialogue = {"vj_hlr/gsrc/npc/ops/of2a5_bo01.wav", "vj_hlr/gsrc/npc/ops/of2a5_bo03.wav", "vj_hlr/gsrc/npc/ops/of6a2_bo01.wav"}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/gsrc/npc/ops/of2a5_bo02.wav", "vj_hlr/gsrc/npc/ops/of6a2_bo02.wav"}
	self.SoundTbl_Investigate = "vj_hlr/gsrc/npc/ops/of6a2_bo03.wav"

	self:SetBodygroup(1 , math.random(0, 3))
	self:SetBodygroup(2, self.HECU_Rappelling and 0 or math.random(0, 1)) -- If we spawn as a rappelling soldier, then only spawn with MP5!
	self.BOA_NextStrafeT = CurTime() + 4
end
---------------------------------------------------------------------------------------------------------------------------------------------
local animStrafing = {ACT_STRAFE_RIGHT, ACT_STRAFE_LEFT}
--
function ENT:HECU_OnThink()
	if self.VJ_IsBeingControlled then return end
	if IsValid(self:GetEnemy()) && self.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND && !self.VJ_IsBeingControlled && CurTime() > self.BOA_NextStrafeT && !self:IsMoving() && self:GetPos():Distance(self:GetEnemy():GetPos()) < 1400 then
		self:StopMoving()
		self:PlayAnim(animStrafing, true, false, false)
		self.BOA_NextRunT = CurTime() + 2
		//if self:GetBodygroup(2) == 1 then
			//self.BOA_NextStrafeT = CurTime() + 2
		//else
			self.BOA_NextStrafeT = CurTime() + 8
		//end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponAttack()
	if self.VJ_IsBeingControlled then return end
	if CurTime() > self.BOA_NextRunT then
		timer.Simple(0.8, function()
			if IsValid(self) && !self:IsMoving() && !self.Dead then
				self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
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
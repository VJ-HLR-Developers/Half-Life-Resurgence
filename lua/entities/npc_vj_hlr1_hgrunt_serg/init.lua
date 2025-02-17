include("entities/npc_vj_hlr1_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/hassault.mdl"
ENT.StartHealth = 180
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK_SWING}
ENT.GrenadeAttackThrowTime = 1
ENT.Weapon_CanReload = false
ENT.Weapon_CanMoveFire = false
ENT.CombatDamageResponse = false
ENT.Weapon_RetreatDistance = 0

ENT.SoundTbl_Breath = "vj_hlr/hl1_npc/hassault/hw_spin.wav"

ENT.BreathSoundLevel = 80

ENT.GeneralSoundPitch1 = 80
ENT.GeneralSoundPitch2 = 80

-- Custom
ENT.Serg_SpinUpT = 0
ENT.Serg_Type = 0
	-- 0 = Default
	-- 1 = Alpha
	-- 2 = Alpha Melee
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnThink()
	-- For weapon spinning sound
	if self.WeaponAttackState && self.WeaponAttackState >= VJ.WEP_ATTACK_STATE_FIRE then
		self.HasBreathSound = true
	else
		VJ.STOPSOUND(self.CurrentBreathSound)
		self.HasBreathSound = false
	end
	
	-- Reset Alpha Sergeant's gun in case the melee animation gets cut off and draw event is never called!
	if self:GetWeaponState() == VJ.WEP_STATE_HOLSTERED && self.AttackType != VJ.ATTACK_TYPE_MELEE then
		self:SetBodygroup(1, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnWeaponAttack()
	-- Do the weapon spin up routine
	if CurTime() > self.Serg_SpinUpT then
		local setTime = CurTime() + 0.9
		self.NextChaseTime = setTime -- Make sure it won't chase
		self.NextWeaponAttackT = setTime -- Make it not shoot for the given time
		self.NextBreathSoundT = setTime -- For the spinning sound
		self:PlayAnim(ACT_ARM, true, 0.9, true)
		VJ.EmitSound(self, "vj_hlr/hl1_npc/hassault/hw_spinup.wav", 80)
		self.Serg_SpinUpT = CurTime() + 4
	end
end
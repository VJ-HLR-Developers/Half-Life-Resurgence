AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/hassault.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 180
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
ENT.AllowWeaponReloading = false -- If false, the SNPC will no longer reload
ENT.HasShootWhileMoving = false -- Can it shoot while moving?
ENT.MoveOrHideOnDamageByEnemy = false -- Should the SNPC move or hide when being damaged by an enemy?
ENT.DisableCallForBackUpOnDamageAnimation = true -- Disables the animation when the CallForBackUpOnDamage function is called

ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/hassault/hw_spin.wav"}

ENT.BreathSoundLevel = 80

ENT.GeneralSoundPitch1 = 80
ENT.GeneralSoundPitch2 = 80

-- Custom
ENT.Serg_SpinUpT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnThink()
	-- Unlimited ammo
	local curWeapon = self:GetActiveWeapon()
	if IsValid(curWeapon) then
		curWeapon:SetClip1(999)
	end
	
	-- For weapon spinning sound
	if self.DoingWeaponAttack == true then
		self.HasBreathSound = true
	else
		VJ_STOPSOUND(self.CurrentBreathSound)
		self.HasBreathSound = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnWeaponAttack()
	-- Do the weapon spin up routine
	if CurTime() > self.Serg_SpinUpT then
		self.NextWeaponAttackT = CurTime() + 0.9
		self.NextBreathSoundT = CurTime() + 0.9
		self:VJ_ACT_PLAYACTIVITY(ACT_IDLE_ANGRY, true, 0.9, true)
		VJ_EmitSound(self, "vj_hlr/hl1_npc/hassault/hw_spinup.wav", 80)
		self.Serg_SpinUpT = CurTime() + 4
	end
end
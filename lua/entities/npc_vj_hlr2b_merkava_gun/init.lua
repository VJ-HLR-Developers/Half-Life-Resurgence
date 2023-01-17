AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/merkava_turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 0
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?

ENT.Tank_SoundTbl_Turning = {"vehicles/tank_turret_loop1.wav"}

ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_Shell_SpawnPos = Vector(232.1, -0.36, 9.64)
ENT.Tank_Shell_DynamicLightPos = Vector(232.1, -0.36, 9.64)
ENT.Tank_Shell_MuzzleFlashPos = Vector(232.1, -0.36, 9.64)
ENT.Tank_Shell_ParticlePos = Vector(232.1, -0.36, 9.64)

util.AddNetworkString("vj_hlr1_merkavag_shooteffects")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartShootEffects()
	if !self.Bradley_DoingMissileAtk then
		net.Start("vj_hlr1_merkavag_shooteffects")
		net.WriteEntity(self)
		net.Broadcast()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank()
	if GetConVar("vj_hlr2_merkava_gunner"):GetInt() == 0 then return end
	local att = self:GetAttachment(3)
	self.Spotter = ents.Create("npc_vj_hlr2_rebel")
	self.Spotter:SetPos(att.Pos)
	self.Spotter:SetAngles(att.Ang)
	self.Spotter:SetOwner(self)
	self.Spotter:SetParent(self)
	self.Spotter.MovementType = VJ_MOVETYPE_STATIONARY
	self.Spotter.AnimTbl_IdleStand = {ACT_IDLE_MANNEDGUN}
	self.Spotter.DisableWeapons = true
	self.Spotter.CanTurnWhileStationary = false
	self.Spotter.NoWeapon_UseScaredBehavior = false
	self.Spotter.Medic_CanBeHealed = false
	self.Spotter.Human_Driver = true
	self.Spotter.VJ_NPC_Class = self.VJ_NPC_Class
	self.Spotter:Spawn()
	self.Spotter:Fire("SetParentAttachment", "gunner")
	self.Spotter:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
	self:DeleteOnRemove(self.Spotter)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local bulletSpread = Vector(0.03490, 0.03490, 0.03490)
local sdFiringGun = {"vj_hlr/hl2_weapon/hmg1/hmg1_7.wav", "vj_hlr/hl2_weapon/hmg1/hmg1_8.wav", "vj_hlr/hl2_weapon/hmg1/hmg1_9.wav"}
--
function ENT:Tank_CustomOnThink_AIEnabled()
	local ene = self:GetEnemy()
	if IsValid(ene) && IsValid(self.Spotter) then
		-- If our enemy is the spotter, then the class changed!
		if ene == self.Spotter then
			self.Spotter.VJ_NPC_Class = self:GetParent().VJ_NPC_Class -- Get from the parent (Chassis) because the gunner's relationship is based from it!
		end
		if self.Tank_FacingTarget then
			local att = self:GetAttachment(1)
			self:FireBullets({
				Attacker = self,
				Damage = 7,
				Force = 10,
				Src = att.Pos,
				Dir = (ene:GetPos() + ene:OBBCenter() - att.Pos):Angle():Forward(),
				Spread = bulletSpread
			})
			VJ_EmitSound(self, sdFiringGun, 100, 100, 1, CHAN_WEAPON)
			ParticleEffect("vj_rifle_full", att.Pos, att.Ang, self)
			local shellEffect = EffectData()
			shellEffect:SetEntity(self)
			shellEffect:SetOrigin(att.Pos + self:GetRight()*5 + self:GetForward()*-23)
			shellEffect:SetAngles((att.Pos):Angle())
			util.Effect("RifleShellEject", shellEffect, true, true)
		end
	end
	return true
end
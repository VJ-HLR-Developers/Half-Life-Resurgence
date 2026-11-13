AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2b/merkava_turret.mdl"
ENT.StartHealth = 0

ENT.Tank_SoundTbl_Turning = "vehicles/tank_turret_loop1.wav"

ENT.Tank_Shell_SpawnPos = Vector(232.1, -0.36, 9.64)
ENT.Tank_Shell_MuzzleFlashPos = Vector(232.1, -0.36, 9.64)
ENT.Tank_Shell_ParticlePos = Vector(232.1, -0.36, 9.64)
-- Custom
ENT.Spotter_NextMGT = 0

function ENT:Tank_Init()
	if GetConVar("vj_hlr2_merkava_gunner"):GetInt() == 0 then return end
	local att = self:GetAttachment(3)
	local spotter = ents.Create("npc_vj_hlr2_rebel")
	spotter:SetPos(att.Pos)
	spotter:SetAngles(att.Ang)
	spotter:SetOwner(self)
	spotter:SetParent(self)
	spotter.MovementType = VJ_MOVETYPE_STATIONARY
	spotter.Weapon_Disabled = true
	spotter.CanTurnWhileStationary = false
	spotter.Weapon_UnarmedBehavior = false
	spotter.VJ_ID_Healable = false
	spotter.CanReceiveOrders = false
	spotter.Human_Driver = true
	spotter.VJ_NPC_Class = self.VJ_NPC_Class
	spotter.PhysgunDisabled = true
	spotter:Spawn()
	spotter:Fire("SetParentAttachment", "gunner")
	spotter:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
	self:DeleteOnRemove(spotter)
	self.Spotter = spotter
end

local bulletSpread = Vector(0.03490, 0.03490, 0.03490)
local sdFiringGun = {"vj_hlr/src/wep/hmg1/hmg1_7.wav", "vj_hlr/src/wep/hmg1/hmg1_8.wav", "vj_hlr/src/wep/hmg1/hmg1_9.wav"}
--
function ENT:Tank_OnThinkActive()
	local ene = self:GetEnemy()
	local spotter = self.Spotter
	if IsValid(ene) and IsValid(spotter) then
		-- If our enemy is the spotter, then the class changed!
		if ene == spotter then
			spotter.VJ_NPC_Class = self:GetParent().VJ_NPC_Class -- Get from the parent (Chassis) because the gunner's relationship is based from it!
		end
		if self.Tank_FacingTarget and ene:Visible(self) and CurTime() > self.Spotter_NextMGT then
			local att = self:GetAttachment(1)
			self:FireBullets({
				Attacker = spotter,
				Damage = 7,
				Force = 10,
				Src = att.Pos,
				Dir = (ene:GetPos() + ene:OBBCenter() - att.Pos):Angle():Forward(),
				Spread = bulletSpread
			})
			VJ.EmitSound(spotter, sdFiringGun, 100, 100, 1, CHAN_WEAPON)
			ParticleEffect("vj_rifle_full", att.Pos, att.Ang, self)

			local shellEffect = EffectData()
			shellEffect:SetEntity(self)
			shellEffect:SetOrigin(att.Pos + self:GetRight() * 5 + self:GetForward() * -23)
			shellEffect:SetAngles((att.Pos):Angle())
			util.Effect("RifleShellEject", shellEffect, true, true)

			local muzLight = ents.Create("light_dynamic")
			muzLight:SetKeyValue("brightness", "4")
			muzLight:SetKeyValue("distance", "120")
			muzLight:Fire("Color", "255 150 60")
			muzLight:SetParent(self)
			muzLight:Fire("SetParentAttachment", "muzzle")
			muzLight:Spawn()
			muzLight:Activate()
			muzLight:Fire("TurnOn")
			muzLight:Fire("Kill", nil, 0.07)
			self:DeleteOnRemove(muzLight)

			self.Spotter_NextMGT = CurTime() + 0.06
		end
	end
end
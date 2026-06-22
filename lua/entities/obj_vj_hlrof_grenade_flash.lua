/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_grenade"
ENT.PrintName		= "Flash Grenade"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category = "VJ Test"
ENT.Spawnable = true

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlrof_grenade_flash", ENT.PrintName, VJ.KILLICON_GRENADE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/weapons/w_fgrenade.mdl"
ENT.RadiusDamage = 0
ENT.RadiusDamageRadius = 500
ENT.CollisionDecal = "VJ_HLR1_Scorch"
ENT.SoundTbl_OnCollide = {"vj_hlr/gsrc/wep/grenade/grenade_hit1.wav", "vj_hlr/gsrc/wep/grenade/grenade_hit2.wav", "vj_hlr/gsrc/wep/grenade/grenade_hit3.wav"}
ENT.SoundTbl_OnRemove = {"vj_hlr/gsrc/wep/fgrenade/flashbang-1.wav", "vj_hlr/gsrc/wep/fgrenade/flashbang-2.wav"}
ENT.OnRemoveSoundLevel = 100

-- Custom
ENT.FuseTime = 2

util.AddNetworkString("VJ_HLR_FlashFX")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	local getVel = phys:GetVelocity()
	local curVelSpeed = getVel:Length()
	phys:SetVelocity(getVel * 0.5)

	if curVelSpeed > 100 then -- If the grenade is going faster than 100, then play the touch sound
		self:PlaySound("OnCollide")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDealDamage(data, phys, hitEnts)
	if !hitEnts then return end
	for _, ent in ipairs(hitEnts) do
		if ent:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS then
			net.Start("VJ_HLR_FlashFX")
				net.WriteEntity(ent)
			net.Send(ent)
			ent.VJ_FlashRing = CreateSound(ent, "vj_hlr/gsrc/wep/fgrenade/flashring.wav")
		elseif ent:IsNPC() then
			if ent.IsVJBaseSNPC then
				if VJ.AnimExists(ent, ACT_COWER) then ent:PlayAnim(ACT_COWER, true, false, false) end
				ent:PlaySoundSystem("Pain")
				ent.EnemyDetection = false
				ent.CanReceiveOrders = false
				ent:ResetEnemy()
				timer.Simple(5, function()
					if IsValid(ent) && !ent.EnemyDetection && !ent.CanReceiveOrders then
						ent.EnemyDetection = true
						ent.CanReceiveOrders = true
					end
				end)
			end
			ent:SetEnemy(NULL)
			ent:ClearSchedule()
			ent:ClearGoal()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vezZ50 = Vector(0, 0, 50)
local vecZ4 = Vector(0, 0, 4)
local vezZ100 = Vector(0, 0, 100)
--
function ENT:OnDestroy()
	local selfPos = self:GetPos()

	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "vj_hl/sprites/animglow01.vmt")
	spr:SetKeyValue("GlowProxySize", "2.0")
	spr:SetKeyValue("HDRColorScale", "1.0")
	spr:SetKeyValue("renderfx", "14")
	spr:SetKeyValue("rendermode", "5")
	spr:SetKeyValue("renderamt", "255")
	spr:SetKeyValue("disablereceiveshadows", "0")
	spr:SetKeyValue("mindxlevel", "0")
	spr:SetKeyValue("maxdxlevel", "0")
	spr:SetKeyValue("framerate", "15.0")
	spr:SetKeyValue("spawnflags", "0")
	spr:SetKeyValue("scale", "4")
	spr:SetPos(selfPos + vezZ50)
	spr:Spawn()
	spr:Fire("Kill", "", 0.4)
	timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "300")
	expLight:SetLocalPos(selfPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "255 255 255")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)

	self:SetLocalPos(selfPos + vecZ4) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - vezZ100,
		filter = self
	})
	util.Decal(VJ.PICK(self.CollisionDecal), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

	self:DealDamage()
	VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris" .. math.random(1, 3) .. ".wav", 80, 100)
	VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/explode" .. math.random(3, 5) .. "_dist.wav", 140, 100)
end
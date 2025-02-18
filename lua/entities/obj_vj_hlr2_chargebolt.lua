/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Charged Bolt"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

ENT.PhysicsSolidMask = MASK_SHOT
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr2_chargebolt", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/crossbow_bolt.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 65
ENT.DirectDamageType = bit.bor(DMG_SLASH, DMG_DISSOLVE, DMG_SHOCK)
ENT.CollisionDecal = "Impact.Concrete"
ENT.SoundTbl_Idle = "ambient/energy/electric_loop.wav"
ENT.SoundTbl_OnCollide = {"ambient/energy/weld1.wav", "ambient/energy/weld2.wav"}

ENT.IdleSoundLevel = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	self:SetMaterial("models/hl_resurgence/hl2/weapons/w_chargebow_arrow")
	self:PhysicsInitSphere(1, "metal_bouncy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	if !IsValid(data.HitEntity) then
		local bolt = ents.Create("prop_dynamic")
		bolt:SetModel("models/crossbow_bolt.mdl")
		bolt:SetPos(data.HitPos + data.HitNormal + self:GetForward()*-15)
		bolt:SetAngles(self:GetAngles())
		bolt:Activate()
		bolt:Spawn()
		bolt:DrawShadow(false)
		bolt:SetMaterial("models/hl_resurgence/hl2/weapons/chargebow_arrow")
		timer.Simple(15, function() if IsValid(bolt) then bolt:Remove() end end)
	end
	local effectSpark = EffectData()
	effectSpark:SetOrigin(data.HitPos)
	util.Effect("StunstickImpact", effectSpark)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDealDamage(data, phys, hitEnts)
	if !hitEnts then return end
	for _, ent in ipairs(hitEnts) do
		ent:Ignite(3)
	end
end
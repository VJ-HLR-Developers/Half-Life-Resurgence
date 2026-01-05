/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Crossbow Bolt"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

ENT.PhysicsSolidMask = MASK_SHOT

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_crossbowbolt", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/hl1/crossbow_bolt.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 50
ENT.DirectDamageType = DMG_SLASH
ENT.CollisionDecal = "Impact.Concrete"
ENT.SoundTbl_OnCollide = "vj_hlr/gsrc/wep/crossbow/xbow_hit1.wav"
local sdOnCollideEnt = {"vj_hlr/gsrc/wep/crossbow/xbow_hitbod1.wav", "vj_hlr/gsrc/wep/crossbow/xbow_hitbod2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	if IsValid(data.HitEntity) then
		self.SoundTbl_OnCollide = sdOnCollideEnt
	else
		local spike = ents.Create("prop_dynamic")
		spike:SetModel("models/vj_hlr/hl1/crossbow_bolt.mdl")
		spike:SetPos(data.HitPos + data.HitNormal + self:GetForward() * -20)
		spike:SetAngles(self:GetAngles())
		spike:Activate()
		spike:Spawn()
		timer.Simple(6, function() if IsValid(spike) then spike:Remove() end end)
	end
end
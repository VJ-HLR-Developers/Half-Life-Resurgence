/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Pit Spike"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_pitspike", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/opfor/pitdrone_spike.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 20
ENT.DirectDamageType = DMG_ACID
ENT.CollisionDecal = "Impact.Concrete"
ENT.SoundTbl_OnCollide = "vj_hlr/gsrc/wep/crossbow/xbow_hit1.wav"
local sdOnCollideEnt = {"vj_hlr/gsrc/wep/crossbow/xbow_hitbod1.wav", "vj_hlr/gsrc/wep/crossbow/xbow_hitbod2.wav"}
local defAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	ParticleEffect("vj_hlr_spit_drone_spawn_old", self:GetPos(), defAng)
	ParticleEffectAttach("vj_hlr_spit_drone", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	if IsValid(data.HitEntity) then
		self.SoundTbl_OnCollide = sdOnCollideEnt
	else
		local spike = ents.Create("prop_dynamic")
		spike:SetModel("models/vj_hlr/opfor/pitdrone_spike.mdl")
		spike:SetPos(data.HitPos + data.HitNormal + self:GetForward()*-5)
		spike:SetAngles(self:GetAngles())
		spike:Activate()
		spike:Spawn()
		timer.Simple(6, function() if IsValid(spike) then spike:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	ParticleEffect("vj_hlr_spit_drone_impact", self:GetPos(), defAng)
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Gonarch Toxic Spit"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_gonarchspit", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_medium.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 70
ENT.RadiusDamage = 15
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_ACID
ENT.CollisionDecal = "VJ_HLR1_Spit_Gonarch"
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/bullchicken/bc_acid1.wav", "vj_hlr/hl1_npc/bullchicken/bc_acid2.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/bullchicken/bc_spithit1.wav", "vj_hlr/hl1_npc/bullchicken/bc_spithit2.wav"}

local defAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	self:DrawShadow(false)

	ParticleEffect("vj_hlr_spit_gonarch_spawn", self:GetPos(), defAng)
	ParticleEffectAttach("vj_hlr_spit_gonarch", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	ParticleEffect("vj_hlr_spit_gonarch_impact", data.HitPos, defAng)
end
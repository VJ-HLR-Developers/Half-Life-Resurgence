/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Gene Worm Biotoxin"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlrof_gw_biotoxin", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.DoesDirectDamage = true -- Should it deal direct damage when it collides with something?
ENT.DirectDamage = 20
ENT.DirectDamageType = DMG_ACID
ENT.RemoveDelay = 1.5 -- Setting this greater than 0 will delay the entity's removal | Useful for lingering trail effects
ENT.SoundTbl_OnCollide = {}
ENT.SoundTbl_Idle = {}

-- Custom
ENT.Track_Enemy = NULL
ENT.Track_TrackTime = 0
ENT.Track_OrgPosition = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	ParticleEffectAttach("vj_hlr_geneworm_spit", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if CurTime() > self.Track_TrackTime then return end
	local ene = self.Track_Enemy
	if IsValid(ene) then
		if ene:GetPos():Distance(self.Track_OrgPosition) > 500 then return end -- If enemy moves to far from org position, then stop tracking
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), ene:GetPos() + ene:OBBCenter(), 2000))
		end
	end
end
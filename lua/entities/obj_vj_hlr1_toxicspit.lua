/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Toxic Spit"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_toxicspit", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/hla/spit.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true -- Should it deal radius damage when it collides with something?
ENT.RadiusDamageRadius = 70
ENT.RadiusDamage = 15
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the hit entity is from the radius origin?
ENT.RadiusDamageType = DMG_ACID
ENT.CollisionDecal = "VJ_HLR_Spit_Acid"
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/bullchicken/bc_acid1.wav", "vj_hlr/hl1_npc/bullchicken/bc_acid2.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/bullchicken/bc_spithit1.wav", "vj_hlr/hl1_npc/bullchicken/bc_spithit2.wav"}

-- Custom
ENT.Spit_AlphaStyle = false -- Should it act like HL Alpha toxic spit?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if IsValid(self:GetOwner()) && self:GetOwner().Bullsquid_BullSquidding then
		self.ProjectileType = VJ.PROJ_TYPE_LINEAR
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	-- ParticleEffectAttach("vj_hl_spit_bullsquid", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	
	self.Scale = math.Rand(0.5, 1.15)
	
	if self.Spit_AlphaStyle then
		self:SetNoDraw(false)
	else
		self:SetNoDraw(true)
		local sprIdle = ents.Create("env_sprite")
		sprIdle:SetKeyValue("model","vj_hl/sprites/bigspit.vmt")
		sprIdle:SetKeyValue("rendercolor","255 255 255")
		sprIdle:SetKeyValue("GlowProxySize","5.0")
		sprIdle:SetKeyValue("HDRColorScale","1.0")
		sprIdle:SetKeyValue("renderfx","0")
		sprIdle:SetKeyValue("rendermode","2")
		sprIdle:SetKeyValue("renderamt","255")
		sprIdle:SetKeyValue("disablereceiveshadows","0")
		sprIdle:SetKeyValue("mindxlevel","0")
		sprIdle:SetKeyValue("maxdxlevel","0")
		sprIdle:SetKeyValue("framerate","40.0")
		sprIdle:SetKeyValue("spawnflags","0")
		sprIdle:SetKeyValue("scale",tostring(self.Scale))
		sprIdle:SetPos(self:GetPos())
		sprIdle:Spawn()
		sprIdle:SetParent(self)
		self:DeleteOnRemove(sprIdle)
	end
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model","vj_hl/sprites/bigspit_impact.vmt")
	spr:SetKeyValue("GlowProxySize","2.0")
	spr:SetKeyValue("HDRColorScale","1.0")
	spr:SetKeyValue("renderfx","0")
	spr:SetKeyValue("rendermode","2")
	spr:SetKeyValue("renderamt","255")
	spr:SetKeyValue("disablereceiveshadows","0")
	spr:SetKeyValue("mindxlevel","0")
	spr:SetKeyValue("maxdxlevel","0")
	spr:SetKeyValue("framerate","15.0")
	spr:SetKeyValue("spawnflags","0")
	spr:SetKeyValue("scale",tostring(self.Scale *0.3))
	spr:SetPos(data.HitPos)
	spr:Spawn()
	spr:Fire("Kill","",0.3)
	timer.Simple(0.3, function() if IsValid(spr) then spr:Remove() end end)

	//ParticleEffect("vj_hl_spit_bullsquid_impact", data.HitPos, Angle(0,0,0), nil)
end
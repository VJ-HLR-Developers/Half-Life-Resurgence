/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Gene Worm Spawner"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlrof_gw_spawner", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	sound.Play("vj_hlr/gsrc/fx/beamstart4.wav", self:GetPos(), 85)
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self:SetNoDraw(true)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

	local glowSpr = ents.Create("env_sprite")
	glowSpr:SetKeyValue("model", "vj_hl/sprites/tele1.vmt")
	//glowSpr:SetKeyValue("rendercolor", "255 128 0")
	glowSpr:SetKeyValue("GlowProxySize", "2.0")
	glowSpr:SetKeyValue("HDRColorScale", "1.0")
	glowSpr:SetKeyValue("renderfx", "14")
	glowSpr:SetKeyValue("rendermode", "3")
	glowSpr:SetKeyValue("renderamt", "255")
	glowSpr:SetKeyValue("disablereceiveshadows", "0")
	glowSpr:SetKeyValue("mindxlevel", "0")
	glowSpr:SetKeyValue("maxdxlevel", "0")
	glowSpr:SetKeyValue("framerate", "10.0")
	glowSpr:SetKeyValue("spawnflags", "0")
	glowSpr:SetKeyValue("scale", "1.5")
	glowSpr:SetPos(self:GetPos())
	glowSpr:Spawn()
	glowSpr:SetParent(self)
	self:DeleteOnRemove(glowSpr)

	timer.Simple(2.6, function()
		if IsValid(self) then
			local owner = self:GetOwner()
			sound.Play("vj_hlr/gsrc/fx/beamstart2.wav", self:GetPos(), 85)
			local ent = ents.Create("npc_vj_hlrof_shocktrooper")
			ent:SetPos(self:GetPos())
			ent:SetAngles(self:GetAngles())
			ent:Spawn()
			if IsValid(owner) then
				ent.VJ_NPC_Class = owner.VJ_NPC_Class
				if IsValid(owner:GetEnemy()) then
					ent:ForceSetEnemy(owner:GetEnemy(), true)
				end
			end
			self:Remove()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:NextThink(CurTime())
	return true
end
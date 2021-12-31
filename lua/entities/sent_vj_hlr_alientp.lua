/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "obj_vj_spawner_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Portal (Xen)"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "VJ Base Spawners"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.SingleSpawner = true -- If set to true, it will spawn the entities once then remove itself
ENT.VJBaseSpawnerDisabled = true -- If set to true, it will stop spawning the entities

-- Custom
ENT.HLRSpawner_Type = 0
	-- 0 = Xen
	-- 1 = Race X
ENT.HLRSpawner_ClassType = "CLASS_XEN" -- Type of class the spawner should when triggering the portal
ENT.HLRSpawner_Distance = 400

local xenEnts = {"npc_vj_hlr1_alienslave","npc_vj_hlr1_aliengrunt","npc_vj_hlr1_bullsquid","npc_vj_hlr1_houndeye"}
local racexEnts = {"npc_vj_hlrof_shocktrooper","npc_vj_hlrof_pitdrone","npc_vj_hlrof_voltigore","npc_vj_hlrof_voltigore_baby"}
---------------------------------------------------------------------------------------------------------------------------------------------
local vec45z = Vector(0, 0, 45)
--
function ENT:CustomOnInitialize()
	timer.Simple(0.02, function()
		if IsValid(self) then
			self:SetPos(self:GetPos() + vec45z)
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:GetCreator():ChatPrint("Portal entity created with activation distance " .. tostring(self.HLRSpawner_Distance) .. " WU.")
			end
		end
	end)
	local enttbl = xenEnts
	if self.HLRSpawner_Type == 1 then
		enttbl = racexEnts
		self.HLRSpawner_ClassType = "CLASS_RACE_X"
	end
	self.EntitiesToSpawn = {{Entities = enttbl}}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HLR_ActivateSpawner(eneEnt)
	self:SetAngles(Angle(self:GetAngles().x, ((eneEnt:GetPos()) - self:GetPos()):Angle().y, self:GetAngles().z)) -- Make sure it spawns the entity facing the enemy
	local effectTeleport = VJ_HLR_Effect_PortalSpawn(self:GetPos())
	effectTeleport:Fire("Kill", "", 1)
	
	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "2")
	dynLight:SetKeyValue("distance", "200")
	dynLight:SetPos(self:GetPos())
	dynLight:SetLocalAngles(self:GetAngles())
	dynLight:Fire("Color","33 255 0")
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:Fire("TurnOn","",0)
	dynLight:Fire("Kill", "", 0.3)
	
	self.VJBaseSpawnerDisabled = false
	for k, v in ipairs(self.EntitiesToSpawn) do
		self:SpawnAnEntity(k, v, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() // self.Dead == false && 
	if self.VJBaseSpawnerDisabled && GetConVar("ai_disabled"):GetInt() == 0 then
		for _, v in pairs(ents.FindInSphere(self:GetPos(), self.HLRSpawner_Distance)) do
			if (v:IsNPC() or (v:IsPlayer() && GetConVar("ai_ignoreplayers"):GetInt() == 0)) && !v.VJ_NoTarget && !v:IsFlagSet(FL_NOTARGET) && self:Visible(v) && (!v.VJ_NPC_Class or !VJ_HasValue(v.VJ_NPC_Class, self.HLRSpawner_ClassType)) then
				self:HLR_ActivateSpawner(v)
				break
			end
		end
	end
end
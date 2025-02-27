/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "obj_vj_spawner_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Portal (Xen)"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base Spawners"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.SingleSpawner = true
ENT.PauseSpawning = true

-- Custom
ENT.HLRSpawner_Type = 0
	-- 0 = Xen
	-- 1 = Race X
ENT.HLRSpawner_ClassType = "CLASS_XEN" -- Type of class the spawner should when triggering the portal
ENT.HLRSpawner_Distance = 400
ENT.HLRSpawner_NextCheckT = 0

local xenEnts = {"npc_vj_hlr1_alienslave", "npc_vj_hlr1_aliengrunt", "npc_vj_hlr1_bullsquid", "npc_vj_hlr1_houndeye", "npc_vj_hlr1_panthereye"}
local racexEnts = {"npc_vj_hlrof_shocktrooper", "npc_vj_hlrof_pitdrone", "npc_vj_hlrof_voltigore", "npc_vj_hlrof_voltigore_baby"}
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ45 = Vector(0, 0, 45)
local vecNZ20 = Vector(0, 0, -20)
--
function ENT:Init()
	timer.Simple(0.02, function()
		if IsValid(self) then
			self:SetPos(self:GetPos() + vecZ45)
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:GetCreator():ChatPrint("Portal entity created with activation distance " .. tostring(self.HLRSpawner_Distance) .. " WU.")
			end
		end
	end)
	local entTbl = xenEnts
	if self.HLRSpawner_Type == 1 then
		entTbl = racexEnts
		self.HLRSpawner_ClassType = "CLASS_RACE_X"
	end
	self.EntitiesToSpawn = {{
		Entities = entTbl,
		SpawnPosition = vecNZ20 -- Make the NPC spawn little bit down otherwise it tends to get stuck in ceilings
	}}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HLR_ActivateSpawner(eneEnt)
	local myPos = self:GetPos()
	self.PauseSpawning = false
	
	self:SetAngles(Angle(self:GetAngles().x, ((eneEnt:GetPos()) - myPos):Angle().y, self:GetAngles().z)) -- Make sure it spawns the entity facing the enemy
	VJ.HLR1_Effect_Portal(myPos, nil, self.HLRSpawner_Type == 1 and "189 2 186" or nil, function()
		-- onSpawn
		if IsValid(self) then
			for k, v in ipairs(self.EntitiesToSpawn) do
				self:SpawnEntity(k, v, true)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.PauseSpawning && VJ_CVAR_AI_ENABLED && CurTime() > self.HLRSpawner_NextCheckT then
		for _, v in ipairs(ents.FindInSphere(self:GetPos(), self.HLRSpawner_Distance)) do
			if v:IsPlayer() && (v.VJ_IsControllingNPC or VJ_CVAR_IGNOREPLAYERS) then continue end
			if v.VJ_ID_Living && v:Alive() && !v:IsFlagSet(FL_NOTARGET) && self:Visible(v) && (!v.VJ_NPC_Class or !VJ.HasValue(v.VJ_NPC_Class, self.HLRSpawner_ClassType)) then
				self:HLR_ActivateSpawner(v)
				break
			end
		end
		self.HLRSpawner_NextCheckT = CurTime() + 1.5
	end
end
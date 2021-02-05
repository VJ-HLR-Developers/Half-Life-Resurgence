AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.SingleSpawner = true -- If set to true, it will spawn the entities once then remove itself
ENT.VJBaseSpawnerDisabled = true -- If set to true, it will stop spawning the entities

-- Custom
ENT.HLRSpawner_Type = 0
	-- 0 = Xen
	-- 1 = Race X
ENT.HLRSpawner_ClassType = "CLASS_XEN" -- Type of class the spawner should when triggering the portal
ENT.HLRSpawner_Distance = 400
ENT.HLRSpawner_ActivationTime = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_BeforeNPCSpawn()
	timer.Simple(0.02, function()
		if IsValid(self) then
			self:SetPos(self:GetPos() + Vector(0,0,45))
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:GetCreator():ChatPrint("Portal entity created. Activation distance is " .. tostring(self.HLRSpawner_Distance) .. " WU.")
			end
		end
	end)
	local enttbl = {"npc_vj_hlr1_alienslave","npc_vj_hlr1_aliengrunt","npc_vj_hlr1_bullsquid","npc_vj_hlr1_houndeye"}
	if self.HLRSpawner_Type == 1 then
		enttbl = {"npc_vj_hlrof_shocktrooper","npc_vj_hlrof_pitdrone","npc_vj_hlrof_voltigore","npc_vj_hlrof_voltigore_baby"}
		self.HLRSpawner_ClassType = "CLASS_RACE_X"
	end
	self.EntitiesToSpawn = {{EntityName = "NPC1", SpawnPosition = {vForward=0, vRight=0, vUp=0}, Entities = enttbl}}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ActivateSpawner(ent)
	local effectTeleport = VJ_HLR_Effect_PortalSpawn(self:GetPos())
	effectTeleport:Fire("Kill", "", self.HLRSpawner_ActivationTime)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "8")
	FireLight1:SetKeyValue("distance", "200")
	FireLight1:SetPos(self:GetPos())
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color","33 255 0")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",self.HLRSpawner_ActivationTime)
	self:DeleteOnRemove(FireLight1)
	
	self.VJBaseSpawnerDisabled = false
	for k, v in ipairs(self.EntitiesToSpawn) do self:SpawnAnEntity(k, v, true) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_BeforeAliveChecks()
	if self.VJBaseSpawnerDisabled && GetConVar("ai_disabled"):GetInt() == 0 then
		for _, v in ipairs(ents.FindInSphere(self:GetPos(), self.HLRSpawner_Distance)) do
			if self.Dead == false && (v:IsNPC() or (v:IsPlayer() && GetConVar("ai_ignoreplayers"):GetInt() == 0)) && !v.VJ_NoTarget && !v:IsFlagSet(FL_NOTARGET) && self:Visible(v) && (!v.VJ_NPC_Class or !VJ_HasValue(v.VJ_NPC_Class, self.HLRSpawner_ClassType)) then
				self:ActivateSpawner()
				break
			end
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
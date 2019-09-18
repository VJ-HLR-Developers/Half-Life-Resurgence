AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.SingleSpawner = true -- If set to true, it will spawn the entities once then remove itself
ENT.VJBaseSpawnerDisabled = true
ENT.Model = {"models/props_junk/popcan01a.mdl"} -- The models it should spawn with | Picks a random one from the table

ENT.VJ_NPC_Class = {}
ENT.SpawnableNPC = {}
ENT.DistanceCheck = 500
ENT.ActivationTime = 2

ENT.CanActivate = false
ENT.DoActivation = false
ENT.ActivatedEntity = NULL
ENT.Scale = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DefaultPortalValues()
	if #self.VJ_NPC_Class == 0 then
		self:SetClass("CLASS_XEN")
	end
	if #self.SpawnableNPC == 0 then
		self:SetNPC("npc_vj_hlr1_aliengrunt")
		self:SetNPC("npc_vj_hlr1_bullsquid")
		self:SetNPC("npc_vj_hlr1_houndeye")
		self:SetNPC("npc_vj_hlr1_vortigaunt")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_BeforeNPCSpawn()
	timer.Simple(0.02,function()
		if IsValid(self) then
			self:SetPos(self:GetPos() +Vector(0,0,45))
			self:DefaultPortalValues()
			if IsValid(self:GetCreator()) && self:GetCreator():IsPlayer() then
				self:GetCreator():ChatPrint("Portal entity created. Activation distance is " .. tostring(self.DistanceCheck) .. " WU.")
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetClass(class)
	table.insert(self.VJ_NPC_Class,class)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetNPC(npc)
	table.insert(self.SpawnableNPC,npc)
	self.EntitiesToSpawn = {
		{EntityName = "HelloMyNameIsCuntMaster3000",SpawnPosition = {vForward=0,vRight=0,vUp=-40},Entities = self.SpawnableNPC}
	}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetActivationDistance(dist)
	self.DistanceCheck = dist
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ActivateSpawner(ent)
	self.StartGlow1 = ents.Create("env_sprite")
	self.StartGlow1:SetKeyValue("model","vj_hl/sprites/exit1.vmt")
	self.StartGlow1:SetKeyValue("GlowProxySize","2.0")
	self.StartGlow1:SetKeyValue("HDRColorScale","1.0")
	self.StartGlow1:SetKeyValue("renderfx","14")
	self.StartGlow1:SetKeyValue("rendermode","3")
	self.StartGlow1:SetKeyValue("renderamt","255")
	self.StartGlow1:SetKeyValue("disablereceiveshadows","0")
	self.StartGlow1:SetKeyValue("mindxlevel","0")
	self.StartGlow1:SetKeyValue("maxdxlevel","0")
	self.StartGlow1:SetKeyValue("framerate","10.0")
	self.StartGlow1:SetKeyValue("spawnflags","0")
	self.StartGlow1:SetKeyValue("scale","1")
	self.StartGlow1:SetPos(self:GetPos())
	self.StartGlow1:Spawn()
	self.StartGlow1:SetParent(self)
	self:DeleteOnRemove(self.StartGlow1)
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
	FireLight1:Fire("Kill","",self.ActivationTime)
	self:DeleteOnRemove(FireLight1)
	VJ_EmitSound(self,"vj_hlr/fx/beamstart" .. math.random(1,2) .. ".wav",85,100)
	timer.Simple(self.ActivationTime,function() if IsValid(self) then self.VJBaseSpawnerDisabled = false; for k,v in ipairs(self.EntitiesToSpawn) do self:SpawnAnEntity(k,v,true) end end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_BeforeAliveChecks()
	if self.DoActivation then
		self.Scale = self.Scale -0.05
		if IsValid(self.StartGlow1) then self.StartGlow1:SetKeyValue("scale",tostring(self.Scale)) end
	end
	if self.VJBaseSpawnerDisabled && !self.CanActivate then
		if GetConVarNumber("ai_disabled") == 1 then return end
		for _,v in ipairs(ents.FindInSphere(self:GetPos(),self.DistanceCheck)) do
			if v:IsNPC() or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && !v.VJ_NoTarget) then
				if !self:Visible(v) then return end
				for _,friclass in ipairs(self.VJ_NPC_Class) do
					if (v.VJ_NPC_Class && !VJ_HasValue(v.VJ_NPC_Class,friclass)) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && !v.VJ_NoTarget) or (v:IsNPC() && !v.VJ_NPC_Class) then
						self.CanActivate = true
						self.ActivatedEntity = v
					end
				end
			end
		end
	end
	if self.CanActivate && !self.DoActivation then
		self.DoActivation = true
		self:ActivateSpawner(self.ActivatedEntity)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnAnEntity(keys,values,initspawn)
	local k = keys
	local v = values
	local initspawn = initspawn or false
	local overridedisable = false
	local hasweps = false
	local wepslist = {}
	if initspawn == true then overridedisable = true end
	if self.VJBaseSpawnerDisabled == true && overridedisable == false then return end
	if self.VJBaseSpawnerDisabled then return end -- Mkay Vrej
	
	local getthename = v.EntityName
	local spawnpos = v.SpawnPosition
	local getthename = ents.Create(VJ_PICKRANDOMTABLE(v.Entities))
	getthename:SetPos(self:GetPos() +self:GetForward()*spawnpos.vForward +self:GetRight()*spawnpos.vRight +self:GetUp()*spawnpos.vUp)
	getthename:SetAngles(self:GetAngles())
	getthename:Spawn()
	getthename:Activate()
	if v.WeaponsList != nil && VJ_PICKRANDOMTABLE(v.WeaponsList) != false && VJ_PICKRANDOMTABLE(v.WeaponsList) != NULL && VJ_PICKRANDOMTABLE(v.WeaponsList) != "None" && VJ_PICKRANDOMTABLE(v.WeaponsList) != "none" then hasweps = true wepslist = v.WeaponsList end
	if hasweps == true then
		local randwep = VJ_PICKRANDOMTABLE(v.WeaponsList) -- Kharen zenkme zad e
		if randwep == "default" then
			getthename:Give(VJ_PICKRANDOMTABLE(list.Get("NPC")[getthename:GetClass()].Weapons))
		else
			getthename:Give(randwep)
		end
	end
	if initspawn == false then table.remove(self.CurrentEntities,k) end
	table.insert(self.CurrentEntities,k,{EntityName=v.EntityName,SpawnPosition=v.SpawnPosition,Entities=v.Entities,TheEntity=getthename,WeaponsList=wepslist,Dead=false/*NextTimedSpawnT=CurTime()+self.TimedSpawn_Time*/})
	self:SpawnEntitySoundCode()
	if self.VJBaseSpawnerDisabled == true && overridedisable == true then getthename:Remove() return end
	self:CustomOnEntitySpawn(v.EntityName,v.SpawnPosition,v.Entities,TheEntity)
	timer.Simple(0.1,function() if IsValid(self) then if self.SingleSpawner == true then self:DoSingleSpawnerRemove() end end end)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
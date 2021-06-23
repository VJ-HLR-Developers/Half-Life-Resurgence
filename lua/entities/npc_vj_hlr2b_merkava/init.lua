AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/merkava.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 500
ENT.VJC_Data = {
    ThirdP_Offset = Vector(-40, 0, 20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "body", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 70), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?



ENT.Tank_GunnerENT = "npc_vj_hlr2b_merkava_gun"
ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 100
ENT.Tank_DeathSoldierModels = {"models/Humans/Group03m/male_01.mdl","models/Humans/Group03m/male_02.mdl","models/Humans/Group03m/male_03.mdl","models/Humans/Group03m/male_04.mdl","models/Humans/Group03m/male_05.mdl","models/Humans/Group03m/male_06.mdl","models/Humans/Group03m/male_07.mdl","models/Humans/Group03m/male_08.mdl","models/Humans/Group03m/male_09.mdl"} -- The corpses it will spawn on death (Example: A soldier) | false = Don't spawn anything

util.AddNetworkString("vj_hlr1_merkava_spawneffects")
util.AddNetworkString("vj_hlr1_merkava_moveeffects")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank()
	self:SetSkin(math.random(0, 1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos() + self:GetUp()*69
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSpawnEffects()
	net.Start("vj_hlr1_merkava_spawneffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMoveEffects()
	net.Start("vj_hlr1_merkava_moveeffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnThink()
	-- Keep the skin of the gunner the same!
	if IsValid(self.Gunner) then
		self.Gunner:SetSkin(self:GetSkin())
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randPos = math.random(1,5)
	if randPos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*15 + self:GetForward()*-16 + self:GetUp()*120)
	elseif randPos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 3 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 4 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*60 + self:GetForward()*-40 + self:GetUp()*81)
	elseif randPos == 5 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-60 + self:GetForward()*-40 + self:GetUp()*81)
	end
end
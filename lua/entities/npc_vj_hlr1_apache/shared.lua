ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= ""
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingLeft()
	return self:GetDirections().LR < 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingRight()
	return self:GetDirections().LR > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingForward()
	return self:GetDirections().FB > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingBackward()
	return self:GetDirections().FB < 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingUp()
	return self:GetDirections().UD > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MovingDown()
	return self:GetDirections().UD < 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetDirections()
	local vel = self:GetAbsVelocity()
	return {LR=math.Clamp(vel.x,-1,1),FB=math.Clamp(vel.y,-1,1),UD=math.Clamp(vel.z,-1,1)}
end
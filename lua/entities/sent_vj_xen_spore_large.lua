/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Xen Spore (Large)"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

function ENT:Initialize()
	self:SetModel("models/vj_hlr/hl1/fungus(large).mdl")
	self:SetCollisionBounds(Vector(70, 70, 250), Vector(-70, -70, 0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:ResetSequence("Idle1")
end
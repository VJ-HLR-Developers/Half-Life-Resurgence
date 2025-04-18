/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Archer Spit"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_archerspit", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/opfor/pitdrone_spike.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 20
ENT.DirectDamageType = DMG_ACID
ENT.CollisionDecal = "VJ_HLR1_Spit_Acid"
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/bullchicken/bc_acid1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_acid2.wav"}
ENT.SoundTbl_OnCollide = "vj_hlr/gsrc/npc/bullchicken/bc_spithit3.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	ParticleEffectAttach("vj_hlr_spore_idle_small", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:WaterLevel() == 3 then
		local myPos = self:GetPos()
		effects.BubbleTrail(myPos, myPos + self:GetForward()*400, 6, -500, 100)
	end
	
	-- Make it slow down when its out of the water and fall down
	/*if self:WaterLevel() == 0 then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(true)
			phys:EnableDrag(true)
			phys:SetVelocity(phys:GetVelocity() * 0.3)
		end
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle(0, 0, 0)
--
function ENT:OnDestroy(data, phys)
	ParticleEffect("vj_hlr_spore_small", self:GetPos(), defAng)
end
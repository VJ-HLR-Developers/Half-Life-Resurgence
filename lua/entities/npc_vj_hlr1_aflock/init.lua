include("entities/npc_vj_hlr1_boid/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/aflock.mdl"
ENT.ControllerParams = {
	FirstP_Bone = "bone12",
	FirstP_Offset = Vector(15, 0, 2),
	FirstP_ShrinkBone = false,
}

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH

-- Custom
ENT.Boid_WoundedAnim = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.Boid_Type = 1
	self:SetCollisionBounds(Vector(18, 18, 10), Vector(-18, -18, 0))
	self.Boid_FollowOffsetPos = Vector(math.random(-50, 50), math.random(-120, 120), math.random(-150, 150))
	self.Boid_WoundedAnim = VJ.SequenceToActivity(self, "wounded")
	if !IsValid(VJ.HLR_NPC_AFlock_Leader) then
		VJ.HLR_NPC_AFlock_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE or act == ACT_FLY then
		if self:Health() <= (self:GetMaxHealth() / 2.2) then
			return self.Boid_WoundedAnim
		else
			return ACT_FLY
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.VJ_IsBeingControlled then return end
	local leader = VJ.HLR_NPC_AFlock_Leader
	if IsValid(leader) then
		if leader != self && leader.AA_CurrentMovePos then
			self.DisableWandering = true
			self:AA_MoveTo(leader, true, "Calm", {AddPos = self.Boid_FollowOffsetPos, IgnoreGround = true}) -- Medzavorin haladz e (Kharen deghme)
		end
	else
		self.IsGuard = false
		self.DisableWandering = false
		VJ.HLR_NPC_AFlock_Leader = self
	end
end
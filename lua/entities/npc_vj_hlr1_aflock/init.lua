include("entities/npc_vj_hlr1_boid/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/aflock.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.VJC_Data = {
	FirstP_Bone = "bone12", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(15, 0, 2), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH -- If it uses normal based animation, use this

-- Custom
ENT.Boid_WoundedAnim = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
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
function ENT:CustomOnThink()
	if self.VJ_IsBeingControlled then return end
	local leader = VJ.HLR_NPC_AFlock_Leader
	if IsValid(leader) then
		if leader != self && leader.AA_CurrentMovePos then
			self.DisableWandering = true
			self:AA_MoveTo(leader, true, "Calm", {AddPos=self.Boid_FollowOffsetPos, IgnoreGround=true}) -- Medzavorin haladz e (Kharen deghme)
		end
	else
		self.IsGuard = false
		self.DisableWandering = false
		VJ.HLR_NPC_AFlock_Leader = self
	end
end
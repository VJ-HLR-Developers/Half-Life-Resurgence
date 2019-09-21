AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/aflock.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_BIG_FLINCH} -- If it uses normal based animation, use this
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.Boid_Type = 1
	self:SetCollisionBounds(Vector(18, 18, 10), Vector(-18, -18, 0))
	self.Boid_PosForward = math.random(-50,50)
	self.Boid_PosUp = math.random(-150,150)
	self.Boid_PosRight = math.random(-120,120)
	if !IsValid(HLR_AFlock_Leader) then
		HLR_AFlock_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(HLR_AFlock_Leader) then
		if HLR_AFlock_Leader != self then
			self.DisableWandering = true
			self:AAMove_MoveToPos(HLR_AFlock_Leader,true,{PosForward=self.Boid_PosForward,PosUp=self.Boid_PosUp,PosRight=self.Boid_PosRight}) -- Medzavorin haladz e (Kharen deghme)
		end
	else
		self.DisableWandering = false
		HLR_AFlock_Leader = self
	end
	
	if self.Boid_Type == 1 && self:Health() <= (self:GetMaxHealth() / 2.2) then
		self.AnimTbl_IdleStand = {"wounded"}
		self.Aerial_AnimTbl_Calm = {"wounded"}
		self.Aerial_AnimTbl_Alerted = {"wounded"}
	else
		self.AnimTbl_IdleStand = {ACT_FLY}
		self.Aerial_AnimTbl_Calm = {ACT_FLY}
		self.Aerial_AnimTbl_Alerted = {ACT_FLY}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
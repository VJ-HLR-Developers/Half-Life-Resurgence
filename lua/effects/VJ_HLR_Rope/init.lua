/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("vj_hl/sprites/rope")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.Ent = data:GetEntity()
	self.Att = data:GetAttachment()
	self.CurPos = IsValid(self.Ent) and self.Ent:GetAttachment(self.Att).Pos or self.StartPos
	
	self.Dead = false
	self.Wait = CurTime() + 0.5 -- Minimum wait time
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if !IsValid(self.Ent) or self.Dead then return false end
	self.CurPos = self.Ent:GetAttachment(self.Att).Pos
	self:SetRenderBoundsWS(self.StartPos, self.CurPos)
	if CurTime() > self.Wait && self.Ent:GetVelocity():Length() <= 0 then
		self.Dead = true
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local rColor = Color(255, 255, 255)
--
function EFFECT:Render()
	render.SetMaterial(self.MainMat)
	render.DrawBeam(self.StartPos, self.CurPos, 5, 0, 1 + ((self.StartPos - self.CurPos):Length() / 32), rColor)
end
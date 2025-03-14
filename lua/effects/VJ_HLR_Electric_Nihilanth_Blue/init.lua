/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
local matBeam = Material("vj_hl/beam")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Ent = data:GetEntity()
	self.Att = data:GetAttachment()
	if IsValid(self.Ent) then self.StartPos = self.Ent:GetAttachment(self.Att).Pos end
	
	self.HitPos = self.EndPos - self.StartPos
	self.DieTime = CurTime() + 0.5
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	
	local hitPosNormal = self.HitPos:GetNormalized()
	util.Decal("VJ_HLR1_Scorch_Small", self.EndPos + hitPosNormal * -30, self.EndPos - hitPosNormal * -30)
	local effectData = EffectData()
	effectData:SetOrigin(self.EndPos + hitPosNormal * -2)
	effectData:SetNormal(hitPosNormal * -3)
	effectData:SetMagnitude(0.1)
	effectData:SetScale(0.4)
	effectData:SetRadius(3)
	util.Effect("Sparks", effectData)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if !IsValid(self.Ent) then return false end
	self.StartPos = self.Ent:GetAttachment(self.Att).Pos
	if (CurTime() > self.DieTime) then -- If it's dead then...
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	render.SetMaterial(matBeam)
	render.DrawBeam(self.StartPos, self.EndPos, math.Rand(100, 150), math.Rand(1, 1.3) + ((self.StartPos - self.EndPos):Length() / 1280), (self.StartPos - self.EndPos):Length() / 20000, Color(100, 100, 255, 255))
end
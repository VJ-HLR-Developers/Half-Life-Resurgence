/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("vj_hl/sprites/laserbeam_pitworm")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Ent = data:GetEntity()
	self.Att = data:GetAttachment()
	if IsValid(self.Ent) then self.StartPos = self.Ent:GetAttachment(self.Att).Pos end
	
	self.HitPos = self.EndPos - self.StartPos
	self.DieTime = CurTime() + 0.15
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	
	util.Decal("VJ_HLR1_Scorch_Small", self.EndPos + self.HitPos:GetNormalized(), self.EndPos - self.HitPos:GetNormalized())
	local effectData = EffectData()
	effectData:SetOrigin(self.EndPos + self.HitPos:GetNormalized()*-2)
	effectData:SetNormal(self.HitPos:GetNormalized()*-3)
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
	render.SetMaterial(self.MainMat)
	render.DrawBeam(self.StartPos, self.EndPos, math.Rand(18, 24), math.Rand(0, 1), math.Rand(0, 1) + ((self.StartPos - self.EndPos):Length() / 128), Color(124, 252, 0, 50 / ((self.DieTime - 0.5) - CurTime())))
end
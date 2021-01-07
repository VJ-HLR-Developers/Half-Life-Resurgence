if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("vj_hl/beam")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Ent = data:GetEntity()
	self.Att = data:GetAttachment()
	if IsValid(self.Ent) then self.StartPos = self.Ent:GetAttachment(self.Att).Pos end
	
	self.HitPos = self.EndPos - self.StartPos
	self.DieTime = CurTime() + (1.7 - data:GetScale())
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	
	util.Decal("VJ_HLR_Scorch_Small", self.EndPos + self.HitPos:GetNormalized(), self.EndPos - self.HitPos:GetNormalized())
	/*local effectdata = EffectData()
	effectdata:SetOrigin(self.EndPos + self.HitPos:GetNormalized()*-2)
	effectdata:SetNormal(self.HitPos:GetNormalized()*-3)
	effectdata:SetMagnitude(0.1)
	effectdata:SetScale(0.4)
	effectdata:SetRadius(3)
	util.Effect("Sparks", effectdata)*/
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
	render.DrawBeam(self.StartPos, self.EndPos, math.Rand(18,24), math.Rand(0,1), math.Rand(0,1) + ((self.StartPos - self.EndPos):Length() / 128), Color(255,255,255,(50 / ((self.DieTime - 0.5) - CurTime()))))
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
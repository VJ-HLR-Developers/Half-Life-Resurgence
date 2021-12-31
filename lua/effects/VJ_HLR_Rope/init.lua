if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("vj_hl/sprites/rope")

function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.Ent = data:GetEntity()
	self.Att = self.Ent:GetAttachment(4).Pos
	
	self.Dead = false
	self.Wait = CurTime() + 0.5 -- Minimum wait time
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if !IsValid(self.Ent) or self.Dead then return false end
	self.Att = self.Ent:GetAttachment(4).Pos
	self:SetRenderBoundsWS(self.StartPos, self.Att)
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
	render.DrawBeam(self.StartPos, self.Att, 5, 0, 1 + ((self.StartPos - self.Att):Length() / 32), rColor)
end
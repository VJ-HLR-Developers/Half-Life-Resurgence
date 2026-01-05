/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
local matRope = Material("vj_hl/sprites/rope")

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
	local ent = self.Ent
	if self.Dead or !IsValid(ent) then return false end
	self.CurPos = ent:GetAttachment(self.Att).Pos
	self:SetRenderBoundsWS(self.StartPos, self.CurPos)
	if CurTime() > self.Wait && (ent:GetVelocity():Length() <= 0 && ent:GetSequenceName(ent:GetSequence()) != "repel_die") then -- Do NOT remove the rope if the NPC is playing a death anim!
		self.Dead = true
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local rColor = Color(255, 255, 255)
--
function EFFECT:Render()
	render.SetMaterial(matRope)
	render.DrawBeam(self.StartPos, self.CurPos, 5, 0, 1 + ((self.StartPos - self.CurPos):Length() / 32), rColor)
end
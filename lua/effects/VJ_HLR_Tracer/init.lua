if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
-- Based off of the GMod lasertracer
EFFECT.MainMat = Material("vj_hl/tracer_middle")

function EFFECT:Init( data )
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	local ent = data:GetEntity()
	local att = data:GetAttachment()

	if ( IsValid( ent ) && att > 0 ) then
		if (ent.Owner == LocalPlayer() && !LocalPlayer():GetViewModel() != LocalPlayer()) then ent = ent.Owner:GetViewModel() end
		att = ent:GetAttachment(att)
		if (att) then
			self.StartPos = att.Pos
		end
	end

	self.Dir = self.EndPos - self.StartPos
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	self.TracerTime = math.min(1, self.StartPos:Distance(self.EndPos) / 10000) -- Calculate death time
	self.Length = 0.1

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if (CurTime() > self.DieTime) then
		local tr = util.TraceLine({
			start = self.StartPos,
			endpos = self.EndPos
		})
		if tr.Hit && tr.MatType then
			local mat = tr.MatType
			local metalMat = {[MAT_VENT]=true,[MAT_METAL]=true,[MAT_GRATE]=true,[MAT_GLASS]=true,[MAT_COMPUTER]=true}
			if metalMat[mat] then
				sound.Play("vj_hlr/fx/ric" .. math.random(1,5) .. ".wav",self.EndPos,80,100)

				local Emitter = ParticleEmitter(self.EndPos)
				if GetConVar("vj_hlr_sparkfx"):GetInt() == 1 then
					for i = 1,math.random(5,15) do
						local particle = Emitter:Add("vj_hl/tracer_middle",self.EndPos)
						particle:SetVelocity(VectorRand() *math.Rand(100,350))
						particle:SetDieTime(math.Rand(0.1,1))
						particle:SetStartAlpha(200)
						particle:SetEndAlpha(0)
						particle:SetStartSize(1)
						particle:SetEndSize(3)
						particle:SetRoll(math.random(0,360))
						particle:SetGravity(Vector(math.random(-300,300),math.random(-300,300),math.random(-300,-700)))
						particle:SetCollide(true)
						particle:SetBounce(0.9)
						particle:SetAirResistance(120)
						particle:SetStartLength(0)
						particle:SetEndLength(0.1)
						particle:SetVelocityScale(true)
						particle:SetCollide(true)
						particle:SetColor(255,231,166)
					end
				end

				if math.random(1,2) == 1 then
					local fx = Emitter:Add("vj_hl/rico2",self.EndPos)
					fx:SetVelocity(Vector(0,0,0))
					fx:SetAirResistance(160)
					fx:SetDieTime(0.15)
					fx:SetStartAlpha(255)
					fx:SetEndAlpha(0)
					fx:SetStartSize(math.random(5,8))
					fx:SetEndSize(5)
					fx:SetRoll(math.Rand(180,360))
					fx:SetRollDelta(math.Rand(-1,1))
					fx:SetColor(255,255,255)
				else
					local fx = Emitter:Add("vj_hl/rico1",self.EndPos)
					fx:SetVelocity(Vector(0,0,0))
					fx:SetAirResistance(160)
					fx:SetDieTime(0.15)
					fx:SetStartAlpha(255)
					fx:SetEndAlpha(0)
					fx:SetStartSize(4)
					fx:SetEndSize(8)
					fx:SetRoll(math.Rand(180,360))
					fx:SetRollDelta(math.Rand(-1,1))
					fx:SetColor(255,255,255)
				end
			end
		end
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp(fDelta, 0, 1) ^ 0.5
	render.SetMaterial(self.MainMat)
	local sinWave = math.sin(fDelta * math.pi)
	render.DrawBeam(
		self.EndPos - self.Dir * (fDelta - sinWave * self.Length),
		self.EndPos - self.Dir * (fDelta + sinWave * self.Length),
		1 + sinWave * 3, 1, 0, Color(255, 255, 255, 25)
		-- 5 + sinWave * 10, 1, 0, Color(255, 223, 137, 25)
	)
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data) // You're welcome @DrVrej for not making the effect name Ricochet you illiterate boi
	self.Pos = data:GetOrigin()
	self.Size = data:GetScale()
	self.EffectType = math.Round(data:GetMagnitude())
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end

	sound.Play("vj_hlr/gsrc/fx/ric" .. math.random(1, 5) .. ".wav", self.Pos, 80, 100)

	if GetConVar("vj_hlr1_sparkfx"):GetInt() == 1 then
		for i = 1, math.random(5, 15) do
			local particle = Emitter:Add("vj_hl/tracer_middle", self.Pos)
			particle:SetVelocity(VectorRand() *math.Rand(100, 350))
			particle:SetDieTime(math.Rand(0.1, 1))
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(1)
			particle:SetEndSize(3)
			particle:SetRoll(math.random(0, 360))
			particle:SetGravity(Vector(math.random(-300, 300), math.random(-300, 300), math.random(-300, -700)))
			particle:SetCollide(true)
			particle:SetBounce(0.9)
			particle:SetAirResistance(120)
			particle:SetStartLength(0)
			particle:SetEndLength(0.1)
			particle:SetVelocityScale(true)
			particle:SetCollide(true)
			particle:SetColor(255, 231, 166)
		end
	end
	
	local effect = self.EffectType or math.random(1, 2)
	if effect == 1 then
		local fx = Emitter:Add("vj_hl/rico2", self.Pos)
		fx:SetVelocity(Vector(0, 0, 0))
		fx:SetAirResistance(160)
		fx:SetDieTime(0.15)
		fx:SetStartAlpha(255)
		fx:SetEndAlpha(0)
		fx:SetStartSize(self.Size or math.random(5, 8))
		fx:SetEndSize(5)
		fx:SetRoll(math.Rand(180, 360))
		fx:SetRollDelta(math.Rand(-1, 1))
		fx:SetColor(255, 255, 255)
	elseif effect == 2 then
		local fx = Emitter:Add("vj_hl/rico1", self.Pos)
		fx:SetVelocity(Vector(0, 0, 0))
		fx:SetAirResistance(160)
		fx:SetDieTime(0.15)
		fx:SetStartAlpha(255)
		fx:SetEndAlpha(0)
		fx:SetStartSize(self.Size or 4)
		fx:SetEndSize(self.Size && self.Size *2 or 8)
		fx:SetColor(255, 255, 255)
	end

	Emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end

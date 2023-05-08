/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Size = data:GetScale()
	local emitter = ParticleEmitter(self.Pos)
	if emitter == nil then return end
	
	for _ = 1, 10 do
		local fxSpark = emitter:Add("vj_hl/tracer_middle", self.Pos)
		fxSpark:SetVelocity(VectorRand() * math.Rand(50, 50))
		fxSpark:SetDieTime(math.Rand(0.3, 0.5))
		fxSpark:SetStartAlpha(200)
		fxSpark:SetEndAlpha(0)
		fxSpark:SetStartSize(1)
		fxSpark:SetEndSize(2)
		fxSpark:SetRoll(math.random(0,360))
		fxSpark:SetGravity(Vector(math.random(-300,300),math.random(-300,300),math.random(-200,-10)))
		fxSpark:SetBounce(0.9)
		fxSpark:SetAirResistance(120)
		fxSpark:SetStartLength(0)
		fxSpark:SetEndLength(0.2)
		fxSpark:SetVelocityScale(true)
		fxSpark:SetCollide(true)
		fxSpark:SetColor(255,231,166)
	end
	local fx = emitter:Add("vj_hl/rico1",self.Pos)
	fx:SetVelocity(Vector(0, 0, 0))
	fx:SetAirResistance(160)
	fx:SetDieTime(0.15)
	fx:SetStartAlpha(255)
	fx:SetEndAlpha(0)
	fx:SetStartSize(self.Size or 4)
	fx:SetEndSize(self.Size && self.Size *2 or 8)
	fx:SetColor(255,255,255)
	emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end
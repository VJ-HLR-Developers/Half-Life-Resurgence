/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
	local emitter = ParticleEmitter(vOffset, true)

	for _ = 0, 100 do
		local color = Vector(97, 108, 165)
		local pinkCore = false
		if math.random(1 , 3) == 1 then
			color = Vector(178, 77, 121)
			pinkCore = true
		end
		local size = (pinkCore == true and math.Rand(3, 4)) or math.Rand(3, 5)
		local pos = Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1))
		local particle = emitter:Add("particles/balloon_bit", vOffset + pos * 8)

		if (particle) then
			local alpha = math.random(100, 130)
			particle:SetVelocity(pos * 400)
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(20, 30))
			particle:SetStartAlpha(alpha)
			particle:SetEndAlpha(alpha)
			
			particle:SetStartSize(size)
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, -60))
			
			particle:SetColor(color.r, color.g, color.b)
			particle:SetCollide(true)
			particle:SetAngleVelocity(Angle(math.Rand(-160, 160), math.Rand(-160, 160), math.Rand(-160, 160)))
			particle:SetBounce(0)
			particle:SetLighting(true)
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Size = data:GetScale()
	local emitter = ParticleEmitter(self.Pos)
	if emitter == nil then return end
	
	local fx = emitter:Add("vj_hl/sprites/steam1", self.Pos)
	fx:SetVelocity(self:GetUp()*100 + Vector(0, 20, 20))
	fx:SetDieTime(2)
	fx:SetStartSize(self.Size)
	fx:SetEndSize(self.Size + math.random(0, 9))
	fx:SetRoll(math.Rand(-5, 5))
	fx:SetEndAlpha(0)
	emitter:Finish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end
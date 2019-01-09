if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('shared.lua')
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners
--------------------------------------------------*/

function ENT:Draw() end

/* Taken from my CPTBase effect manager entity. Copyright my asshole beeeeeech*/
ENT.NextEffectBlendT = 0
ENT.EffectBlend = 1
function ENT:Initialize()
	local ENTInd = self:EntIndex()
	hook.Add("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd, function()
		if !IsValid(self) then
			hook.Remove("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd)
			return
		end
		local EffectTime = self:GetNetworkedInt("EFtime")
		local EffectDeathDelay = CurTime() +EffectTime
		local EffectOverlay = Material("vj_hl/shockroach_plasma")
		local Target = self:GetNetworkedEntity("EFent")
		local EffectBlendAdd = 0.05
		if !IsValid(Target) then return end
		cam.Start3D(EyePos(),EyeAngles())
			if util.IsValidModel(Target:GetModel()) then
				render.SetBlend(self.EffectBlend)
				render.MaterialOverride(EffectOverlay)
				Target:DrawModel()
				render.MaterialOverride(0)
				render.SetBlend(1)
			end
		cam.End3D()
		cam.Start3D(EyePos(),EyeAngles(),70)
			if Target:IsPlayer() && Target:GetViewModel() != nil && IsValid(Target:GetViewModel()) then
				if util.IsValidModel(Target:GetViewModel():GetModel()) then
					render.SetBlend(self.EffectBlend)
					render.MaterialOverride(EffectOverlay)
					Target:GetViewModel():DrawModel()
					render.MaterialOverride(0)
					render.SetBlend(1)
				end
			end
		cam.End3D()
		if CurTime() >= self.NextEffectBlendT then
			self.NextEffectBlendT = CurTime() +0.05
			if self.EffectBlend > 0 then
				if CurTime() >= EffectDeathDelay then
					EffectBlendAdd = EffectBlendAdd +math.Clamp(((CurTime() -EffectDeathDelay) /100), 0, 0.05)
				end
				self.EffectBlend = self.EffectBlend -(EffectTime /(EffectTime ^2)) *EffectBlendAdd
			end
		end
	end)
end
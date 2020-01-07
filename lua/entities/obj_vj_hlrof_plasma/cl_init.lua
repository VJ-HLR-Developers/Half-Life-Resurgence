if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('shared.lua')
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners
--------------------------------------------------*/

function ENT:Draw() end

/* Taken from my CPTBase effect manager entity. Copyright my asshole beeeeeech*/
-- ENT.NextEffectBlendT = 0
-- ENT.EffectBlend = 1
-- function ENT:Initialize()
	-- local ENTInd = self:EntIndex()
	-- local Ent = self
	-- hook.Add("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd,function()
		-- if !IsValid(Ent) then
			-- hook.Remove("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd)
			-- return
		-- end
		-- local EffectTime = 3
		-- local EffectDeathDelay = CurTime() +EffectTime
		-- local EffectOverlay = Material("vj_hl/renderfx/render_blue")
		-- local Target = Ent:GetNetworkedEntity("GlowEntity")
		-- local EffectBlendAdd = 0.05
		-- print(Ent,EffectTime,Target)
		-- if !IsValid(Target) then return end
		-- cam.Start3D(EyePos(),EyeAngles())
			-- if util.IsValidModel(Target:GetModel()) then
				-- render.SetBlend(Ent.EffectBlend)
				-- render.MaterialOverride(EffectOverlay)
				-- Target:DrawModel()
				-- render.MaterialOverride(0)
				-- render.SetBlend(1)
			-- end
		-- cam.End3D()
		-- cam.Start3D(EyePos(),EyeAngles(),70)
			-- if Target:IsPlayer() && Target:GetViewModel() != nil && IsValid(Target:GetViewModel()) then
				-- if util.IsValidModel(Target:GetViewModel():GetModel()) then
					-- render.SetBlend(Ent.EffectBlend)
					-- render.MaterialOverride(EffectOverlay)
					-- Target:GetViewModel():DrawModel()
					-- render.MaterialOverride(0)
					-- render.SetBlend(1)
				-- end
			-- end
		-- cam.End3D()
		-- if CurTime() >= Ent.NextEffectBlendT then
			-- Ent.NextEffectBlendT = CurTime() +0.05
			-- if Ent.EffectBlend > 0 then
				-- if CurTime() >= EffectDeathDelay then
					-- EffectBlendAdd = EffectBlendAdd +math.Clamp(((CurTime() -EffectDeathDelay) /100), 0, 0.05)
				-- end
				-- Ent.EffectBlend = Ent.EffectBlend -(EffectTime /(EffectTime ^2)) *EffectBlendAdd
			-- end
		-- end
	-- end)
-- end
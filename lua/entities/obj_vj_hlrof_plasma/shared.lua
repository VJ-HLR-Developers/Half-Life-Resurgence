ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Blaster Rod"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if (CLIENT) then
	local Name = "Shock Trooper"
	local LangName = "obj_vj_hlof_shock"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))

	-- net.Receive("vj_hlr_shockeffect",function(len,pl)
		-- local EffectTime = net.ReadFloat()
		-- local Target = net.ReadEntity()
		-- local Ent = net.ReadEntity()
		-- local ENTInd = Ent:EntIndex()
		-- hook.Add("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd,function()
			-- if !IsValid(Ent) then
				-- hook.Remove("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd)
				-- return
			-- end
			-- local NextEffectBlendT = 0
			-- local EffectBlend = 1
			-- local EffectTime = Ent:GetNetworkedInt("EFtime")
			-- local EffectDeathDelay = CurTime() +EffectTime
			-- local EffectOverlay = Material("vj_hl/renderfx/render_blue")
			-- local Target = Ent:GetNetworkedEntity("EFent")
			-- local EffectBlendAdd = 0.05
			-- if !IsValid(Target) then return end
			-- cam.Start3D(EyePos(),EyeAngles())
				-- if util.IsValidModel(Target:GetModel()) then
					-- render.SetBlend(EffectBlend)
					-- render.MaterialOverride(EffectOverlay)
					-- Target:DrawModel()
					-- render.MaterialOverride(0)
					-- render.SetBlend(1)
				-- end
			-- cam.End3D()
			-- cam.Start3D(EyePos(),EyeAngles(),70)
				-- if Target:IsPlayer() && Target:GetViewModel() != nil && IsValid(Target:GetViewModel()) then
					-- if util.IsValidModel(Target:GetViewModel():GetModel()) then
						-- render.SetBlend(EffectBlend)
						-- render.MaterialOverride(EffectOverlay)
						-- Target:GetViewModel():DrawModel()
						-- render.MaterialOverride(0)
						-- render.SetBlend(1)
					-- end
				-- end
			-- cam.End3D()
			-- if CurTime() >= NextEffectBlendT then
				-- NextEffectBlendT = CurTime() +0.05
				-- if EffectBlend > 0 then
					-- if CurTime() >= EffectDeathDelay then
						-- EffectBlendAdd = EffectBlendAdd +math.Clamp(((CurTime() -EffectDeathDelay) /100), 0, 0.05)
					-- end
					-- EffectBlend = EffectBlend -(EffectTime /(EffectTime ^2)) *EffectBlendAdd
				-- end
			-- end
		-- end)
	-- end)

	ENT.NextEffectBlendT = 0
	ENT.EffectBlend = 1
	function ENT:Initialize()
		local ENTInd = self:EntIndex()
		local Ent = self
		hook.Add("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd,function()
			if !IsValid(Ent) then
				hook.Remove("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd)
				return
			end
			local EffectTime = 3
			local EffectDeathDelay = CurTime() +EffectTime
			local EffectOverlay = Material("vj_hl/renderfx/render_blue")
			local Target = Ent:GetNWEntity("GlowEntity")
			local EffectBlendAdd = 0.05
			-- print(Ent,EffectTime,Target)
			if !IsValid(Target) then return end
			cam.Start3D(EyePos(),EyeAngles())
				if util.IsValidModel(Target:GetModel()) then
					render.SetBlend(Ent.EffectBlend)
					render.MaterialOverride(EffectOverlay)
					Target:DrawModel()
					render.MaterialOverride(0)
					render.SetBlend(1)
				end
			cam.End3D()
			cam.Start3D(EyePos(),EyeAngles(),70)
				if Target:IsPlayer() && Target:GetViewModel() != nil && IsValid(Target:GetViewModel()) then
					if util.IsValidModel(Target:GetViewModel():GetModel()) then
						render.SetBlend(Ent.EffectBlend)
						render.MaterialOverride(EffectOverlay)
						Target:GetViewModel():DrawModel()
						render.MaterialOverride(0)
						render.SetBlend(1)
					end
				end
			cam.End3D()
			if CurTime() >= Ent.NextEffectBlendT then
				Ent.NextEffectBlendT = CurTime() +0.05
				if Ent.EffectBlend > 0 then
					if CurTime() >= EffectDeathDelay then
						EffectBlendAdd = EffectBlendAdd +math.Clamp(((CurTime() -EffectDeathDelay) /100), 0, 0.05)
					end
					Ent.EffectBlend = Ent.EffectBlend -(EffectTime /(EffectTime ^2)) *EffectBlendAdd
				end
			end
		end)
	end
end
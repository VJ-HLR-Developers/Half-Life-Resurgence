ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Kingpin"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	local mat = Material("vj_hl/renderfx/render_kingpin")
	local mat_object = Material("vj_hl/renderfx/render_kingpin2")
	function ENT:Initialize()
		local index = self:EntIndex()
		hook.Add("RenderScreenspaceEffects", "VJ_HLR_Kingpin_Shield" .. index, function()
			if IsValid(self) then
				if self:GetNW2Bool("PsionicEffect") then
					cam.Start3D(EyePos(), EyeAngles())
						if util.IsValidModel(self:GetModel()) then
							render.SetBlend(1)
							render.MaterialOverride(mat)
							self:DrawModel()
							render.MaterialOverride(0)
							render.SetBlend(1)
						end
					cam.End3D()
					for _, prop in ipairs(ents.FindByClass("prop_*")) do
						if prop:GetNW2Bool("BeingControlledByKingPin") then
							cam.Start3D(EyePos(), EyeAngles())
								render.SetBlend(1)
								render.MaterialOverride(mat_object)
								prop:DrawModel()
								render.MaterialOverride(0)
								render.SetBlend(1)
							cam.End3D()
						end
					end
				end
			else
				hook.Remove("RenderScreenspaceEffects", "VJ_HLR_Kingpin_Shield" .. index)
			end
		end)
	end
end
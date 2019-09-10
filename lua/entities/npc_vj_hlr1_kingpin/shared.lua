ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Kingpin"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	local mat = Material("vj_hl/renderfx/render_blue")
	function ENT:Initialize()
		local index = self:EntIndex()
		hook.Add("RenderScreenspaceEffects","VJ_HLR_Kingpin_Shield" .. index,function()
			if !IsValid(self) then
				hook.Remove("RenderScreenspaceEffects","VJ_HLR_Kingpin_Shield" .. index)
				return
			end
			if !IsValid(self) then return end
			if self:GetNWBool("shield") then
				cam.Start3D(EyePos(),EyeAngles())
					if util.IsValidModel(self:GetModel()) then
						render.SetBlend(3)
						render.MaterialOverride(mat)
						self:DrawModel()
						render.MaterialOverride(0)
						render.SetBlend(3)
					end
				cam.End3D()
			end
		end)
	end
end
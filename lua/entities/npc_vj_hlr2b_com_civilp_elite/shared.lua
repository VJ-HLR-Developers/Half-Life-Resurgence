ENT.Base 			= "npc_vj_human_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Civil Protection Elite"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "Half-Life Resurgence"

if CLIENT && GetConVar("vj_hlr2_combine_eyeglow"):GetBool() then
    local mat = Material("sprites/light_glow02_add")
    local col = Color(255, 213, 123)
	local render_SetMaterial = render.SetMaterial
	local render_DrawSprite = render.DrawSprite
	local size = 8
	function ENT:Draw()
		self:DrawModel()
        local bone = self:LookupBone("ValveBiped.Bip01_Head1")
        local pos, ang = self:GetBonePosition(bone)
        local glowOrigin = pos + ang:Forward() * 3.75 + ang:Right() * 7 + ang:Up() * 1.75
        render.SetMaterial(mat)
		render_DrawSprite(glowOrigin, size, size, col)
		render_DrawSprite(glowOrigin, size, size, col)
		glowOrigin = pos + ang:Forward() * 3.75 + ang:Right() * 7 + ang:Up() * -1.75
		render_DrawSprite(glowOrigin, size, size, col)
		render_DrawSprite(glowOrigin, size, size, col)
    end
end
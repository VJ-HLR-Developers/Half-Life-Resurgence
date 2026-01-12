ENT.Base 			= "npc_vj_human_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Civil Protection"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "Half-Life Resurgence"

ENT.VJ_ID_Police = true

if CLIENT && GetConVar("vj_hlr2_combine_eyeglow"):GetBool() then
    local mat = Material("sprites/light_glow02_add")
    local vecOrigin = Vector(3.6, 6.75, 1.7)
    local col = Color(118, 236, 110)
	local render_SetMaterial = render.SetMaterial
	local render_DrawSprite = render.DrawSprite
    function ENT:Draw()
		self:DrawModel()
        local bone = self:LookupBone("ValveBiped.Bip01_Head1")
        local pos, ang = self:GetBonePosition(bone)
        local glowOrigin = pos + ang:Forward() * 3.6 + ang:Right() * 6.75 + ang:Up() * 1.7
        render_SetMaterial(mat)
		render_DrawSprite(glowOrigin, 8, 8, col)
		render_DrawSprite(glowOrigin, 8, 8, col)
		glowOrigin = pos + ang:Forward() * 3.6 + ang:Right() * 6.75 + ang:Up() * -1.7
		render_DrawSprite(glowOrigin, 8, 8, col)
		render_DrawSprite(glowOrigin, 8, 8, col)
    end
end
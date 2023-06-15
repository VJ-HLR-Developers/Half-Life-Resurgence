ENT.Base 			= "npc_vj_hlr2b_com_soldier"
ENT.Type 			= "ai"
ENT.PrintName 		= "Overwatch Elite"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

if CLIENT && GetConVar("vj_hlr2_combine_eyeglow"):GetInt() == 1 then
    local mat = Material("sprites/light_glow02_add")
    local vecOrigin = Vector(0.3,10.6,1.75)
    local size = 14
    local col = Color(255,239,68)
	function ENT:Draw()
		self:DrawModel()
        local bone = self:LookupBone("ValveBiped.Bip01_Head1")
        local pos,ang = self:GetBonePosition(bone)
        local glowOrigin = pos + ang:Forward() * vecOrigin.x + ang:Right() * vecOrigin.y + ang:Up() * vecOrigin.z + ang:Up() *1
        render.SetMaterial(mat)
        for i = 1, 2 do
            if i == 2 then
                glowOrigin = pos + ang:Forward() * vecOrigin.x + ang:Right() * vecOrigin.y + ang:Up() * -vecOrigin.z + ang:Up() *-0.25
            end
            render.DrawSprite(glowOrigin, size, size, col)
            render.DrawSprite(glowOrigin, size, size, col)
        end
    end
end
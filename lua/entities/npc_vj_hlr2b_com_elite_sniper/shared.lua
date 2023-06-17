ENT.Base 			= "npc_vj_hlr2b_com_soldier"
ENT.Type 			= "ai"
ENT.PrintName 		= "Overwatch Sniper Elite (Beta)"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	-- Do not draw eye glow for this combine unit
	function ENT:Draw()
		self:DrawModel()
    end
end
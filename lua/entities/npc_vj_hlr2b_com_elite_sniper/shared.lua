ENT.Base 			= "npc_vj_human_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Overwatch Sniper Elite (Beta)"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	-- Do not draw eye glow for this combine unit, he's supposed to be camouflaged!
	function ENT:Draw()
		self:DrawModel()
    end
end
ENT.Base 			= "npc_vj_hlof_humangrunt"
ENT.Type 			= "ai"
ENT.PrintName 		= "Human Grunt Medic"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life: Resurgence"

if (CLIENT) then
	local Name = "Human Grunt Medic"
	local LangName = "npc_vj_hlof_humangrunt_med"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
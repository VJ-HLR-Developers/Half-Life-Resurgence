ENT.Base 			= "npc_vj_hl_zombie"
ENT.Type 			= "ai"
ENT.PrintName 		= "Zombie Soldier"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half Life"

if (CLIENT) then
	local Name = "Zombie Soldier"
	local LangName = "npc_vj_hlof_zombiesoldier"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
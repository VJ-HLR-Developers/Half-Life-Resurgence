/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Half-Life: Resurgence"
local AddonName = "Half-Life: Resurgence"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_hl_autorun.lua"
-------------------------------------------------------

local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "Half-Life: Resurgence"

	-- Half-Life 1 -------------------------------------------------------
		-- HECU
		VJ.AddNPC("Human Grunt","npc_vj_hl_humangrunt",vCat)
			-- Opposing Force
			VJ.AddNPC("Human Grunt (OppF)","npc_vj_hlof_humangrunt",vCat)
			VJ.AddNPC("Shock Trooper","npc_vj_hlof_shocktrooper",vCat)

		-- Xen Creatures
		VJ.AddNPC("Alien Grunt","npc_vj_hl_aliengrunt",vCat)
		VJ.AddNPC("Baby Headcrab","npc_vj_hl_babyheadcrab",vCat)
		VJ.AddNPC("Gonarch","npc_vj_hl_gonarch",vCat)
			-- Headcrab
			VJ.AddNPC("Zombie","npc_vj_hl_zombie",vCat)
				-- Opposing Force
				VJ.AddNPC("Zombie Security Guard","npc_vj_hlof_zombiesecurity",vCat)
				VJ.AddNPC("Zombie Soldier","npc_vj_hlof_zombiesoldier",vCat)
		
	-- Half-Life 2 -------------------------------------------------------
		-- Combine
		VJ.AddNPC_HUMAN("Overwatch Soldier","npc_vj_hl2c_soldier",{"weapon_vj_smg1","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_ar2","weapon_vj_ar2"},vCat)
		VJ.AddNPC_HUMAN("Overwatch Shotgun Soldier","npc_vj_hl2c_shotgunner",{"weapon_vj_spas12"},vCat)
		VJ.AddNPC_HUMAN("Overwatch Elite","npc_vj_hl2c_elite",{"weapon_vj_ar2"},vCat)
		VJ.AddNPC_HUMAN("Overwatch Prison Guard","npc_vj_hl2c_prospekt",{"weapon_vj_smg1","weapon_vj_smg1","weapon_vj_ar2","weapon_vj_ar2"},vCat)
		VJ.AddNPC_HUMAN("Overwatch Prison Shotgun Guard","npc_vj_hl2c_pshotgunner",{"weapon_vj_spas12"},vCat)
		//VJ.AddNPC("Combine Assassin","npc_vj_hl2c_assassin",vCat)

		-- Resistance
		VJ.AddNPC_HUMAN("Rebel","npc_vj_hl2r_rebel",{"weapon_vj_357","weapon_vj_9mmpistol","weapon_vj_glock17","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_k3","weapon_vj_k3","weapon_vj_ar2","weapon_vj_ar2","weapon_vj_ak47","weapon_vj_m16a1","weapon_vj_mp40","weapon_vj_spas12","weapon_vj_rpg","weapon_vj_blaster"},vCat)
		
		-- Random Creatures
		VJ.AddNPC("Hydra","npc_vj_hlrand_hydra",vCat)
	
	-- Decals
	game.AddDecal("VJ_Blood_HL1_Red",{"vj_hl/decals/hl_blood01","vj_hl/decals/hl_blood02","vj_hl/decals/hl_blood03","vj_hl/decals/hl_blood04","vj_hl/decals/hl_blood05","vj_hl/decals/hl_blood06","vj_hl/decals/hl_blood07","vj_hl/decals/hl_blood08"})
	game.AddDecal("VJ_Blood_HL1_Yellow",{"vj_hl/decals/hl_yblood01","vj_hl/decals/hl_yblood02","vj_hl/decals/hl_yblood03","vj_hl/decals/hl_yblood04","vj_hl/decals/hl_yblood05","vj_hl/decals/hl_yblood06"})
	
	-- ConVars --
	VJ.AddConVar("vj_hl2c_soldier_h",60)
	VJ.AddConVar("vj_hl2c_soldierprison_h",75)
	VJ.AddConVar("vj_hl2c_soldierelite_h",100)
	VJ.AddConVar("vj_hl2c_soldier_d",10)
	
	VJ.AddConVar("vj_hl2r_rebel_h",60)
	VJ.AddConVar("vj_hl2r_rebel_d",10)
	
	-- Particles
	game.AddParticles("particles/vj_hl_shocktrooper.pcf")
	game.AddParticles("particles/vj_hl_sporegrenade.pcf")

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end

				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end

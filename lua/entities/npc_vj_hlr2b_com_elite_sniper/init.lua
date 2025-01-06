include("entities/npc_vj_hlr2b_com_soldier/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2b/combine_elite.mdl" -- Model(s) to spawn with | Picks a random one if it's a table 
ENT.StartHealth = 80
ENT.SightAngle = 200
ENT.Weapon_Accuracy = 0.5
ENT.Weapon_FiringDistanceFar = 10000
include("entities/npc_vj_hlr1_scientist/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/cleansuit_scientist.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.IsMedic = false -- Is this NPC a medic? It will heal friendly players and NPCs

ENT.SCI_Type = 1
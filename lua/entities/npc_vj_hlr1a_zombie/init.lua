include("entities/npc_vj_hlr1_zombie/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/zombie.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(4, 0, 0), -- The offset for the controller when the camera is in first person
}
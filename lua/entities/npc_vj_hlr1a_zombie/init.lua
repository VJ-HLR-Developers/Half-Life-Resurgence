include("entities/npc_vj_hlr1_zombie/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/zombie.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, -20),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(4, 0, 0),
}
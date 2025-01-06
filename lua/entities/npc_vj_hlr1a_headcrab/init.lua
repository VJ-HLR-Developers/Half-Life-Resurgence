include("entities/npc_vj_hlr1_headcrab/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/headcrab.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 20
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed025", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(4, 0, 1), -- The offset for the controller when the camera is in first person
}
ENT.LeapAttackDamage = 100
ENT.SoundTbl_LeapAttackJump = "vj_hlr/hla_npc/headcrab/hc_attack1.wav"
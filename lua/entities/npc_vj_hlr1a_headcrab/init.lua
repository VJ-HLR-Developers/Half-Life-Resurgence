include("entities/npc_vj_hlr1_headcrab/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/headcrab.mdl"
ENT.StartHealth = 20
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, 0),
    FirstP_Bone = "unnamed025",
    FirstP_Offset = Vector(4, 0, 1),
}
ENT.LeapAttackDamage = 100
ENT.SoundTbl_LeapAttackJump = "vj_hlr/gsrc/npc/headcrab_alpha/hc_attack1.wav"
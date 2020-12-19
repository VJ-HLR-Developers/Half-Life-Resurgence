AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/headcrab.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 20
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed025", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(4, 0, 1), -- The offset for the controller when the camera is in first person
}
ENT.LeapAttackDamage = 100
ENT.SoundTbl_LeapAttackJump = {"vj_hlr/hla_npc/headcrab/hc_attack1.wav","vj_hlr/hl1_npc/headcrab/hc_attack2.wav","vj_hlr/hl1_npc/headcrab/hc_attack3.wav"}
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
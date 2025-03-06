include("entities/npc_vj_hlr1_scientist/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/scientist.mdl"
ENT.IsMedic = false
ENT.ControllerParams = {
    ThirdP_Offset = Vector(10, 0, -20),
    FirstP_Bone = "unnamed021",
    FirstP_Offset = Vector(2, 0, 5),
}

ENT.SoundTbl_IdleDialogueAnswer = "vj_hlr/gsrc/npc/barney_alpha/ba_pain1.wav"
ENT.SoundTbl_Pain = "vj_hlr/gsrc/npc/barney_alpha/ba_pain1.wav"
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/barney_alpha/ba_die1.wav", "vj_hlr/gsrc/npc/barney_alpha/ba_die2.wav", "vj_hlr/gsrc/npc/barney_alpha/ba_die3.wav"}
	
ENT.SCI_Type = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetBodygroup(0, math.random(0, 4))
end
include("entities/npc_vj_hlr1_scientist/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/scientist.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.IsMedicSNPC = false -- Is this NPC a medic? It will heal friendly players and NPCs
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed021", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(2, 0, 5), -- The offset for the controller when the camera is in first person
}

ENT.SoundTbl_IdleDialogueAnswer = "vj_hlr/hla_npc/barney/ba_pain1.wav"
ENT.SoundTbl_Pain = "vj_hlr/hla_npc/barney/ba_pain1.wav"
ENT.SoundTbl_Death = {"vj_hlr/hla_npc/barney/ba_die1.wav","vj_hlr/hla_npc/barney/ba_die2.wav","vj_hlr/hla_npc/barney/ba_die3.wav"}
	
ENT.SCI_Type = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetBodygroup(0, math.random(0, 4))
end
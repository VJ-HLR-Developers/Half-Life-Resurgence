AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/scientist.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.IsMedicSNPC = false -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed021", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(2, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCI_CustomOnInitialize()
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hla_npc/barney/ba_pain1.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hla_npc/barney/ba_pain1.wav"}
	self.SoundTbl_Death = {"vj_hlr/hla_npc/barney/ba_die1.wav","vj_hlr/hla_npc/barney/ba_die2.wav","vj_hlr/hla_npc/barney/ba_die3.wav"}
	
	self:SetBodygroup(0, math.random(0, 4))
end
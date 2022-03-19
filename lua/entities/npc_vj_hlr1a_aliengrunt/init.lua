AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/agrunt.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
	FirstP_Bone = "unnamed034", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(12, 0, 5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}

ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1a_hornet"
ENT.RangeAttackPos_Up = 35 -- Up/Down spawning position for range attack

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(25,25,85), Vector(-25,-25,0))
	----
	self.SoundTbl_Idle = {"vj_hlr/hla_npc/agrunt/ag_idle1.wav","vj_hlr/hla_npc/agrunt/ag_idle2.wav","vj_hlr/hla_npc/agrunt/ag_idle3.wav","vj_hlr/hla_npc/agrunt/ag_idle4.wav","vj_hlr/hla_npc/agrunt/ag_idle5.wav","vj_hlr/hla_npc/agrunt/ag_idle6.wav","vj_hlr/hla_npc/agrunt/ag_idle7.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hla_npc/agrunt/ag_alert1.wav","vj_hlr/hla_npc/agrunt/ag_alert2.wav","vj_hlr/hla_npc/agrunt/ag_alert3.wav"}
	self.SoundTbl_MeleeAttackExtra = {"vj_hlr/hla_npc/agrunt/ag_attack1.wav"}
	self.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
	self.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hla_npc/agrunt/ag_attack2.wav"}
	self.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/agrunt/ag_attack1.wav","vj_hlr/hl1_npc/agrunt/ag_attack2.wav","vj_hlr/hl1_npc/agrunt/ag_attack3.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hla_npc/agrunt/ag_pain1.wav","vj_hlr/hla_npc/agrunt/ag_pain2.wav","vj_hlr/hla_npc/agrunt/ag_pain3.wav","vj_hlr/hla_npc/agrunt/ag_pain4.wav","vj_hlr/hla_npc/agrunt/ag_pain5.wav"}
	self.SoundTbl_Death = {"vj_hlr/hla_npc/agrunt/ag_die1.wav","vj_hlr/hla_npc/agrunt/ag_die2.wav","vj_hlr/hla_npc/agrunt/ag_die3.wav"}
	----
	self.AnimTbl_Death = {ACT_DIEFORWARD,ACT_DIESIMPLE}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "event_emit Step" then
		self:FootStepSoundCode()
	elseif key == "event_mattack" then
		self:MeleeAttackCode()
	elseif key == "event_rattack" then
		self:RangeAttackCode()
		VJ_EmitSound(self, "vj_hlr/hla_npc/agrunt/ag_fire"..math.random(1, 3)..".wav", 75, 100)
	elseif key == "body" then
		VJ_EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	-- since everything is based on hl1 agrunt this is just overwritten to do nothing
end
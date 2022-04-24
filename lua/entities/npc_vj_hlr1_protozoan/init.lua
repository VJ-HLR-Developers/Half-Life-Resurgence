AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/protozoa.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 5
ENT.HullType = HULL_TINY
ENT.TurningSpeed = 1 -- How fast it can turn
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 100 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 100 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.VJC_Data = {
    ThirdP_Offset = Vector(-5, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone03", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.IdleAlwaysWander = true -- If set to true, it will make the SNPC always wander when idling
ENT.CanOpenDoors = false -- Can it open doors?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE -- The behavior of the SNPC
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/protozoan/chirp03.wav","vj_hlr/hl1_npc/protozoan/chirp04.wav","vj_hlr/hl1_npc/protozoan/chirp05.wav","vj_hlr/hl1_npc/protozoan/chirp06.wav","vj_hlr/hl1_npc/protozoan/chirp07.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/protozoan/chirp03.wav","vj_hlr/hl1_npc/protozoan/chirp04.wav","vj_hlr/hl1_npc/protozoan/chirp05.wav","vj_hlr/hl1_npc/protozoan/chirp06.wav","vj_hlr/hl1_npc/protozoan/chirp07.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(28, 28, 65), Vector(-28, -28, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo, hitgroup)
	//ParticleEffect("vj_hlr_blood_boob_yellow", self:GetPos() + self:OBBCenter(), self:GetAngles())
	local effectPop = EffectData()
	effectPop:SetOrigin(self:GetPos() + self:OBBCenter())
	util.Effect("VJ_HLR_Protozoan_Pop", effectPop)
end
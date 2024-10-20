AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/protozoa.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 5
ENT.HullType = HULL_TINY
ENT.TurningSpeed = 1 -- How fast it can turn
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Calm = 100 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_FlyingSpeed_Alerted = 100 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.VJC_Data = {
    ThirdP_Offset = Vector(-5, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone03", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.IdleAlwaysWander = true -- Should the NPC constantly wander while idling?
ENT.CanOpenDoors = false -- Can it open doors?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE -- Type of AI behavior to use for this NPC
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/protozoan/chirp03.wav", "vj_hlr/hl1_npc/protozoan/chirp04.wav", "vj_hlr/hl1_npc/protozoan/chirp05.wav", "vj_hlr/hl1_npc/protozoan/chirp06.wav", "vj_hlr/hl1_npc/protozoan/chirp07.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/protozoan/chirp03.wav", "vj_hlr/hl1_npc/protozoan/chirp04.wav", "vj_hlr/hl1_npc/protozoan/chirp05.wav", "vj_hlr/hl1_npc/protozoan/chirp06.wav", "vj_hlr/hl1_npc/protozoan/chirp07.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(28, 28, 65), Vector(-28, -28, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Finish" then
		//ParticleEffect("vj_hlr_blood_boob_yellow", self:GetPos() + self:OBBCenter(), self:GetAngles())
		local effectPop = EffectData()
		effectPop:SetOrigin(self:GetPos() + self:OBBCenter())
		util.Effect("VJ_HLR_Protozoan_Pop", effectPop)
	end
end
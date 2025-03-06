AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/protozoa.mdl"
ENT.StartHealth = 5
ENT.SightAngle = 360
ENT.HullType = HULL_TINY
ENT.TurningSpeed = 1
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 100
ENT.Aerial_FlyingSpeed_Alerted = 100
ENT.ControllerParams = {
    ThirdP_Offset = Vector(-5, 0, -15),
    FirstP_Bone = "Bone03",
    FirstP_Offset = Vector(0, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.IdleAlwaysWander = true
ENT.CanOpenDoors = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
ENT.HasMeleeAttack = false

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/protozoan/chirp03.wav", "vj_hlr/gsrc/npc/protozoan/chirp04.wav", "vj_hlr/gsrc/npc/protozoan/chirp05.wav", "vj_hlr/gsrc/npc/protozoan/chirp06.wav", "vj_hlr/gsrc/npc/protozoan/chirp07.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/protozoan/chirp03.wav", "vj_hlr/gsrc/npc/protozoan/chirp04.wav", "vj_hlr/gsrc/npc/protozoan/chirp05.wav", "vj_hlr/gsrc/npc/protozoan/chirp06.wav", "vj_hlr/gsrc/npc/protozoan/chirp07.wav"}
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
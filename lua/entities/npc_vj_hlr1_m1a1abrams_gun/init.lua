AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/tank_cannon_new.mdl" -- Model(s) to spawn with | Picks a random one if it's a table 
ENT.StartHealth = 0
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.HasDeathCorpse = false -- Should a corpse spawn when it's killed?

-- Tank Base
ENT.Tank_SoundTbl_Turning = "vj_hlr/hl1_npc/tanks/abrams_turret_rot.wav"
ENT.Tank_SoundTbl_ReloadShell = "vj_hlr/hl1_npc/tanks/tank_reload.wav"
ENT.Tank_SoundTbl_FireShell = "vj_hlr/hl1_npc/tanks/shoot.wav"

ENT.Tank_Shell_SpawnPos = Vector(221.83, 1.24, 95.09)
ENT.Tank_Shell_Entity = "obj_vj_hlr1_rocket"
ENT.Tank_Shell_VelocitySpeed = 3000
ENT.Tank_Shell_MuzzleFlashPos = Vector(267.83, 1.24, 91.09)
ENT.Tank_Shell_ParticlePos = Vector(267.83, 1.24, 91.09)
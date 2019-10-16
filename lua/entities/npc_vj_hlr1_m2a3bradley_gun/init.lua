AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/apc_turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 0
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other

-- Tank Base
ENT.Tank_SoundTbl_Turning = {"vj_hlr/hl1_npc/tanks/bradley_turret_rot.wav"}
ENT.Tank_SoundTbl_ReloadShell = {"vj_hlr/hl1_npc/tanks/tank_reload.wav"}
ENT.Tank_SoundTbl_FireShell = {"vj_hlr/hl1_npc/tanks/shoot.wav"}

ENT.Tank_Shell_TimeUntilFire = 0.8 -- How much time until it fires the shell?
ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_Shell_SpawnPos = Vector(55,0,10)
ENT.Tank_Shell_EntityToSpawn = "obj_vj_hlr1_tank_shell" -- The entity that is spawned when the shell is fired
ENT.Tank_Shell_VelocitySpeed = 3000 -- How fast should the tank shell travel?
ENT.Tank_Shell_DynamicLightPos = Vector(117,0,10)
ENT.Tank_Shell_MuzzleFlashPos = Vector(110,0,10)
ENT.Tank_Shell_ParticlePos = Vector(117,00,10)

util.AddNetworkString("vj_hlr1_m2a3bradleyg_shooteffects")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartShootEffects()
	net.Start("vj_hlr1_m2a3bradleyg_shooteffects")
	net.WriteEntity(self)
	net.Broadcast()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/tank_turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 0
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC

-- Tank Base
ENT.Tank_SoundTbl_Turning = {"vj_hlr/hl1_npc/tanks/abrams_turret_rot.wav"}
ENT.Tank_SoundTbl_ReloadShell = {"vj_hlr/hl1_npc/tanks/tank_reload.wav"}
ENT.Tank_SoundTbl_FireShell = {"vj_hlr/hl1_npc/tanks/shoot.wav"}

ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_Shell_SpawnPos = Vector(230,-5,25)
ENT.Tank_Shell_EntityToSpawn = "obj_vj_hlr1_tank_shell" -- The entity that is spawned when the shell is fired
ENT.Tank_Shell_VelocitySpeed = 3000 -- How fast should the tank shell travel?
ENT.Tank_Shell_DynamicLightPos = Vector(285,-5,25)
ENT.Tank_Shell_MuzzleFlashPos = Vector(285,-5,25)
ENT.Tank_Shell_ParticlePos = Vector(285,-5,25)

util.AddNetworkString("vj_hlr1_m1a1abrams_shooteffects")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartShootEffects()
	net.Start("vj_hlr1_m1a1abrams_shooteffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo,hitgroup)
	local rico = EffectData()
	rico:SetOrigin(dmginfo:GetDamagePosition())
	rico:SetScale(5) -- Size
	rico:SetMagnitude(math.random(1,2)) -- Effect type | 1 = Animated | 2 = Basic
	util.Effect("VJ_HLR_Rico",rico)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
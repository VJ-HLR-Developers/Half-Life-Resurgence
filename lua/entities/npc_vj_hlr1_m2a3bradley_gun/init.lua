AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/apc_turret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 0
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC

-- Tank Base
ENT.Tank_SoundTbl_Turning = {"vj_hlr/hl1_npc/tanks/bradley_turret_rot.wav"}
//ENT.Tank_ReloadShellSoundLevel = 75

ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_Shell_EntityToSpawn = "obj_vj_hlr1_rocket" -- The entity that is spawned when the shell is fired
ENT.Tank_Shell_VelocitySpeed = 3000 -- How fast should the tank shell travel?

util.AddNetworkString("vj_hlr1_m2a3bradleyg_shooteffects")

-- Custom
ENT.Bradley_DoingMissileAtk = false
ENT.Bradley_NextMissileAtkT = 0

local vecMissile = Vector(28.65, 57.25, 19.28)
local vecBullet = Vector(113.9, 2.62, 10.06)
local sdReloadMissile = {"vj_hlr/hl1_npc/tanks/tow_reload.wav"}
local sdReloadBullet = {"vj_hlr/hl1_npc/tanks/25mm_reload.wav"}
local sdFireMissile = {"vj_hlr/hl1_npc/tanks/tow_firing.wav"}
local sdFireBullet = {"vj_hlr/hl1_npc/tanks/biggun2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartShootEffects()
	if !self.Bradley_DoingMissileAtk then
		net.Start("vj_hlr1_m2a3bradleyg_shooteffects")
		net.WriteEntity(self)
		net.Broadcast()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnReloadShell()
	if CurTime() > self.Bradley_NextMissileAtkT && math.random(1, 5) == 1 then
		self.Bradley_DoingMissileAtk = true
		self.Tank_Shell_NextFireTime = 3
		self.Tank_Shell_TimeUntilFire = 1.5
		self.Tank_Shell_SpawnPos = vecMissile
		self.Tank_Shell_DynamicLightPos = vecMissile
		self.Tank_Shell_MuzzleFlashPos = vecMissile
		self.Tank_Shell_ParticlePos = vecMissile
		self.HasReloadShellSound = true
		self.Tank_SoundTbl_ReloadShell = sdReloadMissile
		self.Tank_SoundTbl_FireShell = sdFireMissile
	else
		-- If last attack was a missile attack then play the gun switch sound
		if self.Bradley_DoingMissileAtk then
			self.Tank_Shell_TimeUntilFire = 1
			self.HasReloadShellSound = true
		else
			self.Tank_Shell_TimeUntilFire = 0.5
			self.HasReloadShellSound = false
		end
		self.Bradley_DoingMissileAtk = false
		self.Tank_Shell_NextFireTime = 0
		self.Tank_Shell_SpawnPos = vecBullet
		self.Tank_Shell_DynamicLightPos = vecBullet
		self.Tank_Shell_MuzzleFlashPos = vecBullet
		self.Tank_Shell_ParticlePos = vecBullet
		self.Tank_SoundTbl_ReloadShell = sdReloadBullet
		self.Tank_SoundTbl_FireShell = sdFireBullet
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ40 = Vector(0, 0, 40)
--
function ENT:Tank_CustomOnShellFire_BeforeShellCreate()
	if self.Bradley_DoingMissileAtk then return true end
	
	local ene = self:GetEnemy()
	local pos = self:LocalToWorld(vecBullet)
	self:FireBullets({
		Damage = 1,
		Force = 100,
		HullSize = 10,
		Dir = (ene:GetPos() + ene:OBBCenter()) -  pos,
		Src = pos,
		Spread = Vector(math.Rand(-50, 50), math.Rand(-50, 50), 0),
		TracerName = "VJ_HLR_Tracer_Large",
		Callback = function(attack, tr, dmginfo)
			local hitPos = tr.HitPos
			util.Decal("VJ_HLR_Scorch_Small", hitPos + tr.HitNormal, hitPos - tr.HitNormal)
			util.VJ_SphereDamage(self, self, hitPos, 50, 30, DMG_BLAST, true, true, {Force=100})
			
			sound.Play("vj_hlr/hl1_weapon/explosion/explode"..math.random(3, 5)..".wav", hitPos, 70, 100, 1)
			sound.Play("vj_hlr/hl1_weapon/explosion/debris"..math.random(1, 3)..".wav", hitPos, 70, 100, 1)
	
			local spr = ents.Create("env_sprite")
			spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
			spr:SetKeyValue("GlowProxySize","2.0")
			spr:SetKeyValue("HDRColorScale","1.0")
			spr:SetKeyValue("renderfx","14")
			spr:SetKeyValue("rendermode","5")
			spr:SetKeyValue("renderamt","255")
			spr:SetKeyValue("disablereceiveshadows","0")
			spr:SetKeyValue("mindxlevel","0")
			spr:SetKeyValue("maxdxlevel","0")
			spr:SetKeyValue("framerate","15.0")
			spr:SetKeyValue("spawnflags","0")
			spr:SetKeyValue("scale","1.5")
			spr:SetPos(hitPos + vecZ40)
			spr:Spawn()
			spr:Fire("Kill","",0.9)
			timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
			
			local expLight = ents.Create("light_dynamic")
			expLight:SetKeyValue("brightness", "4")
			expLight:SetKeyValue("distance", "300")
			expLight:SetLocalPos(hitPos)
			expLight:SetLocalAngles(self:GetAngles())
			expLight:Fire("Color", "255 150 0")
			expLight:SetParent(self)
			expLight:Spawn()
			expLight:Activate()
			expLight:Fire("TurnOn", "", 0)
			expLight:Fire("Kill", "", 0.1)
			self:DeleteOnRemove(expLight)
		end
	})
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnShellFire_BeforeShellSpawn(shell, spawnPos)
	-- Only ran when its a missile attack, so no need to check if its bullet attacking
	shell.Rocket_AirMissile = true
	self.Bradley_NextMissileAtkT = CurTime() + math.Rand(12, 25)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_ShellFireVelocity(shell, spawnPos, calculatedVel)
	return -- Done in the projectile instead
end
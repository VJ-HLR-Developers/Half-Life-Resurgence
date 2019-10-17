AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/rpgrocket.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 150 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 20 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 90 -- Put the force amount it should apply | false = Don't apply any force
ENT.ShakeWorldOnDeath = true -- Should the world shake when the projectile hits something?
ENT.ShakeWorldOnDeathAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.ShakeWorldOnDeathRadius = 3000 -- How far the screen shake goes, in world units
ENT.ShakeWorldOnDeathtDuration = 1 -- How long the screen shake will last, in seconds
ENT.ShakeWorldOnDeathFrequency = 200 -- The frequency
ENT.DelayedRemove = 3 -- Change this to a number greater than 0 to delay the removal of the entity
ENT.DecalTbl_DeathDecals = {"VJ_HLR_Scorch"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_weapon/rpg/rocket1.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	util.SpriteTrail(self, 0, Color(255,255,255,255), true, 5, 20, 3, 1/(5+20)*0.5, "vj_hl/sprites/smoke.vmt")
	self:SetNWBool("VJ_Dead", false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	self:SetNWBool("VJ_Dead", true)
	VJ_EmitSound(self,"vj_hlr/hl1_weapon/explosion/debris"..math.random(1,3)..".wav",80,math.random(100,100))
	
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
	spr:SetKeyValue("scale","4")
	spr:SetPos(self:GetPos() + Vector(0,0,80))
	spr:Spawn()
	spr:Fire("Kill","",0.9)
	timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
	
	explight = ents.Create("light_dynamic")
	explight:SetKeyValue("brightness", "4")
	explight:SetKeyValue("distance", "300")
	explight:SetLocalPos(data.HitPos)
	explight:SetLocalAngles(self:GetAngles())
	explight:Fire("Color", "255 150 0")
	explight:SetParent(self)
	explight:Spawn()
	explight:Activate()
	explight:Fire("TurnOn", "", 0)
	explight:Fire("Kill", "", 0.1)
	self:DeleteOnRemove(explight)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
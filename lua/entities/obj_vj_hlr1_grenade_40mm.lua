/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "40mm Grenade"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "VJ Base"

ENT.VJ_ID_Danger = true

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_grenade_40mm", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "grenade_ar2")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/weapons/grenade.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesRadiusDamage = true
ENT.RadiusDamageRadius = 150
ENT.RadiusDamage = 80
ENT.RadiusDamageUseRealisticRadius = true
ENT.RadiusDamageType = DMG_BLAST
ENT.RadiusDamageForce = 90
ENT.CollisionDecal = "VJ_HLR_Scorch"
ENT.SoundTbl_OnRemove = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}
ENT.OnRemoveSoundLevel = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "obj_vj_hlr1_grenade_40mm" then
		self.Model = "models/vj_hlr/weapons/grenade_hd.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddAngleVelocity(Vector(0, math.random(300, 400), 0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
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
	spr:SetPos(self:GetPos() + Vector(0,0,90))
	spr:Spawn()
	spr:Fire("Kill","",0.9)
	//timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
	
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris"..math.random(1,3)..".wav", 80, 100)
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3,5).."_dist.wav", 140, 100)
	local light = ents.Create("light_dynamic")
	light:SetKeyValue("brightness", "4")
	light:SetKeyValue("distance", "300")
	light:SetLocalPos(self:GetPos())
	light:SetLocalAngles( self:GetAngles() )
	light:Fire("Color", "255 150 0")
	light:SetParent(self)
	light:Spawn()
	light:Activate()
	light:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(light)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
end
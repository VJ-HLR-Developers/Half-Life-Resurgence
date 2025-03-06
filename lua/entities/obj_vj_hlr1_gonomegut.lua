/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Gonome Gut"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_gonomegut", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_medium.mdl"
ENT.ProjectileType = VJ.PROJ_TYPE_GRAVITY
ENT.DoesDirectDamage = true
ENT.DirectDamage = 20
ENT.DirectDamageType = DMG_ACID
ENT.CollisionDecal = "VJ_HLR1_Spit_Red"
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/bullchicken/bc_acid1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_acid2.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/gsrc/npc/bullchicken/bc_spithit1.wav", "vj_hlr/gsrc/npc/bullchicken/bc_spithit2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	
	self.Scale = math.Rand(0.5,1.15)

	local idleSprite = ents.Create("env_sprite")
	idleSprite:SetKeyValue("model","vj_hl/sprites/bigspit_red.vmt")
	idleSprite:SetKeyValue("rendercolor","255 255 255")
	idleSprite:SetKeyValue("GlowProxySize","1.0")
	idleSprite:SetKeyValue("HDRColorScale","1.0")
	idleSprite:SetKeyValue("renderfx","0")
	idleSprite:SetKeyValue("rendermode","2")
	idleSprite:SetKeyValue("renderamt","255")
	idleSprite:SetKeyValue("disablereceiveshadows","0")
	idleSprite:SetKeyValue("mindxlevel","0")
	idleSprite:SetKeyValue("maxdxlevel","0")
	idleSprite:SetKeyValue("framerate","40.0")
	idleSprite:SetKeyValue("spawnflags","0")
	idleSprite:SetKeyValue("scale",tostring(self.Scale))
	idleSprite:SetPos(self:GetPos())
	idleSprite:Spawn()
	idleSprite:SetParent(self)
	self:DeleteOnRemove(idleSprite)

	//ParticleEffectAttach("vj_hl_gonome_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model","vj_hl/sprites/bigspit_red_impact.vmt")
	spr:SetKeyValue("GlowProxySize","1.0")
	spr:SetKeyValue("HDRColorScale","1.0")
	spr:SetKeyValue("renderfx","0")
	spr:SetKeyValue("rendermode","2")
	spr:SetKeyValue("renderamt","255")
	spr:SetKeyValue("disablereceiveshadows","0")
	spr:SetKeyValue("mindxlevel","0")
	spr:SetKeyValue("maxdxlevel","0")
	spr:SetKeyValue("framerate","15.0")
	spr:SetKeyValue("spawnflags","0")
	spr:SetKeyValue("scale",tostring(self.Scale *0.3))
	spr:SetPos(data.HitPos)
	spr:Spawn()
	spr:Fire("Kill","",0.3)
	timer.Simple(0.3, function() if IsValid(spr) then spr:Remove() end end)

	//ParticleEffect("vj_hl_gonome",self:GetPos(),Angle(0,0,0))
end
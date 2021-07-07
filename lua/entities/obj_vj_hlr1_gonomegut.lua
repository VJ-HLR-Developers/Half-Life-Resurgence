/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Gonome Gut"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if CLIENT then
	local Name = "Gonome Gut"
	local LangName = "obj_vj_hlr1_gonomegut"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/spitball_medium.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 20 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_ACID -- Damage type
ENT.DecalTbl_DeathDecals = {"VJ_HLR_Spit_Red"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/bullchicken/bc_acid1.wav", "vj_hlr/hl1_npc/bullchicken/bc_acid2.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/bullchicken/bc_spithit3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:EnableDrag(false)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNoDraw(true)
	
	self.Scale = math.Rand(0.5,1.15)

	self.IdleEffect = ents.Create("env_sprite")
	self.IdleEffect:SetKeyValue("model","vj_hl/sprites/bigspit_red.vmt")
	self.IdleEffect:SetKeyValue("rendercolor","255 255 255")
	self.IdleEffect:SetKeyValue("GlowProxySize","1.0")
	self.IdleEffect:SetKeyValue("HDRColorScale","1.0")
	self.IdleEffect:SetKeyValue("renderfx","0")
	self.IdleEffect:SetKeyValue("rendermode","2")
	self.IdleEffect:SetKeyValue("renderamt","255")
	self.IdleEffect:SetKeyValue("disablereceiveshadows","0")
	self.IdleEffect:SetKeyValue("mindxlevel","0")
	self.IdleEffect:SetKeyValue("maxdxlevel","0")
	self.IdleEffect:SetKeyValue("framerate","40.0")
	self.IdleEffect:SetKeyValue("spawnflags","0")
	self.IdleEffect:SetKeyValue("scale",tostring(self.Scale))
	self.IdleEffect:SetPos(self:GetPos())
	self.IdleEffect:Spawn()
	self.IdleEffect:SetParent(self)
	self:DeleteOnRemove(self.IdleEffect)

	-- ParticleEffectAttach("vj_hl_gonome_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data, phys)
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

	-- ParticleEffect("vj_hl_gonome",self:GetPos(),Angle(0,0,0),nil)
end
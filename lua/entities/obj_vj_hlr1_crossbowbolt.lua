/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Crossbow Bolt"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

ENT.PhysicsSolidMask = MASK_SHOT

if CLIENT then
	local Name = "Crossbow Bolt"
	local LangName = "obj_vj_hlr1_crossbowbolt"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_hlr/hl1/crossbow_bolt.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.DoesDirectDamage = true -- Should it deal direct damage when it collides with something?
ENT.DirectDamage = 50
ENT.DirectDamageType = DMG_SLASH
ENT.CollisionDecals = "Impact.Concrete"
ENT.SoundTbl_OnCollide = "vj_hlr/hl1_weapon/crossbow/xbow_hit1.wav"
local sdOnCollideEnt = {"vj_hlr/hl1_weapon/crossbow/xbow_hitbod1.wav", "vj_hlr/hl1_weapon/crossbow/xbow_hitbod2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys)
	if IsValid(data.HitEntity) then
		self.SoundTbl_OnCollide = sdOnCollideEnt
	else
		local spike = ents.Create("prop_dynamic")
		spike:SetModel("models/vj_hlr/hl1/crossbow_bolt.mdl")
		spike:SetPos(data.HitPos + data.HitNormal + self:GetForward()*-20)
		spike:SetAngles(self:GetAngles())
		spike:Activate()
		spike:Spawn()
		timer.Simple(6,function() if IsValid(spike) then spike:Remove() end end)
	end
end
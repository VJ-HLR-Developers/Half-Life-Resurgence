/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Charged Bolt"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local Name = "Charged Bolt"
	local LangName = "obj_vj_hlr2_chargebolt"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/crossbow_bolt.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 0 -- How much damage should it do when it hits something
ENT.DecalTbl_DeathDecals = {"Impact.Concrete"}
ENT.SoundTbl_Idle = {"ambient/energy/electric_loop.wav"}
ENT.SoundTbl_OnCollide = {"ambient/energy/weld1.wav","ambient/energy/weld2.wav"}

ENT.IdleSoundLevel = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:SetMass(1)
	phys:EnableGravity(false)
	phys:EnableDrag(false)
	phys:SetBuoyancyRatio(0)
	self:SetMaterial("models/hl_resurgence/hl2/weapons/w_chargebow_arrow")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data,phys)
	if IsValid(data.HitEntity) then
		hitEnt = data.HitEntity
		if data.HitEntity:IsNPC() then
			data.HitEntity:Ignite(3)
		end
		local damagecode = DamageInfo()
		damagecode:SetDamage(65)
		damagecode:SetDamageType(bit.bor(DMG_SLASH,DMG_DISSOLVE,DMG_SHOCK))
		damagecode:SetAttacker(IsValid(self:GetOwner()) && self:GetOwner() or self)
		damagecode:SetInflictor(self)
		damagecode:SetDamagePosition(data.HitPos)
		hitEnt:TakeDamageInfo(damagecode,self)
		VJ_DestroyCombineTurret(self,hitEnt)
	else
		local bolt = ents.Create("prop_dynamic")
		bolt:SetModel("models/crossbow_bolt.mdl")
		bolt:SetPos(data.HitPos + data.HitNormal + self:GetForward()*-15)
		bolt:SetAngles(self:GetAngles())
		bolt:Activate()
		bolt:Spawn()
		bolt:DrawShadow(false)
		bolt:SetMaterial("models/hl_resurgence/hl2/weapons/chargebow_arrow")
		timer.Simple(3, function() if IsValid(bolt) then bolt:Remove() end end)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
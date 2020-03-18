/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Grenade"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "VJ Base"

if (CLIENT) then
	local Name = "Spore Grenade"
	local LangName = "obj_vj_hlrof_grenade_spore"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end

ENT.Model = {"models/vj_hlr/weapons/spore.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = nil -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.CollisionGroupType = nil -- Collision type, recommended to keep it as it is
ENT.SolidType = SOLID_VPHYSICS -- Solid type, recommended to keep it as it is
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 150 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 80 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_RADIATION -- Damage type
ENT.RadiusDamageForce = 90 -- Put the force amount it should apply | false = Don't apply any force
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/sporelauncher/spore_hit1.wav","vj_hlr/hl1_weapon/sporelauncher/spore_hit2.wav","vj_hlr/hl1_weapon/sporelauncher/spore_hit3.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:PhysicsInitSphere(4, "gmod_bouncy")
	self:SetModel("models/vj_hlr/weapons/spore.mdl")
	ParticleEffectAttach("vj_hl_spore_idle", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	timer.Simple(3,function() if IsValid(self) then self:DeathEffects() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data,phys)
	local getvelocity = phys:GetVelocity()
	local velocityspeed = getvelocity:Length()
	//if velocityspeed > 500 then -- Or else it will go flying!
		//phys:SetVelocity(getvelocity + self:GetUp()*1000)
	//end
	
	if velocityspeed > 100 then -- If the grenade is going faster than 100, then play the touch sound
		self:OnCollideSoundCode()
	end
	
	local ent = data.HitEntity
	if IsValid(ent) then
		if ent:IsNPC() or ent:IsPlayer() then
			self:DeathEffects()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects()
	ParticleEffect("vj_hl_spore", self:GetPos(), Angle(0,0,0), nil)
	self:EmitSound("vj_hlr/hl1_weapon/sporelauncher/splauncher_impact.wav", 100, 100)
	//ParticleEffect("vj_hl_spore_splash1", self:GetPos(), Angle(0,0,0), nil)
	//ParticleEffect("vj_hl_spore_splash2", self:GetPos(), Angle(0,0,0), nil)
	
	self:DoDamageCode()
	self:SetDeathVariablesTrue(nil,nil,false)
	self:Remove()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Kingpin Energy Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if (CLIENT) then
	local Name = "Kingpin Energy Orb"
	local LangName = "obj_vj_hlr1_kingpin_orb"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end

ENT.Model = {"models/spitball_large.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 95 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_DISSOLVE -- Damage type
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav","vj_hlr/hl1_weapon/gauss/electro5.wav","vj_hlr/hl1_weapon/gauss/electro6.wav"}

-- Custom
ENT.EO_Enemy = NULL
ENT.Speed = 100
ENT.SpeedIncrease = 12
ENT.MaxSpeed = 1250
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	phys:EnableGravity(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNoDraw(true)
	self.StartGlow1 = ents.Create("env_sprite")
	self.StartGlow1:SetKeyValue("model","vj_hl/sprites/nhth1.vmt")
	self.StartGlow1:SetKeyValue("GlowProxySize","2.0")
	self.StartGlow1:SetKeyValue("HDRColorScale","1.0")
	self.StartGlow1:SetKeyValue("renderfx","14")
	self.StartGlow1:SetKeyValue("rendermode","3")
	self.StartGlow1:SetKeyValue("renderamt","255")
	self.StartGlow1:SetKeyValue("disablereceiveshadows","0")
	self.StartGlow1:SetKeyValue("mindxlevel","0")
	self.StartGlow1:SetKeyValue("maxdxlevel","0")
	self.StartGlow1:SetKeyValue("framerate","10.0")
	self.StartGlow1:SetKeyValue("spawnflags","0")
	self.StartGlow1:SetKeyValue("scale","1")
	self.StartGlow1:SetPos(self:GetPos())
	self.StartGlow1:Spawn()
	self.StartGlow1:SetParent(self)
	self:DeleteOnRemove(self.StartGlow1)
	util.SpriteTrail(self, 0, Color(255,127,223,180), true, 50, 0, 1.5, 1/(6 + 0)*0.5, "vj_hl/sprites/laserbeam.vmt")
	self:EmitSound("vj_hlr/hl1_npc/kingpin/kingpin_seeker".. math.random(1,3) .. ".wav",85,100)
	self.LoopSound = CreateSound(self,"vj_hlr/hl1_npc/kingpin/kingpin_seeker_amb.wav")
	self.LoopSound:SetSoundLevel(80)
	self.LoopSound:Play()
	self.NextSpeedIncreaseT = CurTime() +2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if !IsValid(self:GetOwner()) then return end
	self.EO_Enemy = self:GetOwner():GetEnemy()
	if IsValid(self.EO_Enemy) then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line",self:GetPos(),self.EO_Enemy:GetPos() +self.EO_Enemy:OBBCenter(),self.Speed))
		end
		if self.Speed < self.MaxSpeed then
			if CurTime() > self.NextSpeedIncreaseT then
				self.Speed = self.Speed +self.SpeedIncrease
				self.NextSpeedIncreaseT = CurTime() +0.2
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.LoopSound:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	/*local effectdata = EffectData()
	effectdata:SetOrigin(data.HitPos)
	effectdata:SetScale(1)
	util.Effect("StriderBlood",effectdata)
	util.Effect("StriderBlood",effectdata)
	util.Effect("StriderBlood",effectdata)*/
	//ParticleEffect("vj_hl_spit_bullsquid_impact", data.HitPos, Angle(0,0,0), nil)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
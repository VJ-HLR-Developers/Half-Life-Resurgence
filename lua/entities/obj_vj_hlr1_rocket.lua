/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Rocket"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

ENT.VJ_ID_Danger = true

if CLIENT then
	local Name = "Tank Shell"
	local LangName = "obj_vj_hlr1_rocket"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))

	function ENT:Think()
		if IsValid(self) && self:GetNW2Bool("VJ_Dead") != true then
			self.Emitter = ParticleEmitter(self:GetPos())
			self.SmokeEffect1 = self.Emitter:Add("particles/flamelet2", self:GetPos() + self:GetForward()*-7)
			self.SmokeEffect1:SetVelocity(self:GetForward()*math.Rand(0, -50) + Vector(math.Rand(5, -5), math.Rand(5, -5), math.Rand(5, -5)) + self:GetVelocity())
			self.SmokeEffect1:SetDieTime(0.2)
			self.SmokeEffect1:SetStartAlpha(100)
			self.SmokeEffect1:SetEndAlpha(0)
			self.SmokeEffect1:SetStartSize(4)
			self.SmokeEffect1:SetEndSize(1)
			self.SmokeEffect1:SetRoll(math.Rand(-0.2, 0.2))
			self.SmokeEffect1:SetAirResistance(200)
			self.Emitter:Finish()
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/vj_hlr/hl1/rpgrocket.mdl"} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.DoesRadiusDamage = true -- Should it deal radius damage when it collides with something?
ENT.RadiusDamageRadius = 150
ENT.RadiusDamage = 100
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the hit entity is from the radius origin?
ENT.RadiusDamageType = DMG_BLAST
ENT.RadiusDamageForce = 90 -- Damage force to apply to the hit entity | false = Don't apply any force
ENT.RemoveDelay = 6 -- Setting this greater than 0 will delay the entity's removal | Useful for lingering trail effects
ENT.CollisionDecal = {"VJ_HLR_Scorch"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_weapon/rpg/rocket1.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"}
ENT.OnCollideSoundLevel = 100

-- Custom
ENT.Rocket_AirMissile = false
ENT.Rocket_HelicopterMissile = false
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ20 = Vector(0, 0, 40)
local colorTrail = Color(224, 224, 255, 255)
--
function ENT:Init()
	self.StartGlow1 = ents.Create("env_sprite")
	self.StartGlow1:SetKeyValue("model","vj_hl/sprites/animglow01.vmt")
	self.StartGlow1:SetKeyValue("rendercolor","224 224 255")
	self.StartGlow1:SetKeyValue("GlowProxySize","5.0")
	self.StartGlow1:SetKeyValue("HDRColorScale","1.0")
	self.StartGlow1:SetKeyValue("renderfx","14")
	self.StartGlow1:SetKeyValue("rendermode","3")
	self.StartGlow1:SetKeyValue("renderamt","255")
	self.StartGlow1:SetKeyValue("disablereceiveshadows","0")
	self.StartGlow1:SetKeyValue("mindxlevel","0")
	self.StartGlow1:SetKeyValue("maxdxlevel","0")
	self.StartGlow1:SetKeyValue("framerate","40.0")
	self.StartGlow1:SetKeyValue("spawnflags","0")
	self.StartGlow1:SetKeyValue("scale","0.5")
	self.StartGlow1:SetPos(self:GetPos())
	self.StartGlow1:Spawn()
	self.StartGlow1:SetParent(self)
	self:DeleteOnRemove(self.StartGlow1)
	util.SpriteTrail(self, 0, colorTrail, true, 5, 20, 6, 1/(5+20)*0.5, "vj_hl/sprites/smoke.vmt")
	self:SetNW2Bool("VJ_Dead", false)
	
	-- Used by helicopters
	if self.Rocket_HelicopterMissile then
		timer.Simple(0.5, function()
			if IsValid(self) then
				local owner = self:GetOwner()
				if IsValid(owner) then
					local phys = self:GetPhysicsObject()
					local ene = self:GetOwner():GetEnemy()
					if IsValid(phys) && IsValid(ene) then
						local myPos = self:GetPos()
						phys:SetVelocity(self:CalculateProjectile("Line", myPos, owner:GetAimPosition(ene, myPos, 1, 2000), 2000))
						self:SetAngles(self:GetVelocity():GetNormal():Angle())
					end
				end
			end
		end)
	-- Used by the Bradley
	elseif self.Rocket_AirMissile then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			-- 1. Go forward
			phys:SetVelocity(self:GetForward()*200)
			self:SetAngles(self:GetVelocity():GetNormal():Angle())
			timer.Simple(0.5, function()
				if IsValid(self) then
					-- 2. Go up
					local tr = util.TraceLine({
						start = self:GetPos(),
						endpos = self:GetPos() + self:GetUp()*math.random(2000, 2800),
						filter = self
					})
					local hitPos = tr.HitPos - vecZ20
					phys = self:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), hitPos, 800))
						self:SetAngles(self:GetVelocity():GetNormal():Angle())
						timer.Simple(self:GetPos():Distance(hitPos) / self:GetVelocity():Length(), function()
							if IsValid(self) then
								local owner = self:GetOwner()
								if IsValid(owner) then
									-- 3. Go to the enemy (Final move)
									phys = self:GetPhysicsObject()
									local ene = owner:GetEnemy()
									if IsValid(phys) && IsValid(ene) then
										local myPos = self:GetPos()
										phys:SetVelocity(self:CalculateProjectile("Line", myPos, owner:GetAimPosition(ene, myPos, 1, 5000), 5000))
										self:SetAngles(self:GetVelocity():GetNormal():Angle())
									end
								end
							end
						end)
					end
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ80 = Vector(0, 0, 80)
--
function ENT:OnDestroy(data, phys)
	util.ScreenShake(data.HitPos, 16, 200, 1, 3000)
	if IsValid(self.StartGlow1) then self.StartGlow1:Remove() end
	
	self:SetNW2Bool("VJ_Dead", true)
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris"..math.random(1,3)..".wav", 80, 100)
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3,5).."_dist.wav", 140, 100, 100, 1)
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
	spr:SetPos(self:GetPos() + vecZ80)
	spr:Spawn()
	spr:Fire("Kill","",0.9)
	timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
	
	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "4")
	expLight:SetKeyValue("distance", "300")
	expLight:SetLocalPos(data.HitPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "255 150 0")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	expLight:Fire("Kill", "", 0.1)
	self:DeleteOnRemove(expLight)
end
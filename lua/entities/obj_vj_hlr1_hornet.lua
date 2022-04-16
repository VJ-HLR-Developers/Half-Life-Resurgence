/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Hornet"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

//ENT.VJ_IsDetectableDanger = true

if CLIENT then
	local Name = "Hornet"
	local LangName = "obj_vj_hlr1_hornet"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/vj_hlr/hl1/hornet.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = MOVECOLLIDE_FLY_SLIDE -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 4 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SLASH -- Damage type
ENT.CollideCodeWithoutRemoving = true -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.DecalTbl_DeathDecals = {"VJ_HLR_Blood_Yellow"}
ENT.DecalTbl_OnCollideDecals = {"VJ_HLR_Blood_Yellow"} -- Decals that paint when the projectile collides with something | It picks a random one from this table
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/hornet/ag_hornethit1.wav","vj_hlr/hl1_npc/hornet/ag_hornethit2.wav","vj_hlr/hl1_npc/hornet/ag_hornethit3.wav"}

ENT.IdleSoundPitch = VJ_Set(100, 100)

local defVec = Vector(0, 0, 0)
local sdIdle = {"vj_hlr/hl1_npc/hornet/ag_buzz1.wav","vj_hlr/hl1_npc/hornet/ag_buzz2.wav","vj_hlr/hl1_npc/hornet/ag_buzz3.wav"}
local sdCollideAlpha = {"vj_hlr/hla_npc/hornet/ag_buzz1.wav","vj_hlr/hla_npc/hornet/ag_buzz2.wav","vj_hlr/hla_npc/hornet/ag_buzz3.wav"}

-- Custom
ENT.Track_Enemy = NULL
ENT.Track_Position = defVec
ENT.Hornet_Alpha = false
ENT.Hornet_ChaseSpeed = 600
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	phys:EnableGravity(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitializeBeforePhys()
	//self:PhysicsInitSphere(1, "metal_bouncy")
	//construct.SetPhysProp(self:GetOwner(), self, 0, self:GetPhysicsObject(), {GravityToggle = false, Material = "metal_bouncy"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(5, function() if IsValid(self) then self:Remove() end end)
	
	if self.Hornet_Alpha then
		self.SoundTbl_OnCollide = sdCollideAlpha
		self.Hornet_ChaseSpeed = 400
	else
		self.SoundTbl_Idle = sdIdle
		util.SpriteTrail(self, 0, Color(255,math.random(50,200),0,120), true, 6, 0, 1.5, 1/(6 + 0)*0.5, "vj_hl/sprites/laserbeam.vmt")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local phys = self:GetPhysicsObject()
	if IsValid(self.Track_Enemy) then -- Homing Behavior
		local pos = self.Track_Enemy:GetPos() + self.Track_Enemy:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.Track_Position + self.Track_Enemy:GetUp()*math.random(-50,50) + self.Track_Enemy:GetRight()*math.random(-50,50), self.Hornet_ChaseSpeed))
			self:SetAngles(self:GetVelocity():GetNormal():Angle())
		end
	else
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self:GetPos() + self:GetForward()*math.random(-80, 80)+ self:GetRight()*math.random(-80, 80) + self:GetUp()*math.random(-80, 80), self.Hornet_ChaseSpeed / 2))
			self:SetAngles(self:GetVelocity():GetNormal():Angle())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data, phys)
	local lastVel = math.max(data.OurOldVelocity:Length(), data.Speed) -- Get the last velocity and speed
	local newVel = phys:GetVelocity():GetNormal()
	lastVel = math.max(newVel:Length(), lastVel)
	phys:SetVelocity(newVel * lastVel * 0.3)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data, phys, hitEnt)
	if data.HitEntity:IsNPC() or data.HitEntity:IsPlayer() then
		self:SetDeathVariablesTrue(data, phys)
		self:Remove()
	end
end
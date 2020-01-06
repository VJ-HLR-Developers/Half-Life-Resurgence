AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/hornet.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = MOVECOLLIDE_FLY_BOUNCE -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 4 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SLASH -- Damage type
ENT.CollideCodeWithoutRemoving = true -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.DecalTbl_DeathDecals = {"VJ_HLR_Blood_Yellow"}
ENT.DecalTbl_OnCollideDecals = {"VJ_HLR_Blood_Yellow"} -- Decals that paint when the projectile collides with something | It picks a random one from this table
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/hornet/ag_buzz1.wav","vj_hlr/hl1_npc/hornet/ag_buzz2.wav","vj_hlr/hl1_npc/hornet/ag_buzz3.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/hornet/ag_hornethit1.wav","vj_hlr/hl1_npc/hornet/ag_hornethit2.wav","vj_hlr/hl1_npc/hornet/ag_hornethit3.wav"}

ENT.IdleSoundPitch1 = 100
ENT.IdleSoundPitch2 = 100

-- Custom
ENT.MyEnemy = NULL
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
	self:PhysicsInitSphere(1, "metal_bouncy")
	//construct.SetPhysProp(self:GetOwner(), self, 0, self:GetPhysicsObject(), {GravityToggle = false, Material = "metal_bouncy"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(5,function() if IsValid(self) then self:Remove() end end)
	
	util.SpriteTrail(self, 0, Color(255,math.random(50,200),0,120), true, 6, 0, 1.5, 1/(6 + 0)*0.5, "vj_hl/sprites/laserbeam.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self.MyEnemy) then -- Homing Behavior
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.MyEnemy:GetPos() + self.MyEnemy:OBBCenter() + self.MyEnemy:GetUp()*math.random(-50,50) + self.MyEnemy:GetRight()*math.random(-50,50), 600))
			self:SetAngles(self:GetVelocity():GetNormal():Angle())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data,phys,hitent)
	if data.HitEntity:IsNPC() or data.HitEntity:IsPlayer() then
		self:SetDeathVariablesTrue(data,phys)
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data,phys)
	-- Let's use CollisionData!
	local lastvel = math.max(data.OurOldVelocity:Length(), data.Speed) -- Get the last velocity and speed
	local oldvel = phys:GetVelocity()
	local newvel = oldvel:GetNormal()
	lastvel = math.max(newvel:Length(), lastvel)
	local setvel = newvel*lastvel*0.3
	phys:SetVelocity(setvel)
	self:SetAngles(self:GetVelocity():GetNormal():Angle())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	local effectdata = EffectData()
	effectdata:SetOrigin(data.HitPos)
	effectdata:SetScale(0.6)
	util.Effect("StriderBlood",effectdata)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
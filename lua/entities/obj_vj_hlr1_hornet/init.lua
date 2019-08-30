AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/weapons/w_hornet.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = MOVECOLLIDE_FLY_BOUNCE -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 3.5 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SLASH -- Damage type
ENT.CollideCodeWithoutRemoving = true -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.DecalTbl_DeathDecals = {"YellowBlood"}
ENT.DecalTbl_OnCollideDecals = {"YellowBlood"} -- Decals that paint when the projectile collides with something | It picks a random one from this table
ENT.SoundTbl_Startup = {}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/hornet/ag_buzz1.wav","vj_hlr/hl1_npc/hornet/ag_buzz2.wav","vj_hlr/hl1_npc/hornet/ag_buzz3.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/hornet/ag_hornethit1.wav","vj_hlr/hl1_npc/hornet/ag_hornethit2.wav","vj_hlr/hl1_npc/hornet/ag_hornethit3.wav"}
ENT.IdleSoundPitch1 = 100
ENT.IdleSoundPitch2 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(false)
	phys:EnableDrag(false)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitializeBeforePhys()
	self:PhysicsInitSphere(1, "metal_bouncy") 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(5,function() if IsValid(self) then self:Remove() end end)
	
	util.SpriteTrail(self, 0, Color(255,math.random(50,200),0,120), true, 12, 0, 1, 0.04, "sprites/hornettrail.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self.ParentsEnemy) && self:GetPos():Distance(self.ParentsEnemy:GetPos()) < 300 then
		self:SetAngles(self:GetVelocity():GetNormal():Angle())
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			if self:GetPos():Distance(self.ParentsEnemy:GetPos()) < 150 then
				phys:ApplyForceCenter(((self.ParentsEnemy:GetPos() +self.ParentsEnemy:GetUp()*math.Rand(30,45) +self.ParentsEnemy:GetRight()*math.Rand(-30,30)) - self:GetPos())*10 +self:GetRight()*math.Rand(-40,40) +self:GetUp()*math.Rand(-40,40))
			else 
				phys:ApplyForceCenter(((self.ParentsEnemy:GetPos() +self.ParentsEnemy:GetUp()*math.Rand(30,45) +self.ParentsEnemy:GetRight()*math.Rand(-30,30)) - self:GetPos())*4 +self:GetRight()*math.Rand(-40,40) +self:GetUp()*math.Rand(-40,40))
			end
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
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	local effectdata = EffectData()
	effectdata:SetOrigin(data.HitPos)
	effectdata:SetScale( 0.6 )
	util.Effect("StriderBlood",effectdata)
	ParticleEffect("antlion_gib_02_floaters", data.HitPos, Angle(0,0,0), nil)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
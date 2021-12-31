/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Gargantua Stomp Shockwave"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if CLIENT then
	local Name = "Gargantua"
	local LangName = "obj_vj_hlr1_garg_stomp"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/spitball_large.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.PhysicsInitType = SOLID_VPHYSICS
ENT.MoveCollideType = MOVETYPE_NONE -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 100 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_DISSOLVE -- Damage type'
ENT.DecalTbl_DeathDecals = {"VJ_HLR_Scorch_Small"} -- Decals that paint when the projectile dies | It picks a random one from this table
ENT.SoundTbl_Startup = {"vj_hlr/hl1_weapon/tripmine/mine_charge.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav","vj_hlr/hl1_weapon/gauss/electro5.wav","vj_hlr/hl1_weapon/gauss/electro6.wav"}
-- ENT.RemoveOnHit = false
-- ENT.CollideCodeWithoutRemoving = true

ENT.StartupSoundPitch = VJ_Set(100, 100)

-- Custom
ENT.Stomp_InitialRan = false
ENT.Stomp_SpeedMultiplier = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	//phys:Wake()
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
	phys:EnableGravity(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNoDraw(true)

	-- self.StartGlow1 = ents.Create("env_sprite")
	-- self.StartGlow1:SetKeyValue("model","vj_hl/sprites/gwave1.vmt")
	-- self.StartGlow1:SetKeyValue("rendercolor","224 224 255")
	-- self.StartGlow1:SetKeyValue("GlowProxySize","5.0")
	-- self.StartGlow1:SetKeyValue("HDRColorScale","1.0")
	-- self.StartGlow1:SetKeyValue("renderfx","14")
	-- self.StartGlow1:SetKeyValue("rendermode","3")
	-- self.StartGlow1:SetKeyValue("renderamt","255")
	-- self.StartGlow1:SetKeyValue("disablereceiveshadows","0")
	-- self.StartGlow1:SetKeyValue("mindxlevel","0")
	-- self.StartGlow1:SetKeyValue("maxdxlevel","0")
	-- self.StartGlow1:SetKeyValue("framerate","40.0")
	-- self.StartGlow1:SetKeyValue("spawnflags","0")
	-- self.StartGlow1:SetKeyValue("scale","1")
	-- self.StartGlow1:SetPos(self:GetPos())
	-- self.StartGlow1:Spawn()
	-- self.StartGlow1:SetParent(self)
	-- self:DeleteOnRemove(self.StartGlow1)
	
	//util.SpriteTrail(self, 0, Color(255,0,0), true, 20, 1, 2, 1 / (20 + 1) * 0.5, "vj_hl/sprites/xbeam3.vmt")
	
	ParticleEffectAttach("vj_hlr_garg_stomp", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	-- ParticleEffectAttach("vj_hlr_garg_stomp_2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local owner = self:GetOwner()
	if !self.Stomp_InitialRan && IsValid(owner) then 
		self.Stomp_InitialRan = true
		self:SetAngles(Angle(owner:GetAngles().p, 0, 0))
		local myPos = self:GetPos()
		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos + self:GetUp()*-1000,
			filter = {self, owner}
		})
		//VJ_CreateTestObject(tr.HitPos, self:GetAngles(), Color(0,255,0), 5)
		self:SetPos(tr.HitPos + Vector(0,0,8))
		
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			local res = self:CalculateProjectile("Line", myPos, owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 100)
			res.z = 0
			phys:SetVelocity(res)
		end
	end
	
	local phys = self:GetPhysicsObject()
	local myVel = self:GetVelocity()
	if IsValid(phys) && myVel:Length() < 400 then
		phys:SetVelocity(myVel*(1 + math.Clamp(self.Stomp_SpeedMultiplier, 0, 0.1)))
	end
	self.Stomp_SpeedMultiplier = self.Stomp_SpeedMultiplier + 0.01
	
/*
	//self:SetAngles(Angle(0,0,0))
	//if IsValid(self:GetOwner()) then self:SetAngles(self:GetOwner():GetAngles()) end
	local trfr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() + self:GetForward()*10,
		filter = self
	})
	//VJ_CreateTestObject(trfr.HitPos,self:GetAngles(),Color(0,255,255),5)
	//if trfr.HitWorld then self:Remove() return end
	
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() + self:GetUp()*-100,
		filter = self
	})
	//VJ_CreateTestObject(tr.HitPos,self:GetAngles(),Color(0,255,0),5)
	//self:SetPos(self:GetPos() + Vector(0,0,(tr.HitPos + Vector(0,0,100)).z))
	//self:SetPos(tr.HitPos)
	
	if self.RanOnce == false then 
	self.RanOnce = true
		if IsValid(self:GetOwner()) then self:SetAngles(self:GetOwner():GetAngles()) end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			local res = self:CalculateProjectile("Line", self:GetPos(), self:GetPos() + self:GetForward()*500, 200)
			res.z = 0
			phys:SetVelocity(res)
		end
		end
*/
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Gargantua Stomp Shockwave"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

ENT.VJ_ID_Danger = true

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlr1_garg_stomp", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.MoveCollideType = MOVETYPE_NONE
ENT.DoesDirectDamage = true
ENT.DirectDamage = 100
ENT.DirectDamageType = DMG_DISSOLVE
ENT.CollisionDecal = "VJ_HLR_Scorch_Small"
ENT.SoundTbl_Startup = "vj_hlr/hl1_weapon/tripmine/mine_charge.wav"
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav", "vj_hlr/hl1_weapon/gauss/electro5.wav", "vj_hlr/hl1_weapon/gauss/electro6.wav"}

ENT.StartupSoundPitch = VJ.SET(100, 100)

-- Custom
ENT.Stomp_InitialRan = false
ENT.Stomp_SpeedMultiplier = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)

	//local sprite = ents.Create("env_sprite")
	//sprite:SetKeyValue("model","vj_hl/sprites/gwave1.vmt")
	//sprite:SetKeyValue("rendercolor","224 224 255")
	//sprite:SetKeyValue("GlowProxySize","5.0")
	//sprite:SetKeyValue("HDRColorScale","1.0")
	//sprite:SetKeyValue("renderfx","14")
	//sprite:SetKeyValue("rendermode","3")
	//sprite:SetKeyValue("renderamt","255")
	//sprite:SetKeyValue("disablereceiveshadows","0")
	//sprite:SetKeyValue("mindxlevel","0")
	//sprite:SetKeyValue("maxdxlevel","0")
	//sprite:SetKeyValue("framerate","40.0")
	//sprite:SetKeyValue("spawnflags","0")
	//sprite:SetKeyValue("scale","1")
	//sprite:SetPos(self:GetPos())
	//sprite:Spawn()
	//sprite:SetParent(self)
	//self:DeleteOnRemove(sprite)
	
	//util.SpriteTrail(self, 0, Color(255,0,0), true, 20, 1, 2, 1 / (20 + 1) * 0.5, "vj_hl/sprites/xbeam3.vmt")
	
	ParticleEffectAttach("vj_hlr_garg_stomp", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	//ParticleEffectAttach("vj_hlr_garg_stomp_2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
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
		self:SetPos(tr.HitPos + Vector(0,0,8))
		
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			local res = VJ.CalculateTrajectory(self, NULL, "Line", myPos, owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 100) -- Do NOT predict!
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
end
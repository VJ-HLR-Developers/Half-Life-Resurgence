/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Teleportation Orb"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

ENT.VJ_IsDetectableDanger = true

if CLIENT then
	local Name = "Teleportation Orb"
	local LangName = "obj_vj_hlr1_orb_teleport"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/spitball_large.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 25 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SHOCK -- Damage type
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/x/x_teleattack1.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav","vj_hlr/hl1_weapon/gauss/electro5.wav","vj_hlr/hl1_weapon/gauss/electro6.wav"}

-- Custom
local defVec = Vector(0, 0, 0)

ENT.Track_Enemy = NULL
ENT.Track_Position = defVec
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
	self.StartGlow1:SetKeyValue("model","vj_hl/sprites/exit1.vmt")
	//self.StartGlow1:SetKeyValue("rendercolor","255 128 0")
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
	self.StartGlow1:SetKeyValue("scale","1.5")
	self.StartGlow1:SetPos(self:GetPos())
	self.StartGlow1:Spawn()
	self.StartGlow1:SetParent(self)
	self:DeleteOnRemove(self.StartGlow1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self.Track_Enemy) then -- Homing Behavior
		local pos = self.Track_Enemy:GetPos() + self.Track_Enemy:OBBCenter()
		if self:VisibleVec(pos) or self.Track_Position == defVec then
			self.Track_Position = pos
		end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:CalculateProjectile("Line", self:GetPos(), self.Track_Position, 700))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data, phys, hitEnt)
	local owner = self:GetOwner()
	if IsValid(owner) && (hitEnt:IsNPC() or hitEnt:IsPlayer()) && hitEnt.VJ_IsHugeMonster != true && !hitEnt.Dead && hitEnt:GetClass() != "sent_vj_xen_crystal" then
		local tr = util.TraceLine({
			start = owner:GetPos(),
			endpos = owner:GetPos() + owner:GetForward() * math.Rand(-10000, 10000) + owner:GetRight() * math.Rand(-10000, 10000) + owner:GetUp() * -3000, //math.Rand(-10000, 10000),
			filter = owner,
		})
		local pos = tr.HitPos + tr.HitNormal * hitEnt:OBBMaxs()
		hitEnt:SetPos(pos)
		
		local effectTeleport = VJ_HLR_Effect_PortalSpawn(pos)
		effectTeleport:Fire("Kill", "", 1)
		owner:DeleteOnRemove(effectTeleport)
		
		VJ_EmitSound(hitEnt, "vj_hlr/fx/beamstart" .. math.random(1,2) .. ".wav", 85, 100)
	end
end
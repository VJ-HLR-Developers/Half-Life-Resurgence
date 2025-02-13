AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/flower.mdl"
ENT.StartHealth = 160
ENT.SightDistance = 512
ENT.SightAngle = 360
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanTurnWhileStationary = false
ENT.HullType = HULL_SMALL_CENTERED
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -250),
    FirstP_Bone = "joint2",
    FirstP_Offset = Vector(0, 0, -60),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.DisableDefaultRangeAttackCode = true
ENT.AnimTbl_RangeAttack = false
ENT.RangeDistance = 512
ENT.RangeToMeleeDistance = 1
ENT.RangeAttackAngleRadius = 180
ENT.TimeUntilRangeAttackProjectileRelease = 0
ENT.NextRangeAttackTime = 1.5

ENT.DeathCorpseEntityClass = "prop_vj_animatable"
ENT.GibOnDeathFilter = false

ENT.SoundTbl_Death = {"vj_hlr/fx/bustflesh1.wav", "vj_hlr/fx/bustflesh2.wav"}

local SdTbl_GibImpact = {"vj_hlr/fx/flesh1.wav", "vj_hlr/fx/flesh2.wav", "vj_hlr/fx/flesh3.wav", "vj_hlr/fx/flesh4.wav", "vj_hlr/fx/flesh5.wav", "vj_hlr/fx/flesh6.wav", "vj_hlr/fx/flesh7.wav"}

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(25, 25, 0), Vector(-25, -25, -162))
	self:DrawShadow(false) -- Because the light somehow makes a shadow =/
	
	local spotLight = ents.Create("light_dynamic")
	spotLight:SetPos(self:GetAttachment(1).Pos + Vector(0, 0, -5))
	spotLight:SetKeyValue("_light", "135 24 194 120")
	spotLight:SetKeyValue("brightness", "4")
	spotLight:SetKeyValue("distance", "180")
	spotLight:SetKeyValue("_inner_cone", "30")
	spotLight:SetKeyValue("pitch", "90")
	spotLight:SetParent(self)
	spotLight:Spawn()
	spotLight:Activate()
	spotLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(spotLight)
	
	-- Doesn't work in game
	/*local spotLight = ents.Create("light_spot")
	spotLight:SetPos(self:GetAttachment(1).Pos)
	spotLight:SetKeyValue("_light", "135 24 194 120")
	spotLight:SetKeyValue("_constant_attn", "0")
	spotLight:SetKeyValue("_linear_attn", "0")
	spotLight:SetKeyValue("_quadratic_attn", "1")
	spotLight:SetKeyValue("_cone", "15")
	spotLight:SetKeyValue("_inner_cone", "30")
	spotLight:SetKeyValue("pitch", "90")
	spotLight:SetKeyValue("_exponent", "1")
	spotLight:SetParent(self)
	spotLight:Spawn()
	spotLight:Activate()
	spotLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(spotLight)*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local startPos = self:GetAttachment(1).Pos
	local tr = util.TraceLine({
		start = startPos,
		endpos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(),
		filter = self
	})
	local hitPos = tr.HitPos
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetNormal(tr.HitNormal)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	elec:SetScale(0.5)
	util.Effect("VJ_HLR_Electric_Xen_Turretc", elec)
	
	VJ.ApplyRadiusDamage(self, self, hitPos, 10, 30, DMG_SHOCK, true, false, {Force=90})
	VJ.EmitSound(self, "vj_hlr/hl1_npc/xenceiling_turret/beamstart10.wav", 90, 100)
	//sound.Play("vj_hlr/hl1_npc/pitworm/pit_worm_attack_eyeblast_impact.wav", hitPos, 60)
	
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "vj_hl/sprites/xflare1.vmt")
	//spr:SetKeyValue("rendercolor", "0 0 255")
	spr:SetKeyValue("GlowProxySize", "5.0")
	spr:SetKeyValue("HDRColorScale", "1.0")
	spr:SetKeyValue("renderfx", "14")
	spr:SetKeyValue("rendermode", "3")
	spr:SetKeyValue("renderamt", "255")
	spr:SetKeyValue("disablereceiveshadows", "0")
	spr:SetKeyValue("mindxlevel", "0")
	spr:SetKeyValue("maxdxlevel", "0")
	spr:SetKeyValue("framerate", "60.0")
	spr:SetKeyValue("spawnflags", "0")
	spr:SetKeyValue("scale", "0.8")
	spr:SetPos(self:GetPos())
	spr:Spawn()
	spr:SetParent(self)
	spr:Fire("SetParentAttachment", "0")
	self:DeleteOnRemove(spr)
	timer.Simple(0.2, function() SafeRemoveEntity(spr) end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	-- Take damage only if the bottom part is hit or it's a blast damage!
	if status == "PreDamage" && hitgroup == 3 && !dmginfo:IsDamageType(DMG_BLAST) then
		dmginfo:SetDamage(0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ20 = Vector(0, 0, 20)
local vecZ12 = Vector(0, 0, 12)
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	local attPos = self:GetAttachment(1).Pos
	if self.HasGibOnDeathEffects then
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("rendercolor", "115,  30,  164")
		spr:SetKeyValue("GlowProxySize", "5.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "3")
		spr:SetKeyValue("renderamt", "200")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "10.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "1")
		spr:SetPos(attPos + vecZ20)
		spr:Spawn()
		//spr:SetParent(self)
		//spr:Fire("SetParentAttachment",  "0")
		//self:DeleteOnRemove(spr)
		timer.Simple(1.4, function() SafeRemoveEntity(spr) end)
	end
	
	local pos = attPos + vecZ12
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal=false,  Pos=pos + Vector(1, 0, 0),  CollisionSound=SdTbl_GibImpact})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal=false,  Pos=pos + Vector(2, 0, 0),  CollisionSound=SdTbl_GibImpact})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal=false,  Pos=pos + Vector(3, 0, 0),  CollisionSound=SdTbl_GibImpact})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal=false,  Pos=pos + Vector(4, 0, 0),  CollisionSound=SdTbl_GibImpact})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal=false,  Pos=pos + Vector(5, 0, 0),  CollisionSound=SdTbl_GibImpact})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal=false,  Pos=pos + Vector(6, 0, 0),  CollisionSound=SdTbl_GibImpact})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal=false,  Pos=pos + Vector(0, 1, 0),  CollisionSound=SdTbl_GibImpact})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal=false,  Pos=pos + Vector(0, 2, 0),  CollisionSound=SdTbl_GibImpact})
	return true, {AllowCorpse = true, AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetBodygroup(0, 1)
end
include("entities/npc_vj_hlr1_zombie/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/zombie_german.mdl"
ENT.ControllerParams = {
	ThirdP_Offset = Vector(10, 0, -20),
	FirstP_Bone = "Bip01 Head",
	FirstP_Offset = Vector(4, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = VJ.BLOOD_COLOR_NONE
ENT.HasBloodParticle = false -- Blood particles are disabled, but we still want to bleed when shot in the head
ENT.HasBloodDecal = false
ENT.VJ_ID_Healable = false
ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/npc/rgrunt/pl_metal1.wav", "vj_hlr/gsrc/npc/rgrunt/pl_metal2.wav", "vj_hlr/gsrc/npc/rgrunt/pl_metal3.wav", "vj_hlr/gsrc/npc/rgrunt/pl_metal4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/rgrunt/rb_die1.wav", "vj_hlr/gsrc/npc/rgrunt/rb_die2.wav", "vj_hlr/gsrc/npc/rgrunt/rb_die3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	-- Take damage if in water
	if self:WaterLevel() == 3 then
		self:SetHealth(self:Health() - 1)
		if self:Health() <= 0 then -- Actually kill it
			self:TakeDamage(1, self, self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector()
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" then
		if hitgroup == HITGROUP_HEAD then --We've been headshot! Spurt blood!
			self:SpawnBloodParticles(dmginfo, hitgroup)
		elseif dmginfo:GetDamagePosition() != vec && !dmginfo:IsExplosionDamage() && hitgroup != HITGROUP_HEAD then
			-- Ricochet effect
			local rico = EffectData()
			rico:SetOrigin(dmginfo:GetDamagePosition())
			rico:SetScale(4) -- Size
			rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
			util.Effect("VJ_HLR_Rico", rico)
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.5) -- Reduce incoming damage to half if it's not a headshot or explosive damage
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local animDeathHead = {ACT_DIE_GUTSHOT, ACT_DIE_HEADSHOT}
local animDeathDef = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("GlowProxySize", "2.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "5")
		spr:SetKeyValue("renderamt", "255")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "20.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "1.5")
		spr:SetPos(self:GetPos() + self:GetUp() * 60)
		spr:Spawn()
		spr:Fire("Kill", nil, 0.7)
		timer.Simple(0.7, function() if IsValid(spr) then spr:Remove() end end)
		if GetConVar("vj_hlr1_corpse_static"):GetInt() == 1 && VJ_CVAR_AI_ENABLED && self.HasDeathAnimation then
			self.DeathAnimationDecreaseLengthAmount = -1
			self.DeathCorpseEntityClass = "prop_vj_animatable"
		end
	elseif status == "DeathAnim" then
		if hitgroup == HITGROUP_HEAD then
			self.AnimTbl_Death = animDeathHead
		else
			self.AnimTbl_Death = animDeathDef
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibsCollideSd = {"vj_hlr/gsrc/fx/metal1.wav", "vj_hlr/gsrc/fx/metal2.wav", "vj_hlr/gsrc/fx/metal3.wav", "vj_hlr/gsrc/fx/metal4.wav", "vj_hlr/gsrc/fx/metal5.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("GlowProxySize", "2.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "5")
		spr:SetKeyValue("renderamt", "255")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "20.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "2")
		spr:SetPos(self:GetPos() + self:GetUp() * 60)
		spr:Spawn()
		spr:Fire("Kill", nil, 0.7)
		timer.Simple(0.7, function() if IsValid(spr) then spr:Remove() end end)
	end
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 40)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 1, 40)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 50)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 0, 40)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 1, 40)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 45)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 1, 45)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 0, 45)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 1, 45)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 2, 40)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(2, 1, 40)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog1.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 60)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog2.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 15)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_rib.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 1, 15)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 0, 15)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 1, 15)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 2, 15)), CollisionSound = gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_spring.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(2, 1, 15)), CollisionSound = false}) -- Shad ge sharji, ere vor tsayn chi hane

	VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris3.wav", 100, 100)
	self:PlaySoundSystem("Gib", "vj_hlr/gsrc/npc/rgrunt/rb_gib.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/metalgib_p1.mdl", "models/vj_hlr/gibs/metalgib_p2.mdl", "models/vj_hlr/gibs/metalgib_p3.mdl", "models/vj_hlr/gibs/metalgib_p4.mdl", "models/vj_hlr/gibs/metalgib_p5.mdl", "models/vj_hlr/gibs/metalgib_p6.mdl", "models/vj_hlr/gibs/metalgib_p7.mdl", "models/vj_hlr/gibs/metalgib_p8.mdl", "models/vj_hlr/gibs/metalgib_p9.mdl", "models/vj_hlr/gibs/metalgib_p10.mdl", "models/vj_hlr/gibs/metalgib_p11.mdl", "models/vj_hlr/gibs/rgib_cog1.mdl", "models/vj_hlr/gibs/rgib_cog2.mdl", "models/vj_hlr/gibs/rgib_rib.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpse, 1)
	VJ.HLR_ApplyCorpseSystem(self, corpse, gibs, {CollisionSound = gibsCollideSd, ExpSound = "vj_hlr/gsrc/npc/rgrunt/rb_gib.wav"})
end
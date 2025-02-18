include("entities/npc_vj_hlr1_rgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/rgrunt_black.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(5, 0, 5),
}
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"}

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	self:SetBodygroup(1, math.random(0, 1))
	self.SoundTbl_FootStep = {"vj_hlr/hl1_npc/rgrunt/pl_metal1.wav", "vj_hlr/hl1_npc/rgrunt/pl_metal2.wav", "vj_hlr/hl1_npc/rgrunt/pl_metal3.wav", "vj_hlr/hl1_npc/rgrunt/pl_metal4.wav"}
	self.SoundTbl_Breath = "vj_hlr/hl1_npc/rgrunt/rb_engine_alt.wav"
	self.SoundTbl_Alert = "vj_hlr/hl1_npc/rgrunt/rb_cover1.wav"
	self.SoundTbl_CallForHelp = "vj_hlr/hl1_npc/rgrunt/deeoo.wav"
	self.SoundTbl_WeaponReload = {"vj_hlr/hl1_npc/rgrunt/rb_cover1.wav", "vj_hlr/hl1_npc/rgrunt/rb_cover2.wav"}
	self.SoundTbl_GrenadeSight = {"vj_hlr/hl1_npc/rgrunt/rb_cover2.wav", "vj_hlr/hl1_npc/rgrunt/deeoo.wav", "vj_hlr/hl1_npc/rgrunt/beepboop.wav"}
	self.SoundTbl_DangerSight = {"vj_hlr/hl1_npc/rgrunt/rb_cover2.wav", "vj_hlr/hl1_npc/rgrunt/deeoo.wav", "vj_hlr/hl1_npc/rgrunt/beepboop.wav"}
	self.SoundTbl_KilledEnemy = "vj_hlr/hl1_npc/rgrunt/doop.wav"
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/rgrunt/buzwarn.wav", "vj_hlr/hl1_npc/rgrunt/rb_allydeath2.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hl1_npc/rgrunt/spark1.wav", "vj_hlr/hl1_npc/rgrunt/spark2.wav", "vj_hlr/hl1_npc/rgrunt/spark3.wav", "vj_hlr/hl1_npc/rgrunt/spark4.wav", "vj_hlr/hl1_npc/rgrunt/spark5.wav", "vj_hlr/hl1_npc/rgrunt/spark6.wav"}
	self.SoundTbl_Death = {"vj_hlr/hl1_npc/rgrunt/rb_die1.wav", "vj_hlr/hl1_npc/rgrunt/rb_die2.wav", "vj_hlr/hl1_npc/rgrunt/rb_die3.wav"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibsCollideSd = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
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
		spr:SetPos(self:GetPos() + self:GetUp()*60)
		spr:Spawn()
		spr:Fire("Kill", "", 0.7)
		timer.Simple(0.7, function() if IsValid(spr) then spr:Remove() end end)
	end
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 50)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 1, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 1, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 2, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(2, 1, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog1.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 60)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog2.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_rib.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 1, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 2, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_spring.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(2, 1, 15)), CollisionSound=false}) -- Shad ge sharji, ere vor tsayn chi hane
	
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 100, 100)
	self:PlaySoundSystem("Gib", "vj_hlr/hl1_npc/rgrunt/rb_gib.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/metalgib_p1.mdl", "models/vj_hlr/gibs/metalgib_p2.mdl", "models/vj_hlr/gibs/metalgib_p3.mdl", "models/vj_hlr/gibs/metalgib_p4.mdl", "models/vj_hlr/gibs/metalgib_p5.mdl", "models/vj_hlr/gibs/metalgib_p6.mdl", "models/vj_hlr/gibs/metalgib_p7.mdl", "models/vj_hlr/gibs/metalgib_p8.mdl", "models/vj_hlr/gibs/metalgib_p9.mdl", "models/vj_hlr/gibs/metalgib_p10.mdl", "models/vj_hlr/gibs/metalgib_p11.mdl", "models/vj_hlr/gibs/rgib_cog1.mdl", "models/vj_hlr/gibs/rgib_cog2.mdl", "models/vj_hlr/gibs/rgib_rib.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, 5)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs, {CollisionSound = gibsCollideSd, ExpSound = {"vj_hlr/hl1_npc/rgrunt/rb_gib.wav"}})
end
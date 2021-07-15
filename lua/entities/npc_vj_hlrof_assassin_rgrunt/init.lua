AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/rgrunt_black.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 5), -- The offset for the controller when the camera is in first person
}
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"}

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	self:SetBodygroup(1, math.random(0, 1))
	self.SoundTbl_FootStep = {"vj_hlr/hl1_npc/rgrunt/pl_metal1.wav","vj_hlr/hl1_npc/rgrunt/pl_metal2.wav","vj_hlr/hl1_npc/rgrunt/pl_metal3.wav","vj_hlr/hl1_npc/rgrunt/pl_metal4.wav"}
	self.SoundTbl_Breath = {"vj_hlr/hl1_npc/rgrunt/rb_engine_alt.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hl1_npc/rgrunt/rb_cover1.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/rgrunt/deeoo.wav"}
	self.SoundTbl_WeaponReload = {"vj_hlr/hl1_npc/rgrunt/rb_cover1.wav","vj_hlr/hl1_npc/rgrunt/rb_cover2.wav"}
	self.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/rgrunt/rb_cover2.wav","vj_hlr/hl1_npc/rgrunt/deeoo.wav"}
	self.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/rgrunt/doop.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/rgrunt/buzwarn.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hl1_npc/rgrunt/spark1.wav","vj_hlr/hl1_npc/rgrunt/spark2.wav","vj_hlr/hl1_npc/rgrunt/spark3.wav","vj_hlr/hl1_npc/rgrunt/spark4.wav","vj_hlr/hl1_npc/rgrunt/spark5.wav","vj_hlr/hl1_npc/rgrunt/spark6.wav"}
	self.SoundTbl_Death = {"vj_hlr/hl1_npc/rgrunt/rb_die1.wav","vj_hlr/hl1_npc/rgrunt/rb_die2.wav","vj_hlr/hl1_npc/rgrunt/rb_die3.wav"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibsCollideSd = {"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
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
		spr:SetKeyValue("framerate","20.0")
		spr:SetKeyValue("spawnflags","0")
		spr:SetKeyValue("scale","2")
		spr:SetPos(self:GetPos() + self:GetUp()*60)
		spr:Spawn()
		spr:Fire("Kill","",0.7)
		timer.Simple(0.7, function() if IsValid(spr) then spr:Remove() end end)
	end
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p1.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p2.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p3.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,50)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p4.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p9.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p10.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p11.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog1.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,60)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog2.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_rib.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_spring.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound=""}) -- Shad ge sharji, ere vor tsayn chi hane
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/metalgib_p1.mdl", "models/vj_hlr/gibs/metalgib_p2.mdl", "models/vj_hlr/gibs/metalgib_p3.mdl", "models/vj_hlr/gibs/metalgib_p4.mdl", "models/vj_hlr/gibs/metalgib_p5.mdl", "models/vj_hlr/gibs/metalgib_p6.mdl", "models/vj_hlr/gibs/metalgib_p7.mdl", "models/vj_hlr/gibs/metalgib_p8.mdl", "models/vj_hlr/gibs/metalgib_p9.mdl", "models/vj_hlr/gibs/metalgib_p10.mdl", "models/vj_hlr/gibs/metalgib_p11.mdl", "models/vj_hlr/gibs/rgib_cog1.mdl", "models/vj_hlr/gibs/rgib_cog2.mdl", "models/vj_hlr/gibs/rgib_rib.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl"}
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, 5)
	VJ_HLR_ApplyCorpseEffects(self, corpseEnt, gibs, {CollideSound = gibsCollideSd, ExpSound = {"vj_hlr/hl1_npc/rgrunt/rb_gib.wav"}})
end
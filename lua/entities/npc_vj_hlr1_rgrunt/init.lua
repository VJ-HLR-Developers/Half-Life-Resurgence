include("entities/npc_vj_hlr1_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/rgrunt.mdl"
ENT.StartHealth = 200
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(5, 0, 5),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.BloodColor = ""
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false
ENT.VJ_ID_Healable = false

ENT.BreathSoundLevel = 50
ENT.MainSoundPitch = VJ.SET(130, 140)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_rgrunt" then
		self.Model = "models/vj_hlr/hl_hd/rgrunt.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	self:SetBodygroup(1, math.random(0, 1))
	self.SoundTbl_FootStep = {"vj_hlr/gsrc/npc/rgrunt/pl_metal1.wav","vj_hlr/gsrc/npc/rgrunt/pl_metal2.wav","vj_hlr/gsrc/npc/rgrunt/pl_metal3.wav","vj_hlr/gsrc/npc/rgrunt/pl_metal4.wav"}
	self.SoundTbl_Idle = {"vj_hlr/gsrc/npc/rgrunt/rb_idle1.wav","vj_hlr/gsrc/npc/rgrunt/rb_idle2.wav","vj_hlr/gsrc/npc/rgrunt/rb_idle3.wav"}
	self.SoundTbl_Breath = {"vj_hlr/gsrc/npc/rgrunt/rb_engine.wav"}
	self.SoundTbl_IdleDialogue = {"vj_hlr/gsrc/npc/rgrunt/rb_question1.wav","vj_hlr/gsrc/npc/rgrunt/rb_question2.wav","vj_hlr/gsrc/npc/rgrunt/rb_question3.wav","vj_hlr/gsrc/npc/rgrunt/rb_question4.wav","vj_hlr/gsrc/npc/rgrunt/rb_question5.wav"}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/gsrc/npc/rgrunt/rb_answer1.wav","vj_hlr/gsrc/npc/rgrunt/rb_answer2.wav","vj_hlr/gsrc/npc/rgrunt/rb_answer3.wav","vj_hlr/gsrc/npc/rgrunt/rb_answer4.wav","vj_hlr/gsrc/npc/rgrunt/rb_answer5.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/gsrc/npc/rgrunt/rb_combat1.wav","vj_hlr/gsrc/npc/rgrunt/rb_combat2.wav","vj_hlr/gsrc/npc/rgrunt/rb_combat3.wav","vj_hlr/gsrc/npc/rgrunt/rb_combat4.wav","vj_hlr/gsrc/npc/rgrunt/rb_taunt1.wav","vj_hlr/gsrc/npc/rgrunt/rb_taunt2.wav","vj_hlr/gsrc/npc/rgrunt/rb_taunt3.wav"}
	self.SoundTbl_Investigate = {"vj_hlr/gsrc/npc/rgrunt/rb_investigate.wav"}
	self.SoundTbl_Alert = {"vj_hlr/gsrc/npc/rgrunt/rb_alert1.wav","vj_hlr/gsrc/npc/rgrunt/rb_alert2.wav","vj_hlr/gsrc/npc/rgrunt/rb_alert3.wav","vj_hlr/gsrc/npc/rgrunt/rb_alert4.wav","vj_hlr/gsrc/npc/rgrunt/rb_alert5.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/gsrc/npc/rgrunt/rb_help.wav"}
	self.SoundTbl_WeaponReload = {"vj_hlr/gsrc/npc/rgrunt/rb_cover1.wav","vj_hlr/gsrc/npc/rgrunt/rb_cover2.wav"}
	self.SoundTbl_GrenadeAttack = {"vj_hlr/gsrc/npc/rgrunt/rb_deploy1.wav","vj_hlr/gsrc/npc/rgrunt/rb_deploy2.wav"}
	self.SoundTbl_GrenadeSight = {"vj_hlr/gsrc/npc/rgrunt/rb_gren1.wav","vj_hlr/gsrc/npc/rgrunt/rb_gren2.wav","vj_hlr/gsrc/npc/rgrunt/rb_gren3.wav"}
	self.SoundTbl_DangerSight = {"vj_hlr/gsrc/npc/rgrunt/rb_gren2.wav","vj_hlr/gsrc/npc/rgrunt/rb_cover1.wav","vj_hlr/gsrc/npc/rgrunt/rb_cover2.wav"}
	self.SoundTbl_KilledEnemy = {"vj_hlr/gsrc/npc/rgrunt/rb_killed1.wav","vj_hlr/gsrc/npc/rgrunt/rb_killed2.wav","vj_hlr/gsrc/npc/rgrunt/rb_killed3.wav","vj_hlr/gsrc/npc/rgrunt/rb_killed4.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/gsrc/npc/rgrunt/rb_allydeath1.wav"}
	self.SoundTbl_Pain = {"vj_hlr/gsrc/npc/rgrunt/spark1.wav","vj_hlr/gsrc/npc/rgrunt/spark2.wav","vj_hlr/gsrc/npc/rgrunt/spark3.wav","vj_hlr/gsrc/npc/rgrunt/spark4.wav","vj_hlr/gsrc/npc/rgrunt/spark5.wav","vj_hlr/gsrc/npc/rgrunt/spark6.wav"}
	self.SoundTbl_Death = {"vj_hlr/gsrc/npc/rgrunt/rb_die1.wav","vj_hlr/gsrc/npc/rgrunt/rb_die2.wav","vj_hlr/gsrc/npc/rgrunt/rb_die3.wav"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnThink()
	if self.HECU_NextMouthMove > CurTime() then
		local changeTo = self:GetSkin() + 1
		if changeTo > 3 then
			changeTo = 1
		end
		self:SetSkin(changeTo)
	else
		self:SetSkin(0)
	end
	
	-- Take damage if in water
	if self:WaterLevel() == 3 then
		self:SetHealth(self:Health() - 1)
		if self:Health() <= 0 then -- Actually kill it
			self:TakeDamage(1, self, self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_Breath, sdFile) or VJ.HasValue(self.SoundTbl_Pain, sdFile) then return end
	self.HECU_NextMouthMove = CurTime() + SoundDuration(sdFile)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Init" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibsCollideSd = {"vj_hlr/gsrc/fx/metal1.wav", "vj_hlr/gsrc/fx/metal2.wav", "vj_hlr/gsrc/fx/metal3.wav", "vj_hlr/gsrc/fx/metal4.wav", "vj_hlr/gsrc/fx/metal5.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
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
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 50)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 1, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 1, 45)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 2, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11_g.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(2, 1, 40)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog1.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 60)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog2.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_rib.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 1, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 2, 15)), CollisionSound=gibsCollideSd})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_spring.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(2, 1, 15)), CollisionSound=false}) -- Shad ge sharji,  ere vor tsayn chi hane
	
	VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris3.wav", 100, 100)
	self:PlaySoundSystem("Gib", "vj_hlr/gsrc/npc/rgrunt/rb_gib.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/metalgib_p1_g.mdl", "models/vj_hlr/gibs/metalgib_p2_g.mdl", "models/vj_hlr/gibs/metalgib_p3_g.mdl", "models/vj_hlr/gibs/metalgib_p4_g.mdl", "models/vj_hlr/gibs/metalgib_p5_g.mdl", "models/vj_hlr/gibs/metalgib_p6_g.mdl", "models/vj_hlr/gibs/metalgib_p7_g.mdl", "models/vj_hlr/gibs/metalgib_p8_g.mdl", "models/vj_hlr/gibs/metalgib_p9_g.mdl", "models/vj_hlr/gibs/metalgib_p10_g.mdl", "models/vj_hlr/gibs/metalgib_p11_g.mdl", "models/vj_hlr/gibs/rgib_cog1.mdl", "models/vj_hlr/gibs/rgib_cog2.mdl", "models/vj_hlr/gibs/rgib_rib.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl", "models/vj_hlr/gibs/rgib_screw.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, corpseEnt, 5)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs, {CollisionSound = gibsCollideSd, ExpSound = {"vj_hlr/gsrc/npc/rgrunt/rb_gib.wav"}})
end
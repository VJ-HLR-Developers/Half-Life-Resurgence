AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/rgrunt.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.BloodColor = ""
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false
ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/rgrunt/pl_metal1.wav","vj_hlr/hl1_npc/rgrunt/pl_metal2.wav","vj_hlr/hl1_npc/rgrunt/pl_metal3.wav","vj_hlr/hl1_npc/rgrunt/pl_metal4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/rgrunt/rb_idle1.wav","vj_hlr/hl1_npc/rgrunt/rb_idle2.wav","vj_hlr/hl1_npc/rgrunt/rb_idle3.wav"}
ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/rgrunt/rb_engine.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/rgrunt/rb_question1.wav","vj_hlr/hl1_npc/rgrunt/rb_question2.wav","vj_hlr/hl1_npc/rgrunt/rb_question3.wav","vj_hlr/hl1_npc/rgrunt/rb_question4.wav","vj_hlr/hl1_npc/rgrunt/rb_question5.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/rgrunt/rb_answer1.wav","vj_hlr/hl1_npc/rgrunt/rb_answer2.wav","vj_hlr/hl1_npc/rgrunt/rb_answer3.wav","vj_hlr/hl1_npc/rgrunt/rb_answer4.wav","vj_hlr/hl1_npc/rgrunt/rb_answer5.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/rgrunt/rb_combat1.wav","vj_hlr/hl1_npc/rgrunt/rb_combat2.wav","vj_hlr/hl1_npc/rgrunt/rb_combat3.wav","vj_hlr/hl1_npc/rgrunt/rb_combat4.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt1.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt2.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt3.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/hl1_npc/rgrunt/rb_investigate.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/rgrunt/rb_alert1.wav","vj_hlr/hl1_npc/rgrunt/rb_alert2.wav","vj_hlr/hl1_npc/rgrunt/rb_alert3.wav","vj_hlr/hl1_npc/rgrunt/rb_alert4.wav","vj_hlr/hl1_npc/rgrunt/rb_alert5.wav"}
ENT.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/rgrunt/rb_help.wav"}
ENT.SoundTbl_WeaponReload = {"vj_hlr/hl1_npc/rgrunt/rb_cover1.wav","vj_hlr/hl1_npc/rgrunt/rb_cover2.wav"}
ENT.SoundTbl_GrenadeAttack = {"vj_hlr/hl1_npc/rgrunt/rb_deploy1.wav","vj_hlr/hl1_npc/rgrunt/rb_deploy2.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/rgrunt/rb_gren1.wav","vj_hlr/hl1_npc/rgrunt/rb_gren2.wav","vj_hlr/hl1_npc/rgrunt/rb_gren3.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/rgrunt/rb_killed1.wav","vj_hlr/hl1_npc/rgrunt/rb_killed2.wav","vj_hlr/hl1_npc/rgrunt/rb_killed3.wav","vj_hlr/hl1_npc/rgrunt/rb_killed4.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/rgrunt/rb_allydeath1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/rgrunt/spark1.wav","vj_hlr/hl1_npc/rgrunt/spark2.wav","vj_hlr/hl1_npc/rgrunt/spark3.wav","vj_hlr/hl1_npc/rgrunt/spark4.wav","vj_hlr/hl1_npc/rgrunt/spark5.wav","vj_hlr/hl1_npc/rgrunt/spark6.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/rgrunt/rb_die1.wav","vj_hlr/hl1_npc/rgrunt/rb_die2.wav","vj_hlr/hl1_npc/rgrunt/rb_die3.wav"}

ENT.BreathSoundLevel = 50

ENT.GeneralSoundPitch1 = 130
ENT.GeneralSoundPitch2 = 140
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	self:SetBodygroup(1,math.random(0,1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnThink()
	if self.HECU_NextMouthMove > CurTime() then
		local changeTo = self:GetSkin() +1
		if changeTo > 3 then
			changeTo = 1
		end
		-- Entity(1):ChatPrint("g")
		self:SetSkin(changeTo)
	else
		self:SetSkin(0)
	end
	
	if self:WaterLevel() == 3 then
		self:SetHealth(self:Health() - 1)
		if self:Health() <= 0 then
			self.Bleeds = false
			self:TakeDamage(1,self,self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	if !self.SoundTbl_Breath[SoundFile] && !self.SoundTbl_Pain[SoundFile] then
		self.HECU_NextMouthMove = CurTime() + SoundDuration(SoundFile)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,GetCorpse,5)
	ParticleEffect("explosion_turret_break_fire", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("head")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_flash", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("head")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("head")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_sparks", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("head")).Pos, Angle(0,0,0), GetCorpse)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		util.Effect("HelicopterMegaBomb", effectdata)
		ParticleEffect("explosion_turret_break_fire", self:GetPos() +self:GetUp() *50, Angle(0,0,0))
	end
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p1_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p2_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p3_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,50)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p4_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p9_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,45)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p10_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p11_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,40)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog1.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,60)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog2.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_rib.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_spring.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,15)),CollideSound=""}) -- Shad ge sharji, ere vor tsayn chi hane
	return true
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
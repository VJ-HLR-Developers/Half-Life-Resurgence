AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/rgrunt.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/rgrunt/pl_metal1.wav","vj_hlr/hl1_npc/rgrunt/pl_metal2.wav","vj_hlr/hl1_npc/rgrunt/pl_metal3.wav","vj_hlr/hl1_npc/rgrunt/pl_metal4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/rgrunt/rb_idle1.wav","vj_hlr/hl1_npc/rgrunt/rb_idle2.wav","vj_hlr/hl1_npc/rgrunt/rb_idle3.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/rgrunt/rb_question1.wav","vj_hlr/hl1_npc/rgrunt/rb_question2.wav","vj_hlr/hl1_npc/rgrunt/rb_question3.wav","vj_hlr/hl1_npc/rgrunt/rb_question4.wav","vj_hlr/hl1_npc/rgrunt/rb_question5.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/rgrunt/rb_answer1.wav","vj_hlr/hl1_npc/rgrunt/rb_answer2.wav","vj_hlr/hl1_npc/rgrunt/rb_answer3.wav","vj_hlr/hl1_npc/rgrunt/rb_answer4.wav","vj_hlr/hl1_npc/rgrunt/rb_answer5.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/rgrunt/rb_combat1.wav","vj_hlr/hl1_npc/rgrunt/rb_combat2.wav","vj_hlr/hl1_npc/rgrunt/rb_combat3.wav","vj_hlr/hl1_npc/rgrunt/rb_combat4.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt1.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt2.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt3.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/hl1_npc/rgrunt/rb_investigate.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/rgrunt/rb_alert1.wav","vj_hlr/hl1_npc/rgrunt/rb_alert2.wav","vj_hlr/hl1_npc/rgrunt/rb_alert3.wav","vj_hlr/hl1_npc/rgrunt/rb_alert4.wav","vj_hlr/hl1_npc/rgrunt/rb_alert5.wav"}
ENT.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/rgrunt/rb_help.wav"}
ENT.SoundTbl_WeaponReload = {"vj_hlr/hl1_npc/rgrunt/rb_cover1.wav","vj_hlr/hl1_npc/rgrunt/rb_cover2.wav"}
ENT.SoundTbl_GrenadeAttack = {"vj_hlr/hl1_npc/rgrunt/rb_deploy1.wav","vj_hlr/hl1_npc/rgrunt/rb_deploy2.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/rgrunt/rb_gren1.wav","vj_hlr/hl1_npc/rgrunt/rb_gren2.wav","vj_hlr/hl1_npc/rgrunt/rb_gren3.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/rgrunt/rb_killed1.wav","vj_hlr/hl1_npc/rgrunt/rb_killed2.wav","vj_hlr/hl1_npc/rgrunt/rb_killed3.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/rgrunt/rb_allydeath1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/rgrunt/spark1.wav","vj_hlr/hl1_npc/rgrunt/spark2.wav","vj_hlr/hl1_npc/rgrunt/spark3.wav","vj_hlr/hl1_npc/rgrunt/spark4.wav","vj_hlr/hl1_npc/rgrunt/spark5.wav","vj_hlr/hl1_npc/rgrunt/spark6.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/rgrunt/rb_die1.wav","vj_hlr/hl1_npc/rgrunt/rb_die2.wav","vj_hlr/hl1_npc/rgrunt/rb_die3.wav"}

ENT.GeneralSoundPitch1 = 140

function ENT:HECU_CustomOnInitialize()
	self:SetBodygroup(1,math.random(0,1))
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,GetCorpse,2)
	ParticleEffect("explosion_turret_break_fire", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("rhand")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_flash", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("rhand")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("rhand")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_sparks", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("rhand")).Pos, Angle(0,0,0), GetCorpse)
end

function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		ParticleEffect("explosion_turret_break_fire", vPoint +self:GetUp() *70, Angle(0,0,0))
		util.Effect( "HelicopterMegaBomb", effectdata )
	end
	/*
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_bone.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_gib.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_guts.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_hmeat.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_lung.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,60))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_legbone.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,15))})
	*/
	return true
end

function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_hlr/hl1_npc/rgrunt/rb_gib.wav",90,math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
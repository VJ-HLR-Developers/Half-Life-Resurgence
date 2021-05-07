AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/rgrunt.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}
ENT.BloodColor = ""
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false
ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!

ENT.BreathSoundLevel = 50
ENT.GeneralSoundPitch1 = 130
ENT.GeneralSoundPitch2 = 140
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	self:SetBodygroup(1,math.random(0,1))
	self.SoundTbl_FootStep = {"vj_hlr/hl1_npc/rgrunt/pl_metal1.wav","vj_hlr/hl1_npc/rgrunt/pl_metal2.wav","vj_hlr/hl1_npc/rgrunt/pl_metal3.wav","vj_hlr/hl1_npc/rgrunt/pl_metal4.wav"}
	self.SoundTbl_Idle = {"vj_hlr/hl1_npc/rgrunt/rb_idle1.wav","vj_hlr/hl1_npc/rgrunt/rb_idle2.wav","vj_hlr/hl1_npc/rgrunt/rb_idle3.wav"}
	self.SoundTbl_Breath = {"vj_hlr/hl1_npc/rgrunt/rb_engine.wav"}
	self.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/rgrunt/rb_question1.wav","vj_hlr/hl1_npc/rgrunt/rb_question2.wav","vj_hlr/hl1_npc/rgrunt/rb_question3.wav","vj_hlr/hl1_npc/rgrunt/rb_question4.wav","vj_hlr/hl1_npc/rgrunt/rb_question5.wav"}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/rgrunt/rb_answer1.wav","vj_hlr/hl1_npc/rgrunt/rb_answer2.wav","vj_hlr/hl1_npc/rgrunt/rb_answer3.wav","vj_hlr/hl1_npc/rgrunt/rb_answer4.wav","vj_hlr/hl1_npc/rgrunt/rb_answer5.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/rgrunt/rb_combat1.wav","vj_hlr/hl1_npc/rgrunt/rb_combat2.wav","vj_hlr/hl1_npc/rgrunt/rb_combat3.wav","vj_hlr/hl1_npc/rgrunt/rb_combat4.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt1.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt2.wav","vj_hlr/hl1_npc/rgrunt/rb_taunt3.wav"}
	self.SoundTbl_Investigate = {"vj_hlr/hl1_npc/rgrunt/rb_investigate.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hl1_npc/rgrunt/rb_alert1.wav","vj_hlr/hl1_npc/rgrunt/rb_alert2.wav","vj_hlr/hl1_npc/rgrunt/rb_alert3.wav","vj_hlr/hl1_npc/rgrunt/rb_alert4.wav","vj_hlr/hl1_npc/rgrunt/rb_alert5.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/rgrunt/rb_help.wav"}
	self.SoundTbl_WeaponReload = {"vj_hlr/hl1_npc/rgrunt/rb_cover1.wav","vj_hlr/hl1_npc/rgrunt/rb_cover2.wav"}
	self.SoundTbl_GrenadeAttack = {"vj_hlr/hl1_npc/rgrunt/rb_deploy1.wav","vj_hlr/hl1_npc/rgrunt/rb_deploy2.wav"}
	self.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/rgrunt/rb_gren1.wav","vj_hlr/hl1_npc/rgrunt/rb_gren2.wav","vj_hlr/hl1_npc/rgrunt/rb_gren3.wav"}
	self.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/rgrunt/rb_killed1.wav","vj_hlr/hl1_npc/rgrunt/rb_killed2.wav","vj_hlr/hl1_npc/rgrunt/rb_killed3.wav","vj_hlr/hl1_npc/rgrunt/rb_killed4.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/rgrunt/rb_allydeath1.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hl1_npc/rgrunt/spark1.wav","vj_hlr/hl1_npc/rgrunt/spark2.wav","vj_hlr/hl1_npc/rgrunt/spark3.wav","vj_hlr/hl1_npc/rgrunt/spark4.wav","vj_hlr/hl1_npc/rgrunt/spark5.wav","vj_hlr/hl1_npc/rgrunt/spark6.wav"}
	self.SoundTbl_Death = {"vj_hlr/hl1_npc/rgrunt/rb_die1.wav","vj_hlr/hl1_npc/rgrunt/rb_die2.wav","vj_hlr/hl1_npc/rgrunt/rb_die3.wav"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnThink()
	if self.HECU_NextMouthMove > CurTime() then
		local changeTo = self:GetSkin() + 1
		if changeTo > 3 then
			changeTo = 1
		end
		-- Entity(1):ChatPrint("g")
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
function ENT:OnPlayCreateSound(sdData, sdFile)
	if !self.SoundTbl_Breath[sdFile] && !self.SoundTbl_Pain[sdFile] then
		self.HECU_NextMouthMove = CurTime() + SoundDuration(sdFile)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	ParticleEffect("explosion_turret_break_fire", self:GetAttachment(self:LookupAttachment("head")).Pos, Angle(0,0,0), self)
	ParticleEffect("explosion_turret_break_flash", self:GetAttachment(self:LookupAttachment("head")).Pos, Angle(0,0,0), self)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", self:GetAttachment(self:LookupAttachment("head")).Pos, Angle(0,0,0), self)
	ParticleEffect("explosion_turret_break_sparks", self:GetAttachment(self:LookupAttachment("head")).Pos, Angle(0,0,0), self)
end
local vec = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(math.random(1,2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico",rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,corpseEnt,5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
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
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
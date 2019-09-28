AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/houndeye.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 80
ENT.HullType = HULL_WIDE_SHORT
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_Sonic = true -- Immune to sonic damage
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 164 -- How close does it have to be until it attacks?
ENT.TimeUntilMeleeAttackDamage = 2.35 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackDamageType = DMG_SONIC -- Type of Damage
ENT.MeleeAttackDSPSoundType = 34 -- What type of DSP effect? | Search online for the types
ENT.MeleeAttackDSPSoundUseDamage = false -- Should it only do the DSP effect if gets damaged x or greater amount
ENT.DisableDefaultMeleeAttackDamageCode = true -- Disables the default mel	ee attack damage code
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE,ACT_DIEFORWARD,ACT_DIEBACKWARD} -- Death Animations
ENT.DeathAnimationChance = 3 -- Put 1 if you want it to play the animation all the time
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {"vjseq_flinch_small"} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/houndeye/he_hunt1.wav","vj_hlr/hl1_npc/houndeye/he_hunt2.wav","vj_hlr/hl1_npc/houndeye/he_hunt3.wav","vj_hlr/hl1_npc/houndeye/he_hunt4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/houndeye/he_idle1.wav","vj_hlr/hl1_npc/houndeye/he_idle2.wav","vj_hlr/hl1_npc/houndeye/he_idle3.wav","vj_hlr/hl1_npc/houndeye/he_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/houndeye/he_alert1.wav","vj_hlr/hl1_npc/houndeye/he_alert2.wav","vj_hlr/hl1_npc/houndeye/he_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/houndeye/he_attack1.wav","vj_hlr/hl1_npc/houndeye/he_attack2.wav","vj_hlr/hl1_npc/houndeye/he_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/houndeye/he_pain1.wav","vj_hlr/hl1_npc/houndeye/he_pain2.wav","vj_hlr/hl1_npc/houndeye/he_pain3.wav","vj_hlr/hl1_npc/houndeye/he_pain4.wav","vj_hlr/hl1_npc/houndeye/he_pain5.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/houndeye/he_die1.wav","vj_hlr/hl1_npc/houndeye/he_die2.wav","vj_hlr/hl1_npc/houndeye/he_die3.wav"}

ENT.FootStepSoundLevel = 80
ENT.GeneralSoundPitch1 = 100

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Bip01 Head"
ENT.Controller_FirstPersonOffset = Vector(0,0,0)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

-- Custom
ENT.Houndeye_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20 , 40), Vector(-20, -20, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "he_hunt" then
		self:FootStepSoundCode()
	end
	if key == "placeholder_eye_event_dont_use" then
		VJ_EmitSound(self,{"vj_hlr/hl1_npc/houndeye/he_pain1.wav","vj_hlr/hl1_npc/houndeye/he_pain3.wav"})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self:GetEnemy()) then
		self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY}
	else
		self.AnimTbl_IdleStand = {ACT_IDLE,"leaderlook"}
	end
	
	if self.Dead == false && CurTime() > self.Houndeye_BlinkingT then
		self:SetSkin(1)
		timer.Simple(0.1,function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.2,function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.3,function() if IsValid(self) then self:SetSkin(0) end end)
		self.Houndeye_BlinkingT = CurTime() + math.Rand(2,3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,2) == 1 then
		self:VJ_ACT_PLAYACTIVITY({"vjseq_madidle1","vjseq_madidle2","vjseq_madidle3"},true,false,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks()
	local blast = ents.Create("prop_combine_ball")
	blast:SetPos(self:GetPos())
	blast:SetParent(self)
	blast:Spawn()
	blast:Fire("explode","",0)
	//blast:Fire("disablepuntsound","1")
	
	if self.HasSounds == true && GetConVarNumber("vj_npc_sd_meleeattack") == 0 then
		VJ_EmitSound(self,{"vj_hlr/hl1_npc/houndeye/he_blast1.wav","vj_hlr/hl1_npc/houndeye/he_blast2.wav","vj_hlr/hl1_npc/houndeye/he_blast3.wav"},100,math.random(80,100))
	end
	
	util.VJ_SphereDamage(self,self,self:GetPos(),400,self.MeleeAttackDamage,self.MeleeAttackDamageType,true,true,{DisableVisibilityCheck=true,Force=80})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFlinch_BeforeFlinch(dmginfo,hitgroup)
	if self.PlayingAttackAnimation == true then
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	GetCorpse:SetSkin(math.random(1,2))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() +self:OBBCenter())
		effectdata:SetScale(1)
		util.Effect("StriderBlood",effectdata)
		util.Effect("StriderBlood",effectdata)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
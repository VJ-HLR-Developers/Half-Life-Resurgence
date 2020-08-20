AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/big_mom.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 2000
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.EntitiesToNoCollide = {"npc_vj_hlr1_headcrab_baby","npc_vj_hlr1_headcrab","npc_vj_hlr1a_headcrab"} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow_large"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 60
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackDistance = 100 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 200 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
	-- ====== Knock Back Variables ====== --
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 100 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 100 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 10 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 10 -- How far it will push you up | Second in math.random
ENT.MeleeAttackKnockBack_Right1 = 0 -- How far it will push you right | First in math.random
ENT.MeleeAttackKnockBack_Right2 = 0 -- How far it will push you right | Second in math.random
	-- ====== World Shake On Miss Variables ====== --
ENT.MeleeAttackWorldShakeOnMiss = true -- Should it shake the world when it misses during melee attack?
ENT.MeleeAttackWorldShakeOnMissAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.MeleeAttackWorldShakeOnMissRadius = 1000 -- How far the screen shake goes, in world units
ENT.MeleeAttackWorldShakeOnMissDuration = 1 -- How long the screen shake will last, in seconds
ENT.MeleeAttackWorldShakeOnMissFrequency = 100 -- Just leave it to 100

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_gonarchspit" -- The entity that is spawned when range attacking
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 500 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 0.1 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.RangeAttackPos_Up = 180 -- Up/Down spawning position for range attack

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"death"} -- Death Animations
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/gonarch/gon_step1.wav","vj_hlr/hl1_npc/gonarch/gon_step2.wav","vj_hlr/hl1_npc/gonarch/gon_step3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/gonarch/gon_alert1.wav","vj_hlr/hl1_npc/gonarch/gon_alert2.wav","vj_hlr/hl1_npc/gonarch/gon_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/gonarch/gon_attack1.wav","vj_hlr/hl1_npc/gonarch/gon_attack2.wav","vj_hlr/hl1_npc/gonarch/gon_attack3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/gonarch/gon_attack1.wav","vj_hlr/hl1_npc/gonarch/gon_attack2.wav","vj_hlr/hl1_npc/gonarch/gon_attack3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/gonarch/gon_sack1.wav","vj_hlr/hl1_npc/gonarch/gon_sack2.wav","vj_hlr/hl1_npc/gonarch/gon_sack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/gonarch/gon_pain2.wav","vj_hlr/hl1_npc/gonarch/gon_pain4.wav","vj_hlr/hl1_npc/gonarch/gon_pain5.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/gonarch/gon_die1.wav"}

ENT.AllyDeathSoundChance = 1

ENT.FootStepSoundLevel = 80
ENT.GeneralSoundPitch1 = 100
ENT.AllyDeathSoundLevel = 90

-- Custom
ENT.Gonarch_NextBirthT = 0
ENT.Gonarch_NumBabies = 0
ENT.Gonarch_NextDeadBirthT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(100, 100, 200), Vector(-100, -100, 0))
	self.Gonarch_NextBirthT = CurTime() + 3
	self.Gonarch_NumBabies = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "Step" then
		util.ScreenShake(self:GetPos(), 10, 100, 0.4, 2000)
		self:FootStepSoundCode()
	end
	if key == "spawn" then
		for i=1,3 do
			VJ_EmitSound(self,{"vj_hlr/hl1_npc/gonarch/gon_birth1.wav","vj_hlr/hl1_npc/gonarch/gon_birth1.wav","vj_hlr/hl1_npc/gonarch/gon_birth1.wav"},80)
			if self.Gonarch_NumBabies < 20 then
				local bcrab = ents.Create("npc_vj_hlr1_headcrab_baby")
				if i == 1 then
					bcrab:SetPos(self:GetPos() + self:GetUp()*20)
				elseif i == 2 then
					bcrab:SetPos(self:GetPos() + self:GetUp()*20 + self:GetRight()*25)
				elseif i == 3 then
					bcrab:SetPos(self:GetPos() + self:GetUp()*20 + self:GetRight()*-25)
				end
				bcrab:SetAngles(self:GetAngles())
				bcrab.BabH_Mother = self
				bcrab:Spawn()
				bcrab:Activate()
				bcrab:SetOwner(self)
				self.Gonarch_NumBabies = self.Gonarch_NumBabies + 1
			end
		end
		self.Gonarch_NextBirthT = CurTime() + 10
	end
	if key == "mattack leftA" or key == "mattack rightA" then
		self.MeleeAttackWorldShakeOnMiss = true
		self:MeleeAttackCode()
	elseif key == "mattack leftB" or key == "mattack rightB" then
		self.MeleeAttackWorldShakeOnMiss = false
		self:MeleeAttackCode()
	end
	if key == "rattack" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	self.Gonarch_NextBirthT = CurTime() + math.random(3,6)
	self:VJ_ACT_PLAYACTIVITY({"vjseq_angry1", "vjseq_angry2"}, true, false, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Gonarch_BabyDeath()
	self.Gonarch_NumBabies = self.Gonarch_NumBabies - 1
	if CurTime() > self.Gonarch_NextDeadBirthT then
		self.AllyDeathSoundT = 0
		self:PlaySoundSystem("AllyDeath", {"vj_hlr/hl1_npc/gonarch/gon_childdie1.wav", "vj_hlr/hl1_npc/gonarch/gon_childdie2.wav", "vj_hlr/hl1_npc/gonarch/gon_childdie3.wav"})
		self.Gonarch_NextDeadBirthT = CurTime() + 10
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == false && IsValid(self:GetEnemy()) && self.PlayingAttackAnimation == false && CurTime() > self.Gonarch_NextBirthT && self.Gonarch_NumBabies < 20 && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP))) then
		self:VJ_ACT_PLAYACTIVITY(ACT_SPECIAL_ATTACK1, true, false, true)
		self.Gonarch_NextBirthT = CurTime() + 15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(TheProjectile)
	/*if math.random(1,math.random(2,4)) == 1 then
		self.NextRangeAttackTime_DoRand = 0.1
	else
		self.NextRangeAttackTime_DoRand = 5
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return self:CalculateProjectile("Curve", self:GetPos() + self:GetUp()*self.RangeAttackPos_Up, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1200)
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_shellgib.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,160)),Ang=self:LocalToWorldAngles(Angle(0,0,180))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_sacgib.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(20,0,60)),Ang=self:LocalToWorldAngles(Angle(-89.999908447266, 179.99996948242, 180))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(55,-70,80)),Ang=Angle(3.1017229557037, -35.476417541504, 91.352874755859)})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(70,55,80)),Ang=Angle(3.6497807502747, 60.498592376709, 93.368896484375)})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(-70,-45,80)),Ang=Angle(3.8801980018616, -128.15255737305, 91.630615234375)})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(-45,70,80)),Ang=self:LocalToWorldAngles(Angle(3.8801965713501, -45, 91.630599975586))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
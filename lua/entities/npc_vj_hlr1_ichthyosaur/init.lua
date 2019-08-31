AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/icky.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.HullType = HULL_LARGE
ENT.MovementType = VJ_MOVETYPE_AQUATIC -- How does the SNPC move?
ENT.Aquatic_SwimmingSpeed_Calm = 80 -- The speed it should swim with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aquatic_SwimmingSpeed_Alerted = 300 -- The speed it should swim with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.Aquatic_AnimTbl_Calm = {ACT_WALK} -- Animations it plays when it's wandering around while idle
ENT.Aquatic_AnimTbl_Alerted = {ACT_RUN} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_Blood_HL1_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB -- Type of Damage
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 120 -- How far does the damage go?
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_HOVER,ACT_DIEVIOLENT,ACT_DIESIMPLE} -- Death Animations
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_BIG_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/ichy/ichy_idle1.wav","vj_hlr/hl1_npc/ichy/ichy_idle2.wav","vj_hlr/hl1_npc/ichy/ichy_idle3.wav","vj_hlr/hl1_npc/ichy/ichy_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/ichy/ichy_alert1.wav","vj_hlr/hl1_npc/ichy/ichy_alert2.wav","vj_hlr/hl1_npc/ichy/ichy_alert3.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/ichy/ichy_alert1.wav","vj_hlr/hl1_npc/ichy/ichy_alert2.wav","vj_hlr/hl1_npc/ichy/ichy_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/ichy/ichy_attack1.wav","vj_hlr/hl1_npc/ichy/ichy_attack2.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/ichy/ichy_bite1.wav","vj_hlr/hl1_npc/ichy/ichy_bite2.wav"}
ENT.SoundTbl_MeleeAttackSlowPlayer = {"vj_player/heartbeat.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/ichy/ichy_pain1.wav","vj_hlr/hl1_npc/ichy/ichy_pain2.wav","vj_hlr/hl1_npc/ichy/ichy_pain3.wav","vj_hlr/hl1_npc/ichy/ichy_pain5.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/ichy/ichy_die1.wav","vj_hlr/hl1_npc/ichy/ichy_die2.wav","vj_hlr/hl1_npc/ichy/ichy_die3.wav","vj_hlr/hl1_npc/ichy/ichy_die4.wav"}

ENT.GeneralSoundPitch1 = 100
-- Custom
ENT.Bullsquid_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(40, 40 , 40), Vector(-40, -40, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "mm_tasty" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Dead == false && CurTime() > self.Bullsquid_BlinkingT then
		self:SetSkin(4)
		timer.Simple(0.2,function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.3,function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4,function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.5,function()
			if IsValid(self) then 
				if IsValid(self:GetEnemy()) then
					self:SetSkin(0)
				else
					self:SetSkin(1)
				end
			end
		end)
		self.Bullsquid_BlinkingT = CurTime() + math.Rand(2,3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	GetCorpse:SetSkin(2)
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
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
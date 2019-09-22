AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/floater.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 45
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 100 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 200 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {ACT_WALK} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {ACT_RUN} -- Animations it plays when it's moving while alerted
ENT.AA_ConstantlyMove = true -- Used for aerial and aquatic SNPCs, makes them constantly move
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.IdleAlwaysWander = true -- If set to true, it will make the SNPC always wander when idling
ENT.CanOpenDoors = false -- Can it open doors?
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_NEUTRAL -- The behavior of the SNPC
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {"vjseq_attack"} -- Range Attack Animations
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_toxicspit" -- The entity that is spawned when range attacking
ENT.RangeDistance = 1500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.RangeAttackPos_Up = 20 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 20 -- Forward/ Backward spawning position for range attack
ENT.NextRangeAttackTime = 2 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/floater/fl_idle1.wav","vj_hlr/hl1_npc/floater/fl_idle2.wav","vj_hlr/hl1_npc/floater/fl_idle3.wav","vj_hlr/hl1_npc/floater/fl_idle4.wav","vj_hlr/hl1_npc/floater/fl_idle5.wav","vj_hlr/hl1_npc/floater/fl_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/floater/fl_alert1.wav","vj_hlr/hl1_npc/floater/fl_alert2.wav","vj_hlr/hl1_npc/floater/fl_alert3.wav","vj_hlr/hl1_npc/floater/fl_alert4.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/floater/fl_attack1.wav","vj_hlr/hl1_npc/floater/fl_attack2.wav","vj_hlr/hl1_npc/floater/fl_attack3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/bullchicken/bc_attack2.wav","vj_hlr/hl1_npc/bullchicken/bc_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/floater/fl_pain1.wav","vj_hlr/hl1_npc/floater/fl_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/floater/fl_pain1.wav","vj_hlr/hl1_npc/floater/fl_pain2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Floater_PosForward = 0
ENT.Floater_PosUp = 0
ENT.Floater_PosRight = 0

HLR_Floater_Leader = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(10,10,50), Vector(-10,-10,0))
	self.Floater_PosForward = math.random(-50,50)
	self.Floater_PosUp = math.random(-150,150)
	self.Floater_PosRight = math.random(-120,120)
	if !IsValid(HLR_Floater_Leader) then -- Yete ourish medzavor chiga, ere vor irzenike medzavor ene
		HLR_Floater_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "shoot" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if !IsValid(self:GetEnemy()) then
		if IsValid(HLR_Floater_Leader) then
			if HLR_Floater_Leader != self then
				self.DisableWandering = true
				self:AAMove_MoveToPos(HLR_Floater_Leader,true,{PosForward=self.Floater_PosForward,PosUp=self.Floater_PosUp,PosRight=self.Floater_PosRight}) -- Medzavorin haladz e (Kharen deghme)
			end
		else
			self.DisableWandering = false
			HLR_Floater_Leader = self
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return self:CalculateProjectile("Curve", self:GetPos() + self:GetForward()*20 + self:GetUp()*20, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1500)
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
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
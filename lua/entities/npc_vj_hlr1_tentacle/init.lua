AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/tentacle.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 120
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 35 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 125 -- How far does the damage go?

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"die1","die"} -- Death Animations
ENT.DeathAnimationChance = 3 -- Put 1 if you want it to play the animation all the time
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play


-- Custom
ENT.Tentacle_Level = 0
	-- 0 = Floor level
	-- 1 = Medium Level
	-- 2 = High Level
	-- 3 = Extreme Level
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20 , 60), Vector(-20, -20, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	print(key)
	if key == "attack" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tentacle_DoLevelChange(num)
	local lvl = self.Tentacle_Level + num
	
	if lvl == 0 then
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.Tentacle_Level = 0
	elseif lvl == 1 then
		self.AnimTbl_IdleStand = {ACT_IDLE_RELAXED}
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
		self.Tentacle_Level = 1
	elseif lvl == 2 then
		self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY_MELEE}
		self.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK1_LOW}
		self.Tentacle_Level = 2
	elseif lvl == 3 then
		self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY}
		self.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK2_LOW}
		self.Tentacle_Level = 3
	end
end
/*
 0 to 1 = ACT_SIGNAL1
 1 to 0 = ACT_SIGNAL_ADVANCE
 
 1 to 2 = ACT_SIGNAL2
 2 to 1 = ACT_SIGNAL_FORWARD
 
 2 to 3 = ACT_SIGNAL3
 3 to 2 = ACT_SIGNAL_HALT
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self:GetEnemy()) then
		local enedist = (self.LatestEnemyPosition - self:GetPos()).z
		if enedist >= 570 then
			if self.Tentacle_Level != 3 then
				self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL3,true,false,true)
				self:Tentacle_DoLevelChange(1)
			end
		elseif enedist >= 430 then
			if self.Tentacle_Level != 2 then
				if self.Tentacle_Level > 2 then
					self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_HALT,true,false,true)
					self:Tentacle_DoLevelChange(-1)
				else
					self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL2,true,false,true)
					self:Tentacle_DoLevelChange(1)
				end
			end
		elseif enedist >= 170 then
			if self.Tentacle_Level != 1 then
				if self.Tentacle_Level > 1 then
					self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_FORWARD,true,false,true)
					self:Tentacle_DoLevelChange(-1)
				else
					self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL1,true,false,true)
					self:Tentacle_DoLevelChange(1)
				end
			end
		else
			if self.Tentacle_Level != 0 then
				if self.Tentacle_Level > 0 then
					self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_ADVANCE,true,false,true)
					self:Tentacle_DoLevelChange(-1)
				else
					self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL1,true,false,true)
					self:Tentacle_DoLevelChange(1)
				end
			end
		end
	end
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
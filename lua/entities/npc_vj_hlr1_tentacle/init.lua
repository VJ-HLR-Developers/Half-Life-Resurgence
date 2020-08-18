AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/tentacle.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.SightDistance = 800 -- How far it can see
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.StartHealth = 1000
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow_large"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB -- Type of Damage
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 300 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 380 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 10 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
ENT.IdleSounds_PlayOnAttacks = true -- It will be able to continue and play idle sounds when it performs an attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/tentacle/te_flies1.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/tentacle/te_sing1.wav","vj_hlr/hl1_npc/tentacle/te_sing2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/tentacle/te_alert1.wav","vj_hlr/hl1_npc/tentacle/te_alert2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/tentacle/te_roar1.wav","vj_hlr/hl1_npc/tentacle/te_roar2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/tentacle/te_death2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Tentacle_Level = 0
	-- 0 = Floor level
	-- 1 = Medium Level
	-- 2 = High Level
	-- 3 = Extreme Level
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 160), Vector(-20, -20, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev,evTime,evCycle,evType,evOptions)
	-- Take care of the regular hit sound (When playing idle animations)
	if ev == 6 then
		self:PlaySoundSystem("MeleeAttack", {"vj_hlr/hl1_npc/tentacle/te_strike1.wav","vj_hlr/hl1_npc/tentacle/te_strike2.wav"}, VJ_EmitSound)
		if IsValid(self:GetEnemy()) && (self:GetEnemy():GetPos():Distance(self:GetPos() + self:GetForward()*150)) < 200 then
			self.CanTurnWhileStationary = true
			self:SetAngles(self:VJ_ReturnAngle((self:GetEnemy():GetPos()-self:GetPos()):Angle()))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "attack" then
		self:MeleeAttackCode()
		self:PlaySoundSystem("MeleeAttack", {"vj_hlr/hl1_npc/tentacle/te_strike1.wav","vj_hlr/hl1_npc/tentacle/te_strike2.wav"}, VJ_EmitSound)
		if IsValid(self:GetEnemy()) then self:SetAngles(self:VJ_ReturnAngle((self:GetEnemy():GetPos()-self:GetPos()):Angle())) end
	end
end
-- 0 to 1 = ACT_SIGNAL1				1 to 2 = ACT_SIGNAL2			2 to 3 = ACT_SIGNAL3
-- 1 to 0 = ACT_SIGNAL_ADVANCE		2 to 1 = ACT_SIGNAL_FORWARD		3 to 2 = ACT_SIGNAL_HALT
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tentacle_DoLevelChange(num)
	local lvl = self.Tentacle_Level + num
	VJ_EmitSound(self,{"vj_hlr/hl1_npc/tentacle/te_swing1.wav","vj_hlr/hl1_npc/tentacle/te_swing2.wav"})
	if lvl == 0 then
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.Tentacle_Level = 0
		self:SetCollisionBounds(Vector(20, 20, 160), Vector(-20, -20, 0))
	elseif lvl == 1 then
		self.AnimTbl_IdleStand = {ACT_IDLE_RELAXED}
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
		self.Tentacle_Level = 1
		self:SetCollisionBounds(Vector(20, 20, 380), Vector(-20, -20, 0))
	elseif lvl == 2 then
		self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY_MELEE}
		self.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK1_LOW}
		self.Tentacle_Level = 2
		self:SetCollisionBounds(Vector(20, 20, 580), Vector(-20, -20, 0))
	elseif lvl == 3 then
		self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY}
		self.AnimTbl_MeleeAttack = {ACT_RANGE_ATTACK2_LOW}
		self.Tentacle_Level = 3
		self:SetCollisionBounds(Vector(20, 20, 650), Vector(-20, -20, 0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetNearestPointToEntityPosition()
	-- Take care of the nearest point starting position
	local resultz = 0
	if self.Tentacle_Level == 3 then
		resultz = 570
	elseif self.Tentacle_Level == 2 then
		resultz = 430
	elseif self.Tentacle_Level == 1 then
		resultz = 170
	end
	return self:GetPos() + self:GetForward() + self:GetUp()*resultz -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetMeleeAttackDamagePosition()
	-- Take care of the melee damage starting position
	local resultz = 0
	if self.Tentacle_Level == 3 then
		resultz = 570
	elseif self.Tentacle_Level == 2 then
		resultz = 430
	elseif self.Tentacle_Level == 1 then
		resultz = 170
	end
	return self:GetPos() + self:GetForward() + self:GetUp()*resultz -- Override this to use a different position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self:GetEnemy()) then
		if (self:GetEnemy():GetVelocity():Length() > 50 && self:GetEnemy():IsOnGround()) or (self:GetEnemy():IsNPC() && self:GetEnemy():IsMoving()) then
			self.CanTurnWhileStationary = true
		else
			self.CanTurnWhileStationary = false
		end
		
		if self.CanTurnWhileStationary == true then
			-- 0 = Floor level
			-- 1 = Medium Level
			-- 2 = High Level
			-- 3 = Extreme Level
			local enedist = (self:GetEnemyLastKnownPos() - self:GetPos()).z
			//print("dist: "..enedist)
			if enedist >= 570 then
				if self.Tentacle_Level != 3 then
					self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL3, true, false, false)
					self:Tentacle_DoLevelChange(1)
				end
			elseif enedist >= 430 then
				if self.Tentacle_Level != 2 then
					if self.Tentacle_Level > 2 then
						self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_HALT, true, false, false)
						self:Tentacle_DoLevelChange(-1)
					else
						self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL2, true, false, false)
						self:Tentacle_DoLevelChange(1)
					end
				end
			elseif enedist >= 170 then
				if self.Tentacle_Level != 1 then
					if self.Tentacle_Level > 1 then
						self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_FORWARD, true, false, false)
						self:Tentacle_DoLevelChange(-1)
					else
						self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL1, true, false, false)
						self:Tentacle_DoLevelChange(1)
					end
				end
			else
				if self.Tentacle_Level != 0 then
					if self.Tentacle_Level > 0 then
						self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_ADVANCE, true, false, false)
						self:Tentacle_DoLevelChange(-1)
					else
						self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL1, true, false, false)
						self:Tentacle_DoLevelChange(1)
					end
				end
			end
		end
	else
		self.CanTurnWhileStationary = false
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
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,80))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,80))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,80))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,85))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,80))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,80))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,80))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,85))})
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
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
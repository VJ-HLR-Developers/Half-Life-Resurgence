AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/kingpin.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 1000
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.HullType = HULL_LARGE
ENT.VJC_Data = {
    ThirdP_Offset = Vector(-15, 0, -45), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "MDLDEC_Bone23", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(8, 0, 6), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_Physics = true -- Immune to physics impacts, won't take damage from props

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2} -- Melee Attack Animations
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 105 -- How close does it have to be until it attacks?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 50
ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1 -- How much chance there is that the enemy will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 3 -- How much damage will the enemy get on every rep?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_kingpin_orb" -- The entity that is spawned when range attacking
ENT.RangeDistance = 3000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 180 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.RangeAttackPos_Up = 65
ENT.RangeAttackPos_Forward = 65
ENT.NextRangeAttackTime = 6 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 8 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD, ACT_DIEBACKWARD} -- Death Animations
ENT.FootStepTimeRun = 2-- Next foot step sound when it is running
ENT.FootStepTimeWalk = 2 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {"vjseq_flinch_small"} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/kingpin/kingpin_seeker_amb.wav"}
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/kingpin/kingpin_move.wav", "vj_hlr/hl1_npc/kingpin/kingpin_moveslow.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/kingpin/kingpin_idle1.wav","vj_hlr/hl1_npc/kingpin/kingpin_idle2.wav","vj_hlr/hl1_npc/kingpin/kingpin_idle3.wav",}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/kingpin/kingpin_alert1.wav","vj_hlr/hl1_npc/kingpin/kingpin_alert2.wav","vj_hlr/hl1_npc/kingpin/kingpin_alert3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/kingpin/kingpin_pain1.wav","vj_hlr/hl1_npc/kingpin/kingpin_pain2.wav","vj_hlr/hl1_npc/kingpin/kingpin_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/kingpin/kingpin_death1.wav","vj_hlr/hl1_npc/kingpin/kingpin_death2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.KingPin_NextScanT = 0
ENT.KingPin_PsionicAttacking = false
ENT.KingPin_NextPsionicAttackT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(35, 35, 110),Vector(-35, -35, 0))
	self:SetNW2Bool("PsionicEffect", false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		VJ_EmitSound(self, "vj_hlr/hl1_weapon/crossbow/xbow_hit1.wav", 60, 140)
	elseif key == "attack left" or key == "attack right" then
		self.MeleeAttackDamage = 15
		self:MeleeAttackCode()
	elseif key == "attack strike" then
		self.MeleeAttackDamage = 30
		self:MeleeAttackCode()
	elseif key == "range distance" then
		self:RangeAttackCode()
	//elseif key == "range psychic_loop" then
		//VJ_EmitSound(self, "vj_hlr/hl1_npc/kingpin/port_suckout1.wav", 80, 140)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	-- Ability to see through walls
	if !IsValid(self:GetEnemy()) && CurTime() > self.KingPin_NextScanT then
		VJ_EmitSound(self, {"vj_hlr/hl1_npc/kingpin/kingpin_seeker1.wav", "vj_hlr/hl1_npc/kingpin/kingpin_seeker2.wav", "vj_hlr/hl1_npc/kingpin/kingpin_seeker3.wav"}, 85)
		timer.Simple(0.5, function()
			if IsValid(self) then
				local orgDist = self.SightDistance
				self.FindEnemy_CanSeeThroughWalls = true
				self.SightDistance = 450
				self:DoEntityRelationshipCheck()
				self.FindEnemy_CanSeeThroughWalls = false
				self.SightDistance = orgDist
			end
		end)
		self.KingPin_NextScanT = CurTime() + self.NextProcessTime + 5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:KingPin_ResetPsionicAttack()
	self.GodMode = false
	self.KingPin_PsionicAttacking = false
	self.KingPin_NextPsionicAttackT = CurTime() + math.Rand(8, 12)
	self.AnimTbl_IdleStand = {ACT_IDLE}
	self:SetState()
	self:SetNW2Bool("PsionicEffect", false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	if CurTime() > self.KingPin_NextPsionicAttackT && self.LatestEnemyDistance <= 1000 && !self:BusyWithActivity() && self.KingPin_PsionicAttacking == false && self:Visible(self:GetEnemy()) then
		//print("SEARCH ----")
		local pTbl = {} -- Table of props that it found
		for _, v in ipairs(ents.FindInSphere(self:GetPos(), 600)) do
			if VJ_IsProp(v) && self:Visible(v) && self:GetEnemy():Visible(v) then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) && phys:GetMass() <= 2000 && v.BeingControlledByKingPin != true then
					//print("Prop -", v)
					pTbl[#pTbl + 1] = v
				end
			end
		end
		//print(pTbl)
		if #pTbl > 0 then -- If greater then 1, then we found an object!
			self.GodMode = true
			self:SetNW2Bool("PsionicEffect", true)
			VJ_EmitSound(self, "vj_hlr/hl1_npc/kingpin/port_suckin1.wav", 80, 140) -- 3.08025
			self.KingPin_PsionicAttacking = true
			self.AnimTbl_IdleStand = {ACT_RANGE_ATTACK2}
			self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1_LOW, true, false, false)
			self:SetState(VJ_STATE_ONLY_ANIMATION)
			for _, v in ipairs(pTbl) do
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					v.BeingControlledByKingPin = true
					v:SetNW2Bool("BeingControlledByKingPin", true)
					constraint.RemoveConstraints(v, "Weld")
					phys:EnableMotion(true)
					phys:Wake()
					phys:EnableGravity(false)
					phys:EnableDrag(false)
					phys:ApplyForceCenter(v:GetUp()*2000)
					phys:AddAngleVelocity(v:GetForward()*400 + v:GetRight()*300)
				end
			end
			-- Used to match sounds up
			timer.Simple(2.08025, function()
				if IsValid(self) then
					VJ_EmitSound(self, "vj_hlr/hl1_npc/kingpin/port_suckout1.wav", 80, 140) -- 2.7180
				end
			end)
			-- Used to throw the prop and reset
			timer.Simple(3.42225, function()
				local selfValid = IsValid(self)
				for _, v in ipairs(pTbl) do
					if IsValid(v) then
						local phys = v:GetPhysicsObject()
						if IsValid(phys) then
							v.BeingControlledByKingPin = false
							v:SetNW2Bool("BeingControlledByKingPin", false)
							phys:EnableGravity(true)
							phys:EnableDrag(true)
							if selfValid && IsValid(self:GetEnemy()) then -- We check self here, in case self is removed, we will reset the props at least
								phys:SetVelocity(self:CalculateProjectile("Line", v:GetPos(), self:GetEnemy():GetPos(), 2000))
								self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK2_LOW, true, false, false)
							end
						end
					end
				end
				if selfValid then self:KingPin_ResetPsionicAttack() end -- Here so in case the prop is deleted, we make sure to still reset
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_MeleeAttack() return self.KingPin_PsionicAttacking != true end -- Not returning true will not let the melee attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack() return self.KingPin_PsionicAttacking != true end -- Not returning true will not let the melee attack code run!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
	if IsValid(self:GetEnemy()) then
		projectile.Track_Enemy = self:GetEnemy()
		timer.Simple(20,function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line", self:GetPos() + self:GetUp()*20, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 200)
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if self:HasShield() then
		local dmg = dmginfo:GetDamage()
		dmginfo:SetDamage(0)
		VJ_EmitSound(self,"vj_hlr/hl1_npc/kingpin/port_suckin1.wav",70,200)
		self.ShieldHealth = self.ShieldHealth -dmg
		if self.ShieldHealth <= 0 && !self.IsGeneratingShield then
			self:SetNW2Bool("shield",false)
			self.IsGeneratingShield = true
			timer.Simple(15,function()
				if IsValid(self) then
					self:SetNW2Bool("shield",true)
					self.IsGeneratingShield = false
					self.ShieldHealth = 250
				end
			end)
		end
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(2,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(3,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(4,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(5,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(6,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(7,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(8,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(9,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,1,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,2,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,3,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,4,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,5,55))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,6,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
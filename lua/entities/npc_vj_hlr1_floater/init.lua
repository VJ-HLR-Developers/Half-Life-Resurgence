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
ENT.IdleAlwaysWander = true
ENT.AA_ConstantlyMove = true
ENT.CanOpenDoors = false
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 185 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 185 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.AnimTbl_IdleStand = {"idle"}
ENT.Aerial_AnimTbl_Calm = {"idle"} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {"idle"} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableRangeAttackAnimation = true
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_toxicspit" -- The entity that is spawned when range attacking
ENT.RangeDistance = 1500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = 0.2 -- How much time until the projectile code is ran?
ENT.RangeAttackPos_Up = 20 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 20 -- Forward/ Backward spawning position for range attack
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.GeneralSoundPitch1 = 100
ENT.GibOnDeathDamagesTable = {"All"}
HLR_Boid_Leader = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(15,15,40), Vector(-15,-15,0))
	if !IsValid(Flock_Leader) then
		Flock_Leader = self
	end
	self.FlockRandDistance = math.random(50,150)
	self.RandomPositionUp = math.Rand(-self.FlockRandDistance,self.FlockRandDistance)
	self.RandomPositionForward = math.Rand(-self.FlockRandDistance,self.FlockRandDistance)
	self.RandomPositionRight = math.Rand(-self.FlockRandDistance,self.FlockRandDistance)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_ChaseEnemy(ShouldPlayAnim,UseCalmVariables)
	if self.Dead == true or !IsValid(self:GetEnemy()) then return end
	self:DoIdleAnimation(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_Wander(ShouldPlayAnim,NoFace)
	local calmspeed = self.Aerial_FlyingSpeed_Calm
	local ForceDown = ForceDown or false
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if self:WaterLevel() < 3 then self:AAMove_Stop() ForceDown = true end
		calmspeed = self.Aquatic_SwimmingSpeed_Calm
	end
	
	local Debug = self.AA_EnableDebug
	ShouldPlayAnim = ShouldPlayAnim or false
	NoFace = NoFace or false

	if ShouldPlayAnim == true then
		self.AA_CanPlayMoveAnimation = true
		self.AA_CurrentMoveAnimationType = "Calm"
	else
		self.AA_CanPlayMoveAnimation = false
	end
	if NoFace == false then self:SetAngles(Angle(0,math.random(0,360),0)) end
	local x_neg = 1
	local y_neg = 1
	local z_neg = 1
	if math.random(1,2) == 1 then x_neg = -1 end
	if math.random(1,2) == 1 then y_neg = -1 end
	if math.random(1,2) == 1 then z_neg = -1 end
	local tr_startpos = self:GetPos()
	local tr_endpos = tr_startpos + self:GetForward()*((self:OBBMaxs().x + math.random(100,200))*x_neg) + self:GetRight()*((self:OBBMaxs().y + math.random(100,200))*y_neg) + self:GetUp()*((self:OBBMaxs().z + math.random(100,200))*z_neg)
	if ForceDown == true then
		tr_endpos = tr_startpos + self:GetUp()*((self:OBBMaxs().z + math.random(100,150))*-1)
	end
	/*local tr_for = math.random(-300,300)
	local tr_up = math.random(-300,300)
	local tr_right = math.random(-300,300)
	local tr = util.TraceLine({start = tr_startpos, endpos = tr_startpos+self:GetForward()*tr_for+self:GetRight()*tr_up+self:GetUp()*tr_right, filter = self})*/
	local tr = util.TraceLine({start = tr_startpos, endpos = tr_endpos, filter = self})
	local trFix = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos +Vector(0,0,-200), filter = self})
	local finalPos = tr.HitPos
	if trFix.HitWorld && tr.HitPos:Distance(trFix.HitPos) < 200 then
		finalPos = tr.HitPos +Vector(0,0,100)
	end
	//self.AA_TargetPos = tr.HitPos
	if NoFace == false then self:SetAngles(self:VJ_ReturnAngle((finalPos-tr.StartPos):Angle())) end
	if Debug == true then
		VJ_CreateTestObject(finalPos,self:GetAngles(),Color(0,255,255),5)
		util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,tr.HitPos,false,self:EntIndex(),0)
	end

	-- Set the velocity
	//local myvel = self:GetVelocity()
	local vel_set = (finalPos-self:GetPos()):GetNormal()*calmspeed
	local vel_len = CurTime() + (finalPos:Distance(tr_startpos) / vel_set:Length())
	self.AA_MoveLength_Chase = 0
	if vel_len == vel_len then -- Check for NaN
		self.AA_MoveLength_Wander = vel_len
		self.NextIdleTime = vel_len
	end
	self:SetLocalVelocity(vel_set)
	if Debug == true then ParticleEffect("vj_impact1_centaurspit", tr.HitPos, Angle(0,0,0), self) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_MoveToPos(Ent,ShouldPlayAnim)
	if !IsValid(Ent) then return end
	local MoveSpeed = self.Aerial_FlyingSpeed_Calm
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if Debug == true then
			print("--------")
			print("ME WL: "..self:WaterLevel())
			print("ENEMY WL: "..self:GetEnemy():WaterLevel())
		end
		-- Yete chouri e YEV leman marmine chourin mech-e che, ere vor gena yev kharen kal e
		if self:WaterLevel() <= 2 && self:GetVelocity():Length() > 0 then return end
		if self:WaterLevel() <= 1 && self:GetVelocity():Length() > 0 then self:AAMove_Wander(true,true) return end
		if self:GetEnemy():WaterLevel() == 0 then self:DoIdleAnimation(1) return end -- Yete teshnamin chouren tours e, getsour
		if self:GetEnemy():WaterLevel() <= 1 then -- Yete 0-en ver e, ere vor nayi yete gerna teshanmi-in gerna hasnil
			local trene = util.TraceLine({
				start = self:GetEnemy():GetPos() + self:OBBCenter(),
				endpos = (self:GetEnemy():GetPos() + self:OBBCenter()) + self:GetEnemy():GetUp()*-20,
				filter = self,
				mins = self:OBBMins(),
				maxs = self:OBBMaxs()
			})
			//PrintTable(trene)
			//VJ_CreateTestObject(trene.HitPos,self:GetAngles(),Color(0,255,0),5)
			if trene.Hit == true then return end
		end
		MoveSpeed = self.Aquatic_SwimmingSpeed_Alerted
	end
	
	local Debug = self.AA_EnableDebug
	ShouldPlayAnim = ShouldPlayAnim or false
	NoFace = NoFace or false

	if ShouldPlayAnim == true then
		self.AA_CanPlayMoveAnimation = true
		self.AA_CurrentMoveAnimationType = "Calm"
	else
		self.AA_CanPlayMoveAnimation = false
	end
	
	-- Main Calculations
	local vel_up = 20 //MoveSpeed
	local vel_for = 1
	local vel_stop = false
	local getenemyz = "None"
	local nearpos = self:VJ_GetNearestPointToEntity(Ent)
	local startpos = nearpos.MyPosition // self:GetPos()
	local endpos = nearpos.EnemyPosition // Ent:GetPos()+Ent:OBBCenter()
	local tr = util.TraceHull({
		start = startpos,
		endpos = endpos,
		filter = self,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs()
	})
	local selftohitpos = tr.HitPos
	local selftohitpos_dist = startpos:Distance(selftohitpos)
	if Debug == true then util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,tr.HitPos,false,self:EntIndex(),0) end //vortigaunt_beam
	if selftohitpos_dist <= 16 && tr.HitWorld == true then
		if Debug == true then print("AA: Forward Blocked! [CHASE]") end
		vel_for = 1
		//vel_for = -200
		//vel_stop = true
	end
	//else

	-- X Calculations
		-- Coming soon!

	-- Z Calculations
	local z_self = (self:GetPos()+self:OBBCenter()).z
	local enepos = Ent:GetPos()+Ent:OBBCenter() +Ent:GetForward() *self.RandomPositionForward +Ent:GetRight() *self.RandomPositionRight +Ent:GetUp() *self.RandomPositionUp
	local tr_up_startpos = self:GetPos()+self:OBBCenter()
	//local tr_up = util.TraceLine({start = tr_up_startpos,endpos = self:GetPos()+self:OBBCenter()+self:GetUp()*300,filter = self})
	local tr_down_startpos = self:GetPos()+self:OBBCenter()
	local tr_down = util.TraceLine({start = tr_up_startpos,endpos = self:GetPos()+self:OBBCenter()+self:GetUp()*-300,filter = self})
	//print("UP - ",tr_up_startpos:Distance(tr_up.HitPos))
	//print(math.abs(enepos.z)," OKK ",enepos.z)
	//print(math.abs(z_self)," OKK ",z_self)
	if enepos.z >= z_self then
		if math.abs(enepos.z - z_self) >= 10 then
			if Debug == true then print("AA: UP [CHASE]") end
			getenemyz = "Up"
			//vel_up = 100
		end
	elseif enepos.z <= z_self then
		if math.abs(z_self - enepos.z) >= 10 then
			if Debug == true then print("AA: DOWN [CHASE]") end
			getenemyz = "Down"
			//vel_up = -100
		end
	end
	if getenemyz == "Up" && tr_down_startpos:Distance(tr_down.HitPos) >= 100 then
		if Debug == true then print("AA: GOING UP [CHASE]") end
		vel_up = MoveSpeed //100
	elseif getenemyz == "Up" && tr_down_startpos:Distance(tr_down.HitPos) >= 100 then
		if Debug == true then print("AA: GOING DOWN [CHASE]") end
		vel_up = -MoveSpeed //-100
	end
	/*if tr_up_startpos:Distance(tr_up.HitPos) <= 100 && tr_down_startpos:Distance(tr_down.HitPos) >= 100 then
		print("DOWN - ",tr_up_startpos:Distance(tr_up.HitPos))
		vel_up = -100
	end*/

	-- Set the velocity
	if vel_stop == false then
		//local myvel = self:GetVelocity()
		//local enevel = Ent:GetVelocity()
		local vel_set = ((enepos) - (self:GetPos() + self:OBBCenter())):GetNormal()*MoveSpeed + self:GetUp()*vel_up + self:GetForward()*vel_for
		//local vel_set_yaw = vel_set:Angle().y
		self:SetAngles(self:VJ_ReturnAngle((vel_set):Angle()))
		self:SetLocalVelocity(vel_set)
		local vel_len = CurTime() + (tr.HitPos:Distance(startpos) / vel_set:Length())
		self.AA_MoveLength_Wander = 0
		if vel_len == vel_len then -- Check for NaN
			self.AA_MoveLength_Chase = vel_len
			self.NextIdleTime = vel_len
		end
		if Debug == true then ParticleEffect("vj_impact1_centaurspit", enepos, Angle(0,0,0), self) end
	else
		self:AAMove_Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(Flock_Leader) then
		if Flock_Leader != self then
			self.DisableWandering = true
			self:AAMove_MoveToPos(Flock_Leader,true)
		end
	else
		self.DisableWandering = false
		Flock_Leader = self
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return self:CalculateProjectile("Curve", self:GetPos() + self:GetUp()*-15, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 750)
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,5))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,5))})
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
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/stukabat.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 40
ENT.HullType = HULL_WIDE_SHORT
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 325 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 150 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = ACT_FLY -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = ACT_FLY -- Animations it plays when it's moving while alerted
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "MDLDEC_Bone50", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.IdleAlwaysWander = false -- If set to true, it will make the SNPC always wander when idling
ENT.CanOpenDoors = false -- Can it open doors?

ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.AnimTbl_Death = {"vjseq_Die_on_ground"}

ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = false -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {"vjseq_Attack_bomb"} -- Range Attack Animations
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_stukabomb" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.RangeDistance = 1500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.RangeAttackPos_Up = 20 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 20 -- Forward/ Backward spawning position for range attack
ENT.NextRangeAttackTime = 2 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.NoChaseAfterCertainRange = false -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/stukabat/stkb_idletpick1.wav","vj_hlr/hl1_npc/stukabat/stkb_idletpick2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/stukabat/stkb_deploy1.wav","vj_hlr/hl1_npc/stukabat/stkb_deploy2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/stukabat/stkb_fire1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/stukabat/stkb_flying1.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/stukabat/stkb_die1.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Stuka_Mode = 0 -- 0 = Ground, 1 = Air, 2 = Ceiling
ENT.Stuka_LandingType = 0 -- 0 = None, 1 = Normal, 2 = Ceiling
ENT.Stuka_LandingPos = nil
ENT.Stuka_FlyAnimation = ACT_FLY
ENT.Stuka_ModeChangeT = 0
ENT.Stuka_AerialAnimationType = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(23, 23, 40), Vector(-23, -23, 0))

	self.Stuka_ModeChangeT = CurTime() + math.Rand(3, 6)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChangeMode(mode)
	if self.Dead or self:Health() <= 0 or self:IsBusy() or CurTime() < self.Stuka_ModeChangeT then return end
	local lastMode = self.Stuka_Mode
	if mode == 0 then -- Ground
		self.Stuka_LandingType = 0
		self.Stuka_LandingPos = nil
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self:VJ_ACT_PLAYACTIVITY(ACT_LAND,true,false,false)
		timer.Simple(self:DecideAnimationLength(ACT_LAND, false),function()
			if IsValid(self) then
				self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
				self.IdleAlwaysWander = false
				self.ConstantlyFaceEnemy = false
				self.NoChaseAfterCertainRange = false
				self.HasMeleeAttack = false
				self.HasRangeAttack = false
				self:SetMaxYawSpeed(20)
				self.TurningSpeed = 20
			end
		end)
	elseif mode == 1 then -- Air
		self.Stuka_LandingType = 0
		self.Stuka_LandingPos = nil
		self.AnimTbl_IdleStand = {ACT_HOVER}
		self:VJ_ACT_PLAYACTIVITY(lastMode == 2 && ACT_SPRINT or ACT_LEAP,true,false,false)
		timer.Simple(self:DecideAnimationLength(lastMode == 2 && ACT_SPRINT or ACT_LEAP, false),function()
			if IsValid(self) then
				self:DoChangeMovementType(VJ_MOVETYPE_AERIAL)
				self.IdleAlwaysWander = true
				self.ConstantlyFaceEnemy = true
				self.NoChaseAfterCertainRange = true
				self.HasMeleeAttack = true
				self.HasRangeAttack = true
				self:SetMaxYawSpeed(20)
				self.TurningSpeed = 20
				if lastMode == 2 then
					self:SetPos(self:GetPos() +Vector(0,0,-35))
				end
			end
		end)
	elseif mode == 2 then -- Ceiling
		self.Stuka_LandingType = 0
		self.Stuka_LandingPos = nil
		self.AnimTbl_IdleStand = {ACT_CROUCHIDLE}
		self:VJ_ACT_PLAYACTIVITY(ACT_CROUCH,true,false,false)
		self:SetMaxYawSpeed(0)
		self.TurningSpeed = 0
		timer.Simple(self:DecideAnimationLength(ACT_CROUCH, false),function()
			if IsValid(self) then
				self:DoChangeMovementType(VJ_MOVETYPE_STATIONARY)
				self.IdleAlwaysWander = false
				self.ConstantlyFaceEnemy = false
				self.NoChaseAfterCertainRange = false
				self.HasMeleeAttack = false
				self.HasRangeAttack = false
			end
		end)
		VJ.CreateSound(self,"vj_hlr/hl1_npc/stukabat/stkb_deploy" .. math.random(1,2) .. ".wav")
	end
	self.Stuka_Mode = mode
	-- self.Stuka_ModeChangeT = CurTime() + 4 -- Debug
	self.Stuka_ModeChangeT = CurTime() + (IsValid(self.VJ_TheController) && 4 or math.Rand(15,35))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	-- print(key)
	if key == "wing" then
		VJ.EmitSound(self,"vj_hlr/hl1_npc/stukabat/stkb_wings" .. math.random(1, 3) .. ".wav", 70)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	elseif key == "attack" then
		VJ.CreateSound(self, "vj_hlr/hl1_npc/stukabat/stkb_fire"..math.random(1, 2)..".wav", 75, 100)
	elseif key == "melee" then
		self:MeleeAttackCode()
	elseif key == "dropbomb" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleModeChanging(mode,pos,cont)
	if mode == 1 && CurTime() > self.Stuka_ModeChangeT && (!IsValid(cont) or IsValid(cont) && cont:KeyDown(IN_JUMP)) then
		if self.Stuka_LandingType == 0 && self.Stuka_LandingPos == nil then
			if !self.Stuka_LandingPos then
				local ceiling = math.random(1, 10) == 1
				pos = self:GetLandingPos(ceiling)
				if pos then
					self.Stuka_LandingPos = pos
					self.Stuka_LandingType = ceiling && 2 or 1
				end
			end
		else
			local landType = self.Stuka_LandingType
			-- util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam", self:GetPos(), self.Stuka_LandingPos, false, self:EntIndex(), 0)//vortigaunt_beam
			-- VJ.DEBUG_TempEnt(self.Stuka_LandingPos, self:GetAngles(), Color(212,0,255), 5)
			self:AA_MoveTo(self.Stuka_LandingPos,true,"Calm",{FaceDest=true,FaceDestTarget=false,IgnoreGround=true})
			local tr = util.TraceLine({start = pos,endpos = pos +Vector(0,0,(landType == 1 && -35 or 75)),filter = self})
			if tr.Hit /*&& tr.HitPos:Distance(pos) <= 35*/ then
				if landType == 2 then
					self:SetPos(tr.HitPos +tr.HitNormal *35)
				end
				self:ChangeMode(landType == 1 && 0 or 2)
			end
		end
	elseif mode != 1 && CurTime() > self.Stuka_ModeChangeT && (!IsValid(cont) && math.random(1,30) == 1 or IsValid(cont) && cont:KeyDown(IN_JUMP)) then
		self:ChangeMode(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local cont = self.VJ_TheController
	local ene = self:GetEnemy()
	local pos = self:GetPos()
	local waypoint = pos + self:GetVelocity():Angle():Forward()*50
	local mode = self.Stuka_Mode -- 0 = Ground, 1 = Air, 2 = Ceiling
	if mode == 1 then
		self.Stuka_FlyAnimation = pos.z <= waypoint.z && ACT_FLY or ACT_GLIDE
	end
	if IsValid(ene) then
		if self.LatestEnemyDistance <= self.RangeDistance && self.Stuka_AerialAnimationType != 1 then
			self.Stuka_AerialAnimationType = 1
			self.Aerial_AnimTbl_Calm = ACT_HOVER
		else
			if pos.z <= waypoint.z then
				self.Stuka_AerialAnimationType = 0
				self.Aerial_AnimTbl_Calm = ACT_FLY
			else
				self.Stuka_AerialAnimationType = 2
				self.Aerial_AnimTbl_Calm = ACT_GLIDE
			end
		end
		if IsValid(cont) then
			self:HandleModeChanging(mode, pos, cont)
		elseif mode != 1 && !IsValid(cont) then
			self:ChangeMode(1)
		end
	else
		if self.Stuka_AerialAnimationType != 0 then
			self.Stuka_AerialAnimationType = 0
			self.Aerial_AnimTbl_Calm = self.Stuka_FlyAnimation
		end
		self:HandleModeChanging(mode, pos, cont)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetLandingPos(ceiling)
	local ang = self:GetAngles() +AngleRand()
	local filt = {self,self.VJ_TheController}
	if ceiling then
		ang.p = -70
		local tr1 = util.TraceLine({start = self:GetPos(),endpos = self:GetPos() +ang:Forward() *32000,filter = filt})
		return tr1.MatType && tr1.MatType != 88 && tr1.HitPos +tr1.Normal *5
	end
	ang.p = 35
	local pos = self:GetPos() +(self:GetVelocity() *ang:Forward() *0.1) *ang:Forward()

	local tr1 = util.TraceLine({start = pos,endpos = pos +ang:Forward() *32000,filter = filt})
	local tr1Pos = tr1.HitPos -tr1.Normal *100
	local tr2 = util.TraceLine({start = tr1Pos,endpos = tr1Pos +Vector(0,0,-120),filter = filt})

	return tr2.HitWorld && tr2.MatType && tr2.MatType != 88 && tr2.HitPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AA_StopMoving()
	if IsValid(self.VJ_TheController) && self.Stuka_LandingPos != nil then return end
	if self:GetVelocity():Length() > 0 then
		self.AA_CurrentMoveMaxSpeed = 0
		self.AA_CurrentMoveTime = 0
		self.AA_CurrentMoveType = 0
		self.AA_CurrentMovePos = nil
		self.AA_CurrentMovePosDir = nil
		self.AA_CurrentMoveDist = -1
		self:SetLocalVelocity(Vector(0,0,0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Curve", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 1500), 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if IsValid(self.VJ_TheController) then return end
	if self.Stuka_Mode != 1 then
		self.Stuka_ModeChangeT = CurTime()
		self:ChangeMode(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup)
	if IsValid(self.VJ_TheController) then return end
	if self.Stuka_Mode != 1 then
		self.Stuka_ModeChangeT = CurTime()
		self:ChangeMode(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialKilled(dmginfo, hitgroup)
	if !dmginfo:IsBulletDamage() then return end
	local mode = self.Stuka_Mode
	self.HasDeathAnimation = mode == 0

	if mode == 1 then
		self.HasDeathRagdoll = false
		local deathCorpse = ents.Create("prop_vj_animatable")
		deathCorpse:SetModel(self:GetModel())
		deathCorpse:SetPos(self:GetPos())
		deathCorpse:SetAngles(self:GetAngles())
		function deathCorpse:Initialize()
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:SetSolid(SOLID_CUSTOM)
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:EnableGravity(true)
				phys:SetBuoyancyRatio(0)
			end
		end
		deathCorpse:Spawn()
		deathCorpse:Activate()
		deathCorpse.DeathAnim = VJ.PICK({"Death_fall_simple","Death_fall_violent"})
		undo.ReplaceEntity(self, deathCorpse)
		cleanup.ReplaceEntity(self, deathCorpse)
		function deathCorpse:Think()
			if !self.Dead then
				self:ResetSequence("fall_cycler")
			end
		
			self:NextThink(CurTime())
			return true
		end

		function deathCorpse:PhysicsCollide(data, phys)
			if self.Dead then return end
			self.Dead = true

			self:PhysicsInit(SOLID_NONE)
			self:SetMoveType(MOVETYPE_NONE)
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:SetSolid(SOLID_NONE)
			self:ResetSequence(self.DeathAnim)

			local tr = util.TraceLine({start=self:GetPos(),endpos=self:GetPos() +Vector(0,0,-15),filter=self})
			self:SetPos(tr.Hit && tr.HitPos or self:GetPos() +Vector(0,0,-8)) -- The collision box is too big, so we move it down a bit

			timer.Simple(VJ.AnimDuration(self, self.DeathAnim),function()
				if IsValid(self) then
					local corpse = ents.Create("prop_ragdoll")
					corpse:SetModel(self:GetModel())
					corpse:SetPos(self:GetPos())
					corpse:SetAngles(self:GetAngles())
					corpse:Spawn()
					corpse:Activate()
					corpse:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					corpse.FadeCorpseType = "FadeAndRemove"
					corpse.IsVJBaseCorpse = true
					corpse.ChildEnts = {}
					self.BloodColor = "Yellow"
					self.HasBloodParticle = true
					self.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
					self.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"}

					-- undo.ReplaceEntity(self, corpse)
					-- cleanup.ReplaceEntity(self, corpse)

					for boneLimit = 0, corpse:GetPhysicsObjectCount() - 1 do
						local childphys = corpse:GetPhysicsObjectNum(boneLimit)
						if IsValid(childphys) then
							local childphys_bonepos, childphys_boneang = self:GetBonePosition(corpse:TranslatePhysBoneToBone(boneLimit))
							if (childphys_bonepos) then
								childphys:SetAngles(childphys_boneang)
								childphys:SetPos(childphys_bonepos)
							end
						end
					end

					VJ.HLR_ApplyCorpseSystem(self, corpse, {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"})

					self:Remove()
				end
			end)
			VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
		end

		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(80)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, gibs)
end
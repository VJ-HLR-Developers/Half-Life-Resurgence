AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/strooper.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150
ENT.HullType = HULL_HUMAN
ENT.CombatFaceEnemy = false
ENT.VJC_Data = {
    ThirdP_Offset = Vector(15, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(10, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_hlrof_grenade_spore" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.AnimTbl_GrenadeAttack = {ACT_SPECIAL_ATTACK2} -- Grenade Attack Animations
ENT.GrenadeAttackAttachment = "eyes" -- The attachment that the grenade will spawn at
ENT.TimeUntilGrenadeIsReleased = 1.5 -- Time until the grenade is released
ENT.ThrowGrenadeChance = 1

ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.MoveRandomlyWhenShooting = false -- Should it move randomly when shooting?
ENT.HasLostWeaponSightAnimation = true -- Set to true if you would like the SNPC to play a different animation when it has lost sight of the enemy and can't fire at it
ENT.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK1} -- Animation played when the SNPC does weapon attack | For VJ Weapons
ENT.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK2} -- Animation played when the SNPC does weapon attack while crouching | For VJ Weapons
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL1} -- Call For Help Animations
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL3} -- Animation used if the SNPC does the CallForBackUpOnDamage function
ENT.AnimTbl_TakingCover = {ACT_CROUCHIDLE} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.AnimTbl_AlertFriendsOnDeath = {ACT_IDLE_ANGRY} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIE_GUTSHOT,ACT_DIE_HEADSHOT,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/player/boots1.wav","vj_hlr/hl1_npc/player/boots2.wav","vj_hlr/hl1_npc/player/boots3.wav","vj_hlr/hl1_npc/player/boots4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/shocktrooper/st_idle.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/shocktrooper/st_question1.wav","vj_hlr/hl1_npc/shocktrooper/st_question2.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/shocktrooper/st_answer1.wav","vj_hlr/hl1_npc/shocktrooper/st_answer2.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/shocktrooper/st_combat1.wav","vj_hlr/hl1_npc/shocktrooper/st_combat2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/shocktrooper/st_alert1.wav","vj_hlr/hl1_npc/shocktrooper/st_alert2.wav","vj_hlr/hl1_npc/shocktrooper/st_alert3.wav","vj_hlr/hl1_npc/shocktrooper/st_alert4.wav"}
ENT.SoundTbl_GrenadeAttack = {"vj_hlr/hl1_npc/shocktrooper/st_grenadethrow.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/shocktrooper/st_runfromgrenade.wav"}
ENT.SoundTbl_OnDangerSight = {"vj_hlr/hl1_npc/shocktrooper/st_runfromgrenade.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/shocktrooper/st_combat1.wav"}

ENT.OnGrenadeSightSoundPitch = VJ_Set(105, 110)

-- Custom
ENT.Shocktrooper_BlinkingT = 0
ENT.Shocktrooper_SpawnedEnt = true
ENT.Shocktrooper_DroppedRoach = false
ENT.HECU_UsingHurtWalk = false -- Used for optimizations, makes sure that the animations are only changed once
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 90), Vector(-20, -20, 0))
	self:SetBodygroup(1,0)
	self:Give("weapon_vj_hlrof_strooperwep")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "attack" then
		self:MeleeAttackCode()
	elseif key == "rangeattack" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	elseif key == "body" then
		VJ_EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:Health() <= (self:GetMaxHealth() / 2.2) then
		if !self.HECU_UsingHurtWalk then
			self.AnimTbl_Walk = {ACT_WALK_HURT}
			self.AnimTbl_Run = {ACT_RUN_HURT}
			self.AnimTbl_ShootWhileMovingWalk = {ACT_WALK_HURT}
			self.AnimTbl_ShootWhileMovingRun = {ACT_RUN_HURT}
			self.HECU_UsingHurtWalk = true
		end
	elseif self.HECU_UsingHurtWalk then
		self.AnimTbl_Walk = {ACT_WALK}
		self.AnimTbl_Run = {ACT_RUN}
		self.AnimTbl_ShootWhileMovingWalk = {ACT_WALK}
		self.AnimTbl_ShootWhileMovingRun = {ACT_RUN}
		self.HECU_UsingHurtWalk = false
	end
	
	if self.Dead == false && CurTime() > self.Shocktrooper_BlinkingT then
		timer.Simple(0.2, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4, function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.5, function() if IsValid(self) then self:SetSkin(0) end end)
		self.Shocktrooper_BlinkingT = CurTime() + math.Rand(3,4.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	self.Shocktrooper_SpawnedEnt = false
	if self.HasGibDeathParticles == true then
		local effectBlood = EffectData()
		effectBlood:SetOrigin(self:GetPos() + self:OBBCenter())
		effectBlood:SetColor(VJ_Color2Byte(Color(255,221,35)))
		effectBlood:SetScale(120)
		util.Effect("VJ_Blood1",effectBlood)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() + self:OBBCenter())
		effectdata:SetScale(1)
		util.Effect("StriderBlood",effectdata)
		util.Effect("StriderBlood",effectdata)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,42))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,31))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,36))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,43))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,21))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,32))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/strooper_gib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,24))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,37))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,41))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	self:Shocktrooper_SpawnRoach()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	local activeWep = self:GetActiveWeapon()
	if IsValid(activeWep) then activeWep:Remove() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Shocktrooper_SpawnRoach()
	self:SetBodygroup(1,1)
	self:SetSkin(2)
	if !self.Shocktrooper_DroppedRoach then
		if self.Shocktrooper_SpawnedEnt == true then
			local roachEnt = ents.Create("npc_vj_hlrof_shockroach")
			roachEnt:SetPos(self:GetAttachment(self:LookupAttachment("shock_roach")).Pos)//+ self:GetUp()*50)
			roachEnt:SetAngles(self:GetAngles())
			roachEnt.SRoach_Life = 15
			roachEnt:Spawn()
			roachEnt:Activate()
			roachEnt.VJ_NPC_Class = self.VJ_NPC_Class
		end
		self.Shocktrooper_DroppedRoach = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/strooper_gib1.mdl", "models/vj_hlr/gibs/strooper_gib2.mdl", "models/vj_hlr/gibs/strooper_gib3.mdl", "models/vj_hlr/gibs/strooper_gib4.mdl", "models/vj_hlr/gibs/strooper_gib5.mdl", "models/vj_hlr/gibs/strooper_gib6.mdl", "models/vj_hlr/gibs/strooper_gib7.mdl", "models/vj_hlr/gibs/strooper_gib8.mdl", "models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ_HLR_ApplyCorpseEffects(self, corpseEnt, nil, {ExtraGibs = gibs})
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GrenadeAttackVelUp1 = 200 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelUp2 = 200 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelForward1 = 500 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelForward2 = 500 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelRight1 = -20 -- Grenade attack velocity right | The first # in math.random
ENT.GrenadeAttackVelRight2 = 20 -- Grenade attack velocity right | The second # in math.random
function ENT:ThrowGrenadeCode(customEnt,noOwner)
	if self.Dead == true or self.Flinching == true or self.AttackType == VJ_ATTACK_MELEE or (IsValid(self:GetEnemy()) && !self:Visible(self:GetEnemy())) then return end
	//if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() + self:OBBCenter()),self:GetEnemy():EyePos()) == true then return end
	noOwner = noOwner or false
	local getIsCustom = false
	local gerModel = VJ_PICK(self.GrenadeAttackModel)
	local gerClass = self.GrenadeAttackEntity
	local gerFussTime = self.GrenadeAttackFussTime

	if IsValid(customEnt) then -- Custom nernagner gamal nernagner vor yete bidi nede
		getIsCustom = true
		gerModel = customEnt:GetModel()
		gerClass = customEnt:GetClass()
		customEnt:SetMoveType(MOVETYPE_NONE)
		customEnt:SetParent(self)
		customEnt:Fire("SetParentAttachment",self.GrenadeAttackAttachment)
		//customEnt:SetPos(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos)
		customEnt:SetAngles(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang)
		if gerClass == "obj_vj_grenade" then
			gerFussTime = math.abs(customEnt.FussTime - customEnt.TimeSinceSpawn)
		elseif gerClass == "obj_handgrenade" or gerClass == "obj_spore" then
			gerFussTime = 1
		elseif gerClass == "npc_grenade_frag" or gerClass == "doom3_grenade" or gerClass == "fas2_thrown_m67" or gerClass == "cw_grenade_thrown" or gerClass == "cw_flash_thrown" or gerClass == "cw_smoke_thrown" then
			gerFussTime = 1.5
		elseif gerClass == "obj_cpt_grenade" then
			gerFussTime = 2
		end
	end

	self.AttackType = VJ_ATTACK_GRENADE
	self:CustomOnGrenadeAttack_BeforeStartTimer()
	self:PlaySoundSystem("GrenadeAttack")

	if self.VJ_PlayingSequence == false && self.DisableGrenadeAttackAnimation == false then
		self.CurrentAttackAnimation = VJ_PICK(self.AnimTbl_GrenadeAttack)
		self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) - 0.2,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,self.GrenadeAttackAnimationStopAttacks,self:DecideAnimationLength(self.CurrentAttackAnimation,self.GrenadeAttackAnimationStopAttacksTime),false,self.GrenadeAttackAnimationDelay, {PlayBackRateCalculated=true})
	end

	timer.Simple(self.TimeUntilGrenadeIsReleased,function()
		if getIsCustom == true && !IsValid(customEnt) then return end
		if IsValid(customEnt) then customEnt.VJ_IsPickedUpDanger = false customEnt:Remove() end
		if IsValid(self) && self.Dead == false /*&& IsValid(self:GetEnemy())*/ then -- Yete SNPC ter artoon e...
			local gerShootPos = self:GetPos() + self:GetForward()*200
			if IsValid(self:GetEnemy()) then 
				gerShootPos = self:GetEnemy():GetPos()
			else -- Yete teshnami chooni, nede amenan lav goghme
				local iamarmo = self:VJ_CheckAllFourSides()
				if iamarmo.Forward then gerShootPos = self:GetPos() + self:GetForward()*200; self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Right then gerShootPos = self:GetPos() + self:GetRight()*200; self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Left then gerShootPos = self:GetPos() + self:GetRight()*-200; self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Backward then gerShootPos = self:GetPos() + self:GetForward()*-200; self:FaceCertainPosition(gerShootPos)
				end
			end
			local gent = ents.Create(gerClass)
			local getShootVel = (gerShootPos - self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos) + (self:GetUp()*math.random(450,500) + self:GetForward()*math.Rand(-100,-250) + self:GetRight()*math.Rand(self.GrenadeAttackVelRight1,self.GrenadeAttackVelRight2))
			if IsValid(customEnt) then
				getShootVel = (gerShootPos - self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos) + (self:GetUp()*math.random(self.GrenadeAttackVelUp1,self.GrenadeAttackVelUp2) + self:GetForward()*math.Rand(self.GrenadeAttackVelForward1,self.GrenadeAttackVelForward2) + self:GetRight()*math.Rand(self.GrenadeAttackVelRight1,self.GrenadeAttackVelRight2))
			end
			if noOwner == false then gent:SetOwner(self) end
			gent:SetPos(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos)
			gent:SetAngles(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang)
			if gerModel then gent:SetModel(Model(gerModel)) end
			if gerClass == "obj_vj_grenade" then
				gent.FussTime = gerFussTime
			elseif gerClass == "obj_cpt_grenade" then
				gent:SetTimer(gerFussTime)
			elseif gerClass == "obj_spore" then
				gent:SetGrenade(true)
			elseif gerClass == "ent_hl1_grenade" then
				gent:ShootTimed(customEnt, getShootVel, gerFussTime)
			elseif gerClass == "doom3_grenade" or gerClass == "obj_handgrenade" then
				gent:SetExplodeDelay(gerFussTime)
			elseif gerClass == "cw_grenade_thrown" or gerClass == "cw_flash_thrown" or gerClass == "cw_smoke_thrown" then
				gent:SetOwner(self)
				gent:Fuse(gerFussTime)
			end
			gent:Spawn()
			gent:Activate()
			if gerClass == "npc_grenade_frag" then gent:Input("SetTimer",self:GetOwner(),self:GetOwner(),gerFussTime) end
			local phys = gent:GetPhysicsObject()
			if IsValid(phys) then
				phys:Wake()
				phys:AddAngleVelocity(Vector(math.Rand(500,500),math.Rand(500,500),math.Rand(500,500)))
				phys:SetVelocity(getShootVel)
			end
			self:CustomOnGrenadeAttack_OnThrow(gent)
		end
		if self.AttackType == VJ_ATTACK_GRENADE then
			self.AttackType = VJ_ATTACK_NONE
		end
	end)
end
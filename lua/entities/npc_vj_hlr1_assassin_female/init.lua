AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/hassassin.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.TurningSpeed = 50 -- How fast it can turn
ENT.HullType = HULL_HUMAN
ENT.MaxJumpLegalDistance = VJ_Set(620, 620) -- The max distance the NPC can jump (Usually from one node to another)
ENT.VJC_Data = {
	//FirstP_Bone = "bip01 head", -- If left empty, the base will attempt to calculate a position for first person
	//FirstP_Offset = Vector(6, 0, 2.5), -- The offset for the controller when the camera is in first person
	FirstP_Bone = "bone10", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(-1, 0, -1), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2} -- Melee Attack Animations
ENT.MeleeAttackDamage = 15
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_hlr1_grenade" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.AnimTbl_GrenadeAttack = {ACT_RANGE_ATTACK2} -- Grenade Attack Animations
ENT.GrenadeAttackAttachment = "grenadehand" -- The attachment that the grenade will spawn at
ENT.TimeUntilGrenadeIsReleased = 0.4 -- Time until the grenade is released

ENT.AllowWeaponReloading = false -- If false, the SNPC will no longer reload
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.MoveRandomlyWhenShooting = false -- Should it move randomly when shooting?
ENT.WeaponSpread = 0.6 -- What's the spread of the weapon? | Closer to 0 = better accuracy, Farther than 1 = worse accuracy
ENT.CanCrouchOnWeaponAttack = false -- Can it crouch while shooting?
ENT.AnimTbl_TakingCover = {ACT_LAND} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.AnimTbl_AlertFriendsOnDeath = {ACT_IDLE_ANGRY} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.DropWeaponOnDeathAttachment = "0" -- Which attachment should it use for the weapon's position
ENT.WaitForEnemyToComeOutTime = VJ_Set(1,2) -- How much time should it wait until it starts chasing the enemy?
ENT.HasLostWeaponSightAnimation = true -- Set to true if you would like the SNPC to play a different animation when it has lost sight of the enemy and can't fire at it
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.CombatFaceEnemy = false -- If enemy is exists and is visible
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}

ENT.FootStepSoundLevel = 55

-- Custom
ENT.BOA_CanCloak = true
ENT.BOA_CloakLevel = 1
ENT.BOA_NextJumpT = 0
ENT.BOA_NextRunT = 0
ENT.BOA_ShotsSinceRun = 0
ENT.BOA_OffGround = false
ENT.BOA_FlyAnimSet = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	if GetConVar("vj_hlr1_assassin_cloaks"):GetInt() == 0 then
		self.BOA_CanCloak = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
	if key == "shooty"  or key == "shoot" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	end
	if key == "land" then
		VJ_EmitSound(self, "vj_hlr/hl1_npc/player/pl_jumpland2.wav", 70)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Dead == true then return end
	
	-- Unlimited ammo + weapon body group change
	local activeWep = self:GetActiveWeapon()
	local bGroup = self:GetBodygroup(1)
	if IsValid(activeWep) then
		activeWep:SetClip1(999)
		if bGroup == 1 then
			self:GetActiveWeapon():Remove()
		end
	elseif bGroup == 0 then
		self:DoChangeWeapon("weapon_vj_hlr1_glock17_sup")
	end
	
	-- Cloaking system
	if self.BOA_CanCloak then
		local cloakLvl = math.Clamp(self.BOA_CloakLevel * 255, 40, 255)
		self:SetColor(Color(255, 255, 255, cloakLvl))
		self.BOA_CloakLevel = math.Clamp(self.BOA_CloakLevel + 0.05, 0, 1)
		if cloakLvl <= 220 then -- NPCs can't seem me!
			self:AddFlags(FL_NOTARGET)
			self:DrawShadow(false)
		else -- NPCs can see me! =(
			self:DrawShadow(true)
			self:RemoveFlags(FL_NOTARGET)
		end
	end

	-- Change the firing animation depending if it's on ground or flying
	if self:IsOnGround() then
		if self.BOA_FlyAnimSet then
			self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK1}
			self.BOA_FlyAnimSet = false
		end
	elseif !self.BOA_FlyAnimSet then
		self.AnimTbl_WeaponAttack = {VJ_SequenceToActivity(self, "fly_attack")}
		self.BOA_FlyAnimSet = true
	end
	
	-- Handle landing animation after jumping
	if self.BOA_OffGround == true && self:GetVelocity().z == 0 then
		self.BOA_OffGround = false
		self:VJ_ACT_PLAYACTIVITY(ACT_LAND, true, false, false)
		//VJ_EmitSound(self,"vj_hlr/hl1_npc/player/pl_jumpland2.wav",80) -- Done through event
	end
	
	-- Jump while attacking
	if IsValid(self:GetEnemy()) && CurTime() > self.BOA_NextJumpT && self.DoingWeaponAttack_Standing == true && !self:IsMoving() && self.LatestEnemyDistance < 1400 && self.VJ_IsBeingControlled == false then
		self:StopMoving()
		self:SetGroundEntity(NULL)
		self:SetLocalVelocity(((self:GetPos() + self:GetRight()*(math.random(1, 2) == 1 and 100 or -100)) - (self:GetPos() + self:OBBCenter())):GetNormal()*200 +self:GetUp()*600)
		self:VJ_ACT_PLAYACTIVITY(ACT_JUMP, true, false, true, 0, {}, function(vsched)
			self.BOA_OffGround = true
			//vsched.RunCode_OnFinish = function()
				//self:VJ_ACT_PLAYACTIVITY("fly_attack",true,false,false)
			//end
		end)
		self.BOA_NextRunT = CurTime() + 3
		self.BOA_NextJumpT = CurTime() + 8
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFireBullet(ent, data)
	self.BOA_CloakLevel = 0
	if self.VJ_IsBeingControlled then return end
	self.BOA_ShotsSinceRun = self.BOA_ShotsSinceRun + 1
	if CurTime() > self.BOA_NextRunT && self.BOA_ShotsSinceRun >= 4 then -- Yete amenan keche chors ankam zenke zargadz e, ere vor vaz e!
		self.BOA_ShotsSinceRun = 0
		//timer.Simple(0.8,function() 
			//if IsValid(self) && !self:IsMoving() && self.Dead == false then
				self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
			//end
		//end)
		self.BOA_NextJumpT = CurTime() + 4
		self.BOA_NextRunT = CurTime() + 4
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
	end
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_bone.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_gib.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_guts.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_hmeat.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_lung.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,60))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_legbone.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	self:DropWeaponOnDeathCode(dmginfo, hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	self:SetBodygroup(1,1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo, hitgroup, wepEnt)
	wepEnt.WorldModel_Invisible = false
	wepEnt:SetNW2Bool("VJ_WorldModel_Invisible", false)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
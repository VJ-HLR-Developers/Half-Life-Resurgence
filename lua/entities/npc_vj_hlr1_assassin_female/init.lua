AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/hassassin.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 60
ENT.TurningSpeed = 50 -- How fast it can turn
ENT.HullType = HULL_HUMAN
ENT.JumpVars = {
	MaxRise = 620,
	MaxDrop = 620,
	MaxDistance = 620,
}
ENT.VJC_Data = {
	//FirstP_Bone = "bip01 head", -- If left empty, the base will attempt to calculate a position for first person
	//FirstP_Offset = Vector(6, 0, 2.5), -- The offset for the controller when the camera is in first person
	FirstP_Bone = "bone10", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(-1, 0, -1), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR_Blood_Red"}
ENT.HasBloodPool = false
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.MeleeAttackDamage = 15
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasGrenadeAttack = true -- Should the NPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_hlr1_grenade" -- Entities that it can spawn when throwing a grenade | If set as a table, it picks a random entity | VJ: "obj_vj_grenade" | HL2: "npc_grenade_frag"
ENT.AnimTbl_GrenadeAttack = ACT_RANGE_ATTACK2
ENT.GrenadeAttackAttachment = "grenadehand" -- The attachment that the grenade will spawn at
ENT.TimeUntilGrenadeIsReleased = 0.4 -- Time until the grenade is released

ENT.Weapon_CanReload = false -- If false, the SNPC will no longer reload
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.Weapon_StrafeWhileFiring = false -- Should it move randomly while firing a weapon?
ENT.Weapon_Accuracy = 0.6 -- NPC's accuracy with weapons, affects bullet spread! | x < 1 = Better accuracy | x > 1 = Worse accuracy
ENT.Weapon_CanCrouchAttack = false -- Can it crouch while shooting?
ENT.AnimTbl_TakingCover = ACT_LAND -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.Weapon_WaitOnOcclusionTime = VJ.SET(1, 2) -- How long should it wait before it starts to pursue?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false -- How long should the death animation play?
ENT.CanTurnWhileMoving = false -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav", "vj_hlr/pl_step2.wav", "vj_hlr/pl_step3.wav", "vj_hlr/pl_step4.wav"}

ENT.FootStepSoundLevel = 55

-- Custom
ENT.BOA_CanCloak = true
ENT.BOA_CloakLevel = 1
ENT.BOA_NextJumpT = 0
ENT.BOA_NextRunT = 0
ENT.BOA_ShotsSinceRun = 0
ENT.BOA_OffGround = false
ENT.BOA_ForceJumpShoot = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	if GetConVar("vj_hlr1_assassin_cloaks"):GetInt() == 0 then
		self.BOA_CanCloak = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "melee" then
		self:MeleeAttackCode()
	elseif key == "shooty"  or key == "shoot" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	elseif key == "land" then
		VJ.EmitSound(self, "vj_hlr/hl1_npc/player/pl_jumpland2.wav", 70)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BusyWithActivity()
	-- Override base function to not see jumping as a busy activity when it should jump-fire
	if self:GetNavType() == NAV_JUMP && self.BOA_ForceJumpShoot then
		self.DoingWeaponAttack_Standing = false -- Make the gun actually shoot
		return false
	end
	return self.BaseClass.BusyWithActivity(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	-- Stay under 1.4 to make sure that it will do jump behavior rather then run behavior most of the time | 1.2 = Always jump behavior
	self.BOA_NextJumpT = CurTime() + math.Rand(0.8, 1.4)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.Dead then return end
	local curTime = CurTime()
	
	-- Unlimited ammo + weapon body group change
	local activeWep = self:GetActiveWeapon()
	local bGroup = self:GetBodygroup(1)
	if IsValid(activeWep) then
		if bGroup == 1 then
			self:GetActiveWeapon():Remove()
		end
	elseif bGroup == 0 then
		self:DoChangeWeapon("weapon_vj_hlr1_glock17_sup")
	end
	
	-- Cloaking system
	if self.BOA_CanCloak then
		local prevClockLvl = self:GetColor().a
		local cloakLvl = math.Clamp(self.BOA_CloakLevel * 255, 40, 255)
		self:SetColor(Color(255, 255, 255, cloakLvl))
		self.BOA_CloakLevel = math.Clamp(self.BOA_CloakLevel + 0.05, 0, 1)
		if cloakLvl <= 220 then -- NPCs can't seem me!
			self:DrawShadow(false)
			self:AddFlags(FL_NOTARGET)
		else -- NPCs can see me! =(
			self:DrawShadow(true)
			self:RemoveFlags(FL_NOTARGET)
		end
		-- Make it play a sound effect when it first starts cloaking, as seen here: https://github.com/ValveSoftware/halflife/blob/master/dlls/hassassin.cpp#L728
		if prevClockLvl == 255 && cloakLvl < 255 then
			VJ.EmitSound(self, "vj_hlr/fx/beamstart1.wav", 75, 100, 0.2, CHAN_BODY)
		end
	end
	
	-- If not on ground, make it play fly shooting anim if velocity's z is negative (falling)
	if self:IsOnGround() then
		if self.BOA_ForceJumpShoot then
			self.AnimTbl_WeaponAttack = ACT_RANGE_ATTACK1
			self.BOA_ForceJumpShoot = false
		end
	elseif !self.BOA_ForceJumpShoot && self:GetVelocity().z < 0 then
		local flyAct = VJ.SequenceToActivity(self, "fly_attack")
		self:SetIdealActivity(flyAct)
		self.AnimTbl_WeaponAttack = {flyAct}
		self.BOA_ForceJumpShoot = true
		self.BOA_OffGround = true
	end
	
	if self.BOA_OffGround == true && self:GetVelocity().z == 0 then -- Velocity is 0, so we have landed, play land anim
		self.BOA_OffGround = false
		self:PlayAnim(ACT_LAND, true, false, false)
		//VJ.EmitSound(self,"vj_hlr/hl1_npc/player/pl_jumpland2.wav",80) -- Done through event now
	end
	
	-- Jump while attacking
	if IsValid(self:GetEnemy()) && curTime > self.BOA_NextJumpT && self.DoingWeaponAttack_Standing == true && !self:IsMoving() && self.LatestEnemyDistance < 1400 && self.VJ_IsBeingControlled == false then
		self:ForceMoveJump(((self:GetPos() + self:GetRight()*(math.random(1, 2) == 1 and 100 or -100) + self:GetForward()*(math.random(1, 2) == 1 and 1 or -100)) - (self:GetPos() + self:OBBCenter())):GetNormal()*200 + self:GetUp()*600)
		/*self:StopMoving()
		self:SetGroundEntity(NULL)
		self:SetLocalVelocity(((self:GetPos() + self:GetRight()*(math.random(1, 2) == 1 and 100 or -100)) - (self:GetPos() + self:OBBCenter())):GetNormal()*200 +self:GetUp()*600)
		self:PlayAnim(ACT_JUMP, true, false, true, 0, {}, function(sched)
			self.BOA_OffGround = true
			//sched.RunCode_OnFinish = function()
				//self:PlayAnim("fly_attack",true,false,false)
			//end
		end)*/
		self.BOA_NextRunT = curTime + math.Rand(2, 4)
		self.BOA_NextJumpT = curTime + math.Rand(7, 11)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFireBullet(data)
	self.BOA_CloakLevel = 0
	if self.VJ_IsBeingControlled then return end
	local curTime = CurTime()
	self.BOA_ShotsSinceRun = self.BOA_ShotsSinceRun + 1
	if self:GetNavType() != NAV_JUMP && curTime > self.BOA_NextRunT && self.BOA_ShotsSinceRun >= 4 then -- Yete amenan keche chors ankam zenke zargadz e, ere vor vaz e!
		self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH")
		self.BOA_ShotsSinceRun = 0
		self.BOA_NextJumpT = curTime + math.Rand(2, 4)
		self.BOA_NextRunT = curTime + math.Rand(4, 6)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects == true then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorRed)
		effectData:SetScale(120)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(0)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1,0,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,1,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1,1,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_bone.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_gib.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1,2,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_guts.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(2,1,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_hmeat.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_lung.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,1,45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_skull.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,60))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_legbone.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		self:DeathWeaponDrop(dmginfo, hitgroup)
		self:SetBodygroup(1, 1)
		if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
	elseif status == "Finish" then
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt.WorldModel_Invisible = false
	wepEnt:SetNW2Bool("VJ_WorldModel_Invisible", false)
end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1mp/gordon.mdl"}
ENT.StartHealth = 100
ENT.HasHealthRegeneration = true
ENT.HealthRegenerationAmount = 2
ENT.HealthRegenerationDelay = VJ_Set(0.5,0.5)
ENT.HullType = HULL_HUMAN
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(3, 0, 5),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red"
ENT.CustomBlood_Particle = {"vj_hlr_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"}
ENT.HasBloodPool = false

ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.FriendsWithAllPlayerAllies = true

ENT.PoseParameterLooking_InvertPitch = true

ENT.WeaponInventory_Melee = true
ENT.WeaponInventory_MeleeList = {"weapon_vj_hlr1_ply_crowbar"}
ENT.HasMeleeAttack = false
ENT.AnimTbl_MeleeAttack = {"vjges_shoot_crowbar"}
ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = false
ENT.NextMeleeAttackTime_DoRand = 0.25
ENT.NextAnyAttackTime_Melee = 0.25
ENT.MeleeAttackAnimationAllowOtherTasks = true

ENT.HasGrenadeAttack = false -- Animation refuses to play???
ENT.GrenadeAttackEntity = "obj_vj_hlr1_grenade"
ENT.AnimTbl_GrenadeAttack = {"vjges_shoot_grenade"}
ENT.GrenadeAttackAttachment = "rhand"
ENT.TimeUntilGrenadeIsReleased = 1.3
ENT.NextThrowGrenadeTime = VJ_Set(10, 12)
ENT.ThrowGrenadeChance = 3

ENT.WaitForEnemyToComeOut = false
ENT.HasCallForHelpAnimation = false

ENT.Weapon_NoSpawnMenu = true
-- ENT.CanCrouchOnWeaponAttack = false
-- ENT.DisableWeaponReloadAnimation = true

ENT.AnimTbl_WeaponAttackSecondary = {"vjges_shoot_m203"}

ENT.AnimTbl_ShootWhileMovingWalk = {ACT_RUN_AIM}
ENT.NextMoveRandomlyWhenShootingTime1 = 0
ENT.NextMoveRandomlyWhenShootingTime2 = 0.2

ENT.FootStepTimeRun = 0.3
ENT.FootStepTimeWalk = 0.36

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIE_GUTSHOT,ACT_DIE_HEADSHOT,ACT_DIESIMPLE}

ENT.DropWeaponOnDeathAttachment = "rhand"

ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}

ENT.WeaponsList = {
	["Close"] = {
		"weapon_vj_hlr1_ply_hgun",
		"weapon_vj_hlr1_ply_shotgun",
		"weapon_vj_hlr1_ply_squeak",
	},
	["Normal"] = {
		"weapon_vj_hlr1_ply_357",
		"weapon_vj_hlr1_ply_gauss",
		"weapon_vj_hlr1_ply_mp5",
		"weapon_vj_hlr1_ply_pistol",
	},
	["Far"] = {
		"weapon_vj_hlr1_ply_crossbow",
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInit() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_BeforeStartTimer()
	if IsValid(self:GetActiveWeapon()) then
		self:GetActiveWeapon():SetNoDraw(true)
	end

	local att = self:GetAttachment(self:LookupAttachment("rhand"))
	local gren = ents.Create("prop_vj_animatable")
	gren:SetModel("models/vj_hlr/weapons/w_grenade.mdl")
	gren:SetPos(att.Pos)
	gren:SetAngles(att.Ang)
	gren:SetParent(self)
	gren:Fire("SetParentAttachment","rhand")
	gren:Spawn()
	gren:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:DeleteOnRemove(gren)
	self.FakeGrenade = gren
	self:VJ_ACT_PLAYACTIVITY("aim_grenade",true,false,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(GrenadeEntity)
	SafeRemoveEntity(self.FakeGrenade)
	timer.Simple(0.1,function()
		if IsValid(self) && IsValid(self:GetActiveWeapon()) then
			self:GetActiveWeapon():SetNoDraw(false)
		end
	end)
	local gest = self:AddGestureSequence(self:LookupSequence("shoot_grenade"))
	self:SetLayerPriority(gest,1)
	self:SetLayerPlaybackRate(gest,self.AnimationPlaybackRate *0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(15, 15, 78), Vector(-15, -15, 0))
	self.NextWeaponSwitchT = CurTime() + math.Rand(2,4)

	self:OnInit()

	for _,category in pairs(self.WeaponsList) do
		for _,wep in pairs(category) do
			self:Give(wep)
		end
	end

	self:DoChangeWeapon(VJ_PICK(self.WeaponsList["Normal"]),true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "body" then
		VJ_EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	local ent = self:GetEnemy()
	local dist = self.NearestPointToEnemyDistance
	if IsValid(ent) then
		local wep = self:GetActiveWeapon()
		if self.WeaponInventoryStatus == VJ_WEP_INVENTORY_MELEE then return end
		local selectType = false
		if dist > 2200 then
			selectType = "Far"
		elseif dist <= 2200 && dist > 650 then
			selectType = "Normal"
		else
			selectType = "Close"
		end

		if selectType != false && !self:IsBusy() && CurTime() > self.NextWeaponSwitchT && math.random(1,wep:Clip1() > 0 && (wep:Clip1() <= wep:GetMaxClip1() *0.35) && 1 or (selectType == "Close" && 20 or 150)) == 1 then
			self:DoChangeWeapon(VJ_PICK(self.WeaponsList[selectType]),true)
			wep = self:GetActiveWeapon()
			self.NextWeaponSwitchT = CurTime() + math.Rand(6,math.Round(math.Clamp(wep:Clip1() *0.5,1,wep:Clip1())))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetupWeaponHoldTypeAnims(h)
	local defIdleAim = ACT_IDLE -- ACT_IDLE_ANGRY
	local defWalkAim = ACT_WALK
	local defRunAim = ACT_RUN
	local defFire = ACT_RANGE_ATTACK1
	local defCrouch = ACT_RANGE_ATTACK1_LOW
	local defCrawl = ACT_RUN_CROUCH
	local defReload = ACT_RELOAD

	if self:GetActiveWeapon().HLR_HoldType then -- Allow for more than default hold types
		h = self:GetActiveWeapon().HLR_HoldType
	end

	if h == "crossbow" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_bow")
		defWalkAim = VJ_SequenceToActivity(self,"walk_bow")
		defRunAim = VJ_SequenceToActivity(self,"run_bow")
		defCrouch = VJ_SequenceToActivity(self,"crouch_bow")
		defCrawl = VJ_SequenceToActivity(self,"crawl_bow")
		defFire = "vjges_shoot_bow"
		defReload = "vjges_reload_bow"
	elseif h == "melee" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_crowbar")
		defWalkAim = VJ_SequenceToActivity(self,"walk_crowbar")
		defRunAim = VJ_SequenceToActivity(self,"run_crowbar")
		defCrouch = VJ_SequenceToActivity(self,"crouch_crowbar")
		defCrawl = VJ_SequenceToActivity(self,"crawl_crowbar")
		defFire = "vjges_shoot_crowbar"
		defReload = "vjges_reload_crowbar"
	elseif h == "ar2" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_gauss")
		defWalkAim = VJ_SequenceToActivity(self,"walk_gauss")
		defRunAim = VJ_SequenceToActivity(self,"run_gauss")
		defCrouch = VJ_SequenceToActivity(self,"crouch_gauss")
		defCrawl = VJ_SequenceToActivity(self,"crawl_gauss")
		defFire = "vjges_shoot_gauss"
		defReload = "vjges_reload_gauss"
	elseif h == "physgun" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_hive")
		defWalkAim = VJ_SequenceToActivity(self,"walk_hive")
		defRunAim = VJ_SequenceToActivity(self,"run_hive")
		defCrouch = VJ_SequenceToActivity(self,"crouch_hive")
		defCrawl = VJ_SequenceToActivity(self,"crawl_hive")
		defFire = "vjges_shoot_hive"
		defReload = "vjges_reload_hive"
	elseif h == "smg" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_mp5")
		defWalkAim = VJ_SequenceToActivity(self,"walk_mp5")
		defRunAim = VJ_SequenceToActivity(self,"run_mp5")
		defCrouch = VJ_SequenceToActivity(self,"crouch_mp5")
		defCrawl = VJ_SequenceToActivity(self,"crawl_mp5")
		defFire = "vjges_shoot_mp5"
		defReload = "vjges_reload_mp5"
	elseif h == "pistol" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_onehanded")
		defWalkAim = VJ_SequenceToActivity(self,"walk_onehanded")
		defRunAim = VJ_SequenceToActivity(self,"run_onehanded")
		defCrouch = VJ_SequenceToActivity(self,"crouch_onehanded")
		defCrawl = VJ_SequenceToActivity(self,"crawl_onehanded")
		defFire = "vjges_shoot_onehanded"
		defReload = "vjges_reload_onehanded"
	elseif h == "revolver" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_python")
		defWalkAim = VJ_SequenceToActivity(self,"walk_python")
		defRunAim = VJ_SequenceToActivity(self,"run_python")
		defCrouch = VJ_SequenceToActivity(self,"crouch_python")
		defCrawl = VJ_SequenceToActivity(self,"crawl_python")
		defFire = "vjges_shoot_python"
		defReload = "vjges_reload_python"
	elseif h == "rpg" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_rpg")
		defWalkAim = VJ_SequenceToActivity(self,"walk_rpg")
		defRunAim = VJ_SequenceToActivity(self,"run_rpg")
		defCrouch = VJ_SequenceToActivity(self,"crouch_rpg")
		defCrawl = VJ_SequenceToActivity(self,"crawl_rpg")
		defFire = "vjges_shoot_rpg"
		defReload = "vjges_reload_rpg"
	elseif h == "shotgun" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_shotgun")
		defWalkAim = VJ_SequenceToActivity(self,"walk_shotgun")
		defRunAim = VJ_SequenceToActivity(self,"run_shotgun")
		defCrouch = VJ_SequenceToActivity(self,"crouch_shotgun")
		defCrawl = VJ_SequenceToActivity(self,"crawl_shotgun")
		defFire = "vjges_shoot_shotgun"
		defReload = "vjges_reload_shotgun"
	elseif h == "slam" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_squeak")
		defWalkAim = VJ_SequenceToActivity(self,"walk_squeak")
		defRunAim = VJ_SequenceToActivity(self,"run_squeak")
		defCrouch = VJ_SequenceToActivity(self,"crouch_squeak")
		defCrawl = VJ_SequenceToActivity(self,"crawl_squeak")
		defFire = "vjges_shoot_squeak"
		defReload = "vjges_reload_squeak"
	elseif h == "slam" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_squeak")
		defWalkAim = VJ_SequenceToActivity(self,"walk_squeak")
		defRunAim = VJ_SequenceToActivity(self,"run_squeak")
		defCrouch = VJ_SequenceToActivity(self,"crouch_squeak")
		defCrawl = VJ_SequenceToActivity(self,"crawl_squeak")
		defFire = "vjges_shoot_squeak"
		defReload = "vjges_reload_squeak"
	elseif h == "saw" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_saw")
		defWalkAim = VJ_SequenceToActivity(self,"walk_saw")
		defRunAim = VJ_SequenceToActivity(self,"run_saw")
		defCrouch = VJ_SequenceToActivity(self,"crouch_saw")
		defCrawl = VJ_SequenceToActivity(self,"crawl_saw")
		defFire = "vjges_shoot_saw"
		defReload = "vjges_reload_saw"
	elseif h == "sniper" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_sniper")
		defWalkAim = VJ_SequenceToActivity(self,"walk_sniper")
		defRunAim = VJ_SequenceToActivity(self,"run_sniper")
		defCrouch = VJ_SequenceToActivity(self,"crouch_sniper")
		defCrawl = VJ_SequenceToActivity(self,"crawl_sniper")
		defFire = "vjges_shoot_sniper"
		defReload = "vjges_reload_sniper"
	elseif h == "m16" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_m16")
		defWalkAim = VJ_SequenceToActivity(self,"walk_m16")
		defRunAim = VJ_SequenceToActivity(self,"run_m16")
		defCrouch = VJ_SequenceToActivity(self,"crouch_m16")
		defCrawl = VJ_SequenceToActivity(self,"crawl_m16")
		defFire = "vjges_shoot_m16"
		defReload = "vjges_reload_m16"
	elseif h == "minigun" then
		defIdleAim = VJ_SequenceToActivity(self,"aim_minigun")
		defWalkAim = VJ_SequenceToActivity(self,"walk_minigun")
		defRunAim = VJ_SequenceToActivity(self,"run_minigun")
		defCrouch = VJ_SequenceToActivity(self,"crouch_minigun")
		defCrawl = VJ_SequenceToActivity(self,"crawl_minigun")
		defFire = "vjges_shoot_minigun"
		defReload = "vjges_reload_minigun"
	end

	self.WeaponAnimTranslations[ACT_IDLE] = defIdleAim
	self.WeaponAnimTranslations[ACT_IDLE_ANGRY] = defIdleAim
	self.WeaponAnimTranslations[ACT_WALK] = defWalkAim
	self.WeaponAnimTranslations[ACT_WALK_AIM] = defWalkAim
	self.WeaponAnimTranslations[ACT_RUN] = defRunAim
	self.WeaponAnimTranslations[ACT_RUN_AIM] = defRunAim
	self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] = defIdleAim
	self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] = defCrouch
	self.WeaponAnimTranslations[ACT_COVER_LOW] = defCrouch
	self.WeaponAnimTranslations[ACT_WALK_CROUCH] = defCrawl
	self.WeaponAnimTranslations[ACT_RUN_CROUCH] = defCrawl
	self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] = defFire
	self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK2] = defFire
	self.WeaponAnimTranslations[ACT_RELOAD] = defReload
	self.WeaponAnimTranslations[ACT_RELOAD_LOW] = defReload
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local effectBlood = EffectData()
		effectBlood:SetOrigin(self:GetPos() + self:OBBCenter())
		effectBlood:SetColor(VJ_Color2Byte(Color(130,19,10)))
		effectBlood:SetScale(120)
		util.Effect("VJ_Blood1",effectBlood)
		
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
local transDeath = {
	[HITGROUP_HEAD] = {ACT_DIE_HEADSHOT},
	--[HITGROUP_CHEST] = {ACT_DIEFORWARD,ACT_DIEBACKWARD},
	[HITGROUP_STOMACH] = {ACT_DIE_GUTSHOT},
}
--
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	self.AnimTbl_Death = transDeath[hitgroup] or {ACT_DIESIMPLE,ACT_DIEFORWARD,ACT_DIEBACKWARD}
	self:DropWeaponOnDeathCode(dmginfo, hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ_HLR_ApplyCorpseEffects(self, corpseEnt)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Walk()
	self.FootStepSoundLevel = 52
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnFootStepSound_Run()
	self.FootStepSoundLevel = 70
end
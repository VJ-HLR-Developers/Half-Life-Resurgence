AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/strooper.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 125
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_Blood_HL1_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_RACE_X"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.AnimTbl_WeaponReloadBehindCover = {ACT_RELOAD}
ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.AnimTbl_CustomWaitForEnemyToComeOut = {ACT_IDLE_ANGRY}
ENT.WaitForEnemyToComeOut = false
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {ACT_SPECIAL_ATTACK2} -- Grenade Attack Animations
ENT.Medic_SpawnPropOnHeal = false -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.NoWeapon_UseScaredBehavior = true -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.MoveRandomlyWhenShooting = false -- Should it move randomly when shooting?
ENT.HasShootWhileMoving = false
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL3} -- Animation used if the SNPC does the CallForBackUpOnDamage function
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL1} -- Call For Help Animations
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIE_GUTSHOT,ACT_DIE_HEADSHOT,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.AnimTbl_TakingCover = {ACT_CROUCHIDLE} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.AnimTbl_AlertFriendsOnDeath = {ACT_IDLE_ANGRY} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/player/boots1.wav","vj_hlr/hl1_npc/player/boots2.wav","vj_hlr/hl1_npc/player/boots3.wav","vj_hlr/hl1_npc/player/boots4.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(15, 15, 80), Vector(-15, -15, 0))
	self:SetBodygroup(1,0)
	self:Give("weapon_vj_hl_strooperwep")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "attack" then
		self:MeleeAttackCode()
	end
	if key == "rangeattack" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary(ShootPos,ShootDir)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:Health() <= (self:GetMaxHealth() / 2.2) then
		self.AnimTbl_Walk = {ACT_WALK_HURT}
		self.AnimTbl_Run = {ACT_RUN_HURT}
		self.AnimTbl_ShootWhileMovingWalk = {ACT_WALK_HURT}
		self.AnimTbl_ShootWhileMovingRun = {ACT_RUN_HURT}
	end
	self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK1}
	self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK2}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
	self:SetBodygroup(1,1)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
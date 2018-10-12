AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/opfor/hgrunt.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 90
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.CustomBlood_Decal = {"VJ_HL_RED"} -- Decals to spawn when it's damaged
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

//ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {ACT_SPECIAL_ATTACK2} -- Grenade Attack Animations

ENT.AnimTbl_Medic_GiveHealth = {ACT_SPECIAL_ATTACK2} -- Animations is plays when giving health to an ally
ENT.Medic_SpawnPropOnHeal = false -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.NoWeapon_UseScaredBehavior = false -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.MoveRandomlyWhenShooting = false -- Should it move randomly when shooting?
ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_Names = {pitch={"XR"},yaw={},roll={"ZR"}} -- Custom pose parameters to use, can put as many as needed
ENT.AnimTbl_ShootWhileMovingRun = {ACT_SPRINT} -- Animations it will play when shooting while running | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_ShootWhileMovingWalk = {ACT_SPRINT} -- Animations it will play when shooting while walking | NOTE: Weapon may translate the animation that they see fit!
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL3} -- Animation used if the SNPC does the CallForBackUpOnDamage function
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL1,ACT_SIGNAL2} -- Call For Help Animations
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIE_GUTSHOT,ACT_DIE_HEADSHOT,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = 5 -- Time until the SNPC spawns its corpse and gets removed
//ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed
ENT.AnimTbl_TakingCover = {ACT_CROUCHIDLE} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hl1/pl_step1.wav","vj_hl1/pl_step2.wav","vj_hl1/pl_step3.wav","vj_hl1/pl_step4.wav"}

-- Custom

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(15, 15, 80), Vector(-15, -15, 0))
	
	local randhead = math.random(0,7)
	self:SetBodygroup(1,randhead)
	if randhead == 5 then
		self.IsMedicSNPC = true
	end
	
	local randwep = math.random(1,4)
	if randwep == 1 or randwep == 2 then
		self:SetBodygroup(3,0)
	elseif randwep == 3 then
		self:SetBodygroup(3,1)
	elseif randwep == 4 then
		self:SetBodygroup(3,2)
	end
	
	-- Marminen hamar
	if self:GetBodygroup(3) == 0 then
		self:SetBodygroup(2,0) -- Barz zenk
	elseif self:GetBodygroup(3) == 1 then
		self:SetBodygroup(2,3) -- bonebakshen
	elseif self:GetBodygroup(3) == 2 then
		self:SetBodygroup(2,1) -- Medz reshesh
	end
	
	self:Give("weapon_vj_hl_hgruntwep")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "event_emit step" then
		self:FootStepSoundCode()
	end
	if key == "event_mattack" then
		self:MeleeAttackCode()
	end
	if key == "event_rattack mp5_fire" or key == "event_rattack shotgun_fire" or key == "event_rattack saw_fire" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary(ShootPos,ShootDir)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local bgroup = self:GetBodygroup(3)
	if bgroup == 0 then -- MP5
		self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
		self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
		self.Weapon_StartingAmmoAmount = 50
	elseif bgroup == 1 then -- Shotgun
		self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SHOTGUN}
		self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SHOTGUN_LOW}
		self.Weapon_StartingAmmoAmount = 8
	elseif bgroup == 2 then -- SAW
		self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_AR2}
		self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_AR2_LOW}
		self.Weapon_StartingAmmoAmount = 50
	end
end

-- Mawskeeto was here.

/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/hgrunt.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 90
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackModel = "models/vj_hlr/weapons/w_grenade.mdl" -- The model for the grenade entity
ENT.AnimTbl_GrenadeAttack = {ACT_SPECIAL_ATTACK2} -- Grenade Attack Animations
ENT.GrenadeAttackAttachment = "lhand" -- The attachment that the grenade will spawn at
ENT.TimeUntilGrenadeIsReleased = 1.3 -- Time until the grenade is released
ENT.NextThrowGrenadeTime1 = 10 -- Time until it runs the throw grenade code again | The first # in math.random
ENT.NextThrowGrenadeTime2 = 12 -- Time until it runs the throw grenade code again | The second # in math.random
ENT.ThrowGrenadeChance = 3 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.Medic_DisableAnimation = true -- if true, it will disable the animation code
ENT.Medic_SpawnPropOnHeal = false -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_TimeUntilHeal = 4 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.MoveRandomlyWhenShooting = false -- Should it move randomly when shooting?
//ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch poseparameters (X)
//ENT.PoseParameterLooking_Names = {pitch={"XR"},yaw={},roll={"ZR"}} -- Custom pose parameters to use, can put as many as needed
ENT.AnimTbl_ShootWhileMovingRun = {ACT_SPRINT} -- Animations it will play when shooting while running | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_ShootWhileMovingWalk = {ACT_SPRINT} -- Animations it will play when shooting while walking | NOTE: Weapon may translate the animation that they see fit!
ENT.CallForBackUpOnDamageAnimation = {ACT_SIGNAL3} -- Animation used if the SNPC does the CallForBackUpOnDamage function
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.AnimTbl_CallForHelp = {ACT_SIGNAL1} -- Call For Help Animations
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIE_GUTSHOT,ACT_DIE_HEADSHOT,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = 0.8 -- Time until the SNPC spawns its corpse and gets removed
ENT.AnimTbl_TakingCover = {ACT_CROUCHIDLE} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.AnimTbl_AlertFriendsOnDeath = {"vjseq_idle2"} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.DropWeaponOnDeathAttachment = "rhand" -- Which attachment should it use for the weapon's position
ENT.HasLostWeaponSightAnimation = true -- Set to true if you would like the SNPC to play a different animation when it has lost sight of the enemy and can't fire at it
ENT.AnimTbl_WeaponAttackSecondary = {ACT_SPECIAL_ATTACK1} -- Animations played when the SNPC fires a secondary weapon attack
ENT.WeaponAttackSecondaryTimeUntilFire = 0.9 -- The weapon uses this integer to set the time until the firing code is ran
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/hgrunt/gr_die1.wav","vj_hlr/hl1_npc/hgrunt/gr_die2.wav","vj_hlr/hl1_npc/hgrunt/gr_die3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/hgrunt/gr_pain1.wav","vj_hlr/hl1_npc/hgrunt/gr_pain2.wav","vj_hlr/hl1_npc/hgrunt/gr_pain3.wav","vj_hlr/hl1_npc/hgrunt/gr_pain4.wav","vj_hlr/hl1_npc/hgrunt/gr_pain5.wav"}

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Bip01 Head"
ENT.Controller_FirstPersonOffset = Vector(4,0,5)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

-- Custom
ENT.HECU_Type = 0
	-- 0 = HL1 Grunt
	-- 1 = OppF Grunt
	-- 2 = OppF Medic
	-- 3 = OppF Engineer
	-- 4 = Black Ops Assassin
	-- 5 = Robot Grunt
	-- 6 = Alpha HGrunt
	-- 7 = Human Sergeant
	-- 8 = CS:CZDS Terrorists
	-- 9 = CS:CZDS Counter-Terrorists
ENT.HECU_WepBG = 2 -- The bodygroup that the weapons are in (Ourish e amen modelneroun)
ENT.HECU_LastBodyGroup = 99
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	self.SoundTbl_Idle = {"vj_hlr/hl1_npc/hgrunt/gr_idle1.wav","vj_hlr/hl1_npc/hgrunt/gr_idle2.wav","vj_hlr/hl1_npc/hgrunt/gr_idle3.wav"}
	self.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/hgrunt/gr_question1.wav","vj_hlr/hl1_npc/hgrunt/gr_question2.wav","vj_hlr/hl1_npc/hgrunt/gr_question3.wav","vj_hlr/hl1_npc/hgrunt/gr_question4.wav","vj_hlr/hl1_npc/hgrunt/gr_question5.wav","vj_hlr/hl1_npc/hgrunt/gr_question6.wav","vj_hlr/hl1_npc/hgrunt/gr_question7.wav","vj_hlr/hl1_npc/hgrunt/gr_question8.wav","vj_hlr/hl1_npc/hgrunt/gr_question9.wav","vj_hlr/hl1_npc/hgrunt/gr_question10.wav","vj_hlr/hl1_npc/hgrunt/gr_question11.wav","vj_hlr/hl1_npc/hgrunt/gr_question12.wav","vj_hlr/hl1_npc/hgrunt/gr_check1.wav","vj_hlr/hl1_npc/hgrunt/gr_check2.wav","vj_hlr/hl1_npc/hgrunt/gr_check3.wav","vj_hlr/hl1_npc/hgrunt/gr_check4.wav","vj_hlr/hl1_npc/hgrunt/gr_check5.wav","vj_hlr/hl1_npc/hgrunt/gr_check6.wav","vj_hlr/hl1_npc/hgrunt/gr_check7.wav","vj_hlr/hl1_npc/hgrunt/gr_check8.wav",}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/hgrunt/gr_clear1.wav","vj_hlr/hl1_npc/hgrunt/gr_clear2.wav","vj_hlr/hl1_npc/hgrunt/gr_clear3.wav","vj_hlr/hl1_npc/hgrunt/gr_clear4.wav","vj_hlr/hl1_npc/hgrunt/gr_clear5.wav","vj_hlr/hl1_npc/hgrunt/gr_clear6.wav","vj_hlr/hl1_npc/hgrunt/gr_clear7.wav","vj_hlr/hl1_npc/hgrunt/gr_clear8.wav","vj_hlr/hl1_npc/hgrunt/gr_clear9.wav","vj_hlr/hl1_npc/hgrunt/gr_clear10.wav","vj_hlr/hl1_npc/hgrunt/gr_clear11.wav","vj_hlr/hl1_npc/hgrunt/gr_clear12.wav","vj_hlr/hl1_npc/hgrunt/gr_answer1.wav","vj_hlr/hl1_npc/hgrunt/gr_answer2.wav","vj_hlr/hl1_npc/hgrunt/gr_answer3.wav","vj_hlr/hl1_npc/hgrunt/gr_answer4.wav","vj_hlr/hl1_npc/hgrunt/gr_answer5.wav","vj_hlr/hl1_npc/hgrunt/gr_answer6.wav","vj_hlr/hl1_npc/hgrunt/gr_answer7.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/hgrunt/gr_taunt1.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt2.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt3.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt4.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt5.wav","vj_hlr/hl1_npc/hgrunt/gr_combat1.wav","vj_hlr/hl1_npc/hgrunt/gr_combat2.wav","vj_hlr/hl1_npc/hgrunt/gr_combat3.wav","vj_hlr/hl1_npc/hgrunt/gr_combat4.wav"}
	self.SoundTbl_OnReceiveOrder = {"vj_hlr/hl1_npc/hgrunt/gr_answer1.wav","vj_hlr/hl1_npc/hgrunt/gr_answer2.wav","vj_hlr/hl1_npc/hgrunt/gr_answer3.wav","vj_hlr/hl1_npc/hgrunt/gr_answer5.wav","vj_hlr/hl1_npc/hgrunt/gr_answer7.wav"}
	self.SoundTbl_Investigate = {"vj_hlr/hl1_npc/hgrunt/gr_investigate.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hl1_npc/hgrunt/gr_alert1.wav","vj_hlr/hl1_npc/hgrunt/gr_alert2.wav","vj_hlr/hl1_npc/hgrunt/gr_alert3.wav","vj_hlr/hl1_npc/hgrunt/gr_alert4.wav","vj_hlr/hl1_npc/hgrunt/gr_alert5.wav","vj_hlr/hl1_npc/hgrunt/gr_alert6.wav","vj_hlr/hl1_npc/hgrunt/gr_alert7.wav","vj_hlr/hl1_npc/hgrunt/gr_alert8.wav","vj_hlr/hl1_npc/hgrunt/gr_alert9.wav","vj_hlr/hl1_npc/hgrunt/gr_alert10.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/hgrunt/gr_taunt6.wav","vj_hlr/hl1_npc/hgrunt/gr_cover2.wav","vj_hlr/hl1_npc/hgrunt/gr_cover3.wav","vj_hlr/hl1_npc/hgrunt/gr_cover4.wav","vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
	self.SoundTbl_WeaponReload = {"vj_hlr/hl1_npc/hgrunt/gr_cover1.wav","vj_hlr/hl1_npc/hgrunt/gr_cover2.wav","vj_hlr/hl1_npc/hgrunt/gr_cover3.wav","vj_hlr/hl1_npc/hgrunt/gr_cover4.wav","vj_hlr/hl1_npc/hgrunt/gr_cover5.wav","vj_hlr/hl1_npc/hgrunt/gr_cover6.wav","vj_hlr/hl1_npc/hgrunt/gr_cover7.wav","vj_hlr/hl1_npc/hgrunt/gr_cover8.wav","vj_hlr/hl1_npc/hgrunt/gr_cover9.wav"}
	self.SoundTbl_GrenadeAttack = {"vj_hlr/hl1_npc/hgrunt/gr_throw1.wav","vj_hlr/hl1_npc/hgrunt/gr_throw2.wav","vj_hlr/hl1_npc/hgrunt/gr_throw3.wav","vj_hlr/hl1_npc/hgrunt/gr_throw4.wav"}
	self.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/hgrunt/gr_cover7.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert1.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert2.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert3.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert4.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert5.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert6.wav","vj_hlr/hl1_npc/hgrunt/gr_cover1.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/hgrunt/gr_allydeath.wav","vj_hlr/hl1_npc/hgrunt/gr_cover2.wav","vj_hlr/hl1_npc/hgrunt/gr_cover3.wav","vj_hlr/hl1_npc/hgrunt/gr_cover4.wav","vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
	
	if self.HECU_Type == 7 then
		self:SetBodygroup(1,0)
	else
		self:SetSkin(math.random(0,1))
	
		local randhead = math.random(0,3)
		self:SetBodygroup(1,randhead)
		if randhead == 1 then
			self:SetSkin(0) -- Jermag
		elseif randhead == 3 then
			self:SetSkin(1) -- Sev
		end
		
		local randwep = math.random(1,3)
		if randwep == 1 or randwep == 2 then
			self:SetBodygroup(2,0)
		elseif randwep == 3 then
			self:SetBodygroup(2,1)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(15, 15, 80), Vector(-15, -15, 0))
	
	if self:GetModel() == "models/vj_hlr/hl1/hgrunt.mdl" then // Already the default
		self.HECU_Type = 0
		self.HECU_WepBG = 2
	elseif self:GetModel() == "models/vj_hlr/opfor/hgrunt.mdl" then
		self.HECU_Type = 1
		self.HECU_WepBG = 3
	elseif self:GetModel() == "models/vj_hlr/opfor/hgrunt_medic.mdl" then
		self.HECU_Type = 2
		self.HECU_WepBG = 3
		self.AnimTbl_WeaponReload = {ACT_RELOAD_SMG1}
	elseif self:GetModel() == "models/vj_hlr/opfor/hgrunt_engineer.mdl" then
		self.HECU_Type = 3
		self.HECU_WepBG = 1
		self.AnimTbl_WeaponReload = {ACT_RELOAD_SMG1}
	elseif self:GetModel() == "models/vj_hlr/opfor/massn.mdl" then
		self.HECU_Type = 4
		self.HECU_WepBG = 2
	elseif self:GetModel() == "models/vj_hlr/hl1/rgrunt.mdl" or self:GetModel() == "models/vj_hlr/hl1/rgrunt_black.mdl" then
		self.HECU_Type = 5
		self.HECU_WepBG = 1
	elseif self:GetModel() == "models/vj_hlr/hla/hgrunt.mdl" then
		self.HECU_Type = 6
		self.HECU_WepBG = 1
		self.AnimTbl_Death = {ACT_DIESIMPLE,ACT_DIEFORWARD}
	elseif self:GetModel() == "models/vj_hlr/hl1/hassault.mdl" or self:GetModel() == "models/vj_hlr/hl_hd/hassault.mdl" then
		self.HECU_Type = 7
		self.HECU_WepBG = 1
		self.AnimTbl_Death = {ACT_DIESIMPLE,ACT_DIEBACKWARD,ACT_DIEVIOLENT}
	elseif self:GetModel() == "models/vj_hlr/czeror/gign.mdl" or self:GetModel() == "models/vj_hlr/czeror/arctic.mdl" then
		self.HECU_Type = 8
		self.HECU_WepBG = 2
	end
	
	self.HECU_NextMouthMove = CurTime()
	
	self:HECU_CustomOnInitialize()
	
	//self:Give("weapon_vj_hl_hgruntwep")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	if !self.SoundTbl_Breath[SoundFile] then
		self.HECU_NextMouthMove = CurTime() + SoundDuration(SoundFile)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	print(key)
	if key == "event_emit step" or key == "step" then
		self:FootStepSoundCode()
	end
	if key == "event_mattack" or key == "melee" then
		self:MeleeAttackCode()
	end
	if key == "event_rattack mp5_fire" or key == "event_rattack shotgun_fire" or key == "event_rattack saw_fire" or key == "event_rattack pistol_fire" or key == "shoot" or key == "colt_fire" or key == "fire" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary(ShootPos,ShootDir)
		end
	end
	
	-- OppF Engineer
	if key == "deagle_putout" then
		self:SetBodygroup(1,2)
	end
	if key == "torch_pull" then
		self:SetBodygroup(1,1)
	end
	if key == "torchlight_on" then
		ParticleEffectAttach("vj_hl_torch", PATTACH_POINT_FOLLOW, self, 5)
		VJ_EmitSound(self,"vj_hlr/hl1_npc/hgrunt_oppf/torch_light.wav",80)
	end
	if key == "torch_putout" then
		self:StopParticles()
		self:SetBodygroup(1,2)
	end
	if key == "deagle_pull" then
		self:SetBodygroup(1,0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnThink()
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:HECU_CustomOnThink()
	-- Veravorvadz kalel
	if self:Health() <= (self:GetMaxHealth() / 2.2) && self.HECU_Type != 6 && self.HECU_Type != 7 then
		self.AnimTbl_Walk = {ACT_WALK_HURT}
		self.AnimTbl_Run = {ACT_RUN_HURT}
		self.AnimTbl_ShootWhileMovingWalk = {ACT_WALK_HURT}
		self.AnimTbl_ShootWhileMovingRun = {ACT_RUN_HURT}
	else
		self.AnimTbl_Walk = {ACT_WALK}
		self.AnimTbl_Run = {ACT_RUN}
		self.AnimTbl_ShootWhileMovingWalk = {ACT_WALK}
		self.AnimTbl_ShootWhileMovingRun = {ACT_RUN}
	end
	
	local bgroup = self:GetBodygroup(self.HECU_WepBG)
	if self.HGrunt_LastBodyGroup != bgroup then
		self.HGrunt_LastBodyGroup = bgroup
		if self.HECU_Type == 0 then
			if bgroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
				self.Weapon_StartingAmmoAmount = 50
			elseif bgroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SHOTGUN}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SHOTGUN_LOW}
				self.Weapon_StartingAmmoAmount = 8
			end
		elseif self.HECU_Type == 1 then
			if bgroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
				self.Weapon_StartingAmmoAmount = 50
			elseif bgroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SHOTGUN}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SHOTGUN_LOW}
				self.Weapon_StartingAmmoAmount = 8
			elseif bgroup == 2 then -- SAW
				self:DoChangeWeapon("weapon_vj_hlrof_m249")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_AR2}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_AR2_LOW}
				self.Weapon_StartingAmmoAmount = 50
			end
		elseif self.HECU_Type == 2 then
			if bgroup == 0 then -- Desert Eagle
				self:DoChangeWeapon("weapon_vj_hlrof_desert_eagle")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_PISTOL}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_PISTOL_LOW}
				self.Weapon_StartingAmmoAmount = 7
			elseif bgroup == 1 then -- Glock 17
				self:DoChangeWeapon("weapon_vj_hlr1_glock17")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_PISTOL}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_PISTOL_LOW}
				self.Weapon_StartingAmmoAmount = 17
			end
		elseif self.HECU_Type == 3 then
			if bgroup == 0 then -- Desert Eagle
				self:DoChangeWeapon("weapon_vj_hlrof_desert_eagle")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_PISTOL}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_PISTOL_LOW}
				self.Weapon_StartingAmmoAmount = 7
			end
		elseif self.HECU_Type == 4 then
			if bgroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
				self.Weapon_StartingAmmoAmount = 50
			elseif bgroup == 1 then -- M-40A1
				self:DoChangeWeapon("weapon_vj_hlr1_m40a1")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_AR2}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_AR2_LOW}
				self.Weapon_StartingAmmoAmount = 5
			end
		elseif self.HECU_Type == 5 then
			if bgroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
				self.Weapon_StartingAmmoAmount = 50
			elseif bgroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SHOTGUN}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SHOTGUN_LOW}
				self.Weapon_StartingAmmoAmount = 5
			end
		elseif self.HECU_Type == 6 then
			if bgroup == 0 then -- Colt Carbine
				self:DoChangeWeapon("weapon_vj_hlr1a_coltcarbine")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1}
				self.Weapon_StartingAmmoAmount = 50
			end
		elseif self.HECU_Type == 7 then
			if bgroup == 0 then -- 20mm Cannon
				self:DoChangeWeapon("weapon_vj_hlr1_20mm")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_AR2}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_AR2}
			end
		elseif self.HECU_Type == 8 then
			if bgroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_csczds_mp5")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
				self.Weapon_StartingAmmoAmount = 30
			elseif bgroup == 1 then -- XM1014
				self:DoChangeWeapon("weapon_vj_csczds_xm1014")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SHOTGUN}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SHOTGUN_LOW}
				self.Weapon_StartingAmmoAmount = 7
			elseif bgroup == 2 then -- M72 LAW
				self:DoChangeWeapon("weapon_vj_csczds_law")
				self.AnimTbl_WeaponReload = {ACT_HL2MP_GESTURE_RELOAD_RPG}
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_RPG}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_RPG}
				self.AnimTbl_IdleStand = {ACT_IDLE_RPG}
				self.AnimTbl_Walk = {ACT_IDLE_RPG}
				self.AnimTbl_Run = {ACT_RUN_RPG}
				self.AnimTbl_LostWeaponSight = {ACT_IDLE_ANGRY_RPG}
				self.Weapon_StartingAmmoAmount = 1
			elseif bgroup == 3 then -- AWM
				self:DoChangeWeapon("weapon_vj_csczds_awm")
				self.AnimTbl_LostWeaponSight = {ACT_HL2MP_IDLE_AR2}
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_AR2}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_AR2_LOW}
				self.Weapon_StartingAmmoAmount = 10
			elseif bgroup == 4 then -- AK-47
				self:DoChangeWeapon("weapon_vj_csczds_ak47")
				self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
				self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
				self.Weapon_StartingAmmoAmount = 30
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(GrenadeEntity)
	GrenadeEntity.DecalTbl_DeathDecals = {"VJ_HLR_Scorch"}
	GrenadeEntity.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/grenade/grenade_hit1.wav","vj_hlr/hl1_weapon/grenade/grenade_hit2.wav","vj_hlr/hl1_weapon/grenade/grenade_hit3.wav"}
	GrenadeEntity.SoundTbl_OnRemove = {"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"}
	if self.HECU_Type == 8 then
		GrenadeEntity.SoundTbl_OnCollide = {"vj_hlr/czeror_weapon/he_bounce-1.wav"}
		GrenadeEntity.SoundTbl_OnRemove = {"vj_hlr/czeror_weapon/hegrenade-1.wav","vj_hlr/czeror_weapon/hegrenade-2.wav"}
	end
	GrenadeEntity.OnRemoveSoundLevel = 100
	
	function GrenadeEntity:CustomOnPhysicsCollide(data,phys)
		getvelocity = phys:GetVelocity()
		velocityspeed = getvelocity:Length()
		phys:SetVelocity(getvelocity * 0.5)
		
		if velocityspeed > 100 then -- If the grenade is going faster than 100, then play the touch sound
			self:OnCollideSoundCode()
		end
	end
	
	function GrenadeEntity:DeathEffects()
		spr = ents.Create("env_sprite")
		spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("GlowProxySize","2.0")
		spr:SetKeyValue("HDRColorScale","1.0")
		spr:SetKeyValue("renderfx","14")
		spr:SetKeyValue("rendermode","5")
		spr:SetKeyValue("renderamt","255")
		spr:SetKeyValue("disablereceiveshadows","0")
		spr:SetKeyValue("mindxlevel","0")
		spr:SetKeyValue("maxdxlevel","0")
		spr:SetKeyValue("framerate","15.0")
		spr:SetKeyValue("spawnflags","0")
		spr:SetKeyValue("scale","4")
		spr:SetPos(GrenadeEntity:GetPos() + Vector(0,0,90))
		spr:Spawn()
		spr:Fire("Kill","",0.9)
		timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
		
		light = ents.Create("light_dynamic")
		light:SetKeyValue("brightness", "4")
		light:SetKeyValue("distance", "300")
		light:SetLocalPos(GrenadeEntity:GetPos())
		light:SetLocalAngles( GrenadeEntity:GetAngles() )
		light:Fire("Color", "255 150 0")
		light:SetParent(GrenadeEntity)
		light:Spawn()
		light:Activate()
		light:Fire("TurnOn", "", 0)
		GrenadeEntity:DeleteOnRemove(light)
		util.ScreenShake(GrenadeEntity:GetPos(), 100, 200, 1, 2500)
		
		GrenadeEntity:SetLocalPos(Vector(GrenadeEntity:GetPos().x,GrenadeEntity:GetPos().y,GrenadeEntity:GetPos().z +4)) -- Because the entity is too close to the ground
		local tr = util.TraceLine({
		start = GrenadeEntity:GetPos(),
		endpos = GrenadeEntity:GetPos() - Vector(0, 0, 100),
		filter = GrenadeEntity })
		util.Decal(VJ_PICKRANDOMTABLE(GrenadeEntity.DecalTbl_DeathDecals),tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		
		GrenadeEntity:DoDamageCode()
		GrenadeEntity:SetDeathVariablesTrue(nil,nil,false)
		if self.HECU_Type == 8 then
			VJ_EmitSound(self,"vj_hlr/czeror_weapon/debris"..math.random(1,3)..".wav",80,math.random(100,100))
		else
			VJ_EmitSound(self,"vj_hlr/hl1_weapon/explosion/debris"..math.random(1,3)..".wav",80,math.random(100,100))
		end
		GrenadeEntity:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.HasDeathSounds = false
	if self.HECU_GasTankHit == true then
		util.BlastDamage(self,self,self:GetPos(),100,80)
		util.ScreenShake(self:GetPos(),100,200,1,500)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos()+Vector(0,0,32))
		util.Effect("Explosion",effectdata)
		util.Effect("HelicopterMegaBomb",effectdata)
		//ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil)
	end
	if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,60))})
		self.HasDeathAnimation = false
		return true,{DeathAnim=false,AllowCorpse=true}
	else
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
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
		if self.HECU_Type != 4 && self.HECU_Type != 8 then
			self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/gib_hgrunt.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,15))})
		end
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD then
		VJ_EmitSound(self,{"vj_hlr/fx/headshot1.wav","vj_hlr/fx/headshot2.wav","vj_hlr/fx/headshot3.wav"},75,math.random(100,100))
	elseif self.HECU_Type == 5 then
		VJ_EmitSound(self,"vj_hlr/hl1_weapon/explosion/debris3.wav",150,math.random(100,100))
		VJ_EmitSound(self,"vj_hlr/hl1_npc/rgrunt/rb_gib.wav",80,math.random(100,100))
	elseif self.HECU_Type == 8 then
		VJ_EmitSound(self,"vj_hlr/czeror_fx/bodysplat"..math.random(1,3)..".wav",100,math.random(100,100))
	else
		VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	-- Regular Human Grunt head gib
	if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD && dmginfo:GetDamageForce():Length() > 800 then
		self:SetBodygroup(1,4)
		self.GibOnDeathDamagesTable = {"All"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
	if self.HECU_Type == 6 or self.HECU_Type == 7 then
		self:SetBodygroup(self.HECU_WepBG,1)
	elseif self.HECU_Type == 0 or self.HECU_Type == 3 or self.HECU_Type == 4 then
		self:SetBodygroup(self.HECU_WepBG,2)
	elseif self.HECU_Type == 5 then
		self:SetBodygroup(self.HECU_WepBG,2)
		self:SetSkin(4)
	elseif self.HECU_Type == 1 or self.HECU_Type == 2 then
		self:SetBodygroup(self.HECU_WepBG,3)
	elseif self.HECU_Type == 8 then
		self:SetBodygroup(self.HECU_WepBG,9)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo,hitgroup,GetWeapon)
	GetWeapon.WorldModel_Invisible = false
	GetWeapon:SetNWBool("VJ_WorldModel_Invisible",false)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
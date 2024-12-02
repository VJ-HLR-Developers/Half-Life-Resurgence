AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/hgrunt.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 90
ENT.HullType = HULL_HUMAN
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(3, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasGrenadeAttack = true -- Should the NPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_hlr1_grenade" -- Entities that it can spawn when throwing a grenade | If set as a table, it picks a random entity | VJ: "obj_vj_grenade" | HL2: "npc_grenade_frag"
ENT.AnimTbl_GrenadeAttack = ACT_SPECIAL_ATTACK2
ENT.GrenadeAttackAttachment = "lhand" -- The attachment that the grenade will spawn at
ENT.TimeUntilGrenadeIsReleased = false -- Time until the grenade is released
ENT.NextThrowGrenadeTime = VJ.SET(10, 12) -- Time until it can throw a grenade again
ENT.GrenadeAttackChance = 3 -- 1 in x chance that it will throw a grenade when all the requirements are met | 1 = Throw it every time

ENT.Medic_DisableAnimation = true -- if true, it will disable the animation code
ENT.Medic_SpawnPropOnHeal = false -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_TimeUntilHeal = 4 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.Weapon_StrafeWhileFiring = false -- Should it move randomly while firing a weapon?
//ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch pose parameters (X)
//ENT.PoseParameterLooking_Names = {pitch={"XR"},yaw={},roll={"ZR"}} -- Custom pose parameters to use, can put as many as needed
ENT.CallForBackUpOnDamageAnimation = ACT_SIGNAL3 -- Animations played when it calls for help on damage
ENT.AnimTbl_CallForHelp = ACT_SIGNAL1
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIE_GUTSHOT, ACT_DIE_HEADSHOT, ACT_DIESIMPLE}
//ENT.DeathAnimationTime = 0.8 -- How long should the death animation play?
ENT.AnimTbl_TakingCover = ACT_CROUCHIDLE -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.AnimTbl_WeaponAttackSecondary = ACT_SPECIAL_ATTACK1 -- Animation(s) to play while firing the weapon's secondary attack
ENT.WeaponAttackSecondaryTimeUntilFire = 0.7
ENT.AnimTbl_WeaponReload = ACT_RELOAD_SMG1 -- Animations that play when the SNPC reloads
ENT.CanTurnWhileMoving = false -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/hgrunt/gr_die1.wav","vj_hlr/hl1_npc/hgrunt/gr_die2.wav","vj_hlr/hl1_npc/hgrunt/gr_die3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/hgrunt/gr_pain1.wav","vj_hlr/hl1_npc/hgrunt/gr_pain2.wav","vj_hlr/hl1_npc/hgrunt/gr_pain3.wav","vj_hlr/hl1_npc/hgrunt/gr_pain4.wav","vj_hlr/hl1_npc/hgrunt/gr_pain5.wav"}

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
	-- 8 = Soviet Grunt (Crack-Life Resurgence)
ENT.HECU_WepBG = 2 -- The bodygroup that the weapons are in (Ourish e amen modelneroun)
ENT.HECU_LastBodyGroup = 99
ENT.HECU_UsingDefaultSounds = false -- Set automatically, if true then it's using the default HECU sounds
ENT.HECU_CanHurtWalk = true -- Set to false to disable hurt-walking | Auto disabled for some of the HECU types!
ENT.HECU_Rappelling = false
ENT.HECU_DeployedByOsprey = false
ENT.HECU_CanUseGuardAnim = true -- Set to false to disable the guard animation when it's set to guard
ENT.HECU_SwitchedIdle = false
ENT.HECU_NextMouthMove = 0
ENT.HECU_NextMouthDistance = 0

local defPos = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_hgrunt" then
		self.Model = "models/vj_hlr/hl_hd/hgrunt.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	self.HECU_UsingDefaultSounds = true
	self.SoundTbl_Idle = {"vj_hlr/hl1_npc/hgrunt/gr_alert1.wav", "vj_hlr/hl1_npc/hgrunt/gr_idle1.wav", "vj_hlr/hl1_npc/hgrunt/gr_idle2.wav", "vj_hlr/hl1_npc/hgrunt/gr_idle3.wav"}
	self.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/hgrunt/gr_question1.wav", "vj_hlr/hl1_npc/hgrunt/gr_question2.wav", "vj_hlr/hl1_npc/hgrunt/gr_question3.wav", "vj_hlr/hl1_npc/hgrunt/gr_question4.wav", "vj_hlr/hl1_npc/hgrunt/gr_question5.wav", "vj_hlr/hl1_npc/hgrunt/gr_question6.wav", "vj_hlr/hl1_npc/hgrunt/gr_question7.wav", "vj_hlr/hl1_npc/hgrunt/gr_question8.wav", "vj_hlr/hl1_npc/hgrunt/gr_question9.wav", "vj_hlr/hl1_npc/hgrunt/gr_question10.wav", "vj_hlr/hl1_npc/hgrunt/gr_question11.wav", "vj_hlr/hl1_npc/hgrunt/gr_question12.wav", "vj_hlr/hl1_npc/hgrunt/gr_check1.wav", "vj_hlr/hl1_npc/hgrunt/gr_check2.wav", "vj_hlr/hl1_npc/hgrunt/gr_check3.wav", "vj_hlr/hl1_npc/hgrunt/gr_check4.wav", "vj_hlr/hl1_npc/hgrunt/gr_check5.wav", "vj_hlr/hl1_npc/hgrunt/gr_check6.wav", "vj_hlr/hl1_npc/hgrunt/gr_check7.wav", "vj_hlr/hl1_npc/hgrunt/gr_check8.wav", }
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/hgrunt/gr_clear1.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear2.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear3.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear4.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear5.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear6.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear7.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear8.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear9.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear10.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear11.wav", "vj_hlr/hl1_npc/hgrunt/gr_clear12.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer1.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer2.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer3.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer4.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer5.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer6.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer7.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/hgrunt/gr_taunt1.wav", "vj_hlr/hl1_npc/hgrunt/gr_taunt2.wav", "vj_hlr/hl1_npc/hgrunt/gr_taunt3.wav", "vj_hlr/hl1_npc/hgrunt/gr_taunt4.wav", "vj_hlr/hl1_npc/hgrunt/gr_taunt5.wav", "vj_hlr/hl1_npc/hgrunt/gr_combat1.wav", "vj_hlr/hl1_npc/hgrunt/gr_combat2.wav", "vj_hlr/hl1_npc/hgrunt/gr_combat3.wav", "vj_hlr/hl1_npc/hgrunt/gr_combat4.wav"}
	self.SoundTbl_OnReceiveOrder = {"vj_hlr/hl1_npc/hgrunt/gr_answer1.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer2.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer3.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer5.wav", "vj_hlr/hl1_npc/hgrunt/gr_answer7.wav"}
	self.SoundTbl_Investigate = {"vj_hlr/hl1_npc/hgrunt/gr_investigate.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hl1_npc/hgrunt/gr_alert3.wav", "vj_hlr/hl1_npc/hgrunt/gr_alert4.wav", "vj_hlr/hl1_npc/hgrunt/gr_alert6.wav", "vj_hlr/hl1_npc/hgrunt/gr_alert7.wav", "vj_hlr/hl1_npc/hgrunt/gr_alert8.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/hgrunt/gr_taunt6.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover2.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover3.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover4.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
	self.SoundTbl_WeaponReload = {"vj_hlr/hl1_npc/hgrunt/gr_cover1.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover2.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover3.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover4.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover5.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover6.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover7.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover8.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover9.wav"}
	self.SoundTbl_GrenadeAttack = {"vj_hlr/hl1_npc/hgrunt/gr_throw1.wav", "vj_hlr/hl1_npc/hgrunt/gr_throw2.wav", "vj_hlr/hl1_npc/hgrunt/gr_throw3.wav", "vj_hlr/hl1_npc/hgrunt/gr_throw4.wav"}
	self.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/hgrunt/gr_cover1.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover7.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert1.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert2.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert3.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert4.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert5.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert6.wav"}
	self.SoundTbl_OnDangerSight = {"vj_hlr/hl1_npc/hgrunt/gr_cover1.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover7.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert2.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert3.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert4.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert5.wav", "vj_hlr/hl1_npc/hgrunt/gr_grenadealert6.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/hgrunt/gr_allydeath.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover2.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover3.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover4.wav", "vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
	
	if self.HECU_Type == 7 then
		self:SetBodygroup(1, 0)
	else
		self:SetSkin(math.random(0, 1))
	
		local randHead = math.random(0, 3)
		self:SetBodygroup(1, randHead)
		if randHead == 1 then
			self:SetSkin(0) -- Jermag
		elseif randHead == 3 then
			self:SetSkin(1) -- Sev
		end
		
		if randHead == 2 then
			self:SetBodygroup(2, 1)
		else
			self:SetBodygroup(2, 0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(15, 15, 78), Vector(-15, -15, 0))
	
	local myMDL = self:GetModel()
	if myMDL == "models/vj_hlr/hl1/hgrunt.mdl" then // Already the default
		self.HECU_Type = 0
		self.HECU_WepBG = 2
	elseif myMDL == "models/vj_hlr/opfor/hgrunt.mdl" then
		self.HECU_Type = 1
		self.HECU_WepBG = 3
	elseif myMDL == "models/vj_hlr/opfor/hgrunt_medic.mdl" then
		self.HECU_Type = 2
		self.HECU_WepBG = 3
		self.AnimTbl_WeaponReload = ACT_RELOAD_SMG1
	elseif myMDL == "models/vj_hlr/opfor/hgrunt_engineer.mdl" then
		self.HECU_Type = 3
		self.HECU_WepBG = 1
		self.AnimTbl_WeaponReload = ACT_RELOAD_SMG1
	elseif myMDL == "models/vj_hlr/opfor/massn.mdl" then
		self.HECU_Type = 4
		self.HECU_WepBG = 2
	elseif myMDL == "models/vj_hlr/hl1/rgrunt.mdl" or myMDL == "models/vj_hlr/hl1/rgrunt_black.mdl" or myMDL == "models/vj_hlr/hl_hd/rgrunt.mdl" then
		self.HECU_Type = 5
		self.HECU_WepBG = 1
	elseif myMDL == "models/vj_hlr/hla/hgrunt.mdl" then
		self.HECU_Type = 6
		self.HECU_WepBG = 1
		self.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD}
		self.HECU_CanHurtWalk = false
		self.HECU_CanUseGuardAnim = false
	elseif myMDL == "models/vj_hlr/hl1/hassault.mdl" or myMDL == "models/vj_hlr/hl_hd/hassault.mdl" or myMDL == "models/vj_hlr/hla/hassault.mdl" then
		self.HECU_Type = 7
		self.HECU_WepBG = 1
		-- Alpha version has more death animations
		if myMDL == "models/vj_hlr/hla/hassault.mdl" then
			self.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEVIOLENT, ACT_DIEFORWARD}
		else
			self.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEVIOLENT}
		end
		self.HECU_CanHurtWalk = false
		self.HECU_CanUseGuardAnim = false
	elseif myMDL == "models/vj_hlr/cracklife/hgrunt.mdl" then
		self.HECU_Type = 8
		self.HECU_WepBG = 1
	elseif myMDL == "models/vj_hlr/hl_hd/hgrunt.mdl" then
		self.HECU_Type = 9
		self.HECU_WepBG = 2
	end
	
	self.HECU_NextMouthMove = CurTime()
	
	self:HECU_OnInit()
	
	if self.HECU_Rappelling then
		self:SetGroundEntity(NULL)
		self:AddFlags(FL_FLY)
		self:SetNavType(NAV_FLY)
		self:SetState(VJ_STATE_ONLY_ANIMATION)
		self.HasGrenadeAttack = false
		self.CanUseSecondaryOnWeaponAttack = false
		self.Weapon_CanReload = false
		timer.Simple(0.1, function() if IsValid(self) then self:VJ_ACT_PLAYACTIVITY("repel_jump", true, false, false) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if !self.SoundTbl_Breath[sdFile] then
		self.HECU_NextMouthMove = CurTime() + SoundDuration(sdFile)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "melee" then
		self:MeleeAttackCode()
	elseif key == "throwgrenade" then
		timer.Adjust("timer_grenade_start"..self:EntIndex(), 0)
	elseif key == "shoot" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	-- elseif key == "shootgrenade" then -- Event-based secondary attack
	-- 	local wep = self:GetActiveWeapon()
	-- 	if IsValid(wep) then
	-- 		wep:NPC_SecondaryFire()
	-- 	end
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)

	-- OppF Engineer --
	elseif key == "deagle_putout" then
		self:SetBodygroup(1, 2)
	elseif key == "torch_pull" then
		self:SetBodygroup(1, 1)
	elseif key == "torchlight_on" then
		ParticleEffectAttach("vj_hl_torch", PATTACH_POINT_FOLLOW, self, 5)
		VJ.EmitSound(self, "vj_hlr/hl1_npc/hgrunt_oppf/torch_light.wav", 80)
	elseif key == "torch_putout" then
		self:StopParticles()
		self:SetBodygroup(1, 2)
	elseif key == "deagle_pull" then
		self:SetBodygroup(1, 0)
	
	-- OppF Medic --
	elseif key == "putgun" then
		self:SetBodygroup(3, 3)
	elseif key == "pullneedle" then
		self:SetBodygroup(3, 2)
	elseif key == "putneedle" then
		self:SetBodygroup(3, 3)
	elseif key == "pullgun" then
		self:SetBodygroup(3, self.HECUMedic_HealBG)
	
	-- Alpha HGrunt --
	elseif key == "i_got_something_for_you" then -- Make them play a sound when firing a weapon secondary shot
		self:PlaySoundSystem("GeneralSpeech", "vj_hlr/hla_npc/hgrunt/gr_loadtalk.wav")
		
	-- Alpha Sergeant --
	elseif key == "holster_gun" && self.Serg_Type != 2 then
		self:SetWeaponState(VJ.NPC_WEP_STATE_HOLSTERED)
		self:SetBodygroup(1, 1)
	elseif key == "draw_gun" && self.Serg_Type != 2 then
		self:SetWeaponState()
		self:SetBodygroup(1, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdAlertAlien = {"vj_hlr/hl1_npc/hgrunt/gr_alert9.wav", "vj_hlr/hl1_npc/hgrunt/gr_alert10.wav"}
local sdAlertSoldier = {"vj_hlr/hl1_npc/hgrunt/gr_alert2.wav", "vj_hlr/hl1_npc/hgrunt/gr_alert5.wav"}
--
function ENT:OnAlert(ent)
	if math.random(1, 3) == 1 && self.HECU_UsingDefaultSounds == true then
		if ent.IsVJBaseSNPC_Creature == true then -- Alien sounds
			self:PlaySoundSystem("Alert", sdAlertAlien)
			return
		elseif ent.IsVJBaseSNPC_Human == true or ent:IsPlayer() then -- Soldier sounds
			self:PlaySoundSystem("Alert", sdAlertSoldier)
			return
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- Hurt Walking
	if self.HECU_CanHurtWalk then
		if act == ACT_WALK then
			if self:Health() <= (self:GetMaxHealth() / 2.2) then
				return ACT_WALK_HURT
			end
		elseif act == ACT_RUN then
			if self:Health() <= (self:GetMaxHealth() / 2.2) then
				return ACT_RUN_HURT
			end
		elseif act == ACT_WALK_AIM then
			if self:Health() <= (self:GetMaxHealth() / 2.2) then
				return ACT_WALK_HURT
			end
			return ACT_SPRINT
		elseif act == ACT_RUN_AIM then
			if self:Health() <= (self:GetMaxHealth() / 2.2) then
				return ACT_RUN_HURT
			end
			return ACT_SPRINT
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
	local bodyGroup = self.HGrunt_LastBodyGroup
	
	self.AnimationTranslations[ACT_IDLE] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_repel") or ACT_IDLE
	self.AnimationTranslations[ACT_IDLE_ANGRY] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_repel") or ACT_IDLE_ANGRY
	
	if self.HECU_Type == 0 or self.HECU_Type == 9 then-- 0 = HL1 Grunt
		if bodyGroup == 0 then -- MP5
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_mp5") or ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_mp5") or ACT_RANGE_ATTACK_SMG1_LOW
		elseif bodyGroup == 1 then -- Shotgun
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_shotty") or ACT_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_shotty") or ACT_RANGE_ATTACK_SHOTGUN_LOW
		end
	elseif self.HECU_Type == 1 then -- 1 = OppF Grunt
		if bodyGroup == 0 then -- MP5
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_SMG1_LOW
		elseif bodyGroup == 1 then -- Shotgun
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_SHOTGUN_LOW
		elseif bodyGroup == 2 then -- SAW
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_AR2_LOW
		end
	elseif self.HECU_Type == 2 then -- 2 = OppF Medic
		if bodyGroup == 0 or bodyGroup == 1 then -- Desert Eagle or Glock 17
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_PISTOL_LOW
		end
	elseif self.HECU_Type == 3 then -- 3 = OppF Engineer
		if bodyGroup == 0 then -- Desert Eagle
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_PISTOL
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_PISTOL_LOW
		end
	elseif self.HECU_Type == 4 then -- 4 = Black Ops Assassin
		if bodyGroup == 0 then -- MP5
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_mp5") or ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_mp5") or ACT_RANGE_ATTACK_SMG1_LOW
		elseif bodyGroup == 1 then -- M-40A1
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_AR2_LOW
		end
	elseif self.HECU_Type == 5 then -- 5 = Robot Grunt
		if bodyGroup == 0 then -- MP5
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_mp5") or ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_mp5") or ACT_RANGE_ATTACK_SMG1_LOW
		elseif bodyGroup == 1 then -- Shotgun
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_shotty") or ACT_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = self.HECU_Rappelling and VJ.SequenceToActivity(self, "repel_shoot_shotty") or ACT_RANGE_ATTACK_SHOTGUN_LOW
		end
	elseif self.HECU_Type == 6 then -- 6 = Alpha HGrunt
		if bodyGroup == 0 then -- Colt Carbine
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_SMG1
		end
	elseif self.HECU_Type == 7 then -- 7 = Human Sergeant
		if bodyGroup == 0 then -- 20mm Cannon
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_AR2
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_AR2
		end
	elseif self.HECU_Type == 8 then -- 8 = Soviet Grunt (Crack-Life Resurgence)
		if bodyGroup == 0 then -- MP5
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_SMG1
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_SMG1_LOW
		elseif bodyGroup == 1 then -- Shotgun
			self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_SHOTGUN
			self.AnimationTranslations[ACT_RANGE_ATTACK1_LOW] = ACT_RANGE_ATTACK_SHOTGUN_LOW
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_StopRappelling()
	self.HECU_Rappelling = false
	self.HasGrenadeAttack = true
	self.CanUseSecondaryOnWeaponAttack = true
	self.Weapon_CanReload = true
	self:SetVelocity(defPos)
	self:SetState()
	self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
	self:SetAnimationTranslations()
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Used for custom HECU soldiers
function ENT:HECU_OnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Mouth movement
	if CurTime() < self.HECU_NextMouthMove then
		if self.HECU_NextMouthDistance == 0 then
			self.HECU_NextMouthDistance = math.random(10, 70)
		else
			self.HECU_NextMouthDistance = 0
		end
		self:SetPoseParameter("m", self.HECU_NextMouthDistance)
	else
		self:SetPoseParameter("m", 0)
	end

	-- Handle weapon body group changing
	local bodyGroup = self:GetBodygroup(self.HECU_WepBG)
	if self.HGrunt_LastBodyGroup != bodyGroup then
		self.HGrunt_LastBodyGroup = bodyGroup
		if self.HECU_Type == 0 then -- 0 = HL1 Grunt
			if bodyGroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
			elseif bodyGroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 1 then -- 1 = OppF Grunt
			if bodyGroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
			elseif bodyGroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12")
			elseif bodyGroup == 2 then -- SAW
				self:DoChangeWeapon("weapon_vj_hlrof_m249")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 2 then -- 2 = OppF Medic
			if bodyGroup == 0 then -- Desert Eagle
				self:DoChangeWeapon("weapon_vj_hlrof_desert_eagle")
			elseif bodyGroup == 1 then -- Glock 17
				self:DoChangeWeapon("weapon_vj_hlr1_glock17")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 3 then -- 3 = OppF Engineer
			if bodyGroup == 0 then -- Desert Eagle
				self:DoChangeWeapon("weapon_vj_hlrof_desert_eagle")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 4 then -- 4 = Black Ops Assassin
			if bodyGroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
			elseif bodyGroup == 1 then -- M-40A1
				self:DoChangeWeapon("weapon_vj_hlr1_m40a1")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 5 then -- 5 = Robot Grunt
			if bodyGroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
				if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_rgrunt" then
					self:DoChangeWeapon("weapon_vj_hlr1_m4_hd")
				end
			elseif bodyGroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12")
				if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_rgrunt" then
					self:DoChangeWeapon("weapon_vj_hlr1_spas12_hd")
				end
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 6 then -- 6 = Alpha HGrunt
			if bodyGroup == 0 then -- Colt Carbine
				self:DoChangeWeapon("weapon_vj_hlr1a_coltcarbine")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 7 then -- 7 = Human Sergeant
			if bodyGroup == 0 then -- 20mm Cannon
				self:DoChangeWeapon("weapon_vj_hlr1_20mm")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 8 then -- 8 = Soviet Grunt (Crack-Life Resurgence)
			if bodyGroup == 0 then -- MP5
				self:DoChangeWeapon("weapon_vj_hlr1_mp5")
			elseif bodyGroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		elseif self.HECU_Type == 9 then -- 0 = HL1 HD Grunt
			if bodyGroup == 0 then -- M4
				self:DoChangeWeapon("weapon_vj_hlr1_m4_hd")
			elseif bodyGroup == 1 then -- Shotgun
				self:DoChangeWeapon("weapon_vj_hlr1_spas12_hd")
			elseif IsValid(self:GetActiveWeapon()) then
				self:GetActiveWeapon():Remove()
			end
		end
	end
	
	-- Rappelling System
	if self.HECU_Rappelling && !self.Dead then
		-- If it's on ground then stop rappelling!
		if self:IsOnGround() then
			self:HECU_StopRappelling()
			self:VJ_ACT_PLAYACTIVITY("repel_land", true, false, false)
			-- Let the Osprey know I landed!
			if self.HECU_DeployedByOsprey then
				local owner = self:GetOwner()
				if IsValid(owner) then
					owner.Osprey_DropSoldierStatus = owner.Osprey_DropSoldierStatus + 1
				end
			end
		-- If it was deployed by an Osprey and the Osprey no longer exists, then stop rappelling!
		elseif self.HECU_DeployedByOsprey && !IsValid(self:GetOwner()) then
			self:HECU_StopRappelling()
		-- I am still rappelling...
		else
			return
		end
	end
	self:HECU_OnThink()
	
	-- For guarding
	/*if self.HECU_CanUseGuardAnim then
		if self.IsGuard == true && !self.HECU_Rappelling && !IsValid(self:GetEnemy()) then
			if self.HECU_SwitchedIdle == false then
				self.HECU_SwitchedIdle = true
				self.AnimTbl_IdleStand = {ACT_GET_DOWN_STAND}
			end
		elseif self.HECU_SwitchedIdle == true then
			self.HECU_SwitchedIdle = false
			self.AnimTbl_IdleStand = {ACT_IDLE}
		end
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gasTankExpPos = Vector(0, 0, 90)
local gasTankExpSd = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	-- Handle gas tank for the hgrunt engineer
	if self.HECU_GasTankHit == true then
		util.BlastDamage(self, self, self:GetPos(), 100, 80)
		util.ScreenShake(self:GetPos(), 100, 200, 1, 500)
		VJ.EmitSound(self, gasTankExpSd, 90)
		VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3,5).."_dist.wav", 140, 100)
		local spr = ents.Create("env_sprite")
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
		spr:SetPos(self:GetPos() + gasTankExpPos)
		spr:Spawn()
		spr:Fire("Kill","",0.9)
		timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
	end
	if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,0,60))})
		self.HasDeathAnimation = false
		return true, {DeathAnim=false, AllowCorpse=true}
	else
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
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,40))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,1,40))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1,0,40))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,2,40))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_bone.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,50))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_gib.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1,1,40))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_guts.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(2,1,40))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_hmeat.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,1,45))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_lung.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,45))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_skull.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,60))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_legbone.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,1,15))})
		if self.HECU_Type != 4 then -- Not  Black Ops
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/gib_hgrunt.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,0,15))})
		end
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local sdHeadshot = {"vj_hlr/fx/headshot1.wav","vj_hlr/fx/headshot2.wav","vj_hlr/fx/headshot3.wav"}
--
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD then
		VJ.EmitSound(self, sdHeadshot, 75, 100)
	elseif self.HECU_Type == 5 then
		VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 100, 100)
		VJ.EmitSound(self, "vj_hlr/hl1_npc/rgrunt/rb_gib.wav", 80, 100)
	else
		VJ.EmitSound(self, "vj_base/gib/splat.wav", 90, 100)
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		-- Regular Human Grunt head gib
		if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD && dmginfo:GetDamageForce():Length() > 800 then
			self:SetBodygroup(1, 4)
			self.GibOnDeathDamagesTable = {"All"}
		end
		
		if self.HECU_Type == 5 then
			local spr = ents.Create("env_sprite")
			spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
			spr:SetKeyValue("GlowProxySize","2.0")
			spr:SetKeyValue("HDRColorScale","1.0")
			spr:SetKeyValue("renderfx","14")
			spr:SetKeyValue("rendermode","5")
			spr:SetKeyValue("renderamt","255")
			spr:SetKeyValue("disablereceiveshadows","0")
			spr:SetKeyValue("mindxlevel","0")
			spr:SetKeyValue("maxdxlevel","0")
			spr:SetKeyValue("framerate","20.0")
			spr:SetKeyValue("spawnflags","0")
			spr:SetKeyValue("scale","1.5")
			spr:SetPos(self:GetPos() + self:GetUp()*60)
			spr:Spawn()
			spr:Fire("Kill","",0.7)
			timer.Simple(0.7, function() if IsValid(spr) then spr:Remove() end end)
		end
		
		-- If we are still rappelling then play the rappel death animation!
		if self.HECU_Rappelling then
			self.AnimTbl_Death = "repel_die"
		else
			-- Make the alpha sergeant fly back when its a heavy damage
			if self.HECU_Type == 7 && dmginfo:GetDamage() > 30 && self:GetModel() == "models/vj_hlr/hla/hassault.mdl" then
				self.AnimTbl_Death = ACT_DIEBACKWARD
			end
		end
	elseif status == "DeathAnim" then
		self:DeathWeaponDrop(dmginfo, hitgroup)
		self:OnDeath(dmginfo, hitgroup, "Finish")
		local activeWep = self:GetActiveWeapon()
		if IsValid(activeWep) then activeWep:Remove() end
	elseif status == "Finish" then
		-- Remove the weapon body groups and other objects
		if self.HECU_Type == 6 or self.HECU_Type == 7 then
			self:SetBodygroup(self.HECU_WepBG, 1)
		elseif self.HECU_Type == 0 or self.HECU_Type == 3 or self.HECU_Type == 4 or self.HECU_Type == 9 then
			self:SetBodygroup(self.HECU_WepBG, 2)
		elseif self.HECU_Type == 5 then
			self:SetBodygroup(self.HECU_WepBG, 2)
			self:SetSkin(4)
		elseif self.HECU_Type == 1 or self.HECU_Type == 2 then
			self:SetBodygroup(self.HECU_WepBG, 3)
		elseif self.HECU_Type == 8 then
			self:SetBodygroup(self.HECU_WepBG, 2)
		elseif self.HECU_Type == 2 then
			self:SetBodygroup(2, 3)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = self.HECU_Type != 4 and {"models/vj_hlr/gibs/gib_hgrunt.mdl"} or nil})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeathWeaponDrop(dmginfo, hitgroup, wepEnt)
	wepEnt.WorldModel_Invisible = false
	wepEnt:SetNW2Bool("VJ_WorldModel_Invisible", false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	-- Make sure to let the Osprey know I have died ='(
	if self.HECU_DeployedByOsprey then
		local owner = self:GetOwner()
		if IsValid(owner) then
			owner.Osprey_DropSoldierStatus = owner.Osprey_DropSoldierStatus + 1
			owner.Osprey_DropSoldierStatusDead = owner.Osprey_DropSoldierStatusDead + 1
		end
	end
end
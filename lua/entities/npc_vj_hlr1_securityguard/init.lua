AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/barney.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 90
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.MoveRandomlyWhenShooting = false -- Should it move randomly when shooting?
ENT.HasCallForHelpAnimation = false -- if true, it will play the call for help animation
ENT.AnimTbl_ShootWhileMovingRun = {ACT_RUN} -- Animations it will play when shooting while running | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_ShootWhileMovingWalk = {ACT_RUN} -- Animations it will play when shooting while walking | NOTE: Weapon may translate the animation that they see fit!
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_TakingCover = {ACT_CROUCHIDLE} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.AnimTbl_AlertFriendsOnDeath = {"vjseq_idle2"} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.HasLostWeaponSightAnimation = true -- Set to true if you would like the SNPC to play a different animation when it has lost sight of the enemy and can't fire at it
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.HasItemDropsOnDeath = false -- Should it drop items on death?
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
ENT.HasHitGroupFlinching = true -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}},{HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}},{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}

/*
-- Can't follow
vj_hlr/hl1_npc/barney/ba_stop0.wav
vj_hlr/hl1_npc/barney/ba_stop1.wav
vj_hlr/hl1_npc/barney/stop1.wav
vj_hlr/hl1_npc/barney/stophere.wav

vj_hlr/hl1_npc/barney/ba_internet.wav
vj_hlr/hl1_npc/barney/ba_attacking0.wav
vj_hlr/hl1_npc/barney/ba_attacking2.wav
vj_hlr/hl1_npc/barney/ba_becareful0.wav
vj_hlr/hl1_npc/barney/ba_button0.wav
vj_hlr/hl1_npc/barney/ba_button1.wav
vj_hlr/hl1_npc/barney/ba_canal_death1.wav
vj_hlr/hl1_npc/barney/ba_canal_wound1.wav
vj_hlr/hl1_npc/barney/ba_cure0.wav
vj_hlr/hl1_npc/barney/ba_cure1.wav
vj_hlr/hl1_npc/barney/ba_docprotect0.wav
vj_hlr/hl1_npc/barney/ba_docprotect1.wav
vj_hlr/hl1_npc/barney/ba_docprotect2.wav
vj_hlr/hl1_npc/barney/ba_docprotect3.wav
vj_hlr/hl1_npc/barney/ba_door0.wav
vj_hlr/hl1_npc/barney/ba_door1.wav
vj_hlr/hl1_npc/barney/ba_duty.wav
vj_hlr/hl1_npc/barney/ba_generic2.wav
vj_hlr/hl1_npc/barney/ba_help0.wav
-- vj_hlr/hl1_npc/barney/ba_ht01_01.wav ---> vj_hlr/hl1_npc/barney/ba_ht06_01.wav
-- vj_hlr/hl1_npc/barney/ba_ht06_04.wav ---> vj_hlr/hl1_npc/barney/ba_ht06_10.wav
--vj_hlr/hl1_npc/barney/ba_ht07_01.wav ---> vj_hlr/hl1_npc/barney/ba_ht08_03.wav
vj_hlr/hl1_npc/barney/ba_idle2.wav
vj_hlr/hl1_npc/barney/ba_idle5.wav
vj_hlr/hl1_npc/barney/ba_idle6.wav
vj_hlr/hl1_npc/barney/ba_kill1.wav
vj_hlr/hl1_npc/barney/ba_kill2.wav
vj_hlr/hl1_npc/barney/ba_lead0.wav
vj_hlr/hl1_npc/barney/ba_lead1.wav
vj_hlr/hl1_npc/barney/ba_lead2.wav
vj_hlr/hl1_npc/barney/ba_mad2.wav
vj_hlr/hl1_npc/barney/ba_ok0.wav
vj_hlr/hl1_npc/barney/ba_opgate.wav
vj_hlr/hl1_npc/barney/ba_plfear0.wav
-- vj_hlr/hl1_npc/barney/ba_pok0.wav ---> vj_hlr/hl1_npc/barney/ba_security2_nopass.wav
vj_hlr/hl1_npc/barney/ba_security2_range1.wav
vj_hlr/hl1_npc/barney/ba_security2_range2.wav
vj_hlr/hl1_npc/barney/ba_shot0.wav
vj_hlr/hl1_npc/barney/ba_stare2.wav
vj_hlr/hl1_npc/barney/ba_stare3.wav
-- vj_hlr/hl1_npc/barney/c1a0_ba_button.wav ---> vj_hlr/hl1_npc/barney/c1a2_ba_2zomb.wav
vj_hlr/hl1_npc/barney/c1a2_ba_bullsquid.wav
vj_hlr/hl1_npc/barney/c1a2_ba_climb.wav
vj_hlr/hl1_npc/barney/c1a2_ba_slew.wav
vj_hlr/hl1_npc/barney/c1a2_ba_surface.wav
vj_hlr/hl1_npc/barney/c1a2_ba_top.wav
-- vj_hlr/hl1_npc/barney/c1a4_ba_wisp.wav ---> vj_hlr/hl1_npc/barney/c3a2_ba_stay.wav
vj_hlr/hl1_npc/barney/checkwounds.wav
vj_hlr/hl1_npc/barney/imdead.wav
vj_hlr/hl1_npc/barney/killme.wav
vj_hlr/hl1_npc/barney/leavealone.wav
vj_hlr/hl1_npc/barney/of1a5_ba02.wav
vj_hlr/hl1_npc/barney/of6a4_ba01.wav
vj_hlr/hl1_npc/barney/of6a4_ba02.wav
vj_hlr/hl1_npc/barney/of6a4_ba03.wav
vj_hlr/hl1_npc/barney/of6a4_ba04.wav
vj_hlr/hl1_npc/barney/openfire.wav
vj_hlr/hl1_npc/barney/realbadwound.wav
vj_hlr/hl1_npc/barney/sir.wav
vj_hlr/hl1_npc/barney/soldier.wav
vj_hlr/hl1_npc/barney/youneedmedic.wav
*/

ENT.GeneralSoundPitch1 = 100

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Bip01 Head"
ENT.Controller_FirstPersonOffset = Vector(5,0,1.75)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

-- Custom
ENT.Security_NextMouthMove = 0
ENT.Security_NextMouthDistance = 0
ENT.Security_GunHolstered = true
ENT.Security_Type = 0
	-- 0 = Security Guard
	-- 1 = Otis
	-- 2 = Alpha Security Guard
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_CustomOnInitialize()
	self.SoundTbl_Idle = {"vj_hlr/hl1_npc/barney/whatisthat.wav","vj_hlr/hl1_npc/barney/somethingstinky.wav","vj_hlr/hl1_npc/barney/somethingdied.wav","vj_hlr/hl1_npc/barney/guyresponsible.wav","vj_hlr/hl1_npc/barney/coldone.wav","vj_hlr/hl1_npc/barney/ba_gethev.wav","vj_hlr/hl1_npc/barney/badfeeling.wav","vj_hlr/hl1_npc/barney/bigmess.wav","vj_hlr/hl1_npc/barney/bigplace.wav"}
	self.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/barney/youeverseen.wav","vj_hlr/hl1_npc/barney/workingonstuff.wav","vj_hlr/hl1_npc/barney/whatsgoingon.wav","vj_hlr/hl1_npc/barney/thinking.wav","vj_hlr/hl1_npc/barney/survive.wav","vj_hlr/hl1_npc/barney/stench.wav","vj_hlr/hl1_npc/barney/somethingmoves.wav","vj_hlr/hl1_npc/barney/of1a5_ba01.wav","vj_hlr/hl1_npc/barney/nodrill.wav","vj_hlr/hl1_npc/barney/missingleg.wav","vj_hlr/hl1_npc/barney/luckwillturn.wav","vj_hlr/hl1_npc/barney/gladof38.wav","vj_hlr/hl1_npc/barney/gettingcloser.wav","vj_hlr/hl1_npc/barney/crewdied.wav","vj_hlr/hl1_npc/barney/ba_idle0.wav","vj_hlr/hl1_npc/barney/badarea.wav","vj_hlr/hl1_npc/barney/beertopside.wav"}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/barney/yup.wav","vj_hlr/hl1_npc/barney/youtalkmuch.wav","vj_hlr/hl1_npc/barney/yougotit.wav","vj_hlr/hl1_npc/barney/youbet.wav","vj_hlr/hl1_npc/barney/yessir.wav","vj_hlr/hl1_npc/barney/soundsright.wav","vj_hlr/hl1_npc/barney/noway.wav","vj_hlr/hl1_npc/barney/nope.wav","vj_hlr/hl1_npc/barney/nosir.wav","vj_hlr/hl1_npc/barney/notelling.wav","vj_hlr/hl1_npc/barney/maybe.wav","vj_hlr/hl1_npc/barney/justdontknow.wav","vj_hlr/hl1_npc/barney/ireckon.wav","vj_hlr/hl1_npc/barney/iguess.wav","vj_hlr/hl1_npc/barney/icanhear.wav","vj_hlr/hl1_npc/barney/guyresponsible.wav","vj_hlr/hl1_npc/barney/dontreckon.wav","vj_hlr/hl1_npc/barney/dontguess.wav","vj_hlr/hl1_npc/barney/dontfigure.wav","vj_hlr/hl1_npc/barney/dontbuyit.wav","vj_hlr/hl1_npc/barney/dontbet.wav","vj_hlr/hl1_npc/barney/dontaskme.wav","vj_hlr/hl1_npc/barney/cantfigure.wav","vj_hlr/hl1_npc/barney/bequiet.wav","vj_hlr/hl1_npc/barney/ba_stare0.wav","vj_hlr/hl1_npc/barney/alreadyasked.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/barney/whatgood.wav","vj_hlr/hl1_npc/barney/targetpractice.wav","vj_hlr/hl1_npc/barney/easily.wav","vj_hlr/hl1_npc/barney/getanyworse.wav"}
	self.SoundTbl_FollowPlayer = {"vj_hlr/hl1_npc/barney/yougotit.wav","vj_hlr/hl1_npc/barney/wayout.wav","vj_hlr/hl1_npc/barney/teamup1.wav","vj_hlr/hl1_npc/barney/teamup2.wav","vj_hlr/hl1_npc/barney/rightway.wav","vj_hlr/hl1_npc/barney/letsgo.wav","vj_hlr/hl1_npc/barney/letsmoveit.wav","vj_hlr/hl1_npc/barney/imwithyou.wav","vj_hlr/hl1_npc/barney/gladtolendhand.wav","vj_hlr/hl1_npc/barney/dobettertogether.wav","vj_hlr/hl1_npc/barney/c1a2_ba_goforit.wav","vj_hlr/hl1_npc/barney/ba_ok1.wav","vj_hlr/hl1_npc/barney/ba_ok2.wav","vj_hlr/hl1_npc/barney/ba_ok3.wav","vj_hlr/hl1_npc/barney/ba_idle1.wav","vj_hlr/hl1_npc/barney/ba_ht06_11.wav"}
	self.SoundTbl_UnFollowPlayer = {"vj_hlr/hl1_npc/barney/waitin.wav","vj_hlr/hl1_npc/barney/stop2.wav","vj_hlr/hl1_npc/barney/standguard.wav","vj_hlr/hl1_npc/barney/slowingyoudown.wav","vj_hlr/hl1_npc/barney/seeya.wav","vj_hlr/hl1_npc/barney/iwaithere.wav","vj_hlr/hl1_npc/barney/illwait.wav","vj_hlr/hl1_npc/barney/helpothers.wav","vj_hlr/hl1_npc/barney/ba_wait1.wav","vj_hlr/hl1_npc/barney/ba_wait2.wav","vj_hlr/hl1_npc/barney/ba_wait3.wav","vj_hlr/hl1_npc/barney/ba_wait4.wav","vj_hlr/hl1_npc/barney/ba_security2_pass.wav","vj_hlr/hl1_npc/barney/aintgoin.wav","vj_hlr/hl1_npc/barney/ba_becareful1.wav"}
	self.SoundTbl_OnPlayerSight = {"vj_hlr/hl1_npc/barney/mrfreeman.wav","vj_hlr/hl1_npc/barney/howyoudoing.wav","vj_hlr/hl1_npc/barney/howdy.wav","vj_hlr/hl1_npc/barney/heybuddy.wav","vj_hlr/hl1_npc/barney/heyfella.wav","vj_hlr/hl1_npc/barney/hellonicesuit.wav","vj_hlr/hl1_npc/barney/ba_stare1.wav","vj_hlr/hl1_npc/barney/ba_later.wav","vj_hlr/hl1_npc/barney/ba_idle4.wav","vj_hlr/hl1_npc/barney/ba_idle3.wav","vj_hlr/hl1_npc/barney/ba_ok4.wav","vj_hlr/hl1_npc/barney/ba_ok5.wav","vj_hlr/hl1_npc/barney/ba_ht06_03.wav","vj_hlr/hl1_npc/barney/ba_ht06_03_alt.wav","vj_hlr/hl1_npc/barney/ba_hello0.wav","vj_hlr/hl1_npc/barney/ba_hello1.wav","vj_hlr/hl1_npc/barney/ba_hello2.wav","vj_hlr/hl1_npc/barney/ba_hello3.wav","vj_hlr/hl1_npc/barney/ba_hello4.wav","vj_hlr/hl1_npc/barney/ba_hello5.wav","vj_hlr/hl1_npc/barney/armedforces.wav"}
	self.SoundTbl_Investigate = {"vj_hlr/hl1_npc/barney/youhearthat.wav","vj_hlr/hl1_npc/barney/soundsbad.wav","vj_hlr/hl1_npc/barney/icanhear.wav","vj_hlr/hl1_npc/barney/hearsomething2.wav","vj_hlr/hl1_npc/barney/hearsomething.wav","vj_hlr/hl1_npc/barney/ambush.wav","vj_hlr/hl1_npc/barney/ba_generic0.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hl1_npc/barney/ba_openfire.wav","vj_hlr/hl1_npc/barney/ba_attack1.wav","vj_hlr/hl1_npc/barney/aimforhead.wav"}
	self.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/barney/ba_needhelp0.wav","vj_hlr/hl1_npc/barney/ba_needhelp1.wav"}
	self.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hl1_npc/barney/ba_uwish.wav","vj_hlr/hl1_npc/barney/ba_tomb.wav","vj_hlr/hl1_npc/barney/ba_somuch.wav","vj_hlr/hl1_npc/barney/ba_mad3.wav","vj_hlr/hl1_npc/barney/ba_iwish.wav","vj_hlr/hl1_npc/barney/ba_endline.wav","vj_hlr/hl1_npc/barney/aintscared.wav"}
	self.SoundTbl_Suppressing = {"vj_hlr/hl1_npc/barney/c1a4_ba_octo2.wav","vj_hlr/hl1_npc/barney/c1a4_ba_octo4.wav","vj_hlr/hl1_npc/barney/c1a4_ba_octo3.wav","vj_hlr/hl1_npc/barney/ba_generic1.wav","vj_hlr/hl1_npc/barney/ba_bring.wav","vj_hlr/hl1_npc/barney/ba_attacking1.wav"}
	self.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/barney/standback.wav","vj_hlr/hl1_npc/barney/ba_heeey.wav"}
	self.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/barney/soundsbad.wav","vj_hlr/hl1_npc/barney/ba_seethat.wav","vj_hlr/hl1_npc/barney/ba_kill0.wav","vj_hlr/hl1_npc/barney/ba_gotone.wav","vj_hlr/hl1_npc/barney/ba_firepl.wav","vj_hlr/hl1_npc/barney/ba_buttugly.wav","vj_hlr/hl1_npc/barney/ba_another.wav","vj_hlr/hl1_npc/barney/ba_close.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/barney/die.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hl1_npc/barney/imhit.wav","vj_hlr/hl1_npc/barney/hitbad.wav","vj_hlr/hl1_npc/barney/c1a2_ba_4zomb.wav","vj_hlr/hl1_npc/barney/ba_pain1.wav","vj_hlr/hl1_npc/barney/ba_pain2.wav","vj_hlr/hl1_npc/barney/ba_pain3.wav"}
	self.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/barney/donthurtem.wav","vj_hlr/hl1_npc/barney/ba_whoathere.wav","vj_hlr/hl1_npc/barney/ba_whatyou.wav","vj_hlr/hl1_npc/barney/ba_watchit.wav","vj_hlr/hl1_npc/barney/ba_shot1.wav","vj_hlr/hl1_npc/barney/ba_shot2.wav","vj_hlr/hl1_npc/barney/ba_shot3.wav","vj_hlr/hl1_npc/barney/ba_shot4.wav","vj_hlr/hl1_npc/barney/ba_shot5.wav","vj_hlr/hl1_npc/barney/ba_shot6.wav","vj_hlr/hl1_npc/barney/ba_shot7.wav","vj_hlr/hl1_npc/barney/ba_stepoff.wav","vj_hlr/hl1_npc/barney/ba_pissme.wav","vj_hlr/hl1_npc/barney/ba_mad1.wav","vj_hlr/hl1_npc/barney/ba_mad0.wav","vj_hlr/hl1_npc/barney/ba_friends.wav","vj_hlr/hl1_npc/barney/ba_dotoyou.wav","vj_hlr/hl1_npc/barney/ba_dontmake.wav","vj_hlr/hl1_npc/barney/ba_crazy.wav"}
	self.SoundTbl_Death = {"vj_hlr/hl1_npc/barney/ba_ht06_02_alt.wav","vj_hlr/hl1_npc/barney/ba_ht06_02.wav","vj_hlr/hl1_npc/barney/ba_die1.wav","vj_hlr/hl1_npc/barney/ba_die2.wav","vj_hlr/hl1_npc/barney/ba_die3.wav"}

	self.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIE_GUTSHOT,ACT_DIE_HEADSHOT,ACT_DIESIMPLE} -- Death Animations
	
	self:Give("weapon_vj_hlr1_glock17")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 76), Vector(-13, -13, 0))
	self:SetBodygroup(1,0)
	
	if self:GetModel() == "models/vj_hlr/hl1/barney.mdl" then // Already the default
		self.Security_Type = 0
	elseif self:GetModel() == "models/vj_hlr/opfor/otis.mdl" then
		self.Security_Type = 1
	elseif self:GetModel() == "models/vj_hlr/hla/barney.mdl" then
		self.Security_Type = 2
	end
	self:Security_CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "shoot" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary(ShootPos,ShootDir)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Security_Type != 2 then
		if CurTime() < self.Security_NextMouthMove then
			if self.Security_NextMouthDistance == 0 then
				self.Security_NextMouthDistance = math.random(10,70)
			else
				self.Security_NextMouthDistance = 0
			end
			self:SetPoseParameter("m",self.Security_NextMouthDistance)
		else
			self:SetPoseParameter("m",0)
		end
	elseif IsValid(self:GetActiveWeapon()) then -- Alpha Security Guard can't reload!
		self:GetActiveWeapon():SetClip1(999)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	self.Security_NextMouthMove = CurTime() + SoundDuration(SoundFile)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,2) == 1 then
		if self.Security_Type == 0 then
			if argent:GetClass() == "npc_vj_hlr1_bullsquid" then
				self:PlaySoundSystem("Alert", {"vj_hlr/hl1_npc/barney/c1a4_ba_octo1.wav"})
				self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
			elseif argent.IsVJBaseSNPC_Creature == true then
				self:PlaySoundSystem("Alert", {"vj_hlr/hl1_npc/barney/diebloodsucker.wav"})
				self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
			end
		elseif self.Security_Type == 1 && argent.IsVJBaseSNPC_Creature == true then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl1_npc/otis/aliens.wav"})
			self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
		end
	end
	
	if self.Security_GunHolstered == true then
		self:Security_UnHolsterGun()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_UnHolsterGun()
	self:StopMoving()
	self:VJ_ACT_PLAYACTIVITY(ACT_ARM, true, false, true)
	self.Security_GunHolstered = false
	timer.Simple(0.55,function() if IsValid(self) then self:SetBodygroup(1,1) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	if self.Security_GunHolstered == true && IsValid(self:GetEnemy()) then
		self:Security_UnHolsterGun()
	elseif self.Security_GunHolstered == false && !IsValid(self:GetEnemy()) && self.TimeSinceLastSeenEnemy > 5 && self.IsReloadingWeapon == false then
		self:VJ_ACT_PLAYACTIVITY(ACT_DISARM, true, false, true)
		self.Security_GunHolstered = true
		timer.Simple(1.5,function() if IsValid(self) then self:SetBodygroup(1,0) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnIsAbleToShootWeapon()
	if self.Security_GunHolstered == true then return false end
	return true
end
local vec = Vector(0,0,0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo,hitgroup)
	if hitgroup == HITGROUP_GEAR && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(4) -- Size
		rico:SetMagnitude(math.random(1,2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico",rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.HasDeathSounds = false
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
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, math.random(100,100))
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	self:DropWeaponOnDeathCode(dmginfo, hitgroup)
	self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
	if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
	self:SetBodygroup(1,2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo,hitgroup,GetWeapon)
	GetWeapon.WorldModel_Invisible = false
	GetWeapon:SetNWBool("VJ_WorldModel_Invisible",false)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
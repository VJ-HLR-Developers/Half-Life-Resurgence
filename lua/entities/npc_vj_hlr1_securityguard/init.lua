AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/barney.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 90
ENT.HullType = HULL_HUMAN
ENT.ControllerVars = {
    ThirdP_Offset = Vector(10, 0, -30), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(4, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.FriendsWithAllPlayerAllies = true
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR_Blood_Red"}
ENT.HasBloodPool = false
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.Weapon_StrafeWhileFiring = false -- Should it move randomly while firing a weapon?
ENT.AnimTbl_CallForHelp = false
ENT.DisableFootStepSoundTimer = true
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIE_GUTSHOT, ACT_DIE_HEADSHOT, ACT_DIESIMPLE}
ENT.AnimTbl_TakingCover = ACT_CROUCHIDLE -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.BecomeEnemyToPlayer = 2
ENT.DropDeathLoot = false -- Should it drop loot on death?
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.CanTurnWhileMoving = false -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}},{HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}},{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound Paths ====== --
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

local SECURITY_TYPE_REGULAR = 0 -- Security Guard
local SECURITY_TYPE_OTIS = 1 -- Otis Laurey
local SECURITY_TYPE_ALPHA = 2 -- Alpha Security Guard
	
-- Custom
ENT.Security_NextMouthMove = 0
ENT.Security_NextMouthDistance = 0
ENT.Security_Type = SECURITY_TYPE_REGULAR
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 76), Vector(-13, -13, 0))
	self:SetBodygroup(1, 0)
	self:SetWeaponState(VJ.WEP_STATE_HOLSTERED)
	
	if self.Security_Type == SECURITY_TYPE_REGULAR then
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
		self.SoundTbl_OnDangerSight = {"vj_hlr/hl1_npc/barney/standback.wav","vj_hlr/hl1_npc/barney/ba_heeey.wav"}
		self.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/barney/soundsbad.wav","vj_hlr/hl1_npc/barney/ba_seethat.wav","vj_hlr/hl1_npc/barney/ba_kill0.wav","vj_hlr/hl1_npc/barney/ba_gotone.wav","vj_hlr/hl1_npc/barney/ba_firepl.wav","vj_hlr/hl1_npc/barney/ba_buttugly.wav","vj_hlr/hl1_npc/barney/ba_another.wav","vj_hlr/hl1_npc/barney/ba_close.wav"}
		self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/barney/die.wav"}
		self.SoundTbl_Pain = {"vj_hlr/hl1_npc/barney/imhit.wav","vj_hlr/hl1_npc/barney/hitbad.wav","vj_hlr/hl1_npc/barney/c1a2_ba_4zomb.wav","vj_hlr/hl1_npc/barney/ba_pain1.wav","vj_hlr/hl1_npc/barney/ba_pain2.wav","vj_hlr/hl1_npc/barney/ba_pain3.wav"}
		self.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/barney/donthurtem.wav","vj_hlr/hl1_npc/barney/ba_whoathere.wav","vj_hlr/hl1_npc/barney/ba_whatyou.wav","vj_hlr/hl1_npc/barney/ba_watchit.wav","vj_hlr/hl1_npc/barney/ba_shot1.wav","vj_hlr/hl1_npc/barney/ba_shot2.wav","vj_hlr/hl1_npc/barney/ba_shot3.wav","vj_hlr/hl1_npc/barney/ba_shot4.wav","vj_hlr/hl1_npc/barney/ba_shot5.wav","vj_hlr/hl1_npc/barney/ba_shot6.wav","vj_hlr/hl1_npc/barney/ba_shot7.wav","vj_hlr/hl1_npc/barney/ba_stepoff.wav","vj_hlr/hl1_npc/barney/ba_pissme.wav","vj_hlr/hl1_npc/barney/ba_mad1.wav","vj_hlr/hl1_npc/barney/ba_mad0.wav","vj_hlr/hl1_npc/barney/ba_friends.wav","vj_hlr/hl1_npc/barney/ba_dotoyou.wav","vj_hlr/hl1_npc/barney/ba_dontmake.wav","vj_hlr/hl1_npc/barney/ba_crazy.wav"}
		self.SoundTbl_Death = {"vj_hlr/hl1_npc/barney/ba_ht06_02_alt.wav","vj_hlr/hl1_npc/barney/ba_ht06_02.wav","vj_hlr/hl1_npc/barney/ba_die1.wav","vj_hlr/hl1_npc/barney/ba_die2.wav","vj_hlr/hl1_npc/barney/ba_die3.wav"}
		self:Give("weapon_vj_hlr1_glock17")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Holster / Unholster gun")
	
	function controlEnt:OnKeyPressed(key)
		local npc = self.VJCE_NPC
		if key == KEY_SPACE && npc:GetActivity() != ACT_DISARM && npc:GetActivity() != ACT_ARM then
			if npc:GetWeaponState() == VJ.WEP_STATE_HOLSTERED then
				npc:Security_UnHolsterGun()
			elseif npc:GetWeaponState() == VJ.WEP_STATE_READY then
				npc:Security_HolsterGun()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "shoot" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local guardAnims = {ACT_GET_DOWN_STAND, ACT_GET_UP_STAND}
--
function ENT:TranslateActivity(act) -- Not ran for SECURITY_TYPE_ALPHA
	-- Barnacle animation
	if self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		return ACT_BARNACLE_PULL
	-- Guarding
	elseif act == ACT_IDLE && self.IsGuard && self:GetWeaponState() == VJ.WEP_STATE_HOLSTERED && self:GetNPCState() <= NPC_STATE_IDLE then
		return self:ResolveAnimation(guardAnims)
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.Security_Type != SECURITY_TYPE_ALPHA then -- If it's regular or Otis...
		-- Mouth movement
		if CurTime() < self.Security_NextMouthMove then
			if self.Security_NextMouthDistance == 0 then
				self.Security_NextMouthDistance = math.random(10, 70)
			else
				self.Security_NextMouthDistance = 0
			end
			self:SetPoseParameter("m", self.Security_NextMouthDistance)
		else
			self:SetPoseParameter("m", 0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	self.Security_NextMouthMove = CurTime() + SoundDuration(sdFile)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	
	if math.random(1, 2) == 1 then
		if self.Security_Type == SECURITY_TYPE_REGULAR then
			if ent:GetClass() == "npc_vj_hlr1_bullsquid" then
				self:PlaySoundSystem("Alert", "vj_hlr/hl1_npc/barney/c1a4_ba_octo1.wav")
			elseif ent.IsVJBaseSNPC_Creature then
				self:PlaySoundSystem("Alert", "vj_hlr/hl1_npc/barney/diebloodsucker.wav")
			end
		elseif self.Security_Type == SECURITY_TYPE_OTIS && ent.IsVJBaseSNPC_Creature then
			self:PlaySoundSystem("Alert", "vj_hlr/hl1_npc/otis/aliens.wav")
		end
	end
	
	if self:GetWeaponState() == VJ.WEP_STATE_HOLSTERED then
		self:Security_UnHolsterGun()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_HolsterGun()
	if self:GetBodygroup(1) != 0 then self:PlayAnim(ACT_DISARM, true, false, true) end
	self:SetWeaponState(VJ.WEP_STATE_HOLSTERED)
	timer.Simple(self.Security_Type == SECURITY_TYPE_ALPHA and 1 or 1.5, function()
		-- Set the holster bodygroup if we have NOT been interrupted
		if IsValid(self) && self:GetWeaponState() == VJ.WEP_STATE_HOLSTERED then
			self:SetBodygroup(1, 0)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Security_UnHolsterGun()
	self:StopMoving()
	self:PlayAnim(ACT_ARM, true, false, true)
	self:SetWeaponState()
	timer.Simple(0.55, function() if IsValid(self) then self:SetBodygroup(1, 1) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.VJ_IsBeingControlled or self.Dead or self:IsBusy("Activities") then return end
	-- Unholster the weapon if we are alerted and have NOT unholstered the weapon
	if self:GetNPCState() == NPC_STATE_ALERT or self:GetNPCState() == NPC_STATE_COMBAT then
		if self:GetWeaponState() == VJ.WEP_STATE_HOLSTERED then
			self:Security_UnHolsterGun()
		end
	-- Holster the weapon if we are idling and its been a bit since we saw an enemy
	elseif self:GetWeaponState() == VJ.WEP_STATE_READY && (CurTime() - self.EnemyData.TimeSet) > 5 then
		self:Security_HolsterGun()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Initial" then
		-- Make a metal effect when the helmet is hit!
		self.Bleeds = true
		if self.Security_Type == SECURITY_TYPE_OTIS then return end -- Only types that do have a helmet
		if hitgroup == HITGROUP_GEAR && dmginfo:GetDamagePosition() != vec then
			self.Bleeds = false			-- disable bleeding temporarily when shot at the helmet
			local rico = EffectData()
			rico:SetOrigin(dmginfo:GetDamagePosition())
			rico:SetScale(4) -- Size
			rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
			util.Effect("VJ_HLR_Rico", rico)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_bone.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_gib.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 41))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_guts.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 42))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_hmeat.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_lung.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 1, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_skull.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 60))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_legbone.mdl", {CollisionDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		self:DeathWeaponDrop(dmginfo, hitgroup)
		self:SetBodygroup(1, 2)
		if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
	elseif status == "Finish" then
		self:SetBodygroup(1, 2)
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
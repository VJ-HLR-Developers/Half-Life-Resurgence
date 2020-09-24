AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/scientist.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- Doesn't attack anything
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.HasItemDropsOnDeath = false -- Should it drop items on death?
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.IsMedicSNPC = true -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.Medic_DisableAnimation = true -- if true, it will disable the animation code
ENT.Medic_TimeUntilHeal = 4 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Medic_SpawnPropOnHeal = false -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
ENT.HasHitGroupFlinching = true -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}

/*
-- Can't move, unfollow
"vj_hlr/hl1_npc/scientist/dangerous.wav"
vj_hlr/hl1_npc/scientist/stop1.wav
vj_hlr/hl1_npc/scientist/stop2.wav
vj_hlr/hl1_npc/scientist/stop3.wav
vj_hlr/hl1_npc/scientist/stop4.wav

"vj_hlr/hl1_npc/scientist/limitsok.wav",

vj_hlr/hl1_npc/scientist/assist.wav
vj_hlr/hl1_npc/scientist/b01_sci02_briefcase.wav
vj_hlr/hl1_npc/scientist/b01_sci03_sirplease.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_catscream.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_crit1a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_crit2a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_crit3a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl1a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl2a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl3a.wav
-- vj_hlr/hl1_npc/scientist/c1a0_sci_dis10a.wav ----> vj_hlr/hl1_npc/scientist/c1a0_sci_disa.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_getaway.wav
-- vj_hlr/hl1_npc/scientist/c1a0_sci_lock1a.wav ----> vj_hlr/hl1_npc/scientist/c1a0_sci_lock8a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_mumble.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_samp.wav
vj_hlr/hl1_npc/scientist/c1a1_sci_4scan.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_6zomb.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_elevator.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_lounge.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_transm.wav
vj_hlr/hl1_npc/scientist/c1a3_sci_atlast.wav
vj_hlr/hl1_npc/scientist/c1a3_sci_rescued.wav
vj_hlr/hl1_npc/scientist/c1a3_sci_silo1a.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_blind.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_gener.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_pwr.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_rocket.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_tent.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_trust.wav
"vj_hlr/hl1_npc/scientist/c1a4_sci_pwroff.wav",
"vj_hlr/hl1_npc/scientist/c1a2_sci_darkroom.wav",
vj_hlr/hl1_npc/scientist/c2a3_sci_icky.wav
vj_hlr/hl1_npc/scientist/c2a3_sci_track.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_2tau.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_4tau.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_letout.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_scanner.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_sugicaloff.wav
"vj_hlr/hl1_npc/scientist/c2a4_sci_arg2a.wav",
"vj_hlr/hl1_npc/scientist/c2a4_sci_arg4a.wav",
vj_hlr/hl1_npc/scientist/c2a5_sci_boobie.wav
vj_hlr/hl1_npc/scientist/c2a5_sci_lebuz.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_2sat.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_4sat.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_6sat.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_dome.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_done.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_2glu.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_3glu.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_3surv.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_5surv.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_7surv.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_flood.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_forever.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_linger.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_ljump.wav
-- vj_hlr/hl1_npc/scientist/c3a2_sci_notyet.wav ----> vj_hlr/hl1_npc/scientist/c3a2_sci_uphere_alt.wav
vj_hlr/hl1_npc/scientist/crossgreen.wav
-- vj_hlr/hl1_npc/scientist/d01_sci01_waiting.wav ----> vj_hlr/hl1_npc/scientist/d01_sci09_pushsample2.wav
-- vj_hlr/hl1_npc/scientist/d01_sci11_shouldnthappen.wav ----> vj_hlr/hl1_npc/scientist/d01_sci13_jammed.wav
-- vj_hlr/hl1_npc/scientist/d01_sci15_onschedule.wav ----> vj_hlr/hl1_npc/scientist/d08_sci05_osprey.wav
vj_hlr/hl1_npc/scientist/dontgothere.wav
vj_hlr/hl1_npc/scientist/forcefield_b.wav
vj_hlr/hl1_npc/scientist/g_bounce1.wav
vj_hlr/hl1_npc/scientist/helloladies.wav
vj_hlr/hl1_npc/scientist/letyouin.wav
-- vj_hlr/hl1_npc/scientist/of1a1_sc01.wav ----> vj_hlr/hl1_npc/scientist/of4a1_sc01.wav
vj_hlr/hl1_npc/scientist/perfume.wav
-- vj_hlr/hl1_npc/scientist/sci_1thou.wav ----> vj_hlr/hl1_npc/scientist/sci_5thou.wav
vj_hlr/hl1_npc/scientist/sci_aftertest.wav
vj_hlr/hl1_npc/scientist/sci_alone.wav
vj_hlr/hl1_npc/scientist/sci_busy.wav
vj_hlr/hl1_npc/scientist/shesgonemad.wav
vj_hlr/hl1_npc/scientist/spinals.wav
vj_hlr/hl1_npc/scientist/tram.wav
vj_hlr/hl1_npc/scientist/underbarrel.wav
vj_hlr/hl1_npc/scientist/ushouldsee.wav
vj_hlr/hl1_npc/scientist/whoareyou.wav
vj_hlr/hl1_npc/scientist/xena.wav
vj_hlr/hl1_npc/scientist/scream7.wav (duplicate of scream6)
*/

ENT.GeneralSoundPitch1 = 100

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Bip02 Head"
ENT.Controller_FirstPersonOffset = Vector(0,0,5)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

-- Custom
ENT.SCI_NextMouthMove = 0
ENT.SCI_NextMouthDistance = 0
ENT.SCI_Type = 0
	-- 0 = Regular Scientist and Dr. Rosenberg
	-- 1 = Cleansuit Scientist
	-- 2 = Dr. Keller
	-- 3 = Alpha Scientist
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if self:GetModel() == "models/vj_hlr/hl1/scientist.mdl" then
		self.SCI_Type = 0
	elseif self:GetModel() == "models/vj_hlr/opfor/cleansuit_scientist.mdl" then
		self.SCI_Type = 1
	elseif self:GetModel() == "models/vj_hlr/decay/wheelchair_sci.mdl" then
		self.SCI_Type = 2
	elseif self:GetModel() == "models/vj_hlr/hla/scientist.mdl" then
		self.SCI_Type = 3
	end
	self:SCI_CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCI_CustomOnInitialize()
	self.SoundTbl_Idle = {"vj_hlr/hl1_npc/scientist/administrator.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_stall.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_3scan.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_2scan.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_1scan.wav","vj_hlr/hl1_npc/scientist/c1a4_sci_trainend.wav","vj_hlr/hl1_npc/scientist/containfail.wav","vj_hlr/hl1_npc/scientist/cough.wav","vj_hlr/hl1_npc/scientist/fusionshunt.wav","vj_hlr/hl1_npc/scientist/hopenominal.wav","vj_hlr/hl1_npc/scientist/hideglasses.wav","vj_hlr/hl1_npc/scientist/howinteresting.wav","vj_hlr/hl1_npc/scientist/ipredictedthis.wav","vj_hlr/hl1_npc/scientist/needsleep.wav","vj_hlr/hl1_npc/scientist/neverseen.wav","vj_hlr/hl1_npc/scientist/nogrant.wav","vj_hlr/hl1_npc/scientist/organicmatter.wav","vj_hlr/hl1_npc/scientist/peculiarmarks.wav","vj_hlr/hl1_npc/scientist/peculiarodor.wav","vj_hlr/hl1_npc/scientist/reportflux.wav","vj_hlr/hl1_npc/scientist/runtest.wav","vj_hlr/hl1_npc/scientist/shutdownchart.wav","vj_hlr/hl1_npc/scientist/somethingfoul.wav","vj_hlr/hl1_npc/scientist/sneeze.wav","vj_hlr/hl1_npc/scientist/sniffle.wav","vj_hlr/hl1_npc/scientist/stench.wav","vj_hlr/hl1_npc/scientist/thatsodd.wav","vj_hlr/hl1_npc/scientist/thatsmell.wav","vj_hlr/hl1_npc/scientist/allnominal.wav","vj_hlr/hl1_npc/scientist/importantspecies.wav","vj_hlr/hl1_npc/scientist/yawn.wav","vj_hlr/hl1_npc/scientist/whoresponsible.wav","vj_hlr/hl1_npc/scientist/uselessphd.wav"}
	self.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/scientist/alienappeal.wav","vj_hlr/hl1_npc/scientist/alientrick.wav","vj_hlr/hl1_npc/scientist/analysis.wav","vj_hlr/hl1_npc/scientist/announcer.wav","vj_hlr/hl1_npc/scientist/bloodsample.wav","vj_hlr/hl1_npc/scientist/beverage.wav","vj_hlr/hl1_npc/scientist/areyouthink.wav","vj_hlr/hl1_npc/scientist/catchone.wav","vj_hlr/hl1_npc/scientist/cascade.wav","vj_hlr/hl1_npc/scientist/everseen.wav","vj_hlr/hl1_npc/scientist/doyousmell.wav","vj_hlr/hl1_npc/scientist/donuteater.wav","vj_hlr/hl1_npc/scientist/dinner.wav","vj_hlr/hl1_npc/scientist/fascinating.wav","vj_hlr/hl1_npc/scientist/headcrab.wav","vj_hlr/hl1_npc/scientist/goodpaper.wav","vj_hlr/hl1_npc/scientist/improbable.wav","vj_hlr/hl1_npc/scientist/hungryyet.wav","vj_hlr/hl1_npc/scientist/koso.wav","vj_hlr/hl1_npc/scientist/lambdalab.wav","vj_hlr/hl1_npc/scientist/newsample.wav","vj_hlr/hl1_npc/scientist/nothostile.wav","vj_hlr/hl1_npc/scientist/perfectday.wav","vj_hlr/hl1_npc/scientist/recalculate.wav","vj_hlr/hl1_npc/scientist/purereadings.wav","vj_hlr/hl1_npc/scientist/rumourclean.wav","vj_hlr/hl1_npc/scientist/shakeunification.wav","vj_hlr/hl1_npc/scientist/seencup.wav","vj_hlr/hl1_npc/scientist/smellburn.wav","vj_hlr/hl1_npc/scientist/softethics.wav","vj_hlr/hl1_npc/scientist/stimulating.wav","vj_hlr/hl1_npc/scientist/simulation.wav","vj_hlr/hl1_npc/scientist/statusreport.wav","vj_hlr/hl1_npc/scientist/tunedtoday.wav","vj_hlr/hl1_npc/scientist/sunsets.wav","vj_hlr/hl1_npc/scientist/survival.wav","vj_hlr/hl1_npc/scientist/tunnelcalc.wav","vj_hlr/hl1_npc/scientist/delayagain.wav","vj_hlr/hl1_npc/scientist/safetyinnumbers.wav","vj_hlr/hl1_npc/scientist/chaostheory.wav","vj_hlr/hl1_npc/scientist/checkatten.wav","vj_hlr/hl1_npc/scientist/chimp.wav"}
	self.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/scientist/yees.wav","vj_hlr/hl1_npc/scientist/yes3.wav","vj_hlr/hl1_npc/scientist/absolutely.wav","vj_hlr/hl1_npc/scientist/absolutelynot.wav","vj_hlr/hl1_npc/scientist/cantbeserious.wav","vj_hlr/hl1_npc/scientist/completelywrong.wav","vj_hlr/hl1_npc/scientist/correcttheory.wav","vj_hlr/hl1_npc/scientist/whocansay.wav","vj_hlr/hl1_npc/scientist/whyaskme.wav","vj_hlr/hl1_npc/scientist/stopasking.wav","vj_hlr/hl1_npc/scientist/theoretically.wav","vj_hlr/hl1_npc/scientist/shutup.wav","vj_hlr/hl1_npc/scientist/shutup2.wav","vj_hlr/hl1_npc/scientist/sci_bother.wav","vj_hlr/hl1_npc/scientist/perhaps.wav","vj_hlr/hl1_npc/scientist/positively.wav","vj_hlr/hl1_npc/scientist/repeat.wav","vj_hlr/hl1_npc/scientist/ridiculous.wav","vj_hlr/hl1_npc/scientist/right.wav","vj_hlr/hl1_npc/scientist/ofcourse.wav","vj_hlr/hl1_npc/scientist/ofcoursenot.wav","vj_hlr/hl1_npc/scientist/nodoubt.wav","vj_hlr/hl1_npc/scientist/noguess.wav","vj_hlr/hl1_npc/scientist/noidea.wav","vj_hlr/hl1_npc/scientist/noo.wav","vj_hlr/hl1_npc/scientist/notcertain.wav","vj_hlr/hl1_npc/scientist/notsure.wav","vj_hlr/hl1_npc/scientist/dontconcur.wav","vj_hlr/hl1_npc/scientist/dontknow.wav","vj_hlr/hl1_npc/scientist/ibelieveso.wav","vj_hlr/hl1_npc/scientist/idiotic.wav","vj_hlr/hl1_npc/scientist/idontthinkso.wav","vj_hlr/hl1_npc/scientist/imsure.wav","vj_hlr/hl1_npc/scientist/inconclusive.wav","vj_hlr/hl1_npc/scientist/justasked.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/scientist/scream01.wav","vj_hlr/hl1_npc/scientist/scream02.wav","vj_hlr/hl1_npc/scientist/scream03.wav","vj_hlr/hl1_npc/scientist/scream04.wav","vj_hlr/hl1_npc/scientist/scream05.wav","vj_hlr/hl1_npc/scientist/scream06.wav","vj_hlr/hl1_npc/scientist/scream07.wav","vj_hlr/hl1_npc/scientist/scream08.wav","vj_hlr/hl1_npc/scientist/scream09.wav","vj_hlr/hl1_npc/scientist/scream10.wav","vj_hlr/hl1_npc/scientist/scream11.wav","vj_hlr/hl1_npc/scientist/scream12.wav","vj_hlr/hl1_npc/scientist/scream13.wav","vj_hlr/hl1_npc/scientist/scream14.wav","vj_hlr/hl1_npc/scientist/scream15.wav","vj_hlr/hl1_npc/scientist/scream16.wav","vj_hlr/hl1_npc/scientist/scream17.wav","vj_hlr/hl1_npc/scientist/scream18.wav","vj_hlr/hl1_npc/scientist/scream19.wav","vj_hlr/hl1_npc/scientist/scream20.wav","vj_hlr/hl1_npc/scientist/scream22.wav","vj_hlr/hl1_npc/scientist/scream23.wav","vj_hlr/hl1_npc/scientist/scream24.wav","vj_hlr/hl1_npc/scientist/scream25.wav","vj_hlr/hl1_npc/scientist/sci_fear8.wav","vj_hlr/hl1_npc/scientist/sci_fear7.wav","vj_hlr/hl1_npc/scientist/sci_fear15.wav","vj_hlr/hl1_npc/scientist/sci_fear2.wav","vj_hlr/hl1_npc/scientist/sci_fear3.wav","vj_hlr/hl1_npc/scientist/sci_fear4.wav","vj_hlr/hl1_npc/scientist/sci_fear5.wav","vj_hlr/hl1_npc/scientist/sci_fear11.wav","vj_hlr/hl1_npc/scientist/sci_fear12.wav","vj_hlr/hl1_npc/scientist/sci_fear13.wav","vj_hlr/hl1_npc/scientist/sci_fear1.wav","vj_hlr/hl1_npc/scientist/rescueus.wav","vj_hlr/hl1_npc/scientist/nooo.wav","vj_hlr/hl1_npc/scientist/noplease.wav","vj_hlr/hl1_npc/scientist/madness.wav","vj_hlr/hl1_npc/scientist/gottogetout.wav","vj_hlr/hl1_npc/scientist/getoutofhere.wav","vj_hlr/hl1_npc/scientist/getoutalive.wav","vj_hlr/hl1_npc/scientist/evergetout.wav","vj_hlr/hl1_npc/scientist/dontwantdie.wav","vj_hlr/hl1_npc/scientist/b01_sci01_whereami.wav","vj_hlr/hl1_npc/scientist/cantbeworse.wav","vj_hlr/hl1_npc/scientist/canttakemore.wav"}
	self.SoundTbl_FollowPlayer = {"vj_hlr/hl1_npc/scientist/yes.wav","vj_hlr/hl1_npc/scientist/yes2.wav","vj_hlr/hl1_npc/scientist/yesletsgo.wav","vj_hlr/hl1_npc/scientist/yesok.wav","vj_hlr/hl1_npc/scientist/yesihope.wav","vj_hlr/hl1_npc/scientist/waithere.wav","vj_hlr/hl1_npc/scientist/rightwayout.wav","vj_hlr/hl1_npc/scientist/protectme.wav","vj_hlr/hl1_npc/scientist/okgetout.wav","vj_hlr/hl1_npc/scientist/okihope.wav","vj_hlr/hl1_npc/scientist/odorfromyou.wav","vj_hlr/hl1_npc/scientist/letsgo.wav","vj_hlr/hl1_npc/scientist/leadtheway.wav","vj_hlr/hl1_npc/scientist/icanhelp.wav","vj_hlr/hl1_npc/scientist/hopeyouknow.wav","vj_hlr/hl1_npc/scientist/fellowscientist.wav","vj_hlr/hl1_npc/scientist/excellentteam.wav","vj_hlr/hl1_npc/scientist/d01_sci14_right.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_scanrpt.wav","vj_hlr/hl1_npc/scientist/alright.wav"}
	self.SoundTbl_UnFollowPlayer = {"vj_hlr/hl1_npc/scientist/whyleavehere.wav","vj_hlr/hl1_npc/scientist/slowingyou.wav","vj_hlr/hl1_npc/scientist/reconsider.wav","vj_hlr/hl1_npc/scientist/leavingme.wav","vj_hlr/hl1_npc/scientist/istay.wav","vj_hlr/hl1_npc/scientist/illwaithere.wav","vj_hlr/hl1_npc/scientist/illwait.wav","vj_hlr/hl1_npc/scientist/fine.wav","vj_hlr/hl1_npc/scientist/d01_sci14_right.wav","vj_hlr/hl1_npc/scientist/crowbar.wav","vj_hlr/hl1_npc/scientist/cantbeserious.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_1man.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_5scan.wav","vj_hlr/hl1_npc/scientist/asexpected.wav","vj_hlr/hl1_npc/scientist/beenaburden.wav"}
	self.SoundTbl_MoveOutOfPlayersWay = {"vj_hlr/hl1_npc/scientist/sorryimleaving.wav","vj_hlr/hl1_npc/scientist/excuse.wav"}
	self.SoundTbl_MedicBeforeHeal = {"vj_hlr/hl1_npc/scientist/youlookbad.wav","vj_hlr/hl1_npc/scientist/youlookbad2.wav","vj_hlr/hl1_npc/scientist/youneedmedic.wav","vj_hlr/hl1_npc/scientist/youwounded.wav","vj_hlr/hl1_npc/scientist/thiswillhelp.wav","vj_hlr/hl1_npc/scientist/letstrythis.wav","vj_hlr/hl1_npc/scientist/letmehelp.wav","vj_hlr/hl1_npc/scientist/holdstill.wav","vj_hlr/hl1_npc/scientist/heal1.wav","vj_hlr/hl1_npc/scientist/heal2.wav","vj_hlr/hl1_npc/scientist/heal3.wav","vj_hlr/hl1_npc/scientist/heal4.wav","vj_hlr/hl1_npc/scientist/heal5.wav"}
	self.SoundTbl_OnPlayerSight = {"vj_hlr/hl1_npc/scientist/undertest.wav","vj_hlr/hl1_npc/scientist/sci_somewhere.wav","vj_hlr/hl1_npc/scientist/saved.wav","vj_hlr/hl1_npc/scientist/newhevsuit.wav","vj_hlr/hl1_npc/scientist/keller.wav","vj_hlr/hl1_npc/scientist/inmesstoo.wav","vj_hlr/hl1_npc/scientist/hellothere.wav","vj_hlr/hl1_npc/scientist/hellofromlab.wav","vj_hlr/hl1_npc/scientist/hellofreeman.wav","vj_hlr/hl1_npc/scientist/hello.wav","vj_hlr/hl1_npc/scientist/greetings.wav","vj_hlr/hl1_npc/scientist/greetings2.wav","vj_hlr/hl1_npc/scientist/goodtoseeyou.wav","vj_hlr/hl1_npc/scientist/freemanalive.wav","vj_hlr/hl1_npc/scientist/freeman.wav","vj_hlr/hl1_npc/scientist/fix.wav","vj_hlr/hl1_npc/scientist/corporal.wav","vj_hlr/hl1_npc/scientist/c3a2_sci_1surv.wav","vj_hlr/hl1_npc/scientist/c2a4_sci_surgury.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_thankgod.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_itsyou.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_gm1.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_gm.wav","vj_hlr/hl1_npc/scientist/afellowsci.wav","vj_hlr/hl1_npc/scientist/ahfreeman.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_bigday.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl4a.wav"}
	self.SoundTbl_Investigate = {"vj_hlr/hl1_npc/scientist/whatissound.wav","vj_hlr/hl1_npc/scientist/overhere.wav","vj_hlr/hl1_npc/scientist/lowervoice.wav","vj_hlr/hl1_npc/scientist/ihearsomething.wav","vj_hlr/hl1_npc/scientist/hello2.wav","vj_hlr/hl1_npc/scientist/hearsomething.wav","vj_hlr/hl1_npc/scientist/didyouhear.wav","vj_hlr/hl1_npc/scientist/d01_sci10_interesting.wav","vj_hlr/hl1_npc/scientist/c3a2_sci_1glu.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hl1_npc/scientist/startle1.wav","vj_hlr/hl1_npc/scientist/startle2.wav","vj_hlr/hl1_npc/scientist/startle3.wav","vj_hlr/hl1_npc/scientist/startle4.wav","vj_hlr/hl1_npc/scientist/startle5.wav","vj_hlr/hl1_npc/scientist/startle6.wav","vj_hlr/hl1_npc/scientist/startle7.wav","vj_hlr/hl1_npc/scientist/startle8.wav","vj_hlr/hl1_npc/scientist/startle9.wav","vj_hlr/hl1_npc/scientist/startle1.wav","vj_hlr/hl1_npc/scientist/startle2.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_silo2a.wav"}
	self.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hl1_npc/scientist/getalong.wav","vj_hlr/hl1_npc/scientist/advance.wav","vj_hlr/hl1_npc/scientist/c2a4_sci_alldie.wav"}
	self.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/scientist/sci_fear6.wav","vj_hlr/hl1_npc/scientist/sci_fear14.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_1zomb.wav"}
	self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/scientist/whatnext.wav","vj_hlr/hl1_npc/scientist/luckwillchange.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hl1_npc/scientist/sci_pain1.wav","vj_hlr/hl1_npc/scientist/sci_pain2.wav","vj_hlr/hl1_npc/scientist/sci_pain3.wav","vj_hlr/hl1_npc/scientist/sci_pain4.wav","vj_hlr/hl1_npc/scientist/sci_pain5.wav","vj_hlr/hl1_npc/scientist/sci_pain6.wav","vj_hlr/hl1_npc/scientist/sci_pain7.wav","vj_hlr/hl1_npc/scientist/sci_pain8.wav","vj_hlr/hl1_npc/scientist/sci_pain9.wav","vj_hlr/hl1_npc/scientist/sci_pain10.wav","vj_hlr/hl1_npc/scientist/sci_fear9.wav","vj_hlr/hl1_npc/scientist/sci_fear10.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_dangling.wav","vj_hlr/hl1_npc/scientist/iwounded.wav","vj_hlr/hl1_npc/scientist/iwounded2.wav","vj_hlr/hl1_npc/scientist/iwoundedbad.wav"}
	self.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/scientist/youinsane.wav","vj_hlr/hl1_npc/scientist/whatyoudoing.wav","vj_hlr/hl1_npc/scientist/please.wav","vj_hlr/hl1_npc/scientist/c3a2_sci_fool.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_team.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_stayback.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_3zomb.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_5zomb.wav"}
	self.SoundTbl_Death = {"vj_hlr/hl1_npc/scientist/scream5.wav","vj_hlr/hl1_npc/scientist/scream21.wav","vj_hlr/hl1_npc/scientist/sci_die1.wav","vj_hlr/hl1_npc/scientist/sci_die2.wav","vj_hlr/hl1_npc/scientist/sci_die3.wav","vj_hlr/hl1_npc/scientist/sci_die4.wav","vj_hlr/hl1_npc/scientist/sci_dragoff.wav"}
	
	local randbg = math.random(0,4)
	self:SetBodygroup(1,randbg)
	if randbg == 2 && self.SCI_Type == 0 then
		self:SetSkin(1)
	end
	//self:VJ_GetAllPoseParameters(true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" or key == "wheelchair" then
		self:FootStepSoundCode()
	end
	if key == "tie" then
		self:StopAllCommonSpeechSounds()
		VJ_EmitSound(self,{"vj_hlr/hl1_npc/scientist/weartie.wav","vj_hlr/hl1_npc/scientist/ties.wav"},80,100)
	end
	if key == "draw" then
		self:SetBodygroup(2,1)
	end
	if key == "holster" then
		self:SetBodygroup(2,0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_BeforeHeal()
	self:VJ_ACT_PLAYACTIVITY("pull_needle",true,VJ_GetSequenceDuration(self,"pull_needle") + 0.1,false,0,{},function(vsched)
		vsched.RunCode_OnFinish = function()
			self:VJ_ACT_PLAYACTIVITY("give_shot",true,VJ_GetSequenceDuration(self,"give_shot") + 0.1,false,0,{},function(vsched)
				vsched.RunCode_OnFinish = function()
					self:VJ_ACT_PLAYACTIVITY("return_needle",true,false)
				end
			end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMedic_OnReset()
	timer.Simple(1.5,function() if IsValid(self) then self:SetBodygroup(2,0) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if self.SCI_Type != 2 && self.SCI_Type != 3 then
		if math.random(1,2) == 1 && argent.HLR_Type == "Headcrab" or argent:GetClass() == "npc_headcrab" or argent:GetClass() == "npc_headcrab_black" or argent:GetClass() == "npc_headcrab_fast" then
			self:PlaySoundSystem("Alert", {"vj_hlr/hl1_npc/scientist/seeheadcrab.wav"})
			self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
		end
		if argent:GetPos():Distance(self:GetPos()) >= 300 && math.random(1,2) == 1 then
			self:VJ_ACT_PLAYACTIVITY({"vjseq_eye_wipe","vjseq_fear1","vjseq_fear2"}, true, false, true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self:GetEnemy()) && self.SCI_Type != 3 then
		self.AnimTbl_ScaredBehaviorStand = {ACT_CROUCHIDLE}
		self.AnimTbl_IdleStand = {ACT_CROUCHIDLE}
		if self.SCI_Type != 2 then
			self.AnimTbl_Walk = {ACT_WALK_SCARED}
		end
		self.AnimTbl_Run = {ACT_RUN_SCARED}
	else
		if math.random(1,25) == 1 && self.SCI_Type == 1 then
			self.AnimTbl_IdleStand = {ACT_VM_IDLE_1}
		else
			self.AnimTbl_IdleStand = {ACT_IDLE}
		end
		self.AnimTbl_Walk = {ACT_WALK}
		self.AnimTbl_Run = {ACT_RUN}
	end
	
	if self.SCI_Type == 2 && self:GetBodygroup(0) == 1 then
		self.HasDeathAnimation = false
		self:TakeDamage(999999999,self,self)
	end
	
	if CurTime() < self.SCI_NextMouthMove then
		if self.SCI_NextMouthDistance == 0 then
			self.SCI_NextMouthDistance = math.random(10,70)
		else
			self.SCI_NextMouthDistance = 0
		end
		self:SetPoseParameter("m",self.SCI_NextMouthDistance)
	else
		self:SetPoseParameter("m",0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	self.SCI_NextMouthMove = CurTime() + SoundDuration(SoundFile)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	self:SetBodygroup(2,0)
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
		
		if self.SCI_Type == 2 then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			util.Effect("HelicopterMegaBomb", effectdata)
			ParticleEffect("explosion_turret_break_fire", self:GetPos() +self:GetUp() *30, Angle(0,0,0))
		end
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
	if self.SCI_Type == 2 then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_seat.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,20)),Ang=self:LocalToWorldAngles(Angle(0,-10,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_back.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(-15,0,35)),Ang=self:LocalToWorldAngles(Angle(0,-10,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_headrest.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(-15,0,55)),Ang=self:LocalToWorldAngles(Angle(0,-10,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_arm.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,-15,32)),Ang=self:LocalToWorldAngles(Angle(0,-10,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_arm.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,15,32)),Ang=self:LocalToWorldAngles(Angle(0,-10,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_backwheel.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(-15,-15,5)),Ang=self:LocalToWorldAngles(Angle(0,0,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_backwheel.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(-15,15,5)),Ang=self:LocalToWorldAngles(Angle(0,0,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_frontwheel.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(15,-15,5)),Ang=self:LocalToWorldAngles(Angle(0,90,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/wheelchair_frontwheel.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(15,15,5)),Ang=self:LocalToWorldAngles(Angle(0,90,0)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,20)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,20)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 100, math.random(100,100))
	if self.SCI_Type == 2 then
		VJ_EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 150, math.random(100,100))
		VJ_EmitSound(self, "vj_hlr/hl1_npc/rgrunt/rb_gib.wav", 65, math.random(100,100))
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup)
	if hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = {ACT_DIE_HEADSHOT}
	elseif hitgroup == HITGROUP_STOMACH && self.SCI_Type != 2 then
		self.AnimTbl_Death = {ACT_DIE_GUTSHOT}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
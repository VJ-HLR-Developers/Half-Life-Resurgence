AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/scientist.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 50
ENT.HullType = HULL_HUMAN
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -30), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip02 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this NPC be friends with other player allies?
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR_Blood_Red"}
ENT.HasBloodPool = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- Doesn't attack anything
ENT.BecomeEnemyToPlayer = 2
ENT.DropDeathLoot = false -- Should it drop loot on death?
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.IsMedic = true -- Is this NPC a medic? It will heal friendly players and NPCs
ENT.Medic_DisableAnimation = true -- if true, it will disable the animation code
ENT.Medic_TimeUntilHeal = 4 -- Time until the ally receives health | Set to false to let the base decide the time
ENT.Medic_SpawnPropOnHeal = false -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false -- How long should the death animation play?
ENT.CanTurnWhileMoving = false -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound Paths ====== --
local sdTie = {"vj_hlr/hl1_npc/scientist/weartie.wav","vj_hlr/hl1_npc/scientist/ties.wav"}
local sdStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}

ENT.SoundTbl_FootStep = sdStep

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

local ACT_FEAR_DISPLAY;

local SCI_TYPE_REGULAR = 0 -- Regular Scientist
local SCI_TYPE_CLEANSUIT = 1 -- Cleansuit Scientist
local SCI_TYPE_ALPHA = 2 -- Alpha Scientist
local SCI_TYPE_KELLER = 3 -- Dr. Keller
local SCI_TYPE_ROSENBERG = 4 -- Dr. Rosenberg
	
-- Custom
ENT.SCI_NextMouthMove = 0
ENT.SCI_NextMouthDistance = 0
ENT.SCI_Type = SCI_TYPE_REGULAR
ENT.SCI_NextTieAnnoyanceT = 0
ENT.SCI_ControllerAnim = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init() -- This function runs for: SCI_TYPE_REGULAR, SCI_TYPE_CLEANSUIT, SCI_TYPE_ROSENBERG
	ACT_FEAR_DISPLAY = util.GetActivityIDByName("ACT_FEAR_DISPLAY")
	if self.SCI_Type == SCI_TYPE_ROSENBERG then
		self:SetBodygroup(1, 5)
	else
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
		self.SoundTbl_OnDangerSight = {"vj_hlr/hl1_npc/scientist/sci_fear6.wav","vj_hlr/hl1_npc/scientist/sci_fear14.wav"}
		self.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/scientist/whatnext.wav","vj_hlr/hl1_npc/scientist/luckwillchange.wav"}
		self.SoundTbl_Pain = {"vj_hlr/hl1_npc/scientist/sci_pain1.wav","vj_hlr/hl1_npc/scientist/sci_pain2.wav","vj_hlr/hl1_npc/scientist/sci_pain3.wav","vj_hlr/hl1_npc/scientist/sci_pain4.wav","vj_hlr/hl1_npc/scientist/sci_pain5.wav","vj_hlr/hl1_npc/scientist/sci_pain6.wav","vj_hlr/hl1_npc/scientist/sci_pain7.wav","vj_hlr/hl1_npc/scientist/sci_pain8.wav","vj_hlr/hl1_npc/scientist/sci_pain9.wav","vj_hlr/hl1_npc/scientist/sci_pain10.wav","vj_hlr/hl1_npc/scientist/sci_fear9.wav","vj_hlr/hl1_npc/scientist/sci_fear10.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_dangling.wav","vj_hlr/hl1_npc/scientist/iwounded.wav","vj_hlr/hl1_npc/scientist/iwounded2.wav","vj_hlr/hl1_npc/scientist/iwoundedbad.wav"}
		self.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/scientist/youinsane.wav","vj_hlr/hl1_npc/scientist/whatyoudoing.wav","vj_hlr/hl1_npc/scientist/please.wav","vj_hlr/hl1_npc/scientist/c3a2_sci_fool.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_team.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_stayback.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_3zomb.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_5zomb.wav"}
		self.SoundTbl_Death = {"vj_hlr/hl1_npc/scientist/scream5.wav","vj_hlr/hl1_npc/scientist/scream21.wav","vj_hlr/hl1_npc/scientist/sci_die1.wav","vj_hlr/hl1_npc/scientist/sci_die2.wav","vj_hlr/hl1_npc/scientist/sci_die3.wav","vj_hlr/hl1_npc/scientist/sci_die4.wav","vj_hlr/hl1_npc/scientist/sci_dragoff.wav"}
		
		local randBG = math.random(0, 4)
		self:SetBodygroup(1, randBG)
		if randBG == 2 && self.SCI_Type == SCI_TYPE_REGULAR then
			self:SetSkin(1)
		end
		self.SCI_NextTieAnnoyanceT = CurTime() + math.Rand(2, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("RELOAD: Toggle scared animations")
	if self.SCI_Type == SCI_TYPE_REGULAR then
		ply:ChatPrint("LMOUSE: Play tie annoyance (if not scared & possible)")
	elseif self.SCI_Type == SCI_TYPE_KELLER then
		ply:ChatPrint("JUMP: Stand up")
	end
	
	self.SCI_ControllerAnim = 0
	self.SCI_NextTieAnnoyanceT = 0
	
	function controlEnt:OnKeyBindPressed(key)
		local npc = self.VJCE_NPC
		-- Toggle behavior setting (Idle / Alert)
		if key == IN_RELOAD then
			if npc.SCI_ControllerAnim == 0 then
				npc.SCI_ControllerAnim = 1
				self.VJCE_Player:ChatPrint("I am scared!")
			else
				npc.SCI_ControllerAnim = 0
				self.VJCE_Player:ChatPrint("Calming down...")
			end
		elseif key == IN_ATTACK && npc.SCI_Type == SCI_TYPE_REGULAR && CurTime() > npc.SCI_NextTieAnnoyanceT then
			npc:PlayAnim(ACT_VM_IDLE_1, true, false)
			npc.SCI_NextTieAnnoyanceT = CurTime() + 4
		-- Keller standing up from the wheelchair
		elseif key == IN_JUMP && npc.SCI_Type == SCI_TYPE_KELLER && !npc:IsBusy() then
			npc:SetState(VJ_STATE_ONLY_ANIMATION_CONSTANT)
			npc:PlayAnim(ACT_STAND, true, false, false, 0, {
				-- Already done through event, but also here to make sure it's killed!
				OnFinish = function(interrupted, anim)
					if npc.Dead then return end
					npc.HasDeathAnimation = false
					npc:TakeDamage(npc:Health(), npc, npc)
				end
			})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" or key == "wheelchair" then
		self:FootStepSoundCode()
	elseif key == "tie" /*&& !self:IsBusy("Activities")*/ then
		self:PlaySoundSystem("Speech", sdTie)
		//VJ.EmitSound(self, {"vj_hlr/hl1_npc/scientist/weartie.wav","vj_hlr/hl1_npc/scientist/ties.wav"}, 80, 100)
	elseif key == "draw" then
		self:SetBodygroup(2,1)
	elseif key == "holster" then
		self:SetBodygroup(2,0)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	// keller
	elseif key == "keller_surprise" then
		self.SoundTbl_FootStep = sdStep
		self:PlaySoundSystem("Speech", "vj_hlr/hl1_npc/keller/dk_furher.wav")
	elseif key == "keller_die" then
		self.HasDeathAnimation = false
		self.DeathCorpseApplyForce = false
		local dmg = DamageInfo()
		dmg:SetDamage(self:Health())
		dmg:SetDamageType(bit.band(DMG_GENERIC, DMG_PREVENT_PHYSICS_FORCE))
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		self:TakeDamageInfo(dmg)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- Barnacle animation
	if self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then
		return ACT_BARNACLE_PULL
	-- Scared animations
	elseif self.SCI_Type != SCI_TYPE_ALPHA && ((!self.VJ_IsBeingControlled && (self:GetNPCState() == NPC_STATE_ALERT or self:GetNPCState() == NPC_STATE_COMBAT)) or (self.VJ_IsBeingControlled && self.SCI_ControllerAnim == 1)) then
		if act == ACT_IDLE then
			return ACT_CROUCHIDLE
		elseif act == ACT_WALK && self.SCI_Type != SCI_TYPE_KELLER then
			return ACT_WALK_SCARED
		elseif act == ACT_RUN then
			return ACT_RUN_SCARED
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_IDLE_STAND()
	if !self.BaseClass.SCHEDULE_IDLE_STAND(self) then return end
	-- Tie annoyance
	if self.SCI_Type == SCI_TYPE_REGULAR && CurTime() > self.SCI_NextTieAnnoyanceT && self:GetNPCState() <= NPC_STATE_IDLE then
		if math.random(1, 8) == 1 then
			self:PlayAnim(ACT_VM_IDLE_1, true, false)
		end
		self.SCI_NextTieAnnoyanceT = CurTime() + math.Rand(25, 100)
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMedicBehavior(status, statusData)
	if status == "BeforeHeal" then
		-- Healing animation (3)
		self:PlayAnim(ACT_ARM, true, false, false, 0, {OnFinish=function(interrupted, anim)
			if interrupted then return end
			self:PlayAnim(ACT_MELEE_ATTACK1, true, false, false, 0, {OnFinish=function(interrupted2, anim2)
				if interrupted2 then return end
				self:PlayAnim(ACT_DISARM, true, false)
			end})
		end})
	elseif status == "OnReset" then
		timer.Simple(1.5, function() if IsValid(self) then self:SetBodygroup(2, 0) end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	if self.SCI_Type != SCI_TYPE_KELLER && self.SCI_Type != SCI_TYPE_ALPHA then
		if self.SCI_Type != SCI_TYPE_ROSENBERG && math.random(1, 2) == 1 && ent.VJ_ID_Headcrab then
			self:PlaySoundSystem("Alert", "vj_hlr/hl1_npc/scientist/seeheadcrab.wav")
		end
		if math.random(1, 2) == 1 && ent:GetPos():Distance(self:GetPos()) >= 300 then
			self:PlayAnim(ACT_FEAR_DISPLAY, true, false, true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Mouth animation when talking
	if CurTime() < self.SCI_NextMouthMove then
		if self.SCI_NextMouthDistance == 0 then
			self.SCI_NextMouthDistance = math.random(10, 70)
		else
			self.SCI_NextMouthDistance = 0
		end
		self:SetPoseParameter("m", self.SCI_NextMouthDistance)
	else
		self:SetPoseParameter("m", 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	self.SCI_NextMouthMove = CurTime() + SoundDuration(sdFile)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
local sdMetalCollide = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
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
		
		if self.SCI_Type == SCI_TYPE_KELLER then
			local spr = ents.Create("env_sprite")
			spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
			spr:SetKeyValue("GlowProxySize", "2.0")
			spr:SetKeyValue("HDRColorScale", "1.0")
			spr:SetKeyValue("renderfx", "14")
			spr:SetKeyValue("rendermode", "5")
			spr:SetKeyValue("renderamt", "255")
			spr:SetKeyValue("disablereceiveshadows", "0")
			spr:SetKeyValue("mindxlevel", "0")
			spr:SetKeyValue("maxdxlevel", "0")
			spr:SetKeyValue("framerate", "20.0")
			spr:SetKeyValue("spawnflags", "0")
			spr:SetKeyValue("scale", "2")
			spr:SetPos(self:GetPos() + self:GetUp()*60)
			spr:Spawn()
			spr:Fire("Kill", "", 0.7)
			timer.Simple(0.7, function() if IsValid(spr) then spr:Remove() end end)
		end
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
	if self.SCI_Type == SCI_TYPE_KELLER then
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_seat.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 20)), Ang=self:LocalToWorldAngles(Angle(0, -10, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_back.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(-15, 0, 35)), Ang=self:LocalToWorldAngles(Angle(0, -10, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_headrest.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(-15, 0, 55)), Ang=self:LocalToWorldAngles(Angle(0, -10, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_arm.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, -15, 32)), Ang=self:LocalToWorldAngles(Angle(0, -10, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_arm.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 15, 32)), Ang=self:LocalToWorldAngles(Angle(0, -10, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_backwheel.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(-15, -15, 5)), Ang=self:LocalToWorldAngles(Angle(0, 0, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_backwheel.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(-15, 15, 5)), Ang=self:LocalToWorldAngles(Angle(0, 0, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_frontwheel.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(15, -15, 6)), Ang=self:LocalToWorldAngles(Angle(0, 90, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/wheelchair_frontwheel.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(15, 15, 6)), Ang=self:LocalToWorldAngles(Angle(0, 90, 0)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 1, 20)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 0, 20)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(1, 1, 20)), CollisionSound=sdMetalCollide})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {CollisionDecal=false, Pos=self:LocalToWorld(Vector(0, 0, 21)), CollisionSound=sdMetalCollide})
		VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris3.wav", 150, 100)
		VJ.EmitSound(self, "vj_hlr/hl1_npc/rgrunt/rb_gib.wav", 65, 100)
	end
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		self:SetBodygroup(2, 0)
	elseif status == "DeathAnim" then
		if self.SCI_Type == SCI_TYPE_ALPHA then return end
		if hitgroup == HITGROUP_HEAD then
			self.AnimTbl_Death = ACT_DIE_HEADSHOT
		elseif hitgroup == HITGROUP_STOMACH && self.SCI_Type != SCI_TYPE_KELLER then
			self.AnimTbl_Death = ACT_DIE_GUTSHOT
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
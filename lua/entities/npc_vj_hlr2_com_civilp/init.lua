AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/police.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.AnimTbl_MeleeAttack = "pushplayer" // ACT_MELEE_ATTACK_SWING
ENT.MeleeAttackDamage = 10
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 500 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.WeaponInventory_MeleeList = {"weapon_vj_hlr2_stunstick"} -- It will randomly be given one of these weapons
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"npc/metropolice/vo/clearno647no10-107.wav","npc/metropolice/vo/catchthatbliponstabilization.wav","vj_hlr/hl2_npc/metropolice/standingby.wav","vj_hlr/hl2_npc/metropolice/reportstatus.wav","vj_hlr/hl2_npc/metropolice/reportin.wav","vj_hlr/hl2_npc/metropolice/preservecp.wav","vj_hlr/hl2_npc/metropolice/maintaincp.wav","vj_hlr/hl2_npc/metropolice/checklocal.wav","vj_hlr/hl2_npc/metropolice/aci.wav","npc/metropolice/hiding02.wav","npc/metropolice/vo/allunitsmaintainthiscp.wav","npc/metropolice/vo/anyonepickup647e.wav","npc/metropolice/vo/wearesociostablethislocation.wav","npc/metropolice/vo/utlsuspect.wav","npc/metropolice/vo/unitisonduty10-8.wav","npc/metropolice/vo/unitis10-8standingby.wav","npc/metropolice/vo/ten97.wav","npc/metropolice/vo/ten8standingby.wav","npc/metropolice/vo/ten2.wav","npc/metropolice/vo/standardloyaltycheck.wav","npc/metropolice/vo/sacrificecode1maintaincp.wav","npc/metropolice/vo/readytojudge.wav","npc/metropolice/vo/ptatlocationreport.wav","npc/metropolice/vo/proceedtocheckpoints.wav","npc/metropolice/vo/patrol.wav","npc/metropolice/vo/novisualonupi.wav","npc/metropolice/vo/nonpatrolregion.wav","npc/metropolice/vo/nocontact.wav","npc/metropolice/vo/localcptreportstatus.wav","npc/metropolice/vo/keepmoving.wav","npc/metropolice/vo/ispassive.wav","npc/metropolice/vo/isathardpointreadytoprosecute.wav","npc/metropolice/vo/inpositiononeready.wav","npc/metropolice/vo/inpositionathardpoint.wav","npc/metropolice/vo/inposition.wav","npc/metropolice/vo/holdthisposition.wav","npc/metropolice/vo/holdingon10-14duty.wav","npc/metropolice/vo/dispupdatingapb.wav","npc/metropolice/vo/cpweneedtoestablishaperimeterat.wav","npc/metropolice/vo/cprequestsallunitsreportin.wav","npc/metropolice/vo/atcheckpoint.wav","npc/metropolice/vo/clearandcode100.wav","npc/metropolice/vo/code7.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl2_npc/metropolice/stabilizationunitsmove.wav","vj_hlr/hl2_npc/metropolice/respondingcode2.wav","vj_hlr/hl2_npc/metropolice/preparingtoprosecute.wav","vj_hlr/hl2_npc/metropolice/gogogo.wav","vj_hlr/hl2_npc/metropolice/convergingonsuspect.wav","vj_hlr/hl2_npc/metropolice/allunitsbeadvised.wav","npc/metropolice/hiding03.wav","npc/metropolice/vo/unitreportinwith10-25suspect.wav","npc/metropolice/vo/tenzerovisceratorishunting.wav","npc/metropolice/vo/teaminpositionadvance.wav","npc/metropolice/vo/requestsecondaryviscerator.wav","npc/metropolice/vo/readytoamputate.wav","npc/metropolice/vo/preparingtojudge10-107.wav","npc/metropolice/vo/preparefor1015.wav","npc/metropolice/vo/positiontocontain.wav","npc/metropolice/vo/outlandbioticinhere.wav","npc/metropolice/vo/movingtohardpoint2.wav","npc/metropolice/vo/movingtohardpoint.wav","npc/metropolice/vo/movetoarrestpositions.wav","npc/metropolice/vo/malcompliant10107my1020.wav","npc/metropolice/vo/lockyourposition.wav","npc/metropolice/vo/issuingmalcompliantcitation.wav","npc/metropolice/vo/ismovingin.wav","npc/metropolice/vo/isgo.wav","npc/metropolice/vo/is415b.wav","npc/metropolice/vo/interlock.wav","npc/metropolice/vo/ihave10-30my10-20responding.wav","npc/metropolice/vo/highpriorityregion.wav","npc/metropolice/vo/hardpointscanning.wav","npc/metropolice/vo/establishnewcp.wav","npc/metropolice/vo/distributionblock.wav","npc/metropolice/vo/dispreportssuspectincursion.wav","npc/metropolice/vo/deservicedarea.wav","npc/metropolice/vo/cpbolforthat243.wav","npc/metropolice/vo/converging.wav","npc/metropolice/vo/airwatchsubjectis505.wav","npc/metropolice/vo/allunitscloseonsuspect.wav","npc/metropolice/vo/allunitsmovein.wav","npc/metropolice/vo/allunitsreportlocationsuspect.wav"}
ENT.SoundTbl_OnReceiveOrder = {"vj_hlr/hl2_npc/metropolice/imgoingin.wav","vj_hlr/hl2_npc/metropolice/gogogo.wav","vj_hlr/hl2_npc/metropolice/allunitsgo.wav","vj_hlr/hl2_npc/metropolice/allright.wav","npc/metropolice/vo/ten4.wav","npc/metropolice/vo/rodgerthat.wav","npc/metropolice/vo/responding2.wav","npc/metropolice/vo/readytoprosecute.wav","npc/metropolice/vo/copy.wav","npc/metropolice/vo/affirmative.wav","npc/metropolice/vo/affirmative2.wav"}
ENT.SoundTbl_FollowPlayer = {"vj_hlr/hl2_npc/metropolice/allright.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/hl2_npc/metropolice/allright.wav"}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {"npc/metropolice/vo/freeman.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/hl2_npc/metropolice/scanning.wav","vj_hlr/hl2_npc/metropolice/investigate10-103.wav","npc/metropolice/hiding05.wav","npc/metropolice/vo/sweepingforsuspect.wav","npc/metropolice/vo/searchingforsuspect.wav","npc/metropolice/vo/possible647erequestairwatch.wav","npc/metropolice/vo/possible404here.wav","npc/metropolice/vo/possible10-103alerttagunits.wav","npc/metropolice/vo/pickingupnoncorplexindy.wav","npc/metropolice/vo/investigating10-103.wav","npc/metropolice/vo/investigate.wav","npc/metropolice/vo/goingtotakealook.wav","npc/metropolice/vo/allunitscode2.wav"}
ENT.SoundTbl_LostEnemy = {"npc/metropolice/vo/utlthatsuspect.wav","npc/metropolice/vo/hidinglastseenatrange.wav","vj_hlr/hl2_npc/metropolice/scanning.wav","vj_hlr/hl2_npc/metropolice/novisual.wav","vj_hlr/hl2_npc/metropolice/nostatus.wav","vj_hlr/hl2_npc/metropolice/heshiding.wav"}
ENT.SoundTbl_Alert = {"npc/metropolice/vo/unlawfulentry603.wav","vj_hlr/hl2_npc/metropolice/sectorcompromised.wav","vj_hlr/hl2_npc/metropolice/contactwithsuspect.wav","npc/metropolice/vo/wehavea10-108.wav","npc/metropolice/vo/subject.wav","npc/metropolice/vo/sociocide.wav","npc/metropolice/vo/shotsfiredhostilemalignants.wav","npc/metropolice/vo/reportsightingsaccomplices.wav","npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav","npc/metropolice/vo/non-taggedviromeshere.wav","npc/metropolice/vo/malignant.wav","npc/metropolice/vo/level3civilprivacyviolator.wav","npc/metropolice/vo/is10-108.wav","npc/metropolice/vo/hesupthere.wav","npc/metropolice/vo/dispatchineed10-78.wav","npc/metropolice/vo/criminaltrespass63.wav","npc/metropolice/vo/contactwith243suspect.wav","npc/metropolice/vo/confirmadw.wav","npc/metropolice/vo/condemnedzone.wav","npc/metropolice/vo/allunitsrespondcode3.wav"}
ENT.SoundTbl_CallForHelp = {"vj_hlr/hl2_npc/metropolice/helpcode3tomy10-20.wav","npc/metropolice/vo/reinforcementteamscode3.wav","npc/metropolice/vo/officerneedshelp.wav","npc/metropolice/vo/officerneedsassistance.wav","npc/metropolice/vo/needanyhelpwiththisone.wav","npc/metropolice/vo/ivegot408hereatlocation.wav","npc/metropolice/vo/hesupthere.wav","npc/metropolice/vo/gothimagainsuspect10-20at.wav","npc/metropolice/vo/gota10-107sendairwatch.wav","npc/metropolice/vo/dispatchineed10-78.wav","npc/metropolice/vo/backup.wav","npc/metropolice/vo/cpiscompromised.wav","npc/metropolice/vo/cpisoverrunwehavenocontainment.wav"}
ENT.SoundTbl_Suppressing = {"vj_hlr/hl2_npc/metropolice/p-code100.wav","vj_hlr/hl2_npc/metropolice/isathardpoint.wav","vj_hlr/hl2_npc/metropolice/imgoingin.wav","vj_hlr/hl2_npc/metropolice/firetodislocatetarget.wav","vj_hlr/hl2_npc/metropolice/breakhisinterpose.wav","npc/metropolice/vo/thereheis.wav","npc/metropolice/vo/prepareforjudgement.wav","npc/metropolice/vo/pacifying.wav","npc/metropolice/vo/isclosingonsuspect.wav","npc/metropolice/vo/hesrunning.wav","npc/metropolice/vo/five.wav","npc/metropolice/vo/firingtoexposetarget.wav","npc/metropolice/vo/firetodislocateinterpose.wav","npc/metropolice/vo/dismountinghardpoint.wav","npc/metropolice/vo/destroythatcover.wav","npc/metropolice/vo/cpisoverrunwehavenocontainment.wav","npc/metropolice/vo/breakhiscover.wav","npc/metropolice/vo/covermegoingin.wav"}
ENT.SoundTbl_WeaponReload = {"vj_hlr/hl2_npc/metropolice/takingcover.wav","vj_hlr/hl2_npc/metropolice/outonverdicts.wav","vj_hlr/hl2_npc/metropolice/imoutcoverme.wav","vj_hlr/hl2_npc/metropolice/coverme.wav","vj_hlr/hl2_npc/metropolice/backmeup.wav","npc/metropolice/vo/runninglowonverdicts.wav","npc/metropolice/vo/movingtocover.wav","npc/metropolice/vo/backmeupimout.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {"vj_hlr/hl2_npc/metropolice/lookout2.wav","vj_hlr/hl2_npc/metropolice/grenade2.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hl2_npc/metropolice/shiiit.wav","vj_hlr/hl2_npc/metropolice/lookout2.wav","vj_hlr/hl2_npc/metropolice/grenade2.wav","npc/metropolice/vo/watchit.wav","npc/metropolice/vo/thatsagrenade.wav","npc/metropolice/vo/takecover.wav","npc/metropolice/vo/shit.wav","npc/metropolice/vo/moveit.wav","npc/metropolice/vo/movebackrightnow.wav","npc/metropolice/vo/lookoutrogueviscerator.wav","npc/metropolice/vo/lookout.wav","npc/metropolice/vo/help.wav","npc/metropolice/vo/grenade.wav","npc/metropolice/vo/getdown.wav","npc/metropolice/vo/getoutofhere.wav"}
ENT.SoundTbl_OnDangerSight = {"vj_hlr/hl2_npc/metropolice/shiiit.wav","vj_hlr/hl2_npc/metropolice/lookout2.wav","npc/metropolice/vo/watchit.wav","npc/metropolice/vo/takecover.wav","npc/metropolice/vo/shit.wav","npc/metropolice/vo/moveit.wav","npc/metropolice/vo/lookoutrogueviscerator.wav","npc/metropolice/vo/lookout.wav","npc/metropolice/vo/help.wav","npc/metropolice/vo/getdown.wav","npc/metropolice/vo/getoutofhere.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vj_hlr/hl2_npc/metropolice/innoculate10-107.wav","vj_hlr/hl2_npc/metropolice/cleaningupnow.wav","vj_hlr/hl2_npc/metropolice/administerciviljudgement.wav","npc/metropolice/vo/assaultpointsecureadvance.wav","npc/metropolice/vo/ten97suspectisgoa.wav","npc/metropolice/vo/tag10-91d.wav","npc/metropolice/vo/protectioncomplete.wav","npc/metropolice/vo/isdown.wav","npc/metropolice/vo/gotsuspect1here.wav","npc/metropolice/vo/gotoneaccomplicehere.wav","npc/metropolice/vo/get11-44inboundcleaningup.wav","npc/metropolice/vo/dbcountis.wav","npc/metropolice/vo/chuckle.wav","npc/metropolice/vo/control100percent.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hl2_npc/metropolice/wehavenocontainment.wav","vj_hlr/hl2_npc/metropolice/cpiscompromised2.wav","vj_hlr/hl2_npc/metropolice/cpisoverrun.wav"}
ENT.SoundTbl_Pain = {"npc/metropolice/vo/minorhitscontinuing.wav","vj_hlr/hl2_npc/metropolice/officerunderfire.wav","vj_hlr/hl2_npc/metropolice/officerintrouble.wav","vj_hlr/hl2_npc/metropolice/need10-78at10-20.wav","npc/metropolice/vo/officerunderfiretakingcover.wav","npc/metropolice/vo/help.wav","npc/metropolice/knockout2.wav","npc/metropolice/pain1.wav","npc/metropolice/pain2.wav","npc/metropolice/pain3.wav","npc/metropolice/pain4.wav"}
ENT.SoundTbl_DamageByPlayer = {"npc/metropolice/vo/watchit.wav"}
ENT.SoundTbl_Death = {"npc/metropolice/die1.wav","npc/metropolice/die2.wav","npc/metropolice/die3.wav","npc/metropolice/die4.wav"}

-- Alert: Player or Freeman NPC
local sdCop_Alert_Freeman = {"npc/metropolice/vo/noncitizen.wav","npc/metropolice/vo/anticitizen.wav","npc/metropolice/vo/matchonapblikeness.wav","npc/metropolice/vo/holditrightthere.wav","vj_hlr/hl2_npc/metropolice/freemanishp.wav","vj_hlr/hl2_npc/metropolice/freemanontheloose.wav","vj_hlr/hl2_npc/metropolice/matchoncivilviolator.wav","vj_hlr/hl2_npc/metropolice/prosecuteanticitizen.wav","npc/metropolice/vo/freeman.wav"}
local sdCop_Alert_Freeman_InVehicle = {"vj_hlr/hl2_npc/metropolice/ivegot408here.wav","vj_hlr/hl2_npc/metropolice/freemanis505.wav"}
-- Alert: Citizens / Rebels
local sdCop_Alert_Citizens = {"npc/metropolice/vo/priority2anticitizenhere.wav","npc/metropolice/vo/noncitizen.wav","npc/metropolice/vo/anticitizen.wav","vj_hlr/hl2_npc/metropolice/tagonecitizen.wav","vj_hlr/hl2_npc/metropolice/hostilemalignants.wav","vj_hlr/hl2_npc/metropolice/hostilemalignantshere.wav","vj_hlr/hl2_npc/metropolice/servemalcomplianceverdict.wav"}
-- Alert: Zombies
local sdCop_Alert_Zombies = {"npc/metropolice/vo/tagoneparasitic.wav","npc/metropolice/vo/looseparasitics.wav","vj_hlr/hl2_npc/metropolice/cauterizeinfection.wav","npc/metropolice/vo/infection.wav"}
-- Alert: Creatures
local sdCop_Alert_Creatures = {"npc/metropolice/vo/outbreak.wav","vj_hlr/hl2_npc/metropolice/outlandbiotic.wav","npc/metropolice/vo/bugs.wav","npc/metropolice/vo/bugsontheloose.wav","npc/metropolice/vo/tagonenecrotic.wav","npc/metropolice/vo/tagonebug.wav","npc/metropolice/vo/necrotics.wav","npc/metropolice/vo/freenecrotics.wav","npc/metropolice/vo/infestedzone.wav"}
-- Ally death: Metrocop
local sdCop_AllyDeath_Metrocop = {"vj_hlr/hl2_npc/metropolice/officerdown.wav","vj_hlr/hl2_npc/metropolice/code3tomy10-20officerdown.wav","vj_hlr/hl2_npc/metropolice/10-99officerdown.wav","npc/metropolice/vo/officerdowncode3tomy10-20.wav","npc/metropolice/vo/officerdowniam10-99.wav"}

-- Deployment sounds
local sdCop_DeployManhack = {"vj_hlr/hl2_npc/metropolice/rogueviscerator.wav","vj_hlr/hl2_npc/metropolice/allunitsvisceratorisactive.wav","npc/metropolice/vo/visceratordeployed.wav","npc/metropolice/vo/visceratorisoc.wav","npc/metropolice/vo/visceratorisoffgrid.wav"}

/*
-- Unused MMod sounds:
"vj_hlr/hl2_npc/metropolice/allunits.wav",
"vj_hlr/hl2_npc/metropolice/area.wav",
"vj_hlr/hl2_npc/metropolice/beadvised.wav",
"vj_hlr/hl2_npc/metropolice/classifysubjectname.wav",
"vj_hlr/hl2_npc/metropolice/defendthisposition.wav",
"vj_hlr/hl2_npc/metropolice/documentcitizen.wav",
"vj_hlr/hl2_npc/metropolice/examinehardpoint.wav",
"vj_hlr/hl2_npc/metropolice/investigatemalcompliant.wav",
"vj_hlr/hl2_npc/metropolice/jurisdiction.wav",
"vj_hlr/hl2_npc/metropolice/moveaway.wav",
"vj_hlr/hl2_npc/metropolice/movenow.wav",
"vj_hlr/hl2_npc/metropolice/moverightnow.wav",
"vj_hlr/hl2_npc/metropolice/my1020is.wav",
"vj_hlr/hl2_npc/metropolice/patrolregion.wav",
"vj_hlr/hl2_npc/metropolice/patrolsector.wav",
"vj_hlr/hl2_npc/metropolice/rightnow.wav",
"vj_hlr/hl2_npc/metropolice/searchblock.wav",
"vj_hlr/hl2_npc/metropolice/servesentenceto.wav",
"vj_hlr/hl2_npc/metropolice/thisblockready.wav",
"vj_hlr/hl2_npc/metropolice/zone.wav",


-- NOTE: Number sounds aren't included here!

"npc/metropolice/hiding04.wav"
"npc/metropolice/vo/amputate.wav"
"npc/metropolice/vo/apply.wav"
"npc/metropolice/vo/block.wav"
"npc/metropolice/vo/blockisholdingcohesive.wav"
"npc/metropolice/vo/canal.wav"
"npc/metropolice/vo/canalblock.wav"
"npc/metropolice/vo/cauterize.wav"
"npc/metropolice/vo/checkformiscount.wav"
"npc/metropolice/vo/citizen.wav"
"npc/metropolice/vo/citizensummoned.wav"
"npc/metropolice/vo/classifyasdbthisblockready.wav"
"npc/metropolice/vo/code100.wav"
"npc/metropolice/vo/confirmpriority1sighted.wav"
"npc/metropolice/vo/contactwithpriority2.wav"
"npc/metropolice/vo/controlsection.wav"
"npc/metropolice/vo/defender.wav"
"npc/metropolice/vo/designatesuspectas.wav"
"npc/metropolice/vo/document.wav"
"npc/metropolice/vo/dontmove.wav"
"npc/metropolice/vo/examine.wav"
"npc/metropolice/vo/expired.wav"
"npc/metropolice/vo/externaljurisdiction.wav"
"npc/metropolice/vo/finalverdictadministered.wav"
"npc/metropolice/vo/finalwarning.wav"
"npc/metropolice/vo/firstwarningmove.wav"
"npc/metropolice/vo/hero.wav"
"npc/metropolice/vo/hesgone148.wav" -- Resisting Arrest
"npc/metropolice/vo/holdit.wav"
"npc/metropolice/vo/industrialzone.wav"
"npc/metropolice/vo/inject.wav"
"npc/metropolice/vo/innoculate.wav"
"npc/metropolice/vo/intercede.wav"
"npc/metropolice/vo/isaidmovealong.wav"
"npc/metropolice/vo/isolate.wav"
"npc/metropolice/vo/isreadytogo.wav"
"npc/metropolice/vo/jury.wav"
"npc/metropolice/vo/king.wav"
"npc/metropolice/vo/line.wav"
"npc/metropolice/vo/location.wav"
"npc/metropolice/vo/lock.wav"
"npc/metropolice/vo/lookingfortrouble.wav"
"npc/metropolice/vo/loyaltycheckfailure.wav"
"npc/metropolice/vo/meters.wav"
"npc/metropolice/vo/move.wav"
"npc/metropolice/vo/movealong.wav"
"npc/metropolice/vo/movealong3.wav"
"npc/metropolice/vo/moveit2.wav"
"npc/metropolice/vo/nowgetoutofhere.wav"
"npc/metropolice/vo/outlandzone.wav"
"npc/metropolice/vo/pickupthecan1.wav" - 3
"npc/metropolice/vo/preserve.wav"
"npc/metropolice/vo/pressure.wav"
"npc/metropolice/vo/productionblock.wav"
"npc/metropolice/vo/prosecute.wav"
"npc/metropolice/vo/ptgoagain.wav"
"npc/metropolice/vo/putitinthetrash1.wav" - 2
"npc/metropolice/vo/quick.wav"
"npc/metropolice/vo/readytoprosecutefinalwarning.wav"
"npc/metropolice/vo/repurposedarea.wav"
"npc/metropolice/vo/residentialblock.wav"
"npc/metropolice/vo/restrict.wav"
"npc/metropolice/vo/restrictedblock.wav"
"npc/metropolice/vo/roller.wav"
"npc/metropolice/vo/search.wav"
"npc/metropolice/vo/secondwarning.wav"
"npc/metropolice/vo/sector.wav"
"npc/metropolice/vo/sentencedelivered.wav"
"npc/metropolice/vo/serve.wav"
"npc/metropolice/vo/stabilizationjurisdiction.wav"
"npc/metropolice/vo/stationblock.wav"
"npc/metropolice/vo/sterilize.wav"
"npc/metropolice/vo/stick.wav"
"npc/metropolice/vo/stillgetting647e.wav"
"npc/metropolice/vo/stormsystem.wav"
"npc/metropolice/vo/tap.wav"
"npc/metropolice/vo/ten91dcountis.wav"
"npc/metropolice/vo/terminalrestrictionzone.wav"
"npc/metropolice/vo/therehegoeshesat.wav"
"npc/metropolice/vo/thisisyoursecondwarning.wav"
"npc/metropolice/vo/transitblock.wav"
"npc/metropolice/vo/union.wav"
"npc/metropolice/vo/unitis10-65.wav"
"npc/metropolice/vo/upi.wav"
"npc/metropolice/vo/vacatecitizen.wav"
"npc/metropolice/vo/vice.wav"
"npc/metropolice/vo/victor.wav"
"npc/metropolice/vo/wasteriver.wav"
"npc/metropolice/vo/wegotadbherecancel10-102.wav" -- Cruelty to animals
"npc/metropolice/vo/workforceintake.wav"
"npc/metropolice/vo/xray.wav"
"npc/metropolice/vo/yellow.wav"
"npc/metropolice/vo/youknockeditover.wav"
"npc/metropolice/vo/youwantamalcomplianceverdict.wav"
"npc/metropolice/vo/zone.wav"
*/

-- Custom
ENT.Metrocop_CanHaveManhack = true
ENT.Metrocop_AlwaysSpawnManhack = false -- Always spawn with a manhack, used for auto replace
ENT.Metrocop_HasManhack = false
ENT.Metrocop_Manhack = NULL
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- Handle manhack inventory
	if self.Metrocop_CanHaveManhack && ((math.random(1, 4) == 1) or self.Metrocop_ForceSpawnManhack) then
		self.Metrocop_HasManhack = true
		self:SetBodygroup(1, 1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Deploy Manhack (if available)")
	
	function controlEnt:CustomOnKeyPressed(key)
		if key == KEY_SPACE && self.VJCE_NPC.Metrocop_HasManhack then
			self.VJCE_NPC:Metrocop_DeployManhack()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:CustomOnAcceptInput(key, activator, caller, data)
	-- Campaign compatibility test
	if key == "SetPoliceGoal" then
		print(self, key, activator, caller, data)
		local policeEnt = ents.FindByName("ai_breakin_cop3goal2")[1]
		if IsValid(policeEnt) then
			print("------")
			function policeEnt:KeyValue(key, value)
				print(self, key, value)
			end
		end
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
local getEventName = util.GetAnimEventNameByID
--
function ENT:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	local eventName = getEventName(ev)
	if eventName == "AE_METROPOLICE_BATON_ON" && IsValid(self:GetActiveWeapon()) then
		VJ.EmitSound(self, "Weapon_StunStick.Activate")
		local effectData = EffectData()
		effectData:SetOrigin(self:GetActiveWeapon():GetAttachment(1).Pos)
		effectData:SetMagnitude(1.5)
		effectData:SetScale(0.8)
		util.Effect("Sparks", effectData)
	elseif eventName == "AE_METROPOLICE_START_DEPLOY" then
		self:SetBodygroup(1, 0)
		local prop = ents.Create("prop_vj_animatable")
		prop:SetModel("models/manhack.mdl")
		prop:SetLocalPos(self:GetPos())
		prop:SetAngles(self:GetAngles())
		prop:SetParent(self)
		prop:Spawn()
		prop:Fire("SetParentAttachment", "anim_attachment_LH", 0)
		self.Metrocop_ManhackProp = prop
	elseif eventName == "AE_METROPOLICE_DEPLOY_MANHACK" then
		self:Metrocop_SpawnManhack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_Pain, sdFile) or VJ.HasValue(self.DefaultSoundTbl_MeleeAttack, sdFile) then return end
	VJ.EmitSound(self, "npc/metropolice/vo/on"..math.random(1, 2)..".wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self, "npc/metropolice/vo/off"..math.random(1, 4)..".wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if math.random(1, 2) == 1 then
		if ent:IsPlayer() then
			self:PlaySoundSystem("Alert", ent:InVehicle() and sdCop_Alert_Freeman_InVehicle or sdCop_Alert_Freeman)
		elseif ent.VJ_HLR_Freeman then
			self:PlaySoundSystem("Alert", sdCop_Alert_Freeman) -- Same thing as above, minus in vehicle sounds
		elseif ent:IsNPC() then
			if ent.IsVJBaseSNPC_Creature then
				if math.random(1, 2) == 1 then
					for _,v in ipairs(ent.VJ_NPC_Class or {1}) do
						if v == "CLASS_ZOMBIE" or ent:Classify() == CLASS_ZOMBIE then
							self:PlaySoundSystem("Alert", sdCop_Alert_Zombies)
							return -- Skip the regular creature sounds!
						end
					end
				end
				self:PlaySoundSystem("Alert", sdCop_Alert_Creatures)
			elseif ent:Classify() == CLASS_PLAYER_ALLY or self.VJTag_ID_Civilian then
				self:PlaySoundSystem("Alert", sdCop_Alert_Citizens)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoChangeWeapon(newWeapon, oldWeapon, invSwitch)
	//if invSwitch == true then -- Only if it's a inventory switch
	-- Play the stunstick activation animation
	if newWeapon:GetClass() == "weapon_vj_hlr2_stunstick" then
		self:VJ_ACT_PLAYACTIVITY("activatebaton", true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Metrocop_DeployManhack()
	self.Metrocop_HasManhack = false
	self:VJ_ACT_PLAYACTIVITY("deploy", true, false, true)
	self:StopAllCommonSpeechSounds()
	self:PlaySoundSystem("GeneralSpeech", sdCop_DeployManhack)
	
	-- Backup in case animation cuts out and event is never ran
	timer.Simple(3, function()
		if IsValid(self) && !IsValid(self.Metrocop_Manhack) then
			self:Metrocop_SpawnManhack()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ250 = Vector(0, 0, 250)
--
function ENT:Metrocop_SpawnManhack()
	local manhack = ents.Create("npc_manhack")
	if IsValid(self.Metrocop_ManhackProp) then
		self.Metrocop_ManhackProp:Remove()
		manhack:SetPos(self.Metrocop_ManhackProp:GetPos())
		manhack:SetAngles(self.Metrocop_ManhackProp:GetAngles())
	else
		local att = self:GetAttachment(self:LookupAttachment("LHand"))
		manhack:SetPos(att.Pos)
		manhack:SetAngles(att.Ang)
	end
	manhack.VJ_NPC_Class = self.VJ_NPC_Class
	table.insert(self.VJ_AddCertainEntityAsFriendly, manhack)
	manhack:Spawn()
	manhack:GetPhysicsObject():AddVelocity(vecZ250)
	manhack:Fire("SetMaxLookDistance", self:GetMaxLookDistance())
	manhack:SetKeyValue("spawnflags", "65536")
	//manhack:SetKeyValue("spawnflags", "256")
	manhack:SetEnemy(self:GetEnemy())
	if IsValid(self:GetCreator()) then -- If it has a creator, then add it to that player's undo list
		undo.Create(self:GetName().."'s Manhack")
			undo.AddEntity(manhack)
			undo.SetPlayer(self:GetCreator())
		undo.Finish()
	end
	self.Metrocop_Manhack = manhack
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.VJ_IsBeingControlled then return end
	if self.Metrocop_HasManhack && IsValid(self:GetEnemy()) && self.LatestEnemyDistance <= 1000 && self.LatestEnemyDistance > 300 then
		self:Metrocop_DeployManhack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAllyDeath(ent)
	if math.random(1, 3) != 1  && self.VJTag_ID_Police then
		self:PlaySoundSystem("AllyDeath", sdCop_AllyDeath_Metrocop)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	-- Remove manhack if we were removed without being killed
	if !self.Dead && IsValid(self.Metrocop_Manhack) then
		self.Metrocop_Manhack:Remove()
	end
end
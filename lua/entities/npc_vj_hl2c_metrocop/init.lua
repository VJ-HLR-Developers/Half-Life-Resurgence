AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/police.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60 //GetConVarNumber("vj_dum_dummy_h")
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.MeleeAttackDamage = GetConVarNumber("vj_hl2c_soldier_d")
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK_SWING} -- Melee Attack Animations
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 500 -- How close should the player be until it runs the code?
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"npc/metropolice/vo/allunitsmaintainthiscp.wav","npc/metropolice/vo/anyonepickup647e.wav","npc/metropolice/vo/wearesociostablethislocation.wav","npc/metropolice/vo/utlsuspect.wav","npc/metropolice/vo/unitisonduty10-8.wav","npc/metropolice/vo/unitis10-8standingby.wav","npc/metropolice/vo/ten97.wav","npc/metropolice/vo/ten8standingby.wav","npc/metropolice/vo/ten2.wav","npc/metropolice/vo/standardloyaltycheck.wav","npc/metropolice/vo/sacrificecode1maintaincp.wav","npc/metropolice/vo/readytojudge.wav","npc/metropolice/vo/ptatlocationreport.wav","npc/metropolice/vo/proceedtocheckpoints.wav","npc/metropolice/vo/patrol.wav","npc/metropolice/vo/novisualonupi.wav","npc/metropolice/vo/nonpatrolregion.wav","npc/metropolice/vo/nocontact.wav","npc/metropolice/vo/localcptreportstatus.wav","npc/metropolice/vo/keepmoving.wav","npc/metropolice/vo/ispassive.wav","npc/metropolice/vo/isathardpointreadytoprosecute.wav","npc/metropolice/vo/inpositiononeready.wav","npc/metropolice/vo/inpositionathardpoint.wav","npc/metropolice/vo/inposition.wav","npc/metropolice/vo/holdthisposition.wav","npc/metropolice/vo/holdingon10-14duty.wav","npc/metropolice/vo/dispupdatingapb.wav","npc/metropolice/vo/cpweneedtoestablishaperimeterat.wav","npc/metropolice/vo/cprequestsallunitsreportin.wav","npc/metropolice/vo/atcheckpoint.wav","npc/metropolice/vo/clearandcode100.wav","npc/metropolice/vo/code7.wav"}
ENT.SoundTbl_CombatIdle = {"npc/metropolice/vo/unitreportinwith10-25suspect.wav","npc/metropolice/vo/tenzerovisceratorishunting.wav","npc/metropolice/vo/teaminpositionadvance.wav","npc/metropolice/vo/requestsecondaryviscerator.wav","npc/metropolice/vo/readytoamputate.wav","npc/metropolice/vo/preparingtojudge10-107.wav","npc/metropolice/vo/preparefor1015.wav","npc/metropolice/vo/positiontocontain.wav","npc/metropolice/vo/outlandbioticinhere.wav","npc/metropolice/vo/movingtohardpoint2.wav","npc/metropolice/vo/movingtohardpoint.wav","npc/metropolice/vo/movetoarrestpositions.wav","npc/metropolice/vo/malcompliant10107my1020.wav","npc/metropolice/vo/lockyourposition.wav","npc/metropolice/vo/issuingmalcompliantcitation.wav","npc/metropolice/vo/ismovingin.wav","npc/metropolice/vo/isgo.wav","npc/metropolice/vo/is415b.wav","npc/metropolice/vo/interlock.wav","npc/metropolice/vo/ihave10-30my10-20responding.wav","npc/metropolice/vo/highpriorityregion.wav","npc/metropolice/vo/hardpointscanning.wav","npc/metropolice/vo/establishnewcp.wav","npc/metropolice/vo/distributionblock.wav","npc/metropolice/vo/dispreportssuspectincursion.wav","npc/metropolice/vo/deservicedarea.wav","npc/metropolice/vo/cpbolforthat243.wav","npc/metropolice/vo/converging.wav","npc/metropolice/vo/airwatchsubjectis505.wav","npc/metropolice/vo/allunitscloseonsuspect.wav","npc/metropolice/vo/allunitsmovein.wav","npc/metropolice/vo/allunitsreportlocationsuspect.wav"}
ENT.SoundTbl_OnReceiveOrder = {"npc/metropolice/vo/ten4.wav","npc/metropolice/vo/rodgerthat.wav","npc/metropolice/vo/responding2.wav","npc/metropolice/vo/readytoprosecute.wav","npc/metropolice/vo/copy.wav","npc/metropolice/vo/affirmative.wav","npc/metropolice/vo/affirmative2.wav"}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {"npc/metropolice/vo/freeman.wav"}
ENT.SoundTbl_Investigate = {"npc/metropolice/vo/sweepingforsuspect.wav","npc/metropolice/vo/searchingforsuspect.wav","npc/metropolice/vo/possible647erequestairwatch.wav","npc/metropolice/vo/possible404here.wav","npc/metropolice/vo/possible10-103alerttagunits.wav","npc/metropolice/vo/pickingupnoncorplexindy.wav","npc/metropolice/vo/investigating10-103.wav","npc/metropolice/vo/investigate.wav","npc/metropolice/vo/goingtotakealook.wav","npc/metropolice/vo/allunitscode2.wav"}
ENT.SoundTbl_Alert = {"npc/metropolice/vo/wehavea10-108.wav","npc/metropolice/vo/tagonebug.wav","npc/metropolice/vo/subject.wav","npc/metropolice/vo/sociocide.wav","npc/metropolice/vo/shotsfiredhostilemalignants.wav","npc/metropolice/vo/reportsightingsaccomplices.wav","npc/metropolice/vo/priority2anticitizenhere.wav","npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav","npc/metropolice/vo/noncitizen.wav","npc/metropolice/vo/non-taggedviromeshere.wav","npc/metropolice/vo/malignant.wav","npc/metropolice/vo/looseparasitics.wav","npc/metropolice/vo/level3civilprivacyviolator.wav","npc/metropolice/vo/is10-108.wav","npc/metropolice/vo/hesupthere.wav","npc/metropolice/vo/dispatchineed10-78.wav","npc/metropolice/vo/criminaltrespass63.wav","npc/metropolice/vo/contactwith243suspect.wav","npc/metropolice/vo/confirmadw.wav","npc/metropolice/vo/condemnedzone.wav","npc/metropolice/vo/allunitsrespondcode3.wav","npc/metropolice/vo/bugs.wav","npc/metropolice/vo/bugsontheloose.wav"}
ENT.SoundTbl_CallForHelp = {"npc/metropolice/vo/reinforcementteamscode3.wav","npc/metropolice/vo/officerneedshelp.wav","npc/metropolice/vo/officerneedsassistance.wav","npc/metropolice/vo/needanyhelpwiththisone.wav","npc/metropolice/vo/ivegot408hereatlocation.wav","npc/metropolice/vo/hesupthere.wav","npc/metropolice/vo/gothimagainsuspect10-20at.wav","npc/metropolice/vo/gota10-107sendairwatch.wav","npc/metropolice/vo/dispatchineed10-78.wav","npc/metropolice/vo/backup.wav","npc/metropolice/vo/cpiscompromised.wav","npc/metropolice/vo/cpisoverrunwehavenocontainment.wav"}
ENT.SoundTbl_BecomeEnemyToPlayer = {}
ENT.SoundTbl_Suppressing = {"npc/metropolice/vo/thereheis.wav","npc/metropolice/vo/prepareforjudgement.wav","npc/metropolice/vo/pacifying.wav","npc/metropolice/vo/isclosingonsuspect.wav","npc/metropolice/vo/hesrunning.wav","npc/metropolice/vo/five.wav","npc/metropolice/vo/firingtoexposetarget.wav","npc/metropolice/vo/firetodislocateinterpose.wav","npc/metropolice/vo/dismountinghardpoint.wav","npc/metropolice/vo/destroythatcover.wav","npc/metropolice/vo/cpisoverrunwehavenocontainment.wav","npc/metropolice/vo/breakhiscover.wav","npc/metropolice/vo/covermegoingin.wav"}
ENT.SoundTbl_WeaponReload = {"npc/metropolice/vo/runninglowonverdicts.wav","npc/metropolice/vo/movingtocover.wav","npc/metropolice/vo/backmeupimout.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {}
ENT.SoundTbl_OnGrenadeSight = {"npc/metropolice/vo/watchit.wav","npc/metropolice/vo/thatsagrenade.wav","npc/metropolice/vo/takecover.wav","npc/metropolice/vo/shit.wav","npc/metropolice/vo/moveit.wav","npc/metropolice/vo/movebackrightnow.wav","npc/metropolice/vo/lookoutrogueviscerator.wav","npc/metropolice/vo/lookout.wav","npc/metropolice/vo/help.wav","npc/metropolice/vo/grenade.wav","npc/metropolice/vo/getdown.wav","npc/metropolice/vo/getoutofhere.wav"}
ENT.SoundTbl_OnKilledEnemy = {"npc/metropolice/vo/assaultpointsecureadvance.wav","npc/metropolice/vo/ten97suspectisgoa.wav","npc/metropolice/vo/tag10-91d.wav","npc/metropolice/vo/protectioncomplete.wav","npc/metropolice/vo/isdown.wav","npc/metropolice/vo/gotsuspect1here.wav","npc/metropolice/vo/gotoneaccomplicehere.wav","npc/metropolice/vo/get11-44inboundcleaningup.wav","npc/metropolice/vo/dbcountis.wav","npc/metropolice/vo/chuckle.wav","npc/metropolice/vo/control100percent.wav"}
ENT.SoundTbl_Pain = {"npc/metropolice/vo/officerunderfiretakingcover.wav","npc/metropolice/vo/necrotics.wav","npc/metropolice/vo/help.wav","npc/metropolice/vo/freenecrotics.wav","npc/metropolice/knockout2.wav","npc/metropolice/pain1.wav","npc/metropolice/pain2.wav","npc/metropolice/pain3.wav","npc/metropolice/pain4.wav"}
ENT.SoundTbl_DamageByPlayer = {"npc/metropolice/vo/watchit.wav"}
ENT.SoundTbl_Death = {"npc/metropolice/die1.wav","npc/metropolice/die2.wav","npc/metropolice/die3.wav","npc/metropolice/die4.wav"}

/*
-- All numbers have not been included!

"npc/metropolice/vo/amputate.wav"
"npc/metropolice/vo/anticitizen.wav"
"npc/metropolice/vo/apply.wav"
"npc/metropolice/vo/block.wav"
"npc/metropolice/vo/blockisholdingcohesive.wav"
"npc/metropolice/vo/canal.wav"
"npc/metropolice/vo/canalblock.wav"
"npc/metropolice/vo/catchthatbliponstabilization.wav"
"npc/metropolice/vo/cauterize.wav"
"npc/metropolice/vo/checkformiscount.wav"
"npc/metropolice/vo/citizen.wav"
"npc/metropolice/vo/citizensummoned.wav"
"npc/metropolice/vo/classifyasdbthisblockready.wav"
"npc/metropolice/vo/clearno647no10-107.wav"
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
"npc/metropolice/vo/hesgone148.wav"
"npc/metropolice/vo/hidinglastseenatrange.wav"
"npc/metropolice/vo/holdit.wav"
"npc/metropolice/vo/holditrightthere.wav"
"npc/metropolice/vo/industrialzone.wav"
"npc/metropolice/vo/infection.wav"
"npc/metropolice/vo/infestedzone.wav"
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
"npc/metropolice/vo/matchonapblikeness.wav"
"npc/metropolice/vo/meters.wav"
"npc/metropolice/vo/minorhitscontinuing.wav"
"npc/metropolice/vo/move.wav"
"npc/metropolice/vo/movealong.wav"
"npc/metropolice/vo/movealong3.wav"
"npc/metropolice/vo/moveit2.wav"
"npc/metropolice/vo/nowgetoutofhere.wav"
"npc/metropolice/vo/outbreak.wav"
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
"npc/metropolice/vo/tagonenecrotic.wav"
"npc/metropolice/vo/tagoneparasitic.wav"
"npc/metropolice/vo/tap.wav"
"npc/metropolice/vo/ten91dcountis.wav"
"npc/metropolice/vo/terminalrestrictionzone.wav"
"npc/metropolice/vo/therehegoeshesat.wav"
"npc/metropolice/vo/thisisyoursecondwarning.wav"
"npc/metropolice/vo/transitblock.wav"
"npc/metropolice/vo/union.wav"
"npc/metropolice/vo/unitis10-65.wav"
"npc/metropolice/vo/unlawfulentry603.wav"
"npc/metropolice/vo/upi.wav"
"npc/metropolice/vo/utlthatsuspect.wav"
"npc/metropolice/vo/vacatecitizen.wav"
"npc/metropolice/vo/vice.wav"
"npc/metropolice/vo/victor.wav"
"npc/metropolice/vo/wasteriver.wav"
"npc/metropolice/vo/wegotadbherecancel10-102.wav"
"npc/metropolice/vo/workforceintake.wav"
"npc/metropolice/vo/xray.wav"
"npc/metropolice/vo/yellow.wav"
"npc/metropolice/vo/youknockeditover.wav"
"npc/metropolice/vo/youwantamalcomplianceverdict.wav"
"npc/metropolice/vo/zone.wav"

-- Manhack deploy
"npc/metropolice/vo/visceratordeployed.wav"
"npc/metropolice/vo/visceratorisoc.wav"
"npc/metropolice/vo/visceratorisoffgrid.wav"

-- Man Down
"npc/metropolice/vo/officerdowncode3tomy10-20.wav"
"npc/metropolice/vo/officerdowniam10-99.wav"

"npc/metropolice/vo/off1.wav" - 4
"npc/metropolice/vo/on1.wav" - 2
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	if VJ_HasValue(self.SoundTbl_Pain,SoundFile) or VJ_HasValue(self.DefaultSoundTbl_MeleeAttack,SoundFile) then return end
	VJ_EmitSound(self,"npc/metropolice/vo/on"..math.random(1,2)..".wav")
	timer.Simple(SoundDuration(SoundFile),function() if IsValid(self) && SoundData:IsPlaying() then VJ_EmitSound(self,"npc/metropolice/vo/off"..math.random(1,4)..".wav") end end)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
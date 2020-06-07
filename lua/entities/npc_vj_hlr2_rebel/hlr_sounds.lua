AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:HLR_ApplyMaleSounds()
	self.SoundTbl_Idle = {
		"vo/npc/male01/vanswer14.wav",
	}
	self.SoundTbl_IdleDialogue = {
		"vo/npc/male01/doingsomething.wav",
		"vo/npc/male01/getgoingsoon.wav",
		"vo/npc/male01/question01.wav",
		"vo/npc/male01/question02.wav",
		"vo/npc/male01/question03.wav",
		"vo/npc/male01/question04.wav",
		"vo/npc/male01/question05.wav",
		"vo/npc/male01/question06.wav",
		"vo/npc/male01/question07.wav",
		"vo/npc/male01/question08.wav",
		"vo/npc/male01/question09.wav",
		"vo/npc/male01/question10.wav",
		"vo/npc/male01/question11.wav",
		"vo/npc/male01/question12.wav",
		"vo/npc/male01/question13.wav",
		"vo/npc/male01/question14.wav",
		"vo/npc/male01/question15.wav",
		"vo/npc/male01/question16.wav",
		"vo/npc/male01/question17.wav",
		"vo/npc/male01/question18.wav",
		"vo/npc/male01/question19.wav",
		"vo/npc/male01/question20.wav",
		"vo/npc/male01/question21.wav",
		"vo/npc/male01/question22.wav",
		"vo/npc/male01/question23.wav",
		"vo/npc/male01/question25.wav",
		"vo/npc/male01/question26.wav",
		"vo/npc/male01/question27.wav",
		"vo/npc/male01/question28.wav",
		"vo/npc/male01/question29.wav",
		"vo/npc/male01/question30.wav",
		"vo/npc/male01/question31.wav",
		"vo/npc/male01/vquestion01.wav",
		"vo/npc/male01/vquestion02.wav",
		"vo/npc/male01/vquestion04.wav",
	}
	self.SoundTbl_IdleDialogueAnswer = {
		"vo/npc/male01/answer01.wav",
		"vo/npc/male01/answer02.wav",
		"vo/npc/male01/answer03.wav",
		"vo/npc/male01/answer04.wav",
		"vo/npc/male01/answer05.wav",
		"vo/npc/male01/answer07.wav",
		"vo/npc/male01/answer08.wav",
		"vo/npc/male01/answer09.wav",
		"vo/npc/male01/answer10.wav",
		"vo/npc/male01/answer11.wav",
		"vo/npc/male01/answer12.wav",
		"vo/npc/male01/answer13.wav",
		"vo/npc/male01/answer14.wav",
		"vo/npc/male01/answer15.wav",
		"vo/npc/male01/answer16.wav",
		"vo/npc/male01/answer17.wav",
		"vo/npc/male01/answer18.wav",
		"vo/npc/male01/answer19.wav",
		"vo/npc/male01/answer20.wav",
		"vo/npc/male01/answer21.wav",
		"vo/npc/male01/answer22.wav",
		"vo/npc/male01/answer23.wav",
		"vo/npc/male01/answer25.wav",
		"vo/npc/male01/answer26.wav",
		"vo/npc/male01/answer27.wav",
		"vo/npc/male01/answer28.wav",
		"vo/npc/male01/answer29.wav",
		"vo/npc/male01/answer30.wav",
		"vo/npc/male01/answer31.wav",
		"vo/npc/male01/answer32.wav",
		"vo/npc/male01/answer33.wav",
		"vo/npc/male01/answer34.wav",
		"vo/npc/male01/answer35.wav",
		"vo/npc/male01/answer36.wav",
		"vo/npc/male01/answer37.wav",
		"vo/npc/male01/answer38.wav",
		"vo/npc/male01/answer39.wav",
		"vo/npc/male01/answer40.wav",
		"vo/npc/male01/vanswer01.wav",
		"vo/npc/male01/vanswer04.wav",
		"vo/npc/male01/vanswer08.wav",
		"vo/npc/male01/vanswer13.wav",
	}
	self.SoundTbl_CombatIdle = {
		"vo/npc/male01/letsgo01.wav",
		"vo/npc/male01/letsgo02.wav",
		"vo/npc/male01/squad_affirm05.wav",
		"vo/npc/male01/squad_affirm06.wav",
	}
	self.SoundTbl_OnReceiveOrder = {
		"vo/npc/male01/ok01.wav",
		"vo/npc/male01/ok02.wav",
		"vo/npc/male01/squad_approach02.wav",
		"vo/npc/male01/squad_approach03.wav",
		"vo/npc/male01/squad_approach04.wav",
	}
	self.SoundTbl_FollowPlayer = {
		"vo/npc/male01/leadon01.wav",
		"vo/npc/male01/leadon02.wav",
		"vo/npc/male01/leadtheway01.wav",
		"vo/npc/male01/leadtheway02.wav",
		"vo/npc/male01/okimready01.wav",
		"vo/npc/male01/okimready02.wav",
		"vo/npc/male01/okimready03.wav",
		"vo/npc/male01/readywhenyouare01.wav",
		"vo/npc/male01/readywhenyouare02.wav",
		"vo/npc/male01/squad_affirm01.wav",
		"vo/npc/male01/squad_affirm02.wav",
		"vo/npc/male01/squad_affirm03.wav",
		"vo/npc/male01/squad_affirm04.wav",
		"vo/npc/male01/squad_affirm07.wav",
		"vo/npc/male01/squad_affirm08.wav",
		"vo/npc/male01/squad_affirm09.wav",
		"vo/npc/male01/squad_follow03.wav",
		"vo/npc/male01/squad_train01.wav",
		"vo/npc/male01/squad_train02.wav",
		"vo/npc/male01/squad_train03.wav",
		"vo/npc/male01/squad_train04.wav",
		"vo/npc/male01/yougotit02.wav",
	}
	self.SoundTbl_UnFollowPlayer = {
		"vo/npc/male01/holddownspot01.wav",
		"vo/npc/male01/holddownspot02.wav",
		"vo/npc/male01/illstayhere01.wav",
		"vo/npc/male01/imstickinghere01.wav",
		"vo/npc/male01/littlecorner01.wav",
	}
	self.SoundTbl_MoveOutOfPlayersWay = {
		"vo/npc/male01/excuseme01.wav",
		"vo/npc/male01/excuseme02.wav",
		"vo/npc/male01/outofyourway02.wav",
		"vo/npc/male01/pardonme01.wav",
		"vo/npc/male01/pardonme02.wav",
		"vo/npc/male01/sorry01.wav",
		"vo/npc/male01/sorry02.wav",
		"vo/npc/male01/sorry03.wav",
		"vo/npc/male01/sorrydoc01.wav",
		"vo/npc/male01/sorrydoc02.wav",
		"vo/npc/male01/sorrydoc04.wav",
		"vo/npc/male01/sorryfm01.wav",
		"vo/npc/male01/sorryfm02.wav",
		"vo/npc/male01/whoops01.wav",
	}
	self.SoundTbl_MedicBeforeHeal = {
		"vo/npc/male01/health01.wav",
		"vo/npc/male01/health02.wav",
		"vo/npc/male01/health03.wav",
		"vo/npc/male01/health04.wav",
		"vo/npc/male01/health05.wav"
	}
	self.SoundTbl_MedicAfterHeal = {}
	self.SoundTbl_MedicReceiveHeal = {}
	self.SoundTbl_OnPlayerSight = {
		"vo/npc/male01/abouttime01.wav",
		"vo/npc/male01/abouttime02.wav",
		"vo/npc/male01/ahgordon01.wav",
		"vo/npc/male01/ahgordon02.wav",
		"vo/npc/male01/docfreeman01.wav",
		"vo/npc/male01/docfreeman02.wav",
		"vo/npc/male01/freeman.wav",
		"vo/npc/male01/hellodrfm01.wav",
		"vo/npc/male01/hellodrfm02.wav",
		"vo/npc/male01/heydoc01.wav",
		"vo/npc/male01/heydoc02.wav",
		"vo/npc/male01/hi01.wav",
		"vo/npc/male01/hi02.wav",
		"vo/npc/male01/squad_greet01.wav",
		"vo/npc/male01/squad_greet04.wav",
	}
	self.SoundTbl_Investigate = {
		"vo/npc/male01/startle01.wav",
		"vo/npc/male01/startle02.wav",
	}
	self.SoundTbl_LostEnemy = {}
	self.SoundTbl_Alert = {
		"vo/npc/male01/headsup01.wav",
		"vo/npc/male01/headsup02.wav",
		"vo/npc/male01/heretheycome01.wav",
		"vo/npc/male01/incoming02.wav",
		"vo/npc/male01/overhere01.wav",
		"vo/npc/male01/overthere01.wav",
		"vo/npc/male01/overthere02.wav",
		"vo/npc/male01/squad_away02.wav",
		"vo/npc/male01/upthere01.wav",
		"vo/npc/male01/upthere02.wav",
	}
	self.SoundTbl_CallForHelp = {
		"vo/npc/male01/help01.wav",
	}
	self.SoundTbl_BecomeEnemyToPlayer = {
		"vo/npc/male01/heretohelp01.wav",
		"vo/npc/male01/heretohelp02.wav",
		"vo/npc/male01/notthemanithought01.wav",
		"vo/npc/male01/notthemanithought02.wav",
		"vo/npc/male01/wetrustedyou01.wav",
		"vo/npc/male01/wetrustedyou02.wav",
	}
	self.SoundTbl_Suppressing = {}
	self.SoundTbl_WeaponReload = {
		"vo/npc/male01/coverwhilereload01.wav",
		"vo/npc/male01/coverwhilereload02.wav",
		"vo/npc/male01/gottareload01.wav",
	}
	self.SoundTbl_BeforeMeleeAttack = {}
	self.SoundTbl_MeleeAttack = {}
	self.SoundTbl_MeleeAttackExtra = {}
	self.SoundTbl_MeleeAttackMiss = {}
	self.SoundTbl_GrenadeAttack = {}
	self.SoundTbl_OnGrenadeSight = {
		"vo/npc/male01/getdown02.wav",
		"vo/npc/male01/gethellout.wav",
		"vo/npc/male01/runforyourlife01.wav",
		"vo/npc/male01/runforyourlife02.wav",
		"vo/npc/male01/runforyourlife03.wav",
		"vo/npc/male01/strider_run.wav",
		"vo/npc/male01/takecover02.wav",
		"vo/npc/male01/uhoh.wav",
		"vo/npc/male01/watchout.wav",
	}
	self.SoundTbl_OnKilledEnemy = {
		"vo/npc/male01/gotone01.wav",
		"vo/npc/male01/gotone02.wav",
		"vo/npc/male01/nice.wav",
		"vo/npc/male01/ohno.wav",
		"vo/npc/male01/yeah02.wav",
	}
	self.SoundTbl_AllyDeath = {
		"vo/npc/male01/goodgod.wav",
		"vo/npc/male01/likethat.wav",
		"vo/npc/male01/no01.wav",
		"vo/npc/male01/no02.wav",
	}
	self.SoundTbl_Pain = {
		"vo/npc/male01/imhurt01.wav",
		"vo/npc/male01/imhurt02.wav",
		"vo/npc/male01/ow01.wav",
		"vo/npc/male01/ow02.wav",
		"vo/npc/male01/pain01.wav",
		"vo/npc/male01/pain02.wav",
		"vo/npc/male01/pain03.wav",
		"vo/npc/male01/pain04.wav",
		"vo/npc/male01/pain05.wav",
		"vo/npc/male01/pain06.wav",
	}
	self.SoundTbl_DamageByPlayer = {
		"vo/npc/male01/onyourside.wav",
		"vo/npc/male01/stopitfm.wav",
		"vo/npc/male01/watchwhat.wav",
	}
	self.SoundTbl_Death = {
		"vo/npc/male01/pain07.wav",
		"vo/npc/male01/pain08.wav",
		"vo/npc/male01/pain09.wav"
	}

	--[[ CUSTOM CODE

	-- Detect Zombie
	vo/npc/male01/zombies01.wav
	vo/npc/male01/zombies02.wav

	-- Detect headcrab
	vo/npc/male01/headcrabs01.wav
	vo/npc/male01/headcrabs02.wav

	-- Detect metrocops
	vo/npc/male01/civilprotection01.wav
	vo/npc/male01/civilprotection02.wav
	vo/npc/male01/cps01.wav
	vo/npc/male01/cps02.wav

	-- Detect combine
	vo/npc/male01/combine01.wav
	vo/npc/male01/combine02.wav

	-- Detect Gunship
	vo/npc/male01/gunship02.wav

	-- Detect manhack
	vo/npc/male01/hacks01.wav
	vo/npc/male01/hacks02.wav
	vo/npc/male01/herecomehacks01.wav
	vo/npc/male01/herecomehacks02.wav
	vo/npc/male01/itsamanhack01.wav
	vo/npc/male01/itsamanhack02.wav
	vo/npc/male01/thehacks01.wav
	vo/npc/male01/thehacks02.wav

	-- Detect scanner
	vo/npc/male01/scanners01.wav
	vo/npc/male01/scanners02.wav

	-- Detect Strider
	vo/npc/male01/strider.wav

	-- Taking out RPG
	vo/npc/male01/evenodds.wav

	-- PAIN: Hit gut
	vo/npc/male01/hitingut01.wav
	vo/npc/male01/hitingut02.wav
	vo/npc/male01/mygut02.wav

	-- PAIN: Hit arm
	vo/npc/male01/myarm01.wav
	vo/npc/male01/myarm02.wav

	-- PAIN: Hit leg
	vo/npc/male01/myleg01.wav
	vo/npc/male01/myleg02.wav

	]]--


	--[[ UNUSED

	-- Alert player of danger
	vo/npc/male01/lookoutfm01.wav
	vo/npc/male01/lookoutfm02.wav
	vo/npc/male01/behindyou01.wav
	vo/npc/male01/behindyou02.wav

	-- Player died
	vo/npc/male01/gordead_ans01.wav		1 - 20
	vo/npc/male01/gordead_ques01.wav	1 - 17

	-- Give player ammo
	vo/npc/male01/ammo01.wav	1 - 5

	-- Player needs to reload
	vo/npc/male01/dontforgetreload01.wav
	vo/npc/male01/reloadfm01.wav
	vo/npc/male01/reloadfm01.wav
	vo/npc/male01/youdbetterreload01.wav

	-- Pick-up weapon
	vo/npc/male01/fantastic01.wav
	vo/npc/male01/fantastic02.wav
	vo/npc/male01/evenodds.wav	-- Also in "Taking out RPG"
	vo/npc/male01/finally.wav
	vo/npc/male01/nice.wav
	vo/npc/male01/oneforme.wav
	vo/npc/male01/thislldonicely01.wav

	-- Vortigaunt Answer and Question
	vo/npc/male01/vanswer02.wav
	vo/npc/male01/vanswer03.wav
	vo/npc/male01/vanswer05.wav
	vo/npc/male01/vanswer06.wav
	vo/npc/male01/vanswer07.wav
	vo/npc/male01/vanswer09.wav
	vo/npc/male01/vanswer10.wav
	vo/npc/male01/vanswer11.wav
	vo/npc/male01/vanswer12.wav
	"vo/npc/male01/vquestion03.wav",
	vo/npc/male01/vquestion05.wav
	vo/npc/male01/vquestion06.wav
	vo/npc/male01/vquestion07.wav

	-- Follow player not moving
	vo/npc/male01/waitingsomebody.wav

	vo/npc/male01/busy02.wav
	vo/npc/male01/cit_dropper01.wav
	vo/npc/male01/cit_dropper04.wav

	vo/npc/male01/moan01.wav	 1 - 5

	vo/npc/male01/squad_approach01.wav
	vo/npc/male01/squad_away01.wav
	vo/npc/male01/squad_away03.wav
	vo/npc/male01/squad_follow01.wav
	vo/npc/male01/squad_follow02.wav
	vo/npc/male01/squad_follow04.wav
	"vo/npc/male01/squad_greet02.wav",
	vo/npc/male01/squad_reinforce_group01.wav	1 - 4
	vo/npc/male01/squad_reinforce_single01.wav	1 - 4
	]]--
end

function ENT:HLR_ApplyFemaleSounds()
	self.SoundTbl_Idle = {
		"vo/npc/female01/vanswer14.wav",
	}
	self.SoundTbl_IdleDialogue = {
		"vo/npc/female01/doingsomething.wav",
		"vo/npc/female01/getgoingsoon.wav",
		"vo/npc/female01/question01.wav",
		"vo/npc/female01/question02.wav",
		"vo/npc/female01/question03.wav",
		"vo/npc/female01/question04.wav",
		"vo/npc/female01/question05.wav",
		"vo/npc/female01/question06.wav",
		"vo/npc/female01/question07.wav",
		"vo/npc/female01/question08.wav",
		"vo/npc/female01/question09.wav",
		"vo/npc/female01/question10.wav",
		"vo/npc/female01/question11.wav",
		"vo/npc/female01/question12.wav",
		"vo/npc/female01/question13.wav",
		"vo/npc/female01/question14.wav",
		"vo/npc/female01/question15.wav",
		"vo/npc/female01/question16.wav",
		"vo/npc/female01/question17.wav",
		"vo/npc/female01/question18.wav",
		"vo/npc/female01/question19.wav",
		"vo/npc/female01/question20.wav",
		"vo/npc/female01/question21.wav",
		"vo/npc/female01/question22.wav",
		"vo/npc/female01/question23.wav",
		"vo/npc/female01/question25.wav",
		"vo/npc/female01/question26.wav",
		"vo/npc/female01/question27.wav",
		"vo/npc/female01/question28.wav",
		"vo/npc/female01/question29.wav",
		"vo/npc/female01/question30.wav",
		"vo/npc/female01/question31.wav",
		"vo/npc/female01/vquestion01.wav",
		"vo/npc/female01/vquestion02.wav",
		"vo/npc/female01/vquestion04.wav",
	}
	self.SoundTbl_IdleDialogueAnswer = {
		"vo/npc/female01/answer01.wav",
		"vo/npc/female01/answer02.wav",
		"vo/npc/female01/answer03.wav",
		"vo/npc/female01/answer04.wav",
		"vo/npc/female01/answer05.wav",
		"vo/npc/female01/answer07.wav",
		"vo/npc/female01/answer08.wav",
		"vo/npc/female01/answer09.wav",
		"vo/npc/female01/answer10.wav",
		"vo/npc/female01/answer11.wav",
		"vo/npc/female01/answer12.wav",
		"vo/npc/female01/answer13.wav",
		"vo/npc/female01/answer14.wav",
		"vo/npc/female01/answer15.wav",
		"vo/npc/female01/answer16.wav",
		"vo/npc/female01/answer17.wav",
		"vo/npc/female01/answer18.wav",
		"vo/npc/female01/answer19.wav",
		"vo/npc/female01/answer20.wav",
		"vo/npc/female01/answer21.wav",
		"vo/npc/female01/answer22.wav",
		"vo/npc/female01/answer23.wav",
		"vo/npc/female01/answer25.wav",
		"vo/npc/female01/answer26.wav",
		"vo/npc/female01/answer27.wav",
		"vo/npc/female01/answer28.wav",
		"vo/npc/female01/answer29.wav",
		"vo/npc/female01/answer30.wav",
		"vo/npc/female01/answer31.wav",
		"vo/npc/female01/answer32.wav",
		"vo/npc/female01/answer33.wav",
		"vo/npc/female01/answer34.wav",
		"vo/npc/female01/answer35.wav",
		"vo/npc/female01/answer36.wav",
		"vo/npc/female01/answer37.wav",
		"vo/npc/female01/answer38.wav",
		"vo/npc/female01/answer39.wav",
		"vo/npc/female01/answer40.wav",
		"vo/npc/female01/squad_affirm03.wav",
		"vo/npc/female01/vanswer01.wav",
		"vo/npc/female01/vanswer04.wav",
		"vo/npc/female01/vanswer08.wav",
		"vo/npc/female01/vanswer13.wav",
	}
	self.SoundTbl_CombatIdle = {
		"vo/npc/female01/squad_affirm05.wav",
		"vo/npc/female01/squad_affirm06.wav",
	}
	self.SoundTbl_OnReceiveOrder = {
		"vo/npc/female01/ok01.wav",
		"vo/npc/female01/ok02.wav",
		"vo/npc/female01/squad_approach02.wav",
		"vo/npc/female01/squad_approach03.wav",
		"vo/npc/female01/squad_approach04.wav",
	}
	self.SoundTbl_FollowPlayer = {
		"vo/npc/female01/leadon01.wav",
		"vo/npc/female01/leadon02.wav",
		"vo/npc/female01/leadtheway01.wav",
		"vo/npc/female01/leadtheway02.wav",
		"vo/npc/female01/letsgo01.wav",
		"vo/npc/female01/letsgo02.wav",
		"vo/npc/female01/okimready01.wav",
		"vo/npc/female01/okimready02.wav",
		"vo/npc/female01/okimready03.wav",
		"vo/npc/female01/readywhenyouare01.wav",
		"vo/npc/female01/readywhenyouare02.wav",
		"vo/npc/female01/squad_affirm01.wav",
		"vo/npc/female01/squad_affirm02.wav",
		"vo/npc/female01/squad_affirm03.wav",
		"vo/npc/female01/squad_affirm04.wav",
		"vo/npc/female01/squad_affirm07.wav",
		"vo/npc/female01/squad_affirm08.wav",
		"vo/npc/female01/squad_affirm09.wav",
		"vo/npc/female01/squad_follow03.wav",
		"vo/npc/female01/squad_train01.wav",
		"vo/npc/female01/squad_train02.wav",
		"vo/npc/female01/squad_train03.wav",
		"vo/npc/female01/squad_train04.wav",
		"vo/npc/female01/yougotit02.wav",
	}
	self.SoundTbl_UnFollowPlayer = {
		"vo/npc/female01/holddownspot01.wav",
		"vo/npc/female01/holddownspot02.wav",
		"vo/npc/female01/illstayhere01.wav",
		"vo/npc/female01/imstickinghere01.wav",
		"vo/npc/female01/littlecorner01.wav",
	}
	self.SoundTbl_MoveOutOfPlayersWay = {
		"vo/npc/female01/excuseme01.wav",
		"vo/npc/female01/excuseme02.wav",
		"vo/npc/female01/outofyourway02.wav",
		"vo/npc/female01/pardonme01.wav",
		"vo/npc/female01/pardonme02.wav",
		"vo/npc/female01/sorry01.wav",
		"vo/npc/female01/sorry02.wav",
		"vo/npc/female01/sorry03.wav",
		"vo/npc/female01/sorrydoc01.wav",
		"vo/npc/female01/sorrydoc02.wav",
		"vo/npc/female01/sorrydoc04.wav",
		"vo/npc/female01/sorryfm01.wav",
		"vo/npc/female01/sorryfm02.wav",
		"vo/npc/female01/whoops01.wav",
	}
	self.SoundTbl_MedicBeforeHeal = {
		"vo/npc/female01/health01.wav",
		"vo/npc/female01/health02.wav",
		"vo/npc/female01/health03.wav",
		"vo/npc/female01/health04.wav",
		"vo/npc/female01/health05.wav",
	}
	self.SoundTbl_MedicAfterHeal = {}
	self.SoundTbl_MedicReceiveHeal = {}
	self.SoundTbl_OnPlayerSight = {
		"vo/npc/female01/abouttime01.wav",
		"vo/npc/female01/abouttime02.wav",
		"vo/npc/female01/ahgordon01.wav",
		"vo/npc/female01/ahgordon02.wav",
		"vo/npc/female01/docfreeman01.wav",
		"vo/npc/female01/docfreeman02.wav",
		"vo/npc/female01/freeman.wav",
		"vo/npc/female01/hellodrfm01.wav",
		"vo/npc/female01/hellodrfm02.wav",
		"vo/npc/female01/heydoc01.wav",
		"vo/npc/female01/heydoc02.wav",
		"vo/npc/female01/hi01.wav",
		"vo/npc/female01/hi02.wav",
		"vo/npc/female01/squad_greet01.wav",
		"vo/npc/female01/squad_greet04.wav",
	}
	self.SoundTbl_Investigate = {
		"vo/npc/female01/startle01.wav",
		"vo/npc/female01/startle02.wav",
	}
	self.SoundTbl_LostEnemy = {}
	self.SoundTbl_Alert = {
		"vo/npc/female01/headsup01.wav",
		"vo/npc/female01/headsup02.wav",
		"vo/npc/female01/heretheycome01.wav",
		"vo/npc/female01/incoming02.wav",
		"vo/npc/female01/overhere01.wav",
		"vo/npc/female01/overthere01.wav",
		"vo/npc/female01/overthere02.wav",
		"vo/npc/female01/squad_away02.wav",
		"vo/npc/female01/upthere01.wav",
		"vo/npc/female01/upthere02.wav",
	}
	self.SoundTbl_CallForHelp = {
		"vo/npc/female01/help01.wav",
	}
	self.SoundTbl_BecomeEnemyToPlayer = {
		"vo/npc/female01/heretohelp01.wav",
		"vo/npc/female01/heretohelp02.wav",
		"vo/npc/female01/notthemanithought01.wav",
		"vo/npc/female01/notthemanithought02.wav",
		"vo/npc/female01/wetrustedyou01.wav",
		"vo/npc/female01/wetrustedyou02.wav",
	}
	self.SoundTbl_Suppressing = {}
	self.SoundTbl_WeaponReload = {
		"vo/npc/female01/coverwhilereload01.wav",
		"vo/npc/female01/coverwhilereload02.wav",
		"vo/npc/female01/gottareload01.wav",
	}
	self.SoundTbl_BeforeMeleeAttack = {}
	self.SoundTbl_MeleeAttack = {}
	self.SoundTbl_MeleeAttackExtra = {}
	self.SoundTbl_MeleeAttackMiss = {}
	self.SoundTbl_GrenadeAttack = {}
	self.SoundTbl_OnGrenadeSight = {
		"vo/npc/female01/getdown02.wav",
		"vo/npc/female01/gethellout.wav",
		"vo/npc/female01/runforyourlife01.wav",
		"vo/npc/female01/runforyourlife02.wav",
		"vo/npc/female01/strider_run.wav",
		"vo/npc/female01/takecover02.wav",
		"vo/npc/female01/uhoh.wav",
		"vo/npc/female01/watchout.wav",
	}
	self.SoundTbl_OnKilledEnemy = {
		"vo/npc/female01/gotone01.wav",
		"vo/npc/female01/gotone02.wav",
		"vo/npc/female01/likethat.wav",
		"vo/npc/female01/nice01.wav",
		"vo/npc/female01/nice02.wav",
		"vo/npc/female01/yeah02.wav",
	}
	self.SoundTbl_AllyDeath = {
		"vo/npc/female01/goodgod.wav",
		"vo/npc/female01/no01.wav",
		"vo/npc/female01/no02.wav",
		"vo/npc/female01/ohno.wav",
	}
	self.SoundTbl_Pain = {
		"vo/npc/female01/imhurt01.wav",
		"vo/npc/female01/imhurt02.wav",
		"vo/npc/female01/ow01.wav",
		"vo/npc/female01/ow02.wav",
		"vo/npc/female01/pain01.wav",
		"vo/npc/female01/pain02.wav",
		"vo/npc/female01/pain03.wav",
		"vo/npc/female01/pain04.wav",
		"vo/npc/female01/pain05.wav",
	}
	self.SoundTbl_DamageByPlayer = {
		"vo/npc/female01/onyourside.wav",
		"vo/npc/female01/stopitfm.wav",
		"vo/npc/female01/watchwhat.wav",
	}
	self.SoundTbl_Death = {
		"vo/npc/female01/pain06.wav",
		"vo/npc/female01/pain07.wav",
		"vo/npc/female01/pain08.wav",
		"vo/npc/female01/pain09.wav",
	}

	--[[ CUSTOM CODE

	-- Detect metrocops
	vo/npc/female01/civilprotection01.wav
	vo/npc/female01/civilprotection02.wav
	vo/npc/female01/cps01.wav
	vo/npc/female01/cps02.wav

	-- Detect combine
	vo/npc/female01/combine01.wav
	vo/npc/female01/combine02.wav

	-- Detect gunship
	vo/npc/female01/gunship02.wav

	-- Detect manhacks
	vo/npc/female01/hacks01.wav
	vo/npc/female01/hacks02.wav
	vo/npc/female01/herecomehacks01.wav
	vo/npc/female01/herecomehacks02.wav
	vo/npc/female01/itsamanhack01.wav
	vo/npc/female01/itsamanhack02.wav
	vo/npc/female01/thehacks01.wav
	vo/npc/female01/thehacks02.wav

	-- Detect scanners
	vo/npc/female01/scanners01.wav
	vo/npc/female01/scanners02.wav

	-- Detect headcrabs
	vo/npc/female01/headcrabs01.wav
	vo/npc/female01/headcrabs02.wav

	-- Detect zombies
	vo/npc/female01/zombies01.wav
	vo/npc/female01/zombies02.wav

	-- Detect Strider
	vo/npc/male01/strider.wav

	-- PAIN: Hit gut
	vo/npc/female01/hitingut01.wav
	vo/npc/female01/hitingut02.wav
	vo/npc/female01/mygut02.wav

	-- PAIN: Hit arm
	vo/npc/female01/myarm01.wav
	vo/npc/female01/myarm02.wav

	-- PAIN: Hit leg
	vo/npc/female01/myleg01.wav
	vo/npc/female01/myleg02.wav

	]]--


	--[[ UNUSED

	-- Give player ammo
	vo/npc/female01/ammo01.wav    1 - 5

	-- Player needs to reload
	vo/npc/female01/dontforgetreload01.wav
	vo/npc/female01/reloadfm01.wav
	vo/npc/female01/reloadfm02.wav
	vo/npc/female01/youdbetterreload01.wav

	-- Pick-up weapon
	vo/npc/female01/fantastic01.wav
	vo/npc/female01/fantastic02.wav
	vo/npc/female01/finally.wav
	vo/npc/female01/nice01.wav
	vo/npc/female01/nice02.wav
	vo/npc/female01/thislldonicely01.wav

	-- Alert player of danger
	vo/npc/female01/lookoutfm01.wav
	vo/npc/female01/lookoutfm02.wav
	vo/npc/female01/behindyou01.wav
	vo/npc/female01/behindyou02.wav

	-- Player died
	vo/npc/female01/gordead_ans01.wav        1 - 20
	vo/npc/female01/gordead_ques01.wav    1 - 17

	-- Vortigaunt Answer and Question
	vo/npc/female01/vanswer01.wav		1 - 14
	vo/npc/female01/vquestion01.wav		1 - 7

	-- Follow player not moving
	vo/npc/female01/waitingsomebody.wav

	vo/npc/female01/busy02.wav

	vo/npc/female01/cit_dropper01.wav
	vo/npc/female01/cit_dropper04.wav

	vo/npc/female01/squad_approach01.wav
	vo/npc/female01/squad_away01.wav
	vo/npc/female01/squad_away03.wav
	vo/npc/female01/squad_follow01.wav
	vo/npc/female01/squad_follow02.wav
	vo/npc/female01/squad_follow04.wav
	vo/npc/female01/squad_greet02.wav
	vo/npc/female01/squad_reinforce_group01.wav		1 - 4
	vo/npc/female01/squad_reinforce_single01.wav	1 - 4

	vo/npc/female01/moan01.wav		1 - 5

	]]--
end
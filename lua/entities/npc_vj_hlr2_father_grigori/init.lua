AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/monk.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 100
ENT.HasHealthRegeneration = true -- Can the SNPC regenerate its health?
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.AnimTbl_MeleeAttack = {"vjseq_MeleeAttack01"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.MoveRandomlyWhenShooting = false -- Should it move randomly when shooting?
ENT.AnimTbl_GrenadeAttack = {ACT_RANGE_ATTACK_THROW} -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 0.87 -- Time until the grenade is released
ENT.GrenadeAttackAttachment = "anim_attachment_RH" -- The attachment that the grenade will spawn at
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_Idle = {
	"vo/ravenholm/firetrap_vigil.wav",
	"vo/ravenholm/monk_rant01.wav",
	"vo/ravenholm/monk_rant02.wav",
	"vo/ravenholm/monk_rant03.wav",
	"vo/ravenholm/monk_rant04.wav",
	"vo/ravenholm/monk_rant05.wav",
	"vo/ravenholm/monk_rant06.wav",
	"vo/ravenholm/monk_rant07.wav",
	"vo/ravenholm/monk_rant08.wav",
	"vo/ravenholm/monk_rant09.wav",
	"vo/ravenholm/monk_rant10.wav",
	"vo/ravenholm/monk_rant11.wav",
	"vo/ravenholm/monk_rant12.wav",
	"vo/ravenholm/monk_rant13.wav",
	"vo/ravenholm/monk_rant14.wav",
	"vo/ravenholm/monk_rant15.wav",
	"vo/ravenholm/monk_rant16.wav",
	"vo/ravenholm/monk_rant17.wav",
	"vo/ravenholm/monk_rant18.wav",
	"vo/ravenholm/monk_rant19.wav",
	"vo/ravenholm/monk_rant20.wav",
	"vo/ravenholm/monk_rant21.wav",
	"vo/ravenholm/monk_rant22.wav",
}
ENT.SoundTbl_OnPlayerSight = {
	"vo/ravenholm/grave_follow.wav",
	"vo/ravenholm/grave_stayclose.wav",
	--"vo/ravenholm/monk_followme.wav",
	"vo/ravenholm/monk_overhere.wav",
	"vo/ravenholm/monk_stayclosebro.wav",
	"vo/ravenholm/pyre_anotherlife.wav",
	"vo/ravenholm/yard_greetings.wav",
}
ENT.SoundTbl_Alert = {
	"vo/ravenholm/aimforhead.wav",
	"vo/ravenholm/bucket_guardwell.wav",
	"vo/ravenholm/engage01.wav",
	"vo/ravenholm/engage02.wav",
	"vo/ravenholm/engage03.wav",
	"vo/ravenholm/engage04.wav",
	"vo/ravenholm/engage05.wav",
	"vo/ravenholm/engage06.wav",
	"vo/ravenholm/engage07.wav",
	"vo/ravenholm/engage08.wav",
	"vo/ravenholm/engage09.wav",
	"vo/ravenholm/shotgun_hush.wav",
	"vo/ravenholm/shotgun_theycome.wav",
}
ENT.SoundTbl_BecomeEnemyToPlayer = {
	"vo/ravenholm/engage01.wav",
	"vo/ravenholm/engage02.wav",
	"vo/ravenholm/engage03.wav",
	"vo/ravenholm/engage04.wav",
	"vo/ravenholm/engage05.wav",
	"vo/ravenholm/engage06.wav",
	"vo/ravenholm/engage07.wav",
	"vo/ravenholm/engage08.wav",
	"vo/ravenholm/engage09.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vo/ravenholm/monk_coverme02.wav",
	"vo/ravenholm/monk_coverme03.wav",
	"vo/ravenholm/monk_coverme04.wav",
	"vo/ravenholm/monk_coverme05.wav",
	"vo/ravenholm/monk_coverme07.wav",
	"vo/ravenholm/monk_helpme01.wav",
	"vo/ravenholm/monk_helpme02.wav",
	"vo/ravenholm/monk_helpme03.wav",
	"vo/ravenholm/monk_helpme04.wav",
	"vo/ravenholm/monk_helpme05.wav",
}
ENT.SoundTbl_AllyDeath = {
	"vo/ravenholm/monk_mourn01.wav",
	"vo/ravenholm/monk_mourn02.wav",
	"vo/ravenholm/monk_mourn03.wav",
	"vo/ravenholm/monk_mourn04.wav",
	"vo/ravenholm/monk_mourn05.wav",
	"vo/ravenholm/monk_mourn06.wav",
	"vo/ravenholm/monk_mourn07.wav",
}
ENT.SoundTbl_OnGrenadeSight = {
	"vo/ravenholm/monk_danger01.wav",
	"vo/ravenholm/monk_danger02.wav",
	"vo/ravenholm/monk_danger03.wav",
	"vo/ravenholm/monk_blocked02.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vo/ravenholm/madlaugh01.wav",
	"vo/ravenholm/madlaugh02.wav",
	"vo/ravenholm/madlaugh03.wav",
	"vo/ravenholm/madlaugh04.wav",
	"vo/ravenholm/monk_kill01.wav",
	"vo/ravenholm/monk_kill02.wav",
	"vo/ravenholm/monk_kill03.wav",
	"vo/ravenholm/monk_kill04.wav",
	"vo/ravenholm/monk_kill05.wav",
	"vo/ravenholm/monk_kill06.wav",
	"vo/ravenholm/monk_kill07.wav",
	"vo/ravenholm/monk_kill08.wav",
	"vo/ravenholm/monk_kill09.wav",
	"vo/ravenholm/monk_kill10.wav",
	"vo/ravenholm/monk_kill11.wav",
}
ENT.SoundTbl_Pain = {
	"vo/ravenholm/monk_pain01.wav",
	"vo/ravenholm/monk_pain02.wav",
	"vo/ravenholm/monk_pain03.wav",
	"vo/ravenholm/monk_pain04.wav",
	"vo/ravenholm/monk_pain05.wav",
	"vo/ravenholm/monk_pain06.wav",
	"vo/ravenholm/monk_pain07.wav",
	"vo/ravenholm/monk_pain08.wav",
	"vo/ravenholm/monk_pain09.wav",
	"vo/ravenholm/monk_pain10.wav",
	"vo/ravenholm/monk_pain12.wav",
}
ENT.SoundTbl_Death = {
	"vo/ravenholm/monk_pain01.wav",
	"vo/ravenholm/monk_pain02.wav",
	"vo/ravenholm/monk_pain03.wav",
	"vo/ravenholm/monk_pain04.wav",
	"vo/ravenholm/monk_pain05.wav",
	"vo/ravenholm/monk_pain06.wav",
	"vo/ravenholm/monk_pain07.wav",
	"vo/ravenholm/monk_pain08.wav",
	"vo/ravenholm/monk_pain09.wav",
	"vo/ravenholm/monk_pain10.wav",
	"vo/ravenholm/monk_pain12.wav",
}

ENT.GeneralSoundPitch1 = 100

/*
"vo/ravenholm/attic_apologize.wav"
"vo/ravenholm/bucket_almost.wav"
"vo/ravenholm/bucket_brake.wav"
"vo/ravenholm/bucket_patience.wav"
"vo/ravenholm/bucket_stepin.wav"
"vo/ravenholm/bucket_thereyouare.wav"
"vo/ravenholm/bucket_waited.wav"
"vo/ravenholm/cartrap_better.wav"
"vo/ravenholm/cartrap_iamgrig.wav"
"vo/ravenholm/exit_darkroad.wav"
"vo/ravenholm/exit_goquickly.wav"
"vo/ravenholm/exit_hurry.wav"
"vo/ravenholm/exit_nag01.wav"
"vo/ravenholm/exit_nag02.wav"
"vo/ravenholm/exit_salvation.wav"
"vo/ravenholm/firetrap_freeuse.wav"
"vo/ravenholm/firetrap_lookout.wav"
"vo/ravenholm/firetrap_welldone.wav"
"vo/ravenholm/monk_blocked01.wav"
"vo/ravenholm/monk_blocked03.wav"
"vo/ravenholm/monk_death7.wav"
"vo/ravenholm/monk_followme.wav"
"vo/ravenholm/monk_giveammo01.wav"
"vo/ravenholm/monk_givehealth01.wav"
"vo/ravenholm/monk_quicklybro.wav"
"vo/ravenholm/pyre_keepeye.wav"
"vo/ravenholm/shotgun_bettergun.wav"
"vo/ravenholm/shotgun_catch.wav"
"vo/ravenholm/shotgun_closer.wav"
"vo/ravenholm/shotgun_keepitclose.wav"
"vo/ravenholm/shotgun_moveon.wav"
"vo/ravenholm/shotgun_overhere.wav"
"vo/ravenholm/shotgun_stirreduphell.wav"
"vo/ravenholm/wrongside_howcome.wav"
"vo/ravenholm/wrongside_mendways.wav"
"vo/ravenholm/wrongside_seekchurch.wav"
"vo/ravenholm/wrongside_town.wav"
"vo/ravenholm/yard_shepherd.wav"
"vo/ravenholm/yard_suspect.wav"
"vo/ravenholm/yard_traps.wav"
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
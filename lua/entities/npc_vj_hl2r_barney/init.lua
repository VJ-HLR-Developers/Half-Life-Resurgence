AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/barney.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 80
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_MeleeAttack01"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = GetConVarNumber("vj_hl2r_rebel_d")
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {ACT_RANGE_ATTACK_THROW} -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 0.87 -- Time until the grenade is released
ENT.GrenadeAttackAttachment = "anim_attachment_RH" -- The attachment that the grenade will spawn at
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}
ENT.SoundTbl_OnReceiveOrder = {
	"vo/npc/barney/ba_imwithyou.wav",
}
ENT.SoundTbl_FollowPlayer = {
	"vo/npc/barney/ba_imwithyou.wav",
	"vo/npc/barney/ba_letsdoit.wav",
	"vo/npc/barney/ba_letsgo.wav",
	"vo/npc/barney/ba_oldtimes.wav",
}
ENT.SoundTbl_Investigate = {
	"vo/npc/barney/ba_danger02.wav",
}
ENT.SoundTbl_OnPlayerSight = {
	"vo/npc/barney/ba_followme01.wav",
	"vo/npc/barney/ba_followme02.wav",
	"vo/npc/barney/ba_followme03.wav",
	"vo/npc/barney/ba_followme05.wav",
}
ENT.SoundTbl_Alert = {
	"vo/npc/barney/ba_bringiton.wav",
	"vo/npc/barney/ba_goingdown.wav",
	"vo/npc/barney/ba_hereitcomes.wav",
	"vo/npc/barney/ba_heretheycome01.wav",
	"vo/npc/barney/ba_heretheycome02.wav",
	"vo/npc/barney/ba_openfiregord.wav",
	"vo/npc/barney/ba_uhohheretheycome.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vo/npc/barney/ba_gordonhelp.wav",
	"vo/npc/barney/ba_littlehelphere.wav",
}
ENT.SoundTbl_WeaponReload = {
	"vo/npc/barney/ba_covermegord.wav",
}
ENT.SoundTbl_OnGrenadeSight = {
	"vo/npc/barney/ba_damnit.wav",
	"vo/npc/barney/ba_duck.wav",
	"vo/npc/barney/ba_getaway.wav",
	"vo/npc/barney/ba_getdown.wav",
	"vo/npc/barney/ba_getoutofway.wav",
	"vo/npc/barney/ba_grenade01.wav",
	"vo/npc/barney/ba_grenade02.wav",
	"vo/npc/barney/ba_lookout.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vo/npc/barney/ba_downyougo.wav",
	"vo/npc/barney/ba_gotone.wav",
	"vo/npc/barney/ba_laugh01.wav",
	"vo/npc/barney/ba_laugh02.wav",
	"vo/npc/barney/ba_laugh03.wav",
	"vo/npc/barney/ba_laugh04.wav",
	"vo/npc/barney/ba_losttouch.wav",
	"vo/npc/barney/ba_ohyeah.wav",
	"vo/npc/barney/ba_yell.wav",
}
ENT.SoundTbl_Pain = {
	"vo/npc/barney/ba_damnit.wav",
	"vo/npc/barney/ba_pain01.wav",
	"vo/npc/barney/ba_pain02.wav",
	"vo/npc/barney/ba_pain03.wav",
	"vo/npc/barney/ba_pain04.wav",
	"vo/npc/barney/ba_pain05.wav",
	"vo/npc/barney/ba_pain06.wav",
	"vo/npc/barney/ba_pain07.wav",
	"vo/npc/barney/ba_pain08.wav",
	"vo/npc/barney/ba_pain09.wav",
	"vo/npc/barney/ba_pain10.wav",
	"vo/npc/barney/ba_wounded01.wav",
	"vo/npc/barney/ba_wounded02.wav",
	"vo/npc/barney/ba_wounded03.wav",
}
ENT.SoundTbl_Death = {
	"vo/npc/barney/ba_no01.wav",
	"vo/npc/barney/ba_no02.wav",
	"vo/npc/barney/ba_ohshit03.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.NextRegen = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RegenerateHealth()
	if CurTime() > self.NextRegen then
		local setHealth = math.Clamp(self:Health() +1,0,self:GetMaxHealth())
		if setHealth > self:Health() then
			self:SetHealth(setHealth)
			self.NextRegen = CurTime() +0.1
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:RegenerateHealth()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	self:VJ_ACT_PLAYACTIVITY({"vjseq_cheer1"},false,false,false,0,{vTbl_SequenceInterruptible=true})
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
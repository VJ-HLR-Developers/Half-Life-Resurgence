AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = GetConVarNumber("vj_hl2r_rebel_h")
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
ENT.AnimTbl_Medic_GiveHealth = {"heal"} -- Animations is plays when giving health to an ally
ENT.WeaponInventory_AntiArmorList = {"weapon_vj_rpg", "weapon_vj_hl2_rpg"} -- It will randomly be given one of these weapons
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}

-- Custom
ENT.Human_Gender = 0 -- 0 = Male | 1 = Female
ENT.Human_SdFolder = "male01"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if math.random(1,2) == 1 then
		self.Human_Gender = 0
		if math.random(1,5) == 1 then
			self.Model = {"models/Humans/Group03m/male_01.mdl","models/Humans/Group03m/male_02.mdl","models/Humans/Group03m/male_03.mdl","models/Humans/Group03m/male_04.mdl","models/Humans/Group03m/male_05.mdl","models/Humans/Group03m/male_06.mdl","models/Humans/Group03m/male_07.mdl","models/Humans/Group03m/male_08.mdl","models/Humans/Group03m/male_09.mdl"}
			self.IsMedicSNPC = true
		else
			self.Model = {"models/Humans/Group03/male_01.mdl","models/Humans/Group03/male_02.mdl","models/Humans/Group03/male_03.mdl","models/Humans/Group03/male_04.mdl","models/Humans/Group03/male_05.mdl","models/Humans/Group03/male_06.mdl","models/Humans/Group03/male_07.mdl","models/Humans/Group03/male_08.mdl","models/Humans/Group03/male_09.mdl"}
		end
	else
		self.Human_Gender = 1
		if math.random(1,5) == 1 then
			self.Model = {"models/Humans/Group03m/female_01.mdl","models/Humans/Group03m/female_02.mdl","models/Humans/Group03m/female_03.mdl","models/Humans/Group03m/female_04.mdl","models/Humans/Group03m/female_06.mdl","models/Humans/Group03m/female_07.mdl"}
			self.IsMedicSNPC = true
		else
			self.Model = {"models/Humans/Group03/female_01.mdl","models/Humans/Group03/female_02.mdl","models/Humans/Group03/female_03.mdl","models/Humans/Group03/female_04.mdl","models/Humans/Group03/female_06.mdl","models/Humans/Group03/female_07.mdl"}
		end
	end
	if self.IsMedicSNPC == false && math.random(1,3) == 1 then
		self.WeaponInventory_AntiArmor = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.Human_NextPlyReloadSd = CurTime()
	if self.Human_Gender == 1 then
		self:HLR_ApplyFemaleSounds()
		self.Human_SdFolder = "female01"
	else
		self:HLR_ApplyMaleSounds()
		self.Human_SdFolder = "male01"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntityRelationshipCheck(argent, entisfri, entdist)
	-- Tell the player to reload their weapon
	if argent:IsPlayer() && entisfri == true && entdist <= 200 && !IsValid(self:GetEnemy()) && CurTime() > self.Human_NextPlyReloadSd then
		self.Human_NextPlyReloadSd = CurTime() + math.Rand(10,60)
		local wep = argent:GetActiveWeapon()
		if math.random(1,3) == 1 && IsValid(wep) && wep:Clip1() < wep:GetMaxClip1() && argent:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 then
			self:PlaySoundSystem("GeneralSpeech",{
				"vo/npc/"..self.Human_SdFolder.."/dontforgetreload01.wav",
				"vo/npc/"..self.Human_SdFolder.."/reloadfm01.wav",
				"vo/npc/"..self.Human_SdFolder.."/reloadfm02.wav",
				"vo/npc/"..self.Human_SdFolder.."/youdbetterreload01.wav",
			})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoChangeWeapon(newWeapon, oldWeapon, invSwitch)
	if invSwitch == true then -- Only if it's a inventory switch
		self:VJ_ACT_PLAYACTIVITY(ACT_PICKUP_RACK, true, false, true)
	end
	if self:GetWeaponState() == VJ_WEP_STATE_ANTI_ARMOR && self.Human_Gender == 0 && math.random(1,2) == 1 then self:PlaySoundSystem("GeneralSpeech",{"vo/npc/male01/evenodds.wav"}) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	self:VJ_ACT_PLAYACTIVITY("vjseq_cheer1", false, false, false, 0, {vTbl_SequenceInterruptible=true})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,2) == 1 && argent:IsNPC() then
		//print(argent:Classify())
		if argent.HLR_Type == "Headcrab" or argent:GetClass() == "npc_headcrab" or argent:GetClass() == "npc_headcrab_black" or argent:GetClass() == "npc_headcrab_fast" then
			self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/headcrabs01.wav","vo/npc/"..self.Human_SdFolder.."/headcrabs02.wav"})
			return
		elseif argent:GetClass() == "npc_combinedropship" then
			self:PlaySoundSystem("Alert", {"vo/coast/barn/"..self.Human_SdFolder.."/crapships.wav","vo/coast/barn/"..self.Human_SdFolder.."/incomingdropship.wav"})
			return
		elseif argent.HLR_Type == "Police" or argent:Classify() == CLASS_METROPOLICE then
			self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/civilprotection01.wav","vo/npc/"..self.Human_SdFolder.."/civilprotection02.wav","vo/npc/"..self.Human_SdFolder.."/cps01.wav","vo/npc/"..self.Human_SdFolder.."/cps02.wav"})
			return
		elseif argent:Classify() == CLASS_COMBINE_GUNSHIP then
			self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/gunship02.wav","vo/coast/barn/"..self.Human_SdFolder.."/lite_gunship01.wav","vo/coast/barn/"..self.Human_SdFolder.."/lite_gunship02.wav"})
			return
		elseif argent:Classify() == CLASS_SCANNER then
			self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/scanners01.wav","vo/npc/"..self.Human_SdFolder.."/scanners02.wav"})
			return
		elseif argent:GetClass() == "npc_strider" then
			self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/strider.wav"})
			return
		elseif argent:Classify() == CLASS_MANHACK then
			self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/hacks01.wav","vo/npc/"..self.Human_SdFolder.."/hacks02.wav","vo/npc/"..self.Human_SdFolder.."/herecomehacks01.wav","vo/npc/"..self.Human_SdFolder.."/herecomehacks02.wav","vo/npc/"..self.Human_SdFolder.."/itsamanhack01.wav","vo/npc/"..self.Human_SdFolder.."/itsamanhack02.wav","vo/npc/"..self.Human_SdFolder.."/thehacks01.wav","vo/npc/"..self.Human_SdFolder.."/thehacks02.wav"})
			return
		else
			local tbl = argent.VJ_NPC_Class or {1}
			for _,v in ipairs(tbl) do
				if v == "CLASS_COMBINE" or argent:Classify() == CLASS_COMBINE then
					self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/combine01.wav","vo/npc/"..self.Human_SdFolder.."/combine02.wav"})
					break
				elseif v == "CLASS_ZOMBIE" or argent:Classify() == CLASS_ZOMBIE then
					self:PlaySoundSystem("Alert", {"vo/npc/"..self.Human_SdFolder.."/zombies01.wav","vo/npc/"..self.Human_SdFolder.."/zombies02.wav"})
					break
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	if self:Health() > 0 && math.random(1,2) == 1 then
		if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			self:PlaySoundSystem("Pain", {
				"vo/npc/"..self.Human_SdFolder.."/myarm01.wav",
				"vo/npc/"..self.Human_SdFolder.."/myarm02.wav",
			})
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			self:PlaySoundSystem("Pain", {
				"vo/npc/"..self.Human_SdFolder.."/myleg01.wav",
				"vo/npc/"..self.Human_SdFolder.."/myleg02.wav",
			})
		elseif hitgroup == HITGROUP_STOMACH then
			self:PlaySoundSystem("Pain", {
				"vo/npc/"..self.Human_SdFolder.."/hitingut01.wav",
				"vo/npc/"..self.Human_SdFolder.."/hitingut02.wav",
				"vo/npc/"..self.Human_SdFolder.."/mygut02.wav",
			})
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SOUNDS ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
		"vo/coast/cardock/le_onfoot.wav",
		"vo/trainyard/cit_water.wav",
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
		"vo/trainyard/cit_window_hope.wav",
	}
	self.SoundTbl_CombatIdle = {
		"vo/npc/male01/letsgo01.wav",
		"vo/npc/male01/letsgo02.wav",
		"vo/npc/male01/squad_affirm05.wav",
		"vo/npc/male01/squad_affirm06.wav",
		"vo/canals/male01/stn6_go_nag02.wav",
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
		"vo/canals/male01/gunboat_farewell.wav",
		"vo/canals/male01/gunboat_giveemhell.wav",
		"vo/canals/matt_go_nag04.wav",
		"vo/canals/matt_go_nag05.wav",
		"vo/coast/odessa/male01/stairman_follow03.wav",
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
		"vo/canals/male01/gunboat_owneyes.wav",
		"vo/canals/shanty_yourefm.wav",
		"vo/coast/odessa/nlo_greet_freeman.wav",
	}
	self.SoundTbl_Investigate = {
		"vo/npc/male01/startle01.wav",
		"vo/npc/male01/startle02.wav",
		"vo/canals/boxcar_becareful.wav",
		"vo/streetwar/sniper/male01/c17_09_help03.wav",
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
		"vo/canals/male01/stn6_incoming.wav",
	}
	self.SoundTbl_CallForHelp = {
		"vo/npc/male01/help01.wav",
		"vo/coast/bugbait/sandy_help.wav",
		"vo/streetwar/sniper/male01/c17_09_help01.wav",
		"vo/streetwar/sniper/male01/c17_09_help02.wav",
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
		"vo/coast/odessa/male01/nlo_cheer01.wav",
		"vo/coast/odessa/male01/nlo_cheer02.wav",
		"vo/coast/odessa/male01/nlo_cheer03.wav",
		"vo/coast/odessa/male01/nlo_cheer04.wav",
	}
	self.SoundTbl_AllyDeath = {
		"vo/npc/male01/goodgod.wav",
		"vo/npc/male01/likethat.wav",
		"vo/npc/male01/no01.wav",
		"vo/npc/male01/no02.wav",
		"vo/canals/matt_beglad_b.wav",
		"vo/coast/odessa/male01/nlo_cubdeath01.wav",
		"vo/coast/odessa/male01/nlo_cubdeath02.wav",
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
		"vo/trainyard/male01/cit_hit01.wav",
		"vo/trainyard/male01/cit_hit02.wav",
		"vo/trainyard/male01/cit_hit03.wav",
		"vo/trainyard/male01/cit_hit04.wav",
		"vo/trainyard/male01/cit_hit05.wav",
	}
	self.SoundTbl_Death = {
		"vo/npc/male01/pain07.wav",
		"vo/npc/male01/pain08.wav",
		"vo/npc/male01/pain09.wav"
	}

	--[[ CUSTOM CODE

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
	
	-- Supplies
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
	
	vo/canals/male01/gunboat_breakcamp.wav
	vo/canals/male01/gunboat_eliright.wav
	vo/canals/male01/gunboat_hurry.wav
	vo/canals/male01/gunboat_justintime.wav
	vo/canals/male01/gunboat_moveon.wav
	vo/canals/male01/gunboat_parkboat.wav
	vo/canals/male01/gunboat_pullout.wav
	vo/canals/male01/stn6_shellingus.wav
	
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
		"vo/canals/female01/stn6_go_nag02.wav",
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
		"vo/canals/female01/gunboat_farewell.wav",
		"vo/canals/female01/gunboat_giveemhell.wav",
		"vo/canals/airboat_go_nag03.wav",
		"vo/coast/odessa/female01/stairman_follow03.wav",
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
		"vo/canals/female01/gunboat_owneyes.wav",
		"vo/canals/gunboat_heyyourefm.wav",
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
		"vo/canals/female01/stn6_incoming.wav",
	}
	self.SoundTbl_CallForHelp = {
		"vo/npc/female01/help01.wav",
		"vo/canals/arrest_helpme.wav",
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
		"vo/coast/odessa/female01/nlo_cheer01.wav",
		"vo/coast/odessa/female01/nlo_cheer02.wav",
		"vo/coast/odessa/female01/nlo_cheer03.wav",
	}
	self.SoundTbl_AllyDeath = {
		"vo/npc/female01/goodgod.wav",
		"vo/npc/female01/no01.wav",
		"vo/npc/female01/no02.wav",
		"vo/npc/female01/ohno.wav",
		"vo/coast/odessa/female01/nlo_cubdeath01.wav",
		"vo/coast/odessa/female01/nlo_cubdeath02.wav",
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
		"vo/trainyard/female01/cit_hit01.wav",
		"vo/trainyard/female01/cit_hit02.wav",
		"vo/trainyard/female01/cit_hit03.wav",
		"vo/trainyard/female01/cit_hit04.wav",
		"vo/trainyard/female01/cit_hit05.wav",
	}
	self.SoundTbl_Death = {
		"vo/npc/female01/pain06.wav",
		"vo/npc/female01/pain07.wav",
		"vo/npc/female01/pain08.wav",
		"vo/npc/female01/pain09.wav",
	}

	--[[ CUSTOM CODE

	]]--


	--[[ UNUSED

	-- Give player ammo
	vo/npc/female01/ammo01.wav    1 - 5

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

	-- Supplies
	vo/npc/female01/cit_dropper01.wav
	vo/npc/female01/cit_dropper04.wav
	
	vo/npc/female01/moan01.wav		1 - 5
	
	vo/npc/female01/squad_approach01.wav
	vo/npc/female01/squad_away01.wav
	vo/npc/female01/squad_away03.wav
	vo/npc/female01/squad_follow01.wav
	vo/npc/female01/squad_follow02.wav
	vo/npc/female01/squad_follow04.wav
	vo/npc/female01/squad_greet02.wav
	vo/npc/female01/squad_reinforce_group01.wav		1 - 4
	vo/npc/female01/squad_reinforce_single01.wav	1 - 4
	
	vo/canals/female01/gunboat_breakcamp.wav
	vo/canals/female01/gunboat_eliright.wav
	vo/canals/female01/gunboat_hurry.wav
	vo/canals/female01/gunboat_justintime.wav
	vo/canals/female01/gunboat_moveon.wav
	vo/canals/female01/gunboat_parkboat.wav
	vo/canals/female01/gunboat_pullout.wav
	vo/canals/female01/stn6_shellingus.wav
	]]--
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
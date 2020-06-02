AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2/alyx_ep1.mdl","models/vj_hlr/hl2/alyx_ep2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 120
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?

ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasHealthRegeneration = true -- Can the SNPC regenerate its health?
ENT.HealthRegenerationAmount = 2 -- How much should the health increase after every delay?
ENT.HealthRegenerationDelay = VJ_Set(1,1) -- How much time until the health increases
ENT.HealthRegenerationResetOnDmg = false -- Should the delay reset when it receives damage?

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_MeleeAttack01"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = GetConVarNumber("vj_hl2r_rebel_d")

ENT.DisableFootStepSoundTimer = true

ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {"vjseq_ThrowItem"} -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 1.1 -- Time until the grenade is released
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl" -- The model for the grenade entity
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will spawn at

ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?

	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this

	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {
	"vo/eli_lab/al_hums.wav",
	"vo/eli_lab/al_hums_b.wav",
}
ENT.SoundTbl_IdleDialogue = { -- Needs more lines, I'll let you guys add some more
	"vo/k_lab/al_wontlook.wav",
	"vo/novaprospekt/al_drkleiner01_e.wav",
	"vo/novaprospekt/al_flyingblind.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vo/k_lab2/al_optimism.wav",
	"vo/k_lab2/al_whatdoyoumean.wav",
	"vo/k_lab2/al_whee_b.wav",
	"vo/eli_lab/al_allright01.wav",
	"vo/eli_lab/al_awesome.wav",
	"vo/eli_lab/al_blamingme.wav",
	"vo/eli_lab/al_laugh01.wav",
	"vo/eli_lab/al_laugh02.wav",
	"vo/novaprospekt/al_betyoudid01.wav",
	"vo/novaprospekt/al_elevator02.wav",
	"vo/novaprospekt/al_notexactly.wav",
}
ENT.SoundTbl_OnReceiveOrder = {"vo/episode_1/npc/alyx/al_comingtohelp01.wav","vo/episode_1/npc/alyx/al_comingtohelp02.wav","vo/episode_1/npc/alyx/al_comingtohelp03.wav","vo/episode_1/npc/alyx/al_comingtohelp04.wav"}
ENT.SoundTbl_FollowPlayer = {"vo/streetwar/alyx_gate/al_letsgo.wav","vo/streetwar/alyx_gate/al_letsgo01.wav","vo/streetwar/alyx_gate/al_readywhenyou.wav","vo/episode_1/npc/alyx/al_follow01.wav","vo/episode_1/npc/alyx/al_follow02.wav","vo/episode_1/npc/alyx/al_follow03.wav","vo/episode_1/npc/alyx/al_follow04.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vo/episode_1/npc/alyx/al_affirm_sarc01.wav","vo/episode_1/npc/alyx/al_affirm_sarc02.wav","vo/episode_1/npc/alyx/al_affirm_sarc03.wav","vo/episode_1/npc/alyx/al_affirm_sarc04.wav","vo/episode_1/npc/alyx/al_affirm_sarc05.wav"}
ENT.SoundTbl_OnPlayerSight = {"vo/k_lab/al_heydoc.wav","vo/episode_1/npc/alyx/al_playerfalls01.wav",}
ENT.SoundTbl_Alert = {"vo/episode_1/npc/alyx/al_startcombat01.wav","vo/episode_1/npc/alyx/al_combat_sudden01.wav","vo/episode_1/npc/alyx/al_combat_sudden02.wav","vo/episode_1/npc/alyx/al_combat_sudden03.wav","vo/episode_1/npc/alyx/al_combat_sudden04.wav","vo/episode_1/npc/alyx/al_combat_sudden05.wav","vo/episode_1/npc/alyx/al_combat_sudden06.wav"}
ENT.SoundTbl_CallForHelp = {"vo/episode_1/npc/alyx/al_surround01.wav","vo/episode_1/npc/alyx/al_surround02.wav","vo/episode_1/npc/alyx/al_swamped04.wav"}
ENT.SoundTbl_WeaponReload = {"vo/episode_1/npc/alyx/al_reload01.wav","vo/episode_1/npc/alyx/al_reload02.wav","vo/episode_1/npc/alyx/al_reload03.wav","vo/episode_1/npc/alyx/al_reload04.wav","vo/episode_1/npc/alyx/al_reload05.wav","vo/episode_1/npc/alyx/al_reload06.wav","vo/episode_1/npc/alyx/al_reloading_new02.wav","vo/episode_1/npc/alyx/al_reloading_new03.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vo/episode_1/npc/alyx/al_grenade_warn02.wav","vo/episode_1/npc/alyx/al_grenade_warn_new_02.wav","vo/npc/alyx/lookout01.wav","vo/npc/alyx/lookout03.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vo/novaprospekt/al_gotyounow01.wav","vo/eli_lab/al_sweet.wav","vo/npc/alyx/brutal02.wav","vo/episode_1/npc/alyx/al_laugh02.wav","vo/episode_1/npc/alyx/al_laugh04.wav",}
ENT.SoundTbl_Pain = {"vo/npc/alyx/gasp02.wav","vo/npc/alyx/gasp03.wav","vo/npc/alyx/hurt04.wav","vo/npc/alyx/hurt05.wav","vo/episode_1/npc/alyx/al_post_combat01.wav","vo/episode_1/npc/alyx/al_post_combat03.wav","vo/episode_1/npc/alyx/al_post_combat04.wav"}
ENT.SoundTbl_DamageByPlayer = {"vo/npc/alyx/gordon_dist01.wav"}
ENT.SoundTbl_Death = {"vo/npc/alyx/uggh01.wav","vo/npc/alyx/uggh02.wav"}
ENT.SoundTbl_AllyDeath = {
	"vo/streetwar/alyx_gate/al_no.wav",
	"vo/novaprospekt/al_horrible01.wav",
}
ENT.SoundTbl_MoveOutOfPlayersWay = {
	"vo/npc/alyx/al_excuse01.wav",
	"vo/npc/alyx/al_excuse02.wav",
	"vo/npc/alyx/al_excuse03.wav",
}

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoChangeWeapon(NewWeapon,OldWeapon)
	local htype = NewWeapon:GetHoldType()
	if htype == "pistol" or htype == "revolver" then
		self.WeaponAnimTranslations[ACT_COVER_LOW] 						= VJ_SequenceToActivity(self,"crouch_aim_pistol")

		self.WeaponAnimTranslations[ACT_WALK] 							= ACT_WALK_PISTOL
		self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_WALK_AIM_PISTOL
		self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE

		self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN_PISTOL
		self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM_PISTOL
		self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(GrenadeEntity)
	GrenadeEntity.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
	GrenadeEntity.IdleSoundPitch1 = 100
	local redglow = ents.Create("env_sprite")
	redglow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	redglow:SetKeyValue("scale","0.07")
	redglow:SetKeyValue("rendermode","5")
	redglow:SetKeyValue("rendercolor","150 0 0")
	redglow:SetKeyValue("spawnflags","1") -- If animated
	redglow:SetParent(GrenadeEntity)
	redglow:Fire("SetParentAttachment","fuse",0)
	redglow:Spawn()
	redglow:Activate()
	GrenadeEntity:DeleteOnRemove(redglow)
	util.SpriteTrail(GrenadeEntity,1,Color(200,0,0),true,15,15,0.35,1/(6+6)*0.5,"VJ_Base/sprites/vj_trial1.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	self:VJ_ACT_PLAYACTIVITY({"vjseq_cheer1"},false,false,false,0,{vTbl_SequenceInterruptible=true})
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
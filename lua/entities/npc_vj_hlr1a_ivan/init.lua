AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/doctor.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 100
ENT.HasHealthRegeneration = true
ENT.HealthRegenerationAmount = 2
ENT.HealthRegenerationDelay = VJ.SET(0.5, 0.5)
ENT.HullType = HULL_HUMAN
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "unnamed021", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(8, 0, 7), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this NPC be friends with other player allies?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasOnPlayerSight = true
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasGrenadeAttack = false
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE -- Death Animations
ENT.Weapon_NoSpawnMenu = true -- Not affected by weapons selected from weapon list
--ENT.DeathAnimationTime = 2.15 -- Time until the SNPC spawns its corpse and gets removed
ENT.DisableFootStepSoundTimer = true
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.HasItemDropsOnDeath = false -- Should it drop items on death?
ENT.MoveRandomlyWhenShooting = false
ENT.AllowWeaponReloading = false -- If false, the SNPC will no longer reload
ENT.CanTurnWhileMoving = false -- Can the NPC turn while moving? | EX: GoldSrc NPCs, Facing enemy while running to cover, Facing the player while moving out of the way
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hla_npc/doctor/hoot5.wav","vj_hlr/hla_npc/doctor/hoot6.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav","vj_hlr/hla_npc/doctor/hoot5.wav","vj_hlr/hla_npc/doctor/hoot6.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav","vj_hlr/hla_npc/doctor/hoot5.wav","vj_hlr/hla_npc/doctor/hoot6.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav"}
ENT.SoundTbl_FollowPlayer = {"vj_hlr/hla_npc/doctor/hoot1.wav"}
ENT.SoundTbl_MedicReceiveHeal = {"vj_hlr/hla_npc/doctor/hoot3.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/hla_npc/doctor/hoot3.wav","vj_hlr/hla_npc/doctor/hoot2.wav"}
ENT.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav"}
ENT.SoundTbl_OnPlayerSight = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav","vj_hlr/hla_npc/doctor/hoot4.wav","vj_hlr/hla_npc/doctor/hoot5.wav","vj_hlr/hla_npc/doctor/hoot6.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav","vj_hlr/hla_npc/doctor/hoot4.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav"}
ENT.SoundTbl_OnDangerSight = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vj_hlr/hla_npc/doctor/hoot5.wav","vj_hlr/hla_npc/doctor/hoot6.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hla_npc/doctor/hoot1.wav","vj_hlr/hla_npc/doctor/hoot2.wav","vj_hlr/hla_npc/doctor/hoot3.wav","vj_hlr/hla_npc/doctor/hoot4.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hla_npc/doctor/pl_pain2.wav","vj_hlr/hla_npc/doctor/pl_pain4.wav","vj_hlr/hla_npc/doctor/pl_pain5.wav","vj_hlr/hla_npc/doctor/pl_pain6.wav","vj_hlr/hla_npc/doctor/pl_pain7.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hla_npc/doctor/pl_pain2.wav","vj_hlr/hla_npc/doctor/pl_pain4.wav","vj_hlr/hla_npc/doctor/pl_pain5.wav","vj_hlr/hla_npc/doctor/pl_pain6.wav","vj_hlr/hla_npc/doctor/pl_pain7.wav"}

-- Custom
ENT.Ivan_LastBodyGroup = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSkin(math.random(0, 3))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "hlag_fire" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
	self.AnimationTranslations[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_PISTOL
	self.AnimationTranslations[ACT_IDLE_ANGRY] = ACT_COMBAT_IDLE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local bodyGroup = self:GetBodygroup(0)
	if self.Ivan_LastBodyGroup != bodyGroup then
		self.Ivan_LastBodyGroup = bodyGroup
		if bodyGroup == 0 then
			self:DoChangeWeapon("weapon_vj_hlr1a_ivanglock")
		elseif bodyGroup == 1 && IsValid(self:GetActiveWeapon()) then
			self:GetActiveWeapon():Remove()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	self:SetBodygroup(0, 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorRed)
		effectData:SetScale(100)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(0)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_bone.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_gib.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(2, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_guts.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 2, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_hmeat.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_lung.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(1, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_skull.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 60))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_legbone.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	self:DoDropWeaponOnDeath(dmginfo, hitgroup)
	if IsValid(self:GetActiveWeapon()) then self:GetActiveWeapon():Remove() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon(dmginfo, hitgroup, wepEnt)
	wepEnt.WorldModel_Invisible = false
	wepEnt:SetNW2Bool("VJ_WorldModel_Invisible", false)
end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/strooper.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 150
ENT.HullType = HULL_HUMAN
ENT.CanTurnWhileMoving = false
ENT.VJC_Data = {
    ThirdP_Offset = Vector(15, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(10, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.MeleeAttackDamage = 10
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasGrenadeAttack = true -- Should the NPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vj_hlrof_grenade_spore" -- Entities that it can spawn when throwing a grenade | If set as a table, it picks a random entity | VJ: "obj_vj_grenade" | HL2: "npc_grenade_frag"
ENT.AnimTbl_GrenadeAttack = ACT_SPECIAL_ATTACK2
ENT.GrenadeAttackAttachment = "eyes" -- The attachment that the grenade will spawn at
ENT.TimeUntilGrenadeIsReleased = 1.5 -- Time until the grenade is released
ENT.GrenadeAttackChance = 1 -- 1 in x chance that it will throw a grenade when all the requirements are met | 1 = Throw it every time

ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.DisableWeaponFiringGesture = true -- If set to true, it will disable the weapon firing gestures
ENT.Weapon_StrafeWhileFiring = false -- Should it move randomly while firing a weapon?
ENT.AnimTbl_WeaponAttackCrouch = ACT_RANGE_ATTACK2 -- Animation(s) to play while firing a weapon in crouched position
ENT.AnimTbl_CallForHelp = ACT_SIGNAL2
ENT.CallForBackUpOnDamageAnimation = ACT_SIGNAL1 -- Animations played when it calls for help on damage
ENT.AnimTbl_TakingCover = ACT_CROUCHIDLE -- The animation it plays when hiding in a covered position, leave empty to let the base decide
ENT.AnimTbl_AlertFriendsOnDeath = ACT_IDLE_ANGRY -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIE_GUTSHOT, ACT_DIE_HEADSHOT, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false -- How long should the death animation play?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/player/boots1.wav","vj_hlr/hl1_npc/player/boots2.wav","vj_hlr/hl1_npc/player/boots3.wav","vj_hlr/hl1_npc/player/boots4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/shocktrooper/st_idle.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/shocktrooper/st_question1.wav","vj_hlr/hl1_npc/shocktrooper/st_question2.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/shocktrooper/st_answer1.wav","vj_hlr/hl1_npc/shocktrooper/st_answer2.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/shocktrooper/st_combat1.wav","vj_hlr/hl1_npc/shocktrooper/st_combat2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/shocktrooper/st_alert1.wav","vj_hlr/hl1_npc/shocktrooper/st_alert2.wav","vj_hlr/hl1_npc/shocktrooper/st_alert3.wav","vj_hlr/hl1_npc/shocktrooper/st_alert4.wav"}
ENT.SoundTbl_GrenadeAttack = {"vj_hlr/hl1_npc/shocktrooper/st_grenadethrow.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/shocktrooper/st_runfromgrenade.wav"}
ENT.SoundTbl_OnDangerSight = {"vj_hlr/hl1_npc/shocktrooper/st_runfromgrenade.wav"}
ENT.SoundTbl_OnKilledEnemy = {"vj_hlr/hl1_npc/shocktrooper/st_combat1.wav"}

ENT.OnGrenadeSightSoundPitch = VJ.SET(105, 110)

-- Custom
ENT.Shocktrooper_BlinkingT = 0
ENT.Shocktrooper_SpawnRoach = true
ENT.Shocktrooper_DroppedRoach = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 90), Vector(-20, -20, 0))
	self:SetBodygroup(1,0)
	self:Give("weapon_vj_hlrof_strooperwep")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "attack" then
		self:MeleeAttackCode()
	elseif key == "rangeattack" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary()
		end
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- Injured movement when health is low
	if (act == ACT_WALK or act == ACT_RUN) && self:Health() <= (self:GetMaxHealth() / 2.2) then
		if act == ACT_WALK then
			return ACT_WALK_HURT
		elseif act == ACT_RUN then
			return ACT_RUN_HURT
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if !self.Dead && CurTime() > self.Shocktrooper_BlinkingT then
		timer.Simple(0.2, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4, function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.5, function() if IsValid(self) then self:SetSkin(0) end end)
		self.Shocktrooper_BlinkingT = CurTime() + math.Rand(3, 4.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnGrenadeAttack(status, grenade, customEnt, landDir, landingPos)
	-- Make Shock Trooper's grenade more arched than the usual grenade throws
	if status == "Throw" then
		return (landingPos - grenade:GetPos()) + (self:GetUp() * math.random(450, 500) + self:GetForward() * math.Rand(-100, -250) + self:GetRight()*math.Rand(-20, 20))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	self.Shocktrooper_SpawnRoach = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(120)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 42))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 31))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 36))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib5.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 43))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib6.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 21))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 32))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/strooper_gib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 24))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 37))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 41))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_base/gib/splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		self:OnDeath(dmginfo, hitgroup, "Finish")
		local activeWep = self:GetActiveWeapon()
		if IsValid(activeWep) then activeWep:Remove() end
	elseif status == "Finish" then
		::shocktrooper_death::
		self:Shocktrooper_CreateRoach()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Shocktrooper_CreateRoach()
	self:SetBodygroup(1, 1)
	self:SetSkin(2)
	if !self.Shocktrooper_DroppedRoach then
		if self.Shocktrooper_SpawnRoach == true then
			local roachEnt = ents.Create("npc_vj_hlrof_shockroach")
			roachEnt:SetPos(self:GetAttachment(self:LookupAttachment("shock_roach")).Pos)
			roachEnt:SetAngles(self:GetAngles())
			roachEnt.SRoach_Life = 15
			roachEnt:Spawn()
			roachEnt:Activate()
			roachEnt.VJ_NPC_Class = self.VJ_NPC_Class
		end
		self.Shocktrooper_DroppedRoach = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/strooper_gib1.mdl", "models/vj_hlr/gibs/strooper_gib2.mdl", "models/vj_hlr/gibs/strooper_gib3.mdl", "models/vj_hlr/gibs/strooper_gib4.mdl", "models/vj_hlr/gibs/strooper_gib5.mdl", "models/vj_hlr/gibs/strooper_gib6.mdl", "models/vj_hlr/gibs/strooper_gib7.mdl", "models/vj_hlr/gibs/strooper_gib8.mdl", "models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = gibs})
end
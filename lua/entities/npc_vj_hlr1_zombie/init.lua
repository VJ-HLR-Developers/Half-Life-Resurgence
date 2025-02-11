AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/zombie.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 50
ENT.HullType = HULL_HUMAN
ENT.ControllerVars = {
    ThirdP_Offset = Vector(-5, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
//ENT.CanEat = true -- Should it search and eat organic stuff when idle?

ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 50 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds

ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.DisableFootStepSoundTimer = true
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS -- The regular flinch animations to play
ENT.HitGroupFlinching_Values = {
	{HitGroup={HITGROUP_LEFTARM}, Animation={ACT_FLINCH_LEFTARM}},
	{HitGroup={HITGROUP_LEFTLEG}, Animation={ACT_FLINCH_LEFTLEG}},
	{HitGroup={HITGROUP_RIGHTARM}, Animation={ACT_FLINCH_RIGHTARM}},
	{HitGroup={HITGROUP_RIGHTLEG}, Animation={ACT_FLINCH_RIGHTLEG}}
}
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/zombie/zo_idle1.wav","vj_hlr/hl1_npc/zombie/zo_idle2.wav","vj_hlr/hl1_npc/zombie/zo_idle3.wav","vj_hlr/hl1_npc/zombie/zo_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/zombie/zo_alert10.wav","vj_hlr/hl1_npc/zombie/zo_alert20.wav","vj_hlr/hl1_npc/zombie/zo_alert30.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/zombie/zo_attack1.wav","vj_hlr/hl1_npc/zombie/zo_attack2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav","vj_hlr/hl1_npc/zombie/claw_strike2.wav","vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/zombie/zo_pain1.wav","vj_hlr/hl1_npc/zombie/zo_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/zombie/zo_pain1.wav","vj_hlr/hl1_npc/zombie/zo_pain2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Zombie_Type = 0
	-- 0 = Default / Not Categorized
	-- 1 = Default Zombie Scientist
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	if self:GetModel() == "models/vj_hlr/hl1/zombie.mdl" then
		self.Zombie_Type = 1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "melee" then
		self.MeleeAttackDamage = self:GetActivity() == ACT_MELEE_ATTACK1 and 10 or 25
		self:MeleeAttackCode()
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_RUN then
		return ACT_WALK
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "PriorExecution" then
		if dmginfo:GetDamage() > 30 then
			self.FlinchChance = 8
			self.AnimTbl_Flinch = ACT_BIG_FLINCH
		else
			self.FlinchChance = 16
			self.AnimTbl_Flinch = ACT_FLINCH_PHYSICS
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	if self.Zombie_Type == 1 then -- Scientist zombie leg
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/zombiegib.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 15))})
	end
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local animDeathHead = {ACT_DIE_GUTSHOT, ACT_DIE_HEADSHOT}
local animDeathDef = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		if hitgroup == HITGROUP_HEAD then
			self.AnimTbl_Death = animDeathHead
		else
			self.AnimTbl_Death = animDeathDef
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local extraGibs = {"models/vj_hlr/gibs/zombiegib.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = self.Zombie_Type == 1 and extraGibs or nil})
end
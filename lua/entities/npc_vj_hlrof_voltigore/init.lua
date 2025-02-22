AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/voltigore.mdl"
ENT.StartHealth = 320
ENT.HullType = HULL_LARGE
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bone41",
    FirstP_Offset = Vector(10, 0, 0),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow_large"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.MeleeAttackDamage = 30
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 100
ENT.MeleeAttackDamageDistance = 125

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlrof_voltigore_energy"
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 100
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(3, 4)

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true

ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/voltigore/voltigore_footstep1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_footstep2.wav", "vj_hlr/hl1_npc/voltigore/voltigore_footstep3.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/voltigore/voltigore_idle1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_idle2.wav", "vj_hlr/hl1_npc/voltigore/voltigore_idle3.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/voltigore/voltigore_communicate1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_communicate2.wav", "vj_hlr/hl1_npc/voltigore/voltigore_communicate3.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/voltigore/voltigore_communicate1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_communicate2.wav", "vj_hlr/hl1_npc/voltigore/voltigore_communicate3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/voltigore/voltigore_alert1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_alert2.wav", "vj_hlr/hl1_npc/voltigore/voltigore_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/voltigore/voltigore_attack_melee1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_attack_melee2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav", "vj_hlr/hl1_npc/zombie/claw_strike2.wav", "vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav", "vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/voltigore/voltigore_attack_shock.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/voltigore/voltigore_pain1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_pain2.wav", "vj_hlr/hl1_npc/voltigore/voltigore_pain3.wav", "vj_hlr/hl1_npc/voltigore/voltigore_pain4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/voltigore/voltigore_die1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_die2.wav", "vj_hlr/hl1_npc/voltigore/voltigore_die3.wav"}

local extraMoveSd = {"vj_hlr/hl1_npc/voltigore/voltigore_run_grunt1.wav", "vj_hlr/hl1_npc/voltigore/voltigore_run_grunt2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(60, 60, 95), Vector(-60, -60, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
		util.ScreenShake(self:GetPos(), 10, 100, 0.4, 300)
	end
	if key == "grunting_sounds" then
		self:PlayFootstepSound(extraMoveSd)
		util.ScreenShake(self:GetPos(), 10, 100, 0.4, 300)
	end
	if key == "single" or key == "both" then
		self:ExecuteMeleeAttack()
	end
	if key == "purple_energy_ball" then
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local elecTime = 0.989990234375
--
function ENT:CustomOnRangeAttack_AfterStartTimer()
	local endPos = self:GetAttachment(self:LookupAttachment("3")).Pos
	for att = 1, 3 do
		local tr = util.TraceLine({
			start = self:GetAttachment(att).Pos,
			endpos = endPos,
			filter = self
		})
		local elec = EffectData()
		elec:SetStart(tr.StartPos)
		elec:SetOrigin(tr.HitPos)
		elec:SetEntity(self)
		elec:SetAttachment(att)
		elec:SetScale(elecTime)
		util.Effect("VJ_HLR_Electric_Charge_Purple", elec)
	end
	
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "vj_hl/sprites/flare3.vmt")
	spr:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
	spr:SetKeyValue("renderfx", "14")
	spr:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
	spr:SetKeyValue("renderamt", "255") -- Transparency
	spr:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
	spr:SetKeyValue("framerate", "10.0") -- Rate at which the sprite should animate, if at all.
	spr:SetKeyValue("spawnflags", "0")
	spr:SetParent(self)
	spr:Fire("SetParentAttachment", "3")
	spr:Spawn()
	spr:Activate()
	self:DeleteOnRemove(spr)
	timer.Simple(elecTime, function() if IsValid(self) && IsValid(spr) then spr:Remove() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("3")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	-- Make it explode all the time if it was middle of range attacking!
	if status == "Init" && self.AttackType == VJ.ATTACK_TYPE_RANGE then
		self.GibOnDeathFilter = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	local myPos = self:GetPos()
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(myPos + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(250)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	VJ.ApplyRadiusDamage(self, self, myPos, 120, 50, DMG_SONIC, false, true)
	util.ScreenShake(myPos, 5, 5, 1, 1000)
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/voltigore_gib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	
	VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris"..math.random(1, 3)..".wav", 90, 100) -- No far away sound for this!
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/voltigore_gib1.mdl", "models/vj_hlr/gibs/voltigore_gib2.mdl", "models/vj_hlr/gibs/voltigore_gib3.mdl", "models/vj_hlr/gibs/voltigore_gib4.mdl", "models/vj_hlr/gibs/voltigore_gib5.mdl", "models/vj_hlr/gibs/voltigore_gib6.mdl", "models/vj_hlr/gibs/voltigore_gib7.mdl", "models/vj_hlr/gibs/voltigore_gib8.mdl", "models/vj_hlr/gibs/voltigore_gib9.mdl", "models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = gibs})
end
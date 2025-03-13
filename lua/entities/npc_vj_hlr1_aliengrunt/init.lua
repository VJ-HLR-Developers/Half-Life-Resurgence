AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/agrunt.mdl"
ENT.StartHealth = 120
ENT.HullType = HULL_HUMAN
ENT.ControllerParams = {
	FirstP_Bone = "bip01 head",
	FirstP_Offset = Vector(12, 0, 5),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.MeleeAttackDamage = 20
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 40
ENT.MeleeAttackDamageDistance = 70

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_hornet"
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackMaxDistance = 1100
ENT.RangeAttackMinDistance = 200
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 0

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"
ENT.HasDeathAnimation = true
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH

ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/npc/player/pl_ladder1.wav", "vj_hlr/gsrc/npc/player/pl_ladder2.wav", "vj_hlr/gsrc/npc/player/pl_ladder3.wav", "vj_hlr/gsrc/npc/player/pl_ladder4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/agrunt/ag_idle1.wav", "vj_hlr/gsrc/npc/agrunt/ag_idle2.wav", "vj_hlr/gsrc/npc/agrunt/ag_idle3.wav", "vj_hlr/gsrc/npc/agrunt/ag_idle4.wav", "vj_hlr/gsrc/npc/agrunt/ag_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/agrunt/ag_alert1.wav", "vj_hlr/gsrc/npc/agrunt/ag_alert2.wav", "vj_hlr/gsrc/npc/agrunt/ag_alert3.wav", "vj_hlr/gsrc/npc/agrunt/ag_alert4.wav", "vj_hlr/gsrc/npc/agrunt/ag_alert5.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/gsrc/npc/zombie/claw_strike1.wav", "vj_hlr/gsrc/npc/zombie/claw_strike2.wav", "vj_hlr/gsrc/npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav", "vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/gsrc/npc/agrunt/ag_attack1.wav", "vj_hlr/gsrc/npc/agrunt/ag_attack2.wav", "vj_hlr/gsrc/npc/agrunt/ag_attack3.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/gsrc/npc/agrunt/ag_attack1.wav", "vj_hlr/gsrc/npc/agrunt/ag_attack2.wav", "vj_hlr/gsrc/npc/agrunt/ag_attack3.wav"}
//ENT.SoundTbl_RangeAttack = {"vj_hlr/gsrc/npc/agrunt/ag_fire1.wav", "vj_hlr/gsrc/npc/agrunt/ag_fire2.wav", "vj_hlr/gsrc/npc/agrunt/ag_fire3.wav"} -- Done by events instead because we need it as EmitSound since it plays too many of them at the same time!
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/agrunt/ag_pain1.wav", "vj_hlr/gsrc/npc/agrunt/ag_pain2.wav", "vj_hlr/gsrc/npc/agrunt/ag_pain3.wav", "vj_hlr/gsrc/npc/agrunt/ag_pain4.wav", "vj_hlr/gsrc/npc/agrunt/ag_pain5.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/agrunt/ag_die1.wav", "vj_hlr/gsrc/npc/agrunt/ag_die2.wav", "vj_hlr/gsrc/npc/agrunt/ag_die3.wav", "vj_hlr/gsrc/npc/agrunt/ag_die4.wav", "vj_hlr/gsrc/npc/agrunt/ag_die5.wav"}

ENT.MainSoundPitch = 100
ENT.FootstepSoundPitch = 70

-- Custom
ENT.AGrunt_Type = 0
	-- 0 = Original / Default
	-- 1 = Alpha
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_aliengrunt" then
		self.Model = "models/vj_hlr/hl_hd/agrunt.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(25, 25, 85), Vector(-25, -25, 0))
	
	if self.AGrunt_Type == 1 then --Alpha
		self.AnimTbl_Death = ACT_DIESIMPLE
	else -- Default
		self.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
		self.FlinchHitGroupMap = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "event_emit Step" then
		self:PlayFootstepSound()
	elseif key == "event_mattack" then
		self:ExecuteMeleeAttack()
	elseif key == "event_rattack" then
		self:ExecuteRangeAttack()
		self:PlaySoundSystem("RangeAttack", "vj_hlr/gsrc/npc/".. (self.AGrunt_Type == 1 and "agrunt_alpha" or "agrunt") .."/ag_fire"..math.random(1, 3)..".wav", VJ.EmitSound)
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/gsrc/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PostSpawn" then
		-- Only default Alien Grunt has a muzzle flash!
		projectile.Track_Ent = enemy
		if self.AGrunt_Type == 0 then
			//ParticleEffect("vj_hl_muz7", self:GetAttachment(self:LookupAttachment("hornet")).Pos, self:GetForward():Angle(), self) -- Unimplemented sprite function, needs fixed
			
			local att = self:GetAttachment(self:LookupAttachment("hornet"))
			local muzzleFlash = ents.Create("env_sprite")
			muzzleFlash:SetKeyValue("model", "vj_hl/sprites/muz4.vmt")
			muzzleFlash:SetKeyValue("scale", tostring(math.Rand(0.5, 0.65)))
			muzzleFlash:SetKeyValue("rendermode", "3")
			muzzleFlash:SetKeyValue("renderfx", "14")
			muzzleFlash:SetKeyValue("renderamt", "255")
			muzzleFlash:SetKeyValue("rendercolor", "255 255 255")
			muzzleFlash:SetKeyValue("spawnflags", "0")
			muzzleFlash:SetParent(self)
			muzzleFlash:SetOwner(self)
			muzzleFlash:SetPos(att.Pos + att.Ang:Forward() * 15)
			muzzleFlash:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
			muzzleFlash:Spawn()
			muzzleFlash:Fire("Kill", "", 0.08)
			self:DeleteOnRemove(muzzleFlash)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("hornet")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && hitgroup == HITGROUP_GEAR then
		dmginfo:SetDamage(0)
		if dmginfo:GetDamagePosition() != vec then
			local rico = EffectData()
			rico:SetOrigin(dmginfo:GetDamagePosition())
			rico:SetScale(4) -- Size
			rico:SetMagnitude(2) -- Effect type | 1 = Animated | 2 = Basic
			util.Effect("VJ_HLR_Rico", rico)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnFlinch(dmginfo, hitgroup, status)
	if status == "Init" then
		if dmginfo:GetDamage() > 30 then
			self.AnimTbl_Flinch = ACT_BIG_FLINCH
		else
			self.AnimTbl_Flinch = ACT_SMALL_FLINCH
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 10))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agrunt_gib.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 65))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		if self.AGrunt_Type == 1 then -- Alpha
			if hitgroup == HITGROUP_HEAD then
				self.AnimTbl_Death = ACT_DIEFORWARD
			end
		else
			if hitgroup == HITGROUP_HEAD then
				self.AnimTbl_Death = ACT_DIE_HEADSHOT
			elseif hitgroup == HITGROUP_STOMACH then
				self.AnimTbl_Death = ACT_DIE_GUTSHOT
			end
		end
	-- Chance of dropping an actual hornet gun that the player can pick up
	elseif status == "Finish" && self.AGrunt_Type == 0 && math.random(1, 50) == 1 then
		self:SetBodygroup(1, 1)
		local gun = ents.Create("weapon_hornetgun")
		gun:SetPos(self:GetAttachment(self:LookupAttachment("hornet")).Pos)
		gun:SetAngles(self:GetAngles())
		gun:Spawn()
		gun:Activate()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local extraGibs = {"models/vj_hlr/gibs/agrunt_gib.mdl", "models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = extraGibs})
end
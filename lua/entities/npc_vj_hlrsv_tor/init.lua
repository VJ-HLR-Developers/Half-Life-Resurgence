AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/sven/tor.mdl"
ENT.StartHealth = 3000
ENT.SightAngle = 220
ENT.HullType = HULL_HUMAN
ENT.VJ_ID_Boss = true
ENT.ControllerParams = {
    ThirdP_Offset = Vector(15, 0, -15),
    FirstP_Bone = "TorSkel Head",
    FirstP_Offset = Vector(15, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

-- ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1    = Swing / stab
-- ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK_SWING = Cutting (dozen times)
-- ACT_RANGE_ATTACK2						 = Sonic attack (This must be inputted twice so it has a fair chance to the other attacks!)
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1, ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK_SWING, ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1, ACT_RANGE_ATTACK2, ACT_RANGE_ATTACK2}
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 45
ENT.MeleeAttackDamageDistance = 75

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_orb_electrical"
ENT.RangeAttackMaxDistance = 2000
ENT.RangeAttackMinDistance = 100
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(3, 4)

ENT.LimitChaseDistance = "OnlyRange"
ENT.LimitChaseDistance_Max = 1000
ENT.LimitChaseDistance_Min = 250

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH
ENT.FlinchHitGroupMap = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.SoundTbl_FootStep = {"vj_hlr/gsrc/npc/aslave/vort_foot1.wav", "vj_hlr/gsrc/npc/aslave/vort_foot2.wav", "vj_hlr/gsrc/npc/aslave/vort_foot3.wav", "vj_hlr/gsrc/npc/aslave/vort_foot4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/tor_sven/tor-idle.wav", "vj_hlr/gsrc/npc/tor_sven/tor-idle2.wav", "vj_hlr/gsrc/npc/tor_sven/tor-idle3.wav", "vj_hlr/gsrc/npc/tor_sven/tor-test1.wav"}
ENT.SoundTbl_Alert = "vj_hlr/gsrc/npc/tor_sven/tor-alerted.wav"
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/gsrc/npc/tor_sven/tor-attack1.wav", "vj_hlr/gsrc/npc/tor_sven/tor-attack2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/gsrc/npc/zombie/claw_strike1.wav", "vj_hlr/gsrc/npc/zombie/claw_strike2.wav", "vj_hlr/gsrc/npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav", "vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_RangeAttack = "vj_hlr/gsrc/npc/tor_sven/tor-staff-discharge.wav"
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/tor_sven/tor-pain.wav", "vj_hlr/gsrc/npc/tor_sven/tor-pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/tor_sven/tor-die.wav", "vj_hlr/gsrc/npc/tor_sven/tor-die2.wav"}

ENT.IdleSoundLevel = 80
ENT.AlertSoundLevel = 85

-- Custom
ENT.Tor_NextSpawnT = 0
ENT.Tor_Level = 0 -- 0 = Normal (Green) | 1 = Buffed (Blue)
ENT.Tor_SkipRegMelee = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(25, 25, 90), Vector(-25, -25, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Spawn an Alien Grunt")
	
	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE then
			self.VJCE_NPC:Tor_StartSpawnAlly()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ20 = Vector(0, 0, 20)
--
function ENT:Tor_SpawnAlly()
	-- Can have a total of 3, only 1 can be spawned at a time with a delay until another one is spawned
	local spawnPos = self:GetPos() + self:GetForward() * 100 + self:GetUp() * 5
	local effectTeleport = VJ.HLR1_Effect_Portal(spawnPos + vecZ20, nil, nil, function()
		-- onSpawn
		if IsValid(self) then
			local ally = ents.Create("npc_vj_hlr1_aliengrunt")
			ally:SetPos(spawnPos)
			ally:SetAngles(self:GetAngles())
			ally.VJ_NPC_Class = self.VJ_NPC_Class
			ally:Spawn()
			ally:Activate()
			if !IsValid(self.Tor_Ally1) then
				self.Tor_Ally1 = ally
			elseif !IsValid(self.Tor_Ally2) then
				self.Tor_Ally2 = ally
			elseif !IsValid(self.Tor_Ally3) then
				self.Tor_Ally3 = ally
			end
		end
	end)
	self:DeleteOnRemove(effectTeleport)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tor_StartSpawnAlly()
	if !self:IsBusy("Activities") && CurTime() > self.Tor_NextSpawnT && (!IsValid(self.Tor_Ally1) or !IsValid(self.Tor_Ally2) or !IsValid(self.Tor_Ally3)) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*150,
			filter = self
		})
		if !tr.Hit then
			self:PlayAnim(ACT_SIGNAL_GROUP, true, false)
			VJ.EmitSound(self, "vj_hlr/gsrc/npc/tor_sven/tor-summon.wav")
			self.Tor_NextSpawnT = CurTime() + 10
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "summon" then
		self:Tor_SpawnAlly()
	elseif key == "melee_single" then
		self.HasMeleeAttackMissSounds = true
		self.Tor_SkipRegMelee = false
		self.MeleeAttackDamage = (self.Tor_Level == 0 and 20) or 40
		self:ExecuteMeleeAttack()
	elseif key == "melee" then
		self.HasMeleeAttackMissSounds = false
		self.Tor_SkipRegMelee = false
		self.MeleeAttackDamage = (self.Tor_Level == 0 and 3) or 5
		self:ExecuteMeleeAttack()
	elseif key == "slam" then
		local startPos = self:GetPos() + self:GetForward()*20
		self.HasMeleeAttackMissSounds = false
		self.Tor_SkipRegMelee = true
		VJ.EmitSound(self, "vj_hlr/gsrc/npc/tor_sven/tor-staff-discharge.wav", 90)
		effects.BeamRingPoint(startPos, 0.3, 2, 600, 36, 0, (self.Tor_Level == 0 and Color(0, 255, 0)) or Color(0, 0, 255), {framerate=20, flags=0})
		util.ScreenShake(startPos, 10, 10, 1, 1000)
		util.Decal("VJ_HLR1_Gargantua_Stomp", startPos, startPos + self:GetUp()*-100, self)
		VJ.ApplyRadiusDamage(self, self, startPos, 500, (self.Tor_Level == 0 and 40) or 60, DMG_SONIC, true, true, {DisableVisibilityCheck=true, Force=20})
		//self:ExecuteMeleeAttack()
	elseif key == "range" then
		self:ExecuteRangeAttack()
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/gsrc/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	-- Spawn an ally
	if !self.Dead && !self.VJ_IsBeingControlled && IsValid(self:GetEnemy()) then
		self:Tor_StartSpawnAlly()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	self:PlayAnim(ACT_DEPLOY, true, false, true) -- Angry animation
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	return self.Tor_SkipRegMelee
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PreSpawn" then
		projectile.Track_Ent = enemy
		projectile.Track_SpriteScale = (self.Tor_Level == 0 and 0.6) or 1
		projectile.DirectDamage = (self.Tor_Level == 0 and 10) or 20
		timer.Simple(10, function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("0")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PostDamage" && self.Tor_Level == 0 && (self:Health() < (self:GetMaxHealth() * 0.5)) then
		self.Tor_Level = 1
		self:PlayAnim(ACT_VICTORY_DANCE, true, false)
		timer.Simple(1.2, function()
			if IsValid(self) && self.Dead != true then
				self:SetSkin(1)
				VJ.EmitSound(self, "vj_hlr/gsrc/npc/tor_sven/tor-summon.wav", 80)
				effects.BeamRingPoint(self:GetPos() + self:GetForward()*20, 0.3, 2, 600, 60, 0, Color(0, 0, 255), {framerate=20, flags=0})
				util.ScreenShake(self:GetPos(), 10, 10, 1, 1000)
				VJ.ApplyRadiusDamage(self, self, self:GetPos(), 500, 20, DMG_SONIC, true, true, {DisableVisibilityCheck=true, Force=80})
			end
		end)
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
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/islavegib.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 41))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" && hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = ACT_DIEBACKWARD
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl", "models/vj_hlr/gibs/islavegib.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	corpse:SetBodygroup(1, 1)
	local att = self:GetAttachment(self:LookupAttachment("0")) //self:GetBonePosition(self:LookupBone("Dummy01"))
	self:CreateExtraDeathCorpse("prop_physics", "models/vj_hlr/sven/tor_staff.mdl", {Pos=att.Pos, Ang=att.Ang}, function(x)
		x:SetSkin(self:GetSkin())
	end)
	VJ.HLR_ApplyCorpseSystem(self, corpse, nil, {ExtraGibs = gibs})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	-- If the NPC was removed, then remove its children as well, but not when it's killed!
	if !self.Dead then
		if IsValid(self.Tor_Ally1) then self.Tor_Ally1:Remove() end
		if IsValid(self.Tor_Ally2) then self.Tor_Ally2:Remove() end
		if IsValid(self.Tor_Ally3) then self.Tor_Ally3:Remove() end
	end
end
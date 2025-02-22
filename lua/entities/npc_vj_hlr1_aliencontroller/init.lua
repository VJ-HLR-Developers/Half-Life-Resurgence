AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/controller.mdl"
ENT.StartHealth = 60
ENT.SightAngle = 360
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 120
ENT.Aerial_FlyingSpeed_Alerted = 300
ENT.ControllerParams = {
	FirstP_Bone = "bip01 neck",
	FirstP_Offset = Vector(10, 0, -3),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.ConstantlyFaceEnemy = true
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_energyorb"
ENT.RangeAttackMaxDistance = 2048
ENT.RangeAttackMinDistance = 1
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(3, 4)

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathAnimationTime = 1.2

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH

ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/controller/con_idle1.wav", "vj_hlr/hl1_npc/controller/con_idle2.wav", "vj_hlr/hl1_npc/controller/con_idle3.wav", "vj_hlr/hl1_npc/controller/con_idle4.wav", "vj_hlr/hl1_npc/controller/con_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/controller/con_alert1.wav", "vj_hlr/hl1_npc/controller/con_alert2.wav", "vj_hlr/hl1_npc/controller/con_alert3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/controller/con_attack1.wav", "vj_hlr/hl1_npc/controller/con_attack2.wav", "vj_hlr/hl1_npc/controller/con_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/controller/con_pain1.wav", "vj_hlr/hl1_npc/controller/con_pain2.wav", "vj_hlr/hl1_npc/controller/con_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/controller/con_die1.wav", "vj_hlr/hl1_npc/controller/con_die2.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.AlienC_HomingAttack = false -- false = Regular, true = Homing
ENT.AlienC_NumFired = 0 -- Used to make sure range attack sound only plays once

ENT.AlienC_FlyAnim_Forward  = 0
ENT.AlienC_FlyAnim_Backward  = 0
ENT.AlienC_FlyAnim_Right  = 0
ENT.AlienC_FlyAnim_Left  = 0
ENT.AlienC_FlyAnim_Up  = 0
ENT.AlienC_FlyAnim_Down  = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 70), Vector(-20, -20, -10))
	
	local zapSpr1 = ents.Create("env_sprite")
	zapSpr1:SetKeyValue("model", "vj_hl/sprites/xspark4.vmt")
	zapSpr1:SetKeyValue("scale", "1")
	zapSpr1:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
	zapSpr1:SetKeyValue("renderfx", "14")
	zapSpr1:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
	zapSpr1:SetKeyValue("renderamt", "255") -- Transparency
	zapSpr1:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
	zapSpr1:SetKeyValue("framerate", "10.0") -- Rate at which the sprite should animate, if at all.
	zapSpr1:SetKeyValue("spawnflags", "0")
	zapSpr1:SetParent(self)
	zapSpr1:Fire("SetParentAttachment", "2")
	zapSpr1:Spawn()
	zapSpr1:Activate()
	zapSpr1:SetNoDraw(true)
	self:DeleteOnRemove(zapSpr1)
	self.ZapSpr1 = zapSpr1
	
	local zapSpr2 = ents.Create("env_sprite")
	zapSpr2:SetKeyValue("model", "vj_hl/sprites/xspark4.vmt")
	zapSpr2:SetKeyValue("scale", "1")
	zapSpr2:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
	zapSpr2:SetKeyValue("renderfx", "14")
	zapSpr2:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
	zapSpr2:SetKeyValue("renderamt", "255") -- Transparency
	zapSpr2:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
	zapSpr2:SetKeyValue("framerate", "10.0") -- Rate at which the sprite should animate, if at all.
	zapSpr2:SetKeyValue("spawnflags", "0")
	zapSpr2:SetParent(self)
	zapSpr2:Fire("SetParentAttachment", "3")
	zapSpr2:Spawn()
	zapSpr2:Activate()
	zapSpr2:SetNoDraw(true)
	self:DeleteOnRemove(zapSpr2)
	self.ZapSpr2 = zapSpr2
	
	self.AlienC_FlyAnim_Forward  = self:GetSequenceActivity(self:LookupSequence("forward"))
	self.AlienC_FlyAnim_Backward  = self:GetSequenceActivity(self:LookupSequence("backward"))
	self.AlienC_FlyAnim_Right  = self:GetSequenceActivity(self:LookupSequence("right"))
	self.AlienC_FlyAnim_Left  = self:GetSequenceActivity(self:LookupSequence("left"))
	self.AlienC_FlyAnim_Up  = self:GetSequenceActivity(self:LookupSequence("up"))
	self.AlienC_FlyAnim_Down  = self:GetSequenceActivity(self:LookupSequence("down"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "rangeattack" or key == "rangeattack_close" then
		if IsValid(self.ZapSpr1) then
			self.ZapSpr1:SetNoDraw(true)
		end
		if IsValid(self.ZapSpr2) then
			self.ZapSpr2:SetNoDraw(true)
		end
		self.AlienC_HomingAttack = key == "rangeattack_close"
		self:ExecuteRangeAttack()
	elseif key == "sprite" && !self.AlienC_HomingAttack && self.AttackType == VJ.ATTACK_TYPE_RANGE then
		if IsValid(self.ZapSpr1) then
			self.ZapSpr1:SetNoDraw(false)
		end
		if IsValid(self.ZapSpr2) then
			self.ZapSpr2:SetNoDraw(false)
		end
		-- Backup timer to make sure the sprites are hidden in case event doesn't run!
		timer.Simple(2, function()
			if IsValid(self) then
				if IsValid(self.ZapSpr1) then
					self.ZapSpr1:SetNoDraw(true)
				end
				if IsValid(self.ZapSpr2) then
					self.ZapSpr2:SetNoDraw(true)
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_FLY then
		if self.AA_CurrentMovePosDir then
			local moveDir = self.AA_CurrentMovePosDir:GetNormal()
			-- Up-down
			local dotUp = moveDir:Dot(self:GetUp())
			if dotUp > 0.60 then
				return self.AlienC_FlyAnim_Up
			elseif dotUp < -0.60 then
				return self.AlienC_FlyAnim_Down
			end
			-- Forward-backward
			local dotForward = moveDir:Dot(self:GetForward())
			if dotForward > 0.5 then
				return self.AlienC_FlyAnim_Forward
			elseif dotForward < -0.5 then
				return self.AlienC_FlyAnim_Backward
			end
			-- Right-left
			local dotRight = moveDir:Dot(self:GetRight())
			if dotRight > 0.5 then
				return self.AlienC_FlyAnim_Right
			elseif dotRight < -0.5 then
				return self.AlienC_FlyAnim_Left
			end
		end
		return self.AlienC_FlyAnim_Up -- Fallback animation
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("Right Mouse + CTRL: Fire a homing orb")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_BeforeStartTimer(seed)
	if (math.random(1, 2) == 1 && self.EnemyData.DistanceNearest < 850) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_DUCK)) then
		self.AnimTbl_RangeAttack = ACT_RANGE_ATTACK2
		self.AlienC_HomingAttack = true
	else
		self.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
		self.AlienC_HomingAttack = false
	end
	self.AlienC_NumFired = 0
	self.HasRangeAttackSounds = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
	local ene = self:GetEnemy()
	if self.AlienC_HomingAttack && IsValid(ene) then
		projectile.Track_Enemy = ene
		timer.Simple(10, function() if IsValid(projectile) then projectile:Remove() end end)
	end
	
	if self.AlienC_NumFired < 1 then
		self.AlienC_NumFired = self.AlienC_NumFired + 1
		self.HasRangeAttackSounds = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * (self.AlienC_HomingAttack and 80 or 20)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,0,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,1,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(2,0,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,2,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(3,0,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,3,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,1,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,2,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow",CollisionDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(2,0,20))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
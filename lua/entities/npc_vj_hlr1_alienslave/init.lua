AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/islave.mdl"-- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 60
ENT.SightAngle = 220
ENT.HullType = HULL_HUMAN
ENT.ControllerParams = {
	FirstP_Bone = "bip01 head",
	FirstP_Offset = Vector(5, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.MeleeAttackDamage = 20
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 40
ENT.MeleeAttackDamageDistance = 70

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackMaxDistance = 1020
ENT.RangeAttackMinDistance = 100
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 3
ENT.DisableDefaultRangeAttackCode = true

ENT.LimitChaseDistance = "OnlyRange"
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH
ENT.FlinchHitGroupMap = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}},{HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}},{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/aslave/vort_foot1.wav", "vj_hlr/hl1_npc/aslave/vort_foot2.wav", "vj_hlr/hl1_npc/aslave/vort_foot3.wav", "vj_hlr/hl1_npc/aslave/vort_foot4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/aslave/slv_idle1.wav", "vj_hlr/hl1_npc/aslave/slv_idle2.wav", "vj_hlr/hl1_npc/aslave/slv_idle3.wav", "vj_hlr/hl1_npc/aslave/slv_idle4.wav", "vj_hlr/hl1_npc/aslave/slv_idle5.wav", "vj_hlr/hl1_npc/aslave/slv_idle6.wav", "vj_hlr/hl1_npc/aslave/slv_idle7.wav", "vj_hlr/hl1_npc/aslave/slv_idle8.wav", "vj_hlr/hl1_npc/aslave/slv_idle9.wav", "vj_hlr/hl1_npc/aslave/slv_idle10.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/aslave/slv_idle1.wav", "vj_hlr/hl1_npc/aslave/slv_idle2.wav", "vj_hlr/hl1_npc/aslave/slv_idle3.wav", "vj_hlr/hl1_npc/aslave/slv_idle4.wav", "vj_hlr/hl1_npc/aslave/slv_idle5.wav", "vj_hlr/hl1_npc/aslave/slv_idle6.wav", "vj_hlr/hl1_npc/aslave/slv_idle7.wav", "vj_hlr/hl1_npc/aslave/slv_idle8.wav", "vj_hlr/hl1_npc/aslave/slv_idle9.wav", "vj_hlr/hl1_npc/aslave/slv_idle10.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/aslave/slv_idle1.wav", "vj_hlr/hl1_npc/aslave/slv_idle2.wav", "vj_hlr/hl1_npc/aslave/slv_idle3.wav", "vj_hlr/hl1_npc/aslave/slv_idle4.wav", "vj_hlr/hl1_npc/aslave/slv_idle5.wav", "vj_hlr/hl1_npc/aslave/slv_idle6.wav", "vj_hlr/hl1_npc/aslave/slv_idle7.wav", "vj_hlr/hl1_npc/aslave/slv_idle8.wav", "vj_hlr/hl1_npc/aslave/slv_idle9.wav", "vj_hlr/hl1_npc/aslave/slv_idle10.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/aslave/slv_alert01.wav", "vj_hlr/hl1_npc/aslave/slv_alert02.wav", "vj_hlr/hl1_npc/aslave/slv_alert03.wav", "vj_hlr/hl1_npc/aslave/slv_alert04.wav", "vj_hlr/hl1_npc/aslave/slv_alert05.wav", "vj_hlr/hl1_npc/aslave/slv_alert06.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav", "vj_hlr/hl1_npc/zombie/claw_strike2.wav", "vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav", "vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/fx/zap4.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/hassault/hw_shoot1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/aslave/slv_pain1.wav", "vj_hlr/hl1_npc/aslave/slv_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/aslave/slv_die1.wav", "vj_hlr/hl1_npc/aslave/slv_die2.wav"}

ENT.FootstepSoundLevel = 60

ENT.MainSoundPitch = 100
ENT.RangeAttackPitch = VJ.SET(130, 160)

-- Custom
ENT.Vort_RunAway = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD && self:GetClass() == "npc_vj_hlr1_alienslave" then
		self.Model = "models/vj_hlr/hl_hd/islave.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 65), Vector(-20, -20, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "right" or key == "left" then
		self:ExecuteMeleeAttack()
	elseif key == "shoot" then
		self:ExecuteRangeAttack()
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Vort_DoElecEffect(startPos, hitPos, hitNormal, attachment, timeDecrease)
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetNormal(hitNormal)
	elec:SetEntity(self)
	elec:SetAttachment(attachment)
	elec:SetScale(2.2 - timeDecrease)
	util.Effect("VJ_HLR_Electric_Charge", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	-- Slowly fade the pitch to be higher like the original game
	if self.CurrentSpeechSound then
		self.CurrentSpeechSound:ChangePitch(90 + 90, 1.2)
	end
	
	local myPos = self:GetPos()
	local myForward = self:GetForward()
	local myRight = self:GetRight()
	local myUp = self:GetUp()
	
	-- Tsakh --------------------------
	local tsakhSpawn = myPos + myUp*45 + myRight*20
	local tsakhLocations = {
		myPos + myRight*math.Rand(150, 500) + myUp*-200,
		myPos + myRight*math.Rand(150, 500) + myUp*-200 + myForward*-math.Rand(150, 500),
		myPos + myRight*math.Rand(150, 500) + myUp*-200 + myForward*math.Rand(150, 500),
		myPos + myRight*math.Rand(1, 150) + myUp*200 + myForward*math.Rand(-100, 100),
	}
	for i = 1, 4 do
		local randTime = math.Rand(0, 0.6)
		timer.Simple(randTime, function()
			if IsValid(self) then
				local tr = util.TraceLine({
					start = tsakhSpawn,
					endpos = tsakhLocations[i],
					filter = self
				})
				if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal, 1, randTime) end
			end
		end)
	end
	-- Ach --------------------------
	local achSpawn = myPos + myUp*45 + myRight*-20
	local achLocations = {
		myPos + myRight*-math.Rand(150, 500) + myUp*-200,
		myPos + myRight*-math.Rand(150, 500) + myUp*-200 + myForward*-math.Rand(150, 500),
		myPos + myRight*-math.Rand(150, 500) + myUp*-200 + myForward*math.Rand(150, 500),
		myPos + myRight*-math.Rand(1, 150) + myUp*200 + myForward*math.Rand(-100, 100),
	}
	for i = 1, 4 do
		local randTime = math.Rand(0, 0.6)
		timer.Simple(randTime, function()
			if IsValid(self) then
				local tr = util.TraceLine({
					start = achSpawn,
					endpos = achLocations[i],
					filter = self
				})
				if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal, 2, randTime) end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local startPos = self:GetPos() + self:GetUp()*45 + self:GetForward()*40
	local tr = util.TraceLine({
		start = startPos,
		endpos = self:GetAimPosition(self:GetEnemy(), startPos, 0),
		filter = self
	})
	local hitPos = tr.HitPos
	
	-- Fire 2 electric beams at the enemy
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	util.Effect("VJ_HLR_Electric", elec)
	elec:SetAttachment(2)
	util.Effect("VJ_HLR_Electric", elec)
	
	VJ.ApplyRadiusDamage(self, self, hitPos, 30, 20, DMG_SHOCK, true, false, {Force = 90})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
	self.BaseClass.SelectSchedule(self)
	-- Hide after being attacked
	if !self.Dead && self.Vort_RunAway && !self:IsBusy() && !self.VJ_IsBeingControlled then
		self.Vort_RunAway = false
		self:SCHEDULE_COVER_ENEMY("TASK_RUN_PATH", function(x) x.RunCode_OnFail = function() self.NextDoAnyAttackT = 0 end end)
		self.NextDoAnyAttackT = CurTime() + 5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PostDamage" then
		if (self.NextDoAnyAttackT + 2) > CurTime() then return end
		self.Vort_RunAway = true
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,1,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/islavegib.mdl",{BloodType="Yellow", CollisionDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1,0,40))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" && hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = ACT_DIE_HEADSHOT
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local extraGibs = {"models/vj_hlr/gibs/islavegib.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = extraGibs})
end
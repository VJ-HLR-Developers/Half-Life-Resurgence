AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/islave.mdl"-- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 60
ENT.SightAngle = 220
ENT.HullType = HULL_HUMAN
ENT.VJC_Data = {
	FirstP_Bone = "bip01 head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(5, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.MeleeAttackDamage = 20
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 40 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeDistance = 1020 -- How far can it range attack?
ENT.RangeToMeleeDistance = 100 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.NoChaseAfterCertainRange = true -- Should the NPC stop chasing when the enemy is within the given far and close distances?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD, ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false -- How long should the death animation play?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}},{HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}},{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/aslave/vort_foot1.wav","vj_hlr/hl1_npc/aslave/vort_foot2.wav","vj_hlr/hl1_npc/aslave/vort_foot3.wav","vj_hlr/hl1_npc/aslave/vort_foot4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/aslave/slv_idle1.wav","vj_hlr/hl1_npc/aslave/slv_idle2.wav","vj_hlr/hl1_npc/aslave/slv_idle3.wav","vj_hlr/hl1_npc/aslave/slv_idle4.wav","vj_hlr/hl1_npc/aslave/slv_idle5.wav","vj_hlr/hl1_npc/aslave/slv_idle6.wav","vj_hlr/hl1_npc/aslave/slv_idle7.wav","vj_hlr/hl1_npc/aslave/slv_idle8.wav","vj_hlr/hl1_npc/aslave/slv_idle9.wav","vj_hlr/hl1_npc/aslave/slv_idle10.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/aslave/slv_idle1.wav","vj_hlr/hl1_npc/aslave/slv_idle2.wav","vj_hlr/hl1_npc/aslave/slv_idle3.wav","vj_hlr/hl1_npc/aslave/slv_idle4.wav","vj_hlr/hl1_npc/aslave/slv_idle5.wav","vj_hlr/hl1_npc/aslave/slv_idle6.wav","vj_hlr/hl1_npc/aslave/slv_idle7.wav","vj_hlr/hl1_npc/aslave/slv_idle8.wav","vj_hlr/hl1_npc/aslave/slv_idle9.wav","vj_hlr/hl1_npc/aslave/slv_idle10.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/aslave/slv_idle1.wav","vj_hlr/hl1_npc/aslave/slv_idle2.wav","vj_hlr/hl1_npc/aslave/slv_idle3.wav","vj_hlr/hl1_npc/aslave/slv_idle4.wav","vj_hlr/hl1_npc/aslave/slv_idle5.wav","vj_hlr/hl1_npc/aslave/slv_idle6.wav","vj_hlr/hl1_npc/aslave/slv_idle7.wav","vj_hlr/hl1_npc/aslave/slv_idle8.wav","vj_hlr/hl1_npc/aslave/slv_idle9.wav","vj_hlr/hl1_npc/aslave/slv_idle10.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/aslave/slv_alert01.wav","vj_hlr/hl1_npc/aslave/slv_alert02.wav","vj_hlr/hl1_npc/aslave/slv_alert03.wav","vj_hlr/hl1_npc/aslave/slv_alert04.wav","vj_hlr/hl1_npc/aslave/slv_alert05.wav","vj_hlr/hl1_npc/aslave/slv_alert06.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav","vj_hlr/hl1_npc/zombie/claw_strike2.wav","vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/fx/zap4.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/hassault/hw_shoot1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/aslave/slv_pain1.wav","vj_hlr/hl1_npc/aslave/slv_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/aslave/slv_die1.wav","vj_hlr/hl1_npc/aslave/slv_die2.wav"}

ENT.FootStepSoundLevel = 60

ENT.GeneralSoundPitch1 = 100
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
		self:FootStepSoundCode()
	elseif key == "right" or key == "left" then
		self:MeleeAttackCode()
	elseif key == "shoot" then
		self:RangeAttackCode()
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
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,1,40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/islavegib.mdl",{BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1,0,40))})
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
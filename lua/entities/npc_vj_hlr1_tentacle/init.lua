AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.VJ_ID_Boss = true
ENT.Model = "models/vj_hlr/hl1/tentacle.mdl"
ENT.StartHealth = 1000
ENT.SightDistance = 800
ENT.SightAngle = 360
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.HullType = HULL_LARGE
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Dummy04",
    FirstP_Offset = Vector(23, 0, 30),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow_large"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDistance = 300
ENT.MeleeAttackDamageDistance = 380
ENT.MeleeAttackDamageAngleRadius = 10

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.IdleSoundsWhileAttacking = true

ENT.SoundTbl_Breath = "vj_hlr/gsrc/npc/tentacle/te_flies1.wav"
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/tentacle/te_sing1.wav", "vj_hlr/gsrc/npc/tentacle/te_sing2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/tentacle/te_alert1.wav", "vj_hlr/gsrc/npc/tentacle/te_alert2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/tentacle/te_roar1.wav", "vj_hlr/gsrc/npc/tentacle/te_roar2.wav"}
ENT.SoundTbl_Death = "vj_hlr/gsrc/npc/tentacle/te_death2.wav"

local sdBeakStrike ={"vj_hlr/gsrc/npc/tentacle/te_strike1.wav", "vj_hlr/gsrc/npc/tentacle/te_strike2.wav"}
local sdChangeLevel = {"vj_hlr/gsrc/npc/tentacle/te_swing1.wav", "vj_hlr/gsrc/npc/tentacle/te_swing2.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.Tentacle_Level = 0
	-- 0 = Floor level
	-- 1 = Medium Level
	-- 2 = High Level
	-- 3 = Extreme Level
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(20, 20, 160), Vector(-20, -20, 0))
	self:SetSurroundingBounds(Vector(-300, -300, 0), Vector(300, 300, 750))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Cycle through height levels")
	
	self.CanTurnWhileStationary = true
	controlEnt.LastTentacleLevel = self.Tentacle_Level
	
	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE then
			local npc = self.VJCE_NPC
			local curLvl = npc.Tentacle_Level
			//print("Cur: " .. curLvl)
			//print("Last: " .. self.LastTentacleLevel)
			if curLvl == 0 then
				npc:Tentacle_CalculateLevel(170)
			elseif curLvl == 1 then
				npc:Tentacle_CalculateLevel(self.LastTentacleLevel == 2 and 0 or 430)
			elseif curLvl == 2 then
				npc:Tentacle_CalculateLevel(self.LastTentacleLevel == 3 and 0 or 570)
			elseif curLvl == 3 then
				npc:Tentacle_CalculateLevel(0)
			end
			self.LastTentacleLevel = curLvl
		end
	end
	
	function controlEnt:OnStopControlling(keyPressed)
		self.CanTurnWhileStationary = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		-- Level 0 is just ACT_IDLE so skip it
		if self.Tentacle_Level == 1 then
			return ACT_IDLE_RELAXED
		elseif self.Tentacle_Level == 2 then
			return ACT_IDLE_ANGRY_MELEE
		elseif self.Tentacle_Level == 3 then
			return ACT_IDLE_ANGRY
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAnimEvent(ev, evTime, evCycle, evType, evOptions)
	-- Take care of the regular hit sound (When playing idle animations)
	if ev == 6 && !self.VJ_IsBeingControlled then
		self:PlaySoundSystem("MeleeAttack", sdBeakStrike, VJ.EmitSound)
		local ene = self:GetEnemy()
		if IsValid(ene) && (ene:GetPos():Distance(self:GetPos() + self:GetForward()*150)) < 200 then
			self.CanTurnWhileStationary = true
			self:SetAngles(self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle()))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "attack" then
		self:ExecuteMeleeAttack()
		self:PlaySoundSystem("MeleeAttack", sdBeakStrike, VJ.EmitSound)
		local ene = self:GetEnemy()
		if IsValid(ene) then self:SetAngles(self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle())) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecN = Vector(-20, -20, 0)
local vecLvl0 = Vector(20, 20, 160)
local vecLvl1 = Vector(20, 20, 380)
local vecLvl2 = Vector(20, 20, 580)
local vecLvl3 = Vector(20, 20, 650)
--
function ENT:Tentacle_DoLevelChange(num)
	local lvl = self.Tentacle_Level + num
	VJ.EmitSound(self, sdChangeLevel)
	if lvl == 0 then
		self.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
		self.Tentacle_Level = 0
		self:SetCollisionBounds(vecLvl0, vecN)
	elseif lvl == 1 then
		self.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK2
		self.Tentacle_Level = 1
		self:SetCollisionBounds(vecLvl1, vecN)
	elseif lvl == 2 then
		self.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK1_LOW
		self.Tentacle_Level = 2
		self:SetCollisionBounds(vecLvl2, vecN)
	elseif lvl == 3 then
		self.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK2_LOW
		self.Tentacle_Level = 3
		self:SetCollisionBounds(vecLvl3, vecN)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--
-- 0 to 1 = ACT_SIGNAL1				1 to 2 = ACT_SIGNAL2			2 to 3 = ACT_SIGNAL3
-- 1 to 0 = ACT_SIGNAL_ADVANCE		2 to 1 = ACT_SIGNAL_FORWARD		3 to 2 = ACT_SIGNAL_HALT
--
function ENT:Tentacle_CalculateLevel(eneDist)
	-- 0 = Floor level
	-- 1 = Medium Level
	-- 2 = High Level
	-- 3 = Extreme Level
	//print("dist: " .. eneDist)
	if eneDist >= 570 then
		if self.Tentacle_Level != 3 then
			self:PlayAnim(ACT_SIGNAL3, true, false, false)
			self:Tentacle_DoLevelChange(1)
		end
	elseif eneDist >= 430 then
		if self.Tentacle_Level != 2 then
			if self.Tentacle_Level > 2 then
				self:PlayAnim(ACT_SIGNAL_HALT, true, false, false)
				self:Tentacle_DoLevelChange(-1)
			else
				self:PlayAnim(ACT_SIGNAL2, true, false, false)
				self:Tentacle_DoLevelChange(1)
			end
		end
	elseif eneDist >= 170 then
		if self.Tentacle_Level != 1 then
			if self.Tentacle_Level > 1 then
				self:PlayAnim(ACT_SIGNAL_FORWARD, true, false, false)
				self:Tentacle_DoLevelChange(-1)
			else
				self:PlayAnim(ACT_SIGNAL1, true, false, false)
				self:Tentacle_DoLevelChange(1)
			end
		end
	else
		if self.Tentacle_Level != 0 then
			if self.Tentacle_Level > 0 then
				self:PlayAnim(ACT_SIGNAL_ADVANCE, true, false, false)
				self:Tentacle_DoLevelChange(-1)
			else
				self:PlayAnim(ACT_SIGNAL1, true, false, false)
				self:Tentacle_DoLevelChange(1)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.VJ_IsBeingControlled then return end
	local ene = self:GetEnemy()
	if IsValid(ene) then
		-- If enemy is (on ground & moving) OR (its an NPC that is moving)
		if (ene:IsNPC() && ene:IsMoving()) or (VJ.GetMoveVelocity(ene):Length() > 50 && ene:IsOnGround()) then
			self.CanTurnWhileStationary = true
		else
			self.CanTurnWhileStationary = false
		end
		
		-- Take care of the level calculation
		if self.CanTurnWhileStationary == true then
			self:Tentacle_CalculateLevel((self:GetEnemyLastKnownPos() - self:GetPos()).z)
		end
	else -- Don't turn while idle!
		self.CanTurnWhileStationary = false
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
		effectData:SetScale(620)
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
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 80))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 80))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 80))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 85))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 1, 80))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 81))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 82))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 85))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
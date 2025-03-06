AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/kingpin.mdl"
ENT.StartHealth = 1000
ENT.SightAngle = 360
ENT.HullType = HULL_LARGE
ENT.ControllerParams = {
    ThirdP_Offset = Vector(-15, 0, -45),
    FirstP_Bone = "MDLDEC_Bone23",
    FirstP_Offset = Vector(8, 0, 6),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 105
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDamage = 50
ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1
ENT.MeleeAttackBleedEnemyDamage = 3

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_kingpin_orb"
ENT.RangeAttackMaxDistance = 3000
ENT.RangeAttackMinDistance = 180
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(6, 8)

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD, ACT_DIEBACKWARD}
ENT.FootstepSoundTimerRun = 2
ENT.FootstepSoundTimerWalk = 2
ENT.HasExtraMeleeAttackSounds = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = "vjseq_flinch_small"

ENT.SoundTbl_Breath = "vj_hlr/hl1_npc/kingpin/kingpin_seeker_amb.wav"
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/kingpin/kingpin_move.wav", "vj_hlr/hl1_npc/kingpin/kingpin_moveslow.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/kingpin/kingpin_idle1.wav", "vj_hlr/hl1_npc/kingpin/kingpin_idle2.wav", "vj_hlr/hl1_npc/kingpin/kingpin_idle3.wav",}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/kingpin/kingpin_alert1.wav", "vj_hlr/hl1_npc/kingpin/kingpin_alert2.wav", "vj_hlr/hl1_npc/kingpin/kingpin_alert3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav", "vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/kingpin/kingpin_pain1.wav", "vj_hlr/hl1_npc/kingpin/kingpin_pain2.wav", "vj_hlr/hl1_npc/kingpin/kingpin_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/kingpin/kingpin_death1.wav", "vj_hlr/hl1_npc/kingpin/kingpin_death2.wav"}

local scanSd = {"vj_hlr/hl1_npc/kingpin/kingpin_seeker1.wav", "vj_hlr/hl1_npc/kingpin/kingpin_seeker2.wav", "vj_hlr/hl1_npc/kingpin/kingpin_seeker3.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.KingPin_NextScanT = 0
ENT.KingPin_PsionicAttacking = false
ENT.KingPin_NextPsionicAttackT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(35, 35, 110),Vector(-35, -35, 0))
	self:SetNW2Bool("PsionicEffect", false)
	self:SetPhysicsDamageScale(0.01) -- By default take minimum physics damage
	self.KingPin_NextScanT = CurTime() + math.Rand(1, 5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		VJ.EmitSound(self, "vj_hlr/hl1_weapon/crossbow/xbow_hit1.wav", 60, 140)
	elseif key == "attack left" or key == "attack right" then
		self.MeleeAttackDamage = 15
		self:ExecuteMeleeAttack()
	elseif key == "attack strike" then
		self.MeleeAttackDamage = 30
		self:ExecuteMeleeAttack()
	elseif key == "range distance" then
		self:ExecuteRangeAttack()
	//elseif key == "range psychic_loop" then
		//VJ.EmitSound(self, "vj_hlr/hl1_npc/kingpin/port_suckout1.wav", 80, 140)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("RMouse + CTRL: Preform Psionic Attack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && self.KingPin_PsionicAttacking then
		return ACT_RANGE_ATTACK2
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	-- Ability to see through walls
	if !IsValid(self:GetEnemy()) && CurTime() > self.KingPin_NextScanT then
		VJ.EmitSound(self, scanSd, 85)
		timer.Simple(0.5, function()
			if IsValid(self) then
				local orgDist = self:GetMaxLookDistance()
				self.EnemyXRayDetection = true
				self:SetMaxLookDistance(450)
				self:MaintainRelationships()
				self.EnemyXRayDetection = false
				self:SetMaxLookDistance(orgDist)
			end
		end)
		self.KingPin_NextScanT = CurTime() + self.NextProcessTime + 5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:KingPin_ResetPsionicAttack()
	self.AttackType = VJ.ATTACK_TYPE_NONE
	self.GodMode = false
	self.KingPin_PsionicAttacking = false
	self.KingPin_NextPsionicAttackT = CurTime() + math.Rand(8, 12)
	self:SetState()
	self:SetNW2Bool("PsionicEffect", false)
	timer.Simple(1, function() -- Wait little bit before resetting the physics damage scale to make sure no flying objects hit it!
		if IsValid(self) && !self.GodMode then
			self:SetPhysicsDamageScale(0.01) -- Reset physics damage back to default
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(isAttacking, enemy)
	local eneData = self.EnemyData
	if !self.KingPin_PsionicAttacking && CurTime() > self.KingPin_NextPsionicAttackT && ((!self.VJ_IsBeingControlled && eneData.Visible && eneData.Distance <= 1000) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_ATTACK2) && self.VJ_TheController:KeyDown(IN_DUCK))) && !self:IsBusy() then
		//print("SEARCH ----")
		local pTbl = {} -- Table of props that it found
		for _, v in ipairs(ents.FindInSphere(self:GetPos(), 600)) do
			if VJ.IsProp(v) && self:Visible(v) && enemy:Visible(v) then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) && phys:GetMass() <= 2000 && v.BeingControlledByKingPin != true then
					//print("Prop -", v)
					pTbl[#pTbl + 1] = v
				end
			end
		end
		
		-- If greater then 1, then we found an object!
		if #pTbl > 0 then
			self:SetPhysicsDamageScale(0) -- Take no physics damage
			self.AttackType = VJ.ATTACK_TYPE_CUSTOM
			self.GodMode = true
			self:SetNW2Bool("PsionicEffect", true)
			VJ.EmitSound(self, "vj_hlr/hl1_npc/kingpin/port_suckin1.wav", 80, 140) -- 3.08025
			self.KingPin_PsionicAttacking = true
			self:PlayAnim(ACT_RANGE_ATTACK1_LOW, "LetAttacks", false, false)
			self:SetState(VJ_STATE_ONLY_ANIMATION)
			for _, v in ipairs(pTbl) do
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					v.BeingControlledByKingPin = true
					v:SetNW2Bool("BeingControlledByKingPin", true)
					constraint.RemoveConstraints(v, "Weld")
					phys:EnableMotion(true)
					phys:Wake()
					phys:EnableGravity(false)
					phys:EnableDrag(false)
					phys:ApplyForceCenter(v:GetUp()*2000)
					phys:AddAngleVelocity(v:GetForward()*400 + v:GetRight()*300)
				end
			end
			-- Used to match sounds up
			timer.Simple(2.08025, function()
				if IsValid(self) then
					VJ.EmitSound(self, "vj_hlr/hl1_npc/kingpin/port_suckout1.wav", 80, 140) -- 2.7180
				end
			end)
			-- Used to throw the prop and reset
			timer.Simple(3.42225, function()
				local selfValid = IsValid(self)
				for _, v in ipairs(pTbl) do
					if IsValid(v) then
						local phys = v:GetPhysicsObject()
						if IsValid(phys) then
							v.BeingControlledByKingPin = false
							v:SetNW2Bool("BeingControlledByKingPin", false)
							phys:EnableGravity(true)
							phys:EnableDrag(true)
							if selfValid && IsValid(self:GetEnemy()) then -- Only throw props at the enemy if Kingpin has NOT been removed
								phys:SetVelocity(VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", v:GetPos(), 1, 2000))
								self:PlayAnim(ACT_RANGE_ATTACK2_LOW, "LetAttacks", false, false)
							end
						end
					end
				end
				if selfValid then self:KingPin_ResetPsionicAttack() end -- Here so in case the prop is deleted, we make sure to still reset
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PostSpawn" then
		projectile.Track_Enemy = enemy
		timer.Simple(20, function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 65 + self:GetForward() * 65
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 200)
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
		effectData:SetScale(170)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(2, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(3, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(4, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(5, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(6, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(7, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(8, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(9, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 2, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 3, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 4, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 5, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 6, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", CollisionDecal="VJ_HLR1_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = gibs})
end
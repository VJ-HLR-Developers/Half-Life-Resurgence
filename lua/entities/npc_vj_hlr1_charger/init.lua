AddCSLuaFile("shared.lua")
include("shared.lua")

local defSpeed = 300
local defAnim = ACT_WALK

ENT.Model = "models/vj_hlr/hl1/charger.mdl"
ENT.StartHealth = 80
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.AA_GroundLimit = 70
ENT.Aerial_FlyingSpeed_Calm = defSpeed
ENT.Aerial_FlyingSpeed_Alerted = defSpeed
ENT.Aerial_AnimTbl_Calm = defAnim
ENT.Aerial_AnimTbl_Alerted = defAnim
ENT.ControllerParams = {
	FirstP_Bone = "bip01 head",
	FirstP_Offset = Vector(10, 0, -3),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = "vj_hlr_blood_yellow"
ENT.BloodDecal = "VJ_HLR1_Blood_Yellow"
ENT.HasBloodPool = false
ENT.ConstantlyFaceEnemy = true

ENT.HasMeleeAttack = false
ENT.TimeUntilMeleeAttackDamage = false
ENT.HasMeleeAttackKnockBack = true

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1, ACT_RANGE_ATTACK2}
ENT.RangeAttackProjectiles = "obj_vj_hlr1_toxicspit"
ENT.RangeAttackMinDistance = 1
ENT.RangeAttackMaxDistance = 1500
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(2, 4)

ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_LAND

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/floater/fl_idle1.wav", "vj_hlr/gsrc/npc/floater/fl_idle2.wav", "vj_hlr/gsrc/npc/floater/fl_idle3.wav", "vj_hlr/gsrc/npc/floater/fl_idle4.wav", "vj_hlr/gsrc/npc/floater/fl_idle5.wav", "vj_hlr/gsrc/npc/floater/fl_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/floater/fl_alert1.wav", "vj_hlr/gsrc/npc/floater/fl_alert2.wav", "vj_hlr/gsrc/npc/floater/fl_alert3.wav", "vj_hlr/gsrc/npc/floater/fl_alert4.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/gsrc/npc/floater/fl_attack1.wav", "vj_hlr/gsrc/npc/floater/fl_attack2.wav", "vj_hlr/gsrc/npc/floater/fl_attack3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/gsrc/npc/bullchicken/bc_attack2.wav", "vj_hlr/gsrc/npc/bullchicken/bc_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/floater/fl_pain1.wav", "vj_hlr/gsrc/npc/floater/fl_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/floater/fl_pain1.wav", "vj_hlr/gsrc/npc/floater/fl_pain2.wav"}
ENT.SoundTbl_Impact = {"vj_hlr/gsrc/wep/bullet_hit1.wav", "vj_hlr/gsrc/wep/bullet_hit2.wav"}

ENT.MainSoundPitch = 100

local sdChargeHit = {"vj_hlr/gsrc/npc/panther/pclaw_strike1.wav", "vj_hlr/gsrc/npc/panther/pclaw_strike2.wav", "vj_hlr/gsrc/npc/panther/pclaw_strike3.wav"}
local sdWallHit = {"vj_hlr/gsrc/wep/explosion/debris1.wav", "vj_hlr/gsrc/wep/explosion/debris2.wav", "vj_hlr/gsrc/wep/explosion/debris3.wav"}

-- Custom
ENT.Charger_Charging = false
ENT.Charger_ChargeT = 0
ENT.Charger_NextChargeT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(10, 10, 45), Vector(-10, -10, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "mattack" then
		self:ExecuteMeleeAttack()
	elseif key == "rattack" then
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self.Charger_Charging then
		if act == ACT_IDLE or act == ACT_WALK or act == ACT_RUN then
			return ACT_RUN
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetCharge()
	local curTime = CurTime()
	self:SetMaxYawSpeed(self.TurningSpeed)
	self.Charger_Charging = false
	self.Charger_ChargeT = 0
	self.Charger_NextChargeT = curTime + math.Rand(2, 4)
	self.VJ_ID_Danger = false
	self.Aerial_FlyingSpeed_Calm = defSpeed
	self.Aerial_FlyingSpeed_Alerted = defSpeed
	self.Aerial_AnimTbl_Calm = defAnim
	self.Aerial_AnimTbl_Alerted = defAnim
	self:AA_StopMoving()
	self.RangeAttackMinDistance = 1
	self.LimitChaseDistance = true
	self.IsAbleToRangeAttack = true
	self:ResetTurnTarget()
	self:PlayAnim(ACT_MELEE_ATTACK1, true, false, false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	local curTime = CurTime()
	if self.Charger_Charging && !IsValid(self:GetEnemy()) && curTime < self.Charger_ChargeT then
		self:ResetCharge()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkAttack(isAttacking, enemy)
	local curTime = CurTime()
	local eneData = self.EnemyData
	local dist = eneData.DistanceNearest
	local controlled = self.VJ_IsBeingControlled
	local ply = self.VJ_TheController
	if self.Charger_Charging then
		local myPos = self:GetPos()
		local myCenterPos = myPos + self:OBBCenter()
		local myForward = self:GetForward()
		local myUp = self:GetUp()
		if curTime > self.Charger_ChargeT then
			self:ResetCharge()
			return
		end
		self.VJ_ID_Danger = true
		self.Aerial_FlyingSpeed_Calm = 700
		self.Aerial_FlyingSpeed_Alerted = 700
		self.Aerial_AnimTbl_Calm = ACT_RUN
		self.Aerial_AnimTbl_Alerted = ACT_RUN
		self.AA_NextMoveAnimTime = 0
		self.RangeAttackMinDistance = 100
		self.LimitChaseDistance = false
		self.IsAbleToRangeAttack = false
		//self:AA_ChaseEnemy(true, "Alert")
		self:SetMaxYawSpeed(2)
		self:SetTurnTarget(enemy, -1)
		local tr = util.TraceHull({
			start = myCenterPos,
			endpos = myCenterPos + myForward * 50,
			filter = self,
			mins = self:OBBMins(),
			maxs = self:OBBMaxs()
		})
		//self:SetLastPosition(tr.HitPos + tr.HitNormal * 100)
		//self:SCHEDULE_GOTO_POSITION("TASK_RUN_PATH", function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.TurnData = {Type = VJ.FACE_ENEMY} end)
		//self:SetVelocity(self:GetMoveVelocity() * 0.35)
		if tr.Hit then
			self:ResetCharge()
			if tr.HitWorld then
				self:PlayAnim(ACT_MELEE_ATTACK1, true, false, false)
				//util.ScreenShake(myPos, 1000, 100, 1, 500)
				VJ.EmitSound(self, sdWallHit, 80)
				//ParticleEffect("door_pound_core", myPos + myForward * 50, defAngle)
			else
				local anim, animDur = self:PlayAnim(ACT_MELEE_ATTACK1, false, 0, false)
				VJ.EmitSound(self, sdChargeHit, 80)
				local ent = tr.Entity
				local isProp = IsValid(ent) && VJ.IsProp(ent) or false
				if IsValid(ent) && (isProp or self:CheckRelationship(ent) == D_HT) then
					if isProp then
						local phys = ent:GetPhysicsObject()
						if IsValid(phys) then
							phys:ApplyForceCenter(myForward * 1000 + myUp * 200)
						end
					else
						local vel = myForward * 150 + myUp * 100
						if ent:GetMoveType() != MOVETYPE_PUSH && ent.MovementType != VJ_MOVETYPE_STATIONARY && (!ent.VJ_ID_Boss or ent.IsVJBaseSNPC_Tank) then
							local isNextBot = ent:IsNextBot()
							if !isNextBot then
								ent:SetGroundEntity(NULL)
							end
							ent:SetVelocity(vel)
							if isNextBot then
								ent.loco:Approach(vel, 1)
								ent.loco:Jump()
								ent.loco:SetVelocity(vel)
							end
						end
					end
					/*local dmginfo = DamageInfo()
					dmginfo:SetDamage(25)
					dmginfo:SetDamageType(DMG_SLASH)
					dmginfo:SetDamageForce(myForward * 500)
					dmginfo:SetAttacker(self)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamagePosition(tr.HitPos)
					ent:TakeDamageInfo(dmginfo)*/
				end
				//print("Charge hit")
				self.AttackAnim = anim
				self.AttackAnimDuration = animDur + VJ.AnimDuration(self, ACT_MELEE_ATTACK1)
				self.AttackAnimTime = curTime + self.AttackAnimDuration
			end
		end
		return
	end
	if curTime > self.Charger_NextChargeT && (controlled && ply:KeyDown(IN_ATTACK2) or !controlled && eneData.Visible && dist > 500 && dist <= 2500 && !self.Charger_AttackingDoor && !self:IsBusy() && math.random(1,50) == 1 && math.abs(self:GetPos().z - enemy:GetPos().z) <= 128) && !self.Charger_Charging then
		self.Charger_Charging = true
		self.Charger_ChargeT = curTime + math.Rand(4, 6)
		sound.EmitHint(SOUND_DANGER, enemy:GetPos(), 250, 1, self)
		self:AA_StopMoving()
		self:PlaySoundSystem("Alert", self.SoundTbl_BeforeRangeAttack)
		self:PlayAnim(ACT_CROUCH, true, false, true, 0, {OnFinish = function(interrupted, anim)
			if interrupted then return end
		end})
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetPos() + self:GetUp() * 20 + self:GetForward() * 20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Curve", projectile:GetPos(), 1, 10)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" && GetConVar("vj_hlr1_corpse_static"):GetInt() == 1 && VJ_CVAR_AI_ENABLED && self.HasDeathAnimation then
		self.DeathAnimationDecreaseLengthAmount = -1
		self.DeathCorpseEntityClass = "prop_vj_animatable"
	elseif status == "DeathAnim" then
		self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
local gibsCollideSd = {"vj_hlr/gsrc/fx/flesh1.wav", "vj_hlr/gsrc/fx/flesh2.wav", "vj_hlr/gsrc/fx/flesh3.wav", "vj_hlr/gsrc/fx/flesh5.wav", "vj_hlr/gsrc/fx/flesh6.wav", "vj_hlr/gsrc/fx/flesh7.wav"}
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(55)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end

	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", CollideSound = gibsCollideSd, Pos = self:LocalToWorld(Vector(0, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", CollideSound = gibsCollideSd, Pos = self:LocalToWorld(Vector(1, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", CollideSound = gibsCollideSd, Pos = self:LocalToWorld(Vector(0, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", CollideSound = gibsCollideSd, Pos = self:LocalToWorld(Vector(1, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType = "Yellow", CollisionDecal = "VJ_HLR1_Blood_Yellow", CollideSound = gibsCollideSd, Pos = self:LocalToWorld(Vector(0, 0, 16))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	VJ.HLR_ApplyCorpseSystem(self, corpse, gibs, {CollisionSound = gibsCollideSd})
end
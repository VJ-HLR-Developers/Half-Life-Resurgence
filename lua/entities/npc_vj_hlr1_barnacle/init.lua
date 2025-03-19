AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/barnacle.mdl"
ENT.StartHealth = 30
ENT.SightDistance = 1024
ENT.SightAngle = 360
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanTurnWhileStationary = false
ENT.HullType = HULL_SMALL_CENTERED
ENT.ControllerParams = {
	FirstP_Bone = "bone01",
	FirstP_Offset = Vector(0, 0, -44),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"vj_hlr_blood_red"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Red"}
ENT.HasBloodPool = false

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.TimeUntilMeleeAttackDamage = false
ENT.NextAnyAttackTime_Melee = 10
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 80
ENT.MeleeAttackDamageAngleRadius = 120

ENT.CanReceiveOrders = false
ENT.DamageAllyResponse = false
ENT.CallForHelp = false
ENT.DeathAllyResponse = "OnlyAlert"
ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathCorpseEntityClass = "prop_vj_animatable"

ENT.SoundTbl_Idle = "vj_hlr/gsrc/npc/barnacle/bcl_tongue1.wav"
ENT.SoundTbl_MeleeAttack = {"vj_hlr/gsrc/npc/barnacle/bcl_chew1.wav", "vj_hlr/gsrc/npc/barnacle/bcl_chew2.wav", "vj_hlr/gsrc/npc/barnacle/bcl_chew3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/barnacle/bcl_die1.wav", "vj_hlr/gsrc/npc/barnacle/bcl_die3.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.Barnacle_LastHeight = 180
ENT.Barnacle_CurEnt = NULL
ENT.Barnacle_CurEntMoveType = MOVETYPE_WALK
ENT.Barnacle_PullingEnt = false
ENT.Barnacle_NextPullSoundT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(18, 18, 0), Vector(-18, -18, -50))
	//VJ.GetPoseParameters(self) -- tongue_height 0 / 1024
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "melee_attack" then
		self:ExecuteMeleeAttack()
	end
	if key == "death_gibs" then
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(1, 0, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 2, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(3, 0, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 4, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_bone.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(5, 0, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_b_gib.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 6, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_guts.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(-1, 0, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_hmeat.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -2, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_lung.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(-3, 0, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_skull.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -4, -30))})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/hgib_legbone.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(-5, 0, -30))})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*hook.Add("SetupMove", "VJ_Barnacle_SetupMove", function(ply, mv)
	-- Make the player not be able to walk
	if ply.Barnacle_Grabbed == true then
    	mv:SetMaxClientSpeed(0)
	end
end)*/
---------------------------------------------------------------------------------------------------------------------------------------------
local velInitial = Vector(0, 0, 2)
--
function ENT:Barnacle_CalculateTongue()
	//print(self.Barnacle_LastHeight)
	local myPos = self:GetPos()
	local myUpPos = self:GetUp()
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos + myUpPos * -self.Barnacle_LastHeight,
		filter = self
	})
	local trHitEnt = tr.Entity
	local trHitPos = tr.HitPos
	local height = myPos:Distance(trHitPos)
	-- Increase the height by 10 every tick | minimum = 0, maximum = 1024
	self.Barnacle_LastHeight = math.Clamp(height + 10, 0, 1024)

	if IsValid(trHitEnt) && (trHitEnt:IsNPC() or trHitEnt:IsPlayer()) && self:CheckRelationship(trHitEnt) == D_HT && trHitEnt.VJ_ID_Boss != true then
		-- If the grabbed enemy is a new enemy then reset the enemy values
		if self.Barnacle_CurEnt != trHitEnt then
			self:Barnacle_ResetEnt()
			self.Barnacle_CurEntMoveType = trHitEnt:GetMoveType()
		end
		self.Barnacle_CurEnt = trHitEnt
		trHitEnt:AddEFlags(EFL_IS_BEING_LIFTED_BY_BARNACLE)
		if trHitEnt:IsNPC() then
			trHitEnt:StopMoving()
			trHitEnt:SetVelocity(velInitial)
			trHitEnt:SetMoveType(MOVETYPE_FLY)
		elseif trHitEnt:IsPlayer() then
			trHitEnt:SetMoveType(MOVETYPE_NONE)
			//trHitEnt:AddFlags(FL_ATCONTROLS)
		end
		trHitEnt:SetGroundEntity(NULL)
		-- Make it pull the enemy up
		if height >= 50 then
			trHitEnt:SetPos(Vector(trHitPos.x, trHitPos.y, (trHitEnt:GetPos() + trHitEnt:GetUp() * 5).z)) -- Set the position for the enemy
			if CurTime() > self.Barnacle_NextPullSoundT then -- Play the pulling sound
				VJ.EmitSound(self, "vj_hlr/gsrc/npc/barnacle/bcl_alert2.wav")
				self.Barnacle_NextPullSoundT = CurTime() + 2.7950113378685 // Magic number is the sound duration of "bcl_alert2.wav"
			end
		end
		self:SetPoseParameter("tongue_height", myPos:Distance(trHitPos + myUpPos * 125))
		return true
	else
		self:Barnacle_ResetEnt()
	end
	self:SetPoseParameter("tongue_height", myPos:Distance(trHitPos + myUpPos * 193))
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Barnacle_ResetEnt()
	if !IsValid(self.Barnacle_CurEnt) then return end
	self.Barnacle_CurEnt:RemoveEFlags(EFL_IS_BEING_LIFTED_BY_BARNACLE)
	//self.Barnacle_CurEnt:RemoveFlags(FL_ATCONTROLS)
	self.Barnacle_CurEnt:SetMoveType(self.Barnacle_CurEntMoveType) -- Reset the enemy's move type
	self.Barnacle_CurEnt = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		return (self.Barnacle_PullingEnt and ACT_BARNACLE_PULL) or ACT_IDLE
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Dead then return end
	self.Barnacle_PullingEnt = self:Barnacle_CalculateTongue()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMeleeAttackExecute(status, ent, isProp)
	if status == "PreDamage" then
		if ent.IsVJBaseSNPC_Human then -- Make human NPCs die instantly
			self.MeleeAttackDamage = ent:Health() + 10
		elseif ent:IsPlayer() then
			self.MeleeAttackDamage = 80
		else
			self.MeleeAttackDamage = 100
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:CustomAttackCheck_MeleeAttack()
	return IsValid(self.Barnacle_CurEnt)
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent, inflictor, wasLast)
	VJ.EmitSound(self, "vj_hlr/gsrc/npc/barnacle/bcl_bite3.wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" then
		self:Barnacle_ResetEnt()
	elseif status == "Finish" then
		self:SetPos(self:GetPos() + self:GetUp()*-4)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:DrawShadow(false)
	corpseEnt:ResetSequence("Death")
	corpseEnt:SetCycle(1)
	corpseEnt:SetPoseParameter("tongue_height", 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorRed)
		effectData:SetScale(120)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(0)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 1, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 2, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 3, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 4, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 5, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, 6, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -1, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -2, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -3, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -4, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -5, -20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {CollisionDecal="VJ_HLR1_Blood_Red", Pos=self:LocalToWorld(Vector(0, -6, -20))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:Barnacle_ResetEnt()
end
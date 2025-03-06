AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/prdroid.mdl"
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 100
ENT.Aerial_FlyingSpeed_Alerted = 200
ENT.ControllerParams = {
	FirstP_Bone = "sphere01",
	FirstP_Offset = Vector(15, 0, -3),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
ENT.AlliedWithPlayerAllies = true
ENT.ConstantlyFaceEnemy = true

ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 20
ENT.MeleeAttackDistance = 55
ENT.MeleeAttackDamageDistance = 80
ENT.TimeUntilMeleeAttackDamage = false

ENT.HasRangeAttack = true
ENT.RangeAttackProjectiles = "obj_vj_hlr1_probed_needle"
ENT.RangeAttackMaxDistance = 1500
ENT.RangeAttackMinDistance = 110
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(3, 4)
ENT.AnimTbl_RangeAttack = false

ENT.LimitChaseDistance = "OnlyRange"
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"

ENT.IsMedic = true
ENT.AnimTbl_Medic_GiveHealth = ACT_ARM
ENT.Medic_CheckDistance = 1000
ENT.Medic_HealDistance = 600
ENT.Medic_NextHealTime = VJ.SET(5, 8)
ENT.Medic_SpawnPropOnHeal = false
ENT.VJ_ID_Healable = false

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathAnimationTime = 0.6
ENT.HasDeathCorpse = false
ENT.HasExtraMeleeAttackSounds = true

ENT.SoundTbl_Breath = "vj_hlr/gsrc/npc/prdroid_alpha/engine.wav"
ENT.SoundTbl_MedicOnHeal = "vj_hlr/gsrc/npc/prdroid_alpha/shoot_heal.wav"
ENT.SoundTbl_Alert = "vj_hlr/gsrc/npc/prdroid_alpha/alert.wav"
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/gsrc/npc/zombie/claw_miss1.wav", "vj_hlr/gsrc/npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeRangeAttack = "vj_hlr/gsrc/npc/prdroid_alpha/readytoattack.wav"
ENT.SoundTbl_RangeAttack = "vj_hlr/gsrc/npc/prdroid_alpha/shoot.wav"
ENT.SoundTbl_Death = "vj_hlr/gsrc/npc/prdroid_alpha/die.wav"

ENT.MainSoundPitch = 100
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 80)
--
function ENT:Init()
	self:SetCollisionBounds(Vector(35, 35, 15), Vector(-35, -35, -50))
	self:SetPos(self:GetPos() + spawnPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("Hold-SPACE: Fires healing needle while range attacking")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "melee" then
		self:ExecuteMeleeAttack()
	elseif key == "shoot" then
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_FLY then
		return ACT_IDLE
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMedicBehavior(status, statusData)
	if status == "BeforeHeal" then
		VJ.EmitSound(self, "vj_hlr/gsrc/npc/prdroid_alpha/readytoattack.wav", 90, 100) -- Preparing sound same as range attack
	elseif status == "OnHeal" then
		self:PlayAnim(ACT_RANGE_ATTACK1, true, 0, true, 0, {OnFinish = function()
			self:PlayAnim(ACT_RELOAD, true, false, true)
			VJ.EmitSound(self, "vj_hlr/gsrc/npc/prdroid_alpha/reload.wav", 90, 100) -- Reload sound
		end})
		local attPos = self:GetAttachment(self:LookupAttachment("0")).Pos
		local needle = ents.Create("obj_vj_hlr1_probed_needle")
		needle:SetPos(attPos)
		needle:SetAngles((statusData:GetPos() - needle:GetPos()):Angle())
		needle:SetOwner(self)
		needle:SetPhysicsAttacker(self)
		needle.Needle_Heal = true
		needle:Spawn()
		needle:Activate()
		local phys = needle:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(VJ.CalculateTrajectory(self, self.MedicData.Target, "Line", needle:GetPos(), 1, 1500))
		end
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--  ACT_RANGE_ATTACK2 -- Rapid firing (3-shot burst) range attack animation | !!! UNUSED !!!
--
function ENT:OnRangeAttack(status, enemy)
	if status == "Init" then
		local anim, animDur = self:PlayAnim(ACT_ARM, false, 0, true, 0, {OnFinish = function()
			self:PlayAnim(ACT_RANGE_ATTACK1, false, 0, true, 0, {OnFinish = function()
				self:PlayAnim(ACT_RELOAD, true, false, true)
				VJ.EmitSound(self, "vj_hlr/gsrc/npc/prdroid_alpha/reload.wav", 90, 100) -- Reload sound
			end})
		end})
		self.AttackAnim = anim
		self.AttackAnimDuration = animDur + VJ.AnimDuration(self, ACT_RANGE_ATTACK1)
		self.AttackAnimTime = CurTime() + self.AttackAnimDuration
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "PreSpawn" && self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP) then
		projectile.Needle_Heal = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjPos(projectile)
	return self:GetAttachment(self:LookupAttachment("0")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Init" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local collideSds = {"vj_hlr/gsrc/fx/metal1.wav", "vj_hlr/gsrc/fx/metal2.wav", "vj_hlr/gsrc/fx/metal3.wav", "vj_hlr/gsrc/fx/metal4.wav", "vj_hlr/gsrc/fx/metal5.wav"}
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Init" && dmginfo:IsDamageType(DMG_BLAST) then
		self.HasDeathAnimation = false
	elseif status == "Finish" then
		VJ.ApplyRadiusDamage(self, self, self:GetPos(), 75, 25, DMG_BLAST, false, true)
		VJ.EmitSound(self, "vj_hlr/gsrc/npc/prdroid_alpha/explode.wav", 90, 100)
		local applyForce = self.HasDeathAnimation and false or true
		local myAngs = self:GetAngles()
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_cap.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("sphere01")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_armpiece.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed011")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_armpiece.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed007")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_claw.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed012")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_claw.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed008")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_dshooter.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed005")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_tail.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed014")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_upperarm.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed011")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_upperarm.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed007")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_body.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed003")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_forearm.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed011")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_forearm.mdl", {CollisionDecal=false, Ang=myAngs, Pos=self:GetBonePosition(self:LookupBone("unnamed007")), CollisionSound=collideSds, Vel_ApplyDmgForce=applyForce})

		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("GlowProxySize", "2.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "5")
		spr:SetKeyValue("renderamt", "255")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "15.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "2")
		spr:SetPos(self:GetPos())
		spr:Spawn()
		spr:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
	end
end
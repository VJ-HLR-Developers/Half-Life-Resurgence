AddCSLuaFile("shared.lua")
include("movetype_aa.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/osprey.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true

ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.FindEnemy_UseSphere = true

ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Alerted = 300
ENT.AnimTbl_IdleStand = {ACT_FLY}
ENT.Aerial_AnimTbl_Calm = {ACT_FLY}
ENT.Aerial_AnimTbl_Alerted = {ACT_FLY}
ENT.Aerial_FlyingSpeed_Calm = ENT.Aerial_FlyingSpeed_Alerted

ENT.Bleeds = false
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to bullet type damages
ENT.Immune_Fire = true -- Immune to fire-type damages
ENT.ImmuneDamagesTable = {DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN}

ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone01", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(140, 0, -45), -- The offset for the controller when the camera is in first person
}

ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it"s visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 7500

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it"s between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 4000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 0 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it"s able to range attack
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line",self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos,self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(140,140,100),Vector(-140,-140,0))
	self:SetPos(self:GetPos() +Vector(0,0,400))
	
	self.IdleLP = CreateSound(self,"vj_hlr/hl1_npc/apache/ap_rotor2.wav")
	self.IdleLP:SetSoundLevel(105)
	self.IdleLP:Play()
	self.IdleLP:ChangeVolume(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.AA_MoveTimeCur > CurTime() then
		local remaining = self.AA_MoveTimeCur -CurTime()
		if remaining < 1.75 then
			self:AA_StopMoving()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	ParticleEffectAttach("fire_large_01",PATTACH_POINT_FOLLOW,self,4)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,7)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,8)
	ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,self,9)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	local pos,ang = self:GetBonePosition(0)
	corpseEnt:SetPos(pos)
	corpseEnt:GetPhysicsObject():SetVelocity(((self:GetPos() +self:GetRight() *-700 +self:GetForward() *-300 +self:GetUp() *-200) -self:GetPos()))
	util.BlastDamage(self, self, corpseEnt:GetPos(), 400, 40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)

	VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
	VJ_EmitSound(self,"vj_mili_tank/tank_death3.wav",100,100)
	util.BlastDamage(self,self,corpseEnt:GetPos(),200,40)
	util.ScreenShake(corpseEnt:GetPos(), 100, 200, 1, 2500)
	if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",corpseEnt:GetPos(),Angle(0,0,0),nil) end

	if math.random(1,3) == 1 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/combine_soldier.mdl",{Pos=corpseEnt:GetPos()+corpseEnt:GetUp()*90+corpseEnt:GetRight()*-30,Vel=Vector(math.Rand(-600,600), math.Rand(-600,600),500)},function(extraent) extraent:Ignite(math.Rand(8,10),0); extraent:SetColor(Color(90,90,90)) end)
	end

	if self.HasGibDeathParticles == true then
		ParticleEffect("vj_explosion3",corpseEnt:GetPos(),Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",corpseEnt:GetPos() +corpseEnt:GetForward()*-130,Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",corpseEnt:GetPos() +corpseEnt:GetForward()*130,Angle(0,0,0),nil)
		ParticleEffectAttach("fire_large_01",PATTACH_POINT_FOLLOW,corpseEnt,4)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,corpseEnt,7)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,corpseEnt,8)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_POINT_FOLLOW,corpseEnt,9)
		
		local explosioneffect = EffectData()
		explosioneffect:SetOrigin(corpseEnt:GetPos())
		util.Effect("VJ_Medium_Explosion1",explosioneffect)
		util.Effect("Explosion", explosioneffect)
		
		local dusteffect = EffectData()
		dusteffect:SetOrigin(corpseEnt:GetPos())
		dusteffect:SetScale(800)
		util.Effect("ThumperDust",dusteffect)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.IdleLP:Stop()
	timer.Remove("vj_timer_fire_" .. self:EntIndex())
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
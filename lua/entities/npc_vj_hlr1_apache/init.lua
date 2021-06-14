AddCSLuaFile("shared.lua")
include("movetype_aa.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/apache.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 400
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true

ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.FindEnemy_UseSphere = true

ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Alerted = 400
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

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableRangeAttackAnimation = true
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_rocket" -- The entity that is spawned when range attacking
ENT.TimeUntilRangeAttackProjectileRelease = 0
ENT.NextRangeAttackTime = 5 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 10 -- How much time until it can use a range attack?
ENT.RangeDistance = 7500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = true -- Should the projectile spawn on a attachment?
ENT.RangeAttackExtraTimers = {1}

ENT.VJC_Data = {
    CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone01", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(140, 0, -45), -- The offset for the controller when the camera is in first person
}

ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
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
	
	self.IdleLP = CreateSound(self,"vj_hlr/hl1_npc/apache/ap_rotor4.wav")
	self.IdleLP:SetSoundLevel(105)
	self.IdleLP:Play()
	self.IdleLP:ChangeVolume(1)
	
	self.Charged = false
	self.Charging = false
	self.NextFireT = 0
	
	self.RangeUseAttachmentForPosID = "missile_left"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(ent)
	self.RangeUseAttachmentForPosID = self.RangeUseAttachmentForPosID == "missile_left" && "missile_right" or "missile_left"
	VJ_CreateSound(ent,"vj_hlr/hl1_weapon/rpg/rocketfire1.wav",100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BarrageFire()
	timer.Create("vj_timer_fire_" .. self:EntIndex(),0.1,50,function()
		if IsValid(self:GetEnemy()) && !self.Dead then
			local att = self:GetAttachment(1)
			local bullet = {}
			bullet.Num = 1
			bullet.Src = att.Pos
			bullet.Dir = (self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() -att.Pos):Angle():Forward()
			bullet.Spread = Vector(0.05,0.05,0)
			bullet.Tracer = 1
			bullet.TracerName = "VJ_HLR_Tracer"
			bullet.Force = 3
			bullet.Damage = self:VJ_GetDifficultyValue(8)
			bullet.AmmoType = "AR2"
			self:FireBullets(bullet)
			VJ_EmitSound(self,"vj_hlr/hl1_weapon/saw/saw_fire" .. math.random(1,3) .. ".wav",120)

			local muz = ents.Create("env_sprite")
			muz:SetKeyValue("model","vj_hl/sprites/muzzleflash2.vmt")
			muz:SetKeyValue("scale",""..math.Rand(0.3,0.5))
			muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
			muz:SetKeyValue("HDRColorScale","1.0")
			muz:SetKeyValue("renderfx","14")
			muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
			muz:SetKeyValue("renderamt","255") -- Transparency
			muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
			muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
			muz:SetKeyValue("spawnflags","0")
			muz:SetParent(self)
			muz:Fire("SetParentAttachment","muzzle")
			muz:SetAngles(Angle(math.random(-100,100),math.random(-100,100),math.random(-100,100)))
			muz:Spawn()
			muz:Activate()
			muz:Fire("Kill","",0.08)

			local FireLight1 = ents.Create("light_dynamic")
			FireLight1:SetKeyValue("brightness",8)
			FireLight1:SetKeyValue("distance",300)
			FireLight1:SetLocalPos(att.Pos)
			FireLight1:SetLocalAngles(self:GetAngles())
			FireLight1:Fire("Color","255 60 9 255")
			FireLight1:Spawn()
			FireLight1:Activate()
			FireLight1:Fire("TurnOn","",0)
			FireLight1:Fire("Kill","",0.08)
			self:DeleteOnRemove(FireLight1)
		else
			timer.Remove("vj_timer_fire_" .. self:EntIndex())
			self.NextFireT = CurTime() +1
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
	if IsValid(self:GetEnemy()) then
		local dist = self.NearestPointToEnemyDistance
		if dist <= 4000 && self:Visible(self:GetEnemy()) then
			if CurTime() > self.NextFireT then
				if !self.Charged then
					if !self.Charging then
						self.Charging = true
						VJ_EmitSound(self,"npc/attack_helicopter/aheli_charge_up.wav",105)
						timer.Simple(SoundDuration("npc/attack_helicopter/aheli_charge_up.wav"),function()
							if IsValid(self) then
								self.Charged = true
								self.Charging = false
							end
						end)
					end
					return
				end
				self:BarrageFire()
				self.Charged = false
				self.NextFireT = CurTime() +10
			end
		end
	end
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
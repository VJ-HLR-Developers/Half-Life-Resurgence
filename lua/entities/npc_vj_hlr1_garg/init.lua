AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/garg.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 800
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 10 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageType = DMG_CRUSH -- How close does it have to be until it attacks?
ENT.MeleeAttackDistance = 65 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 165 -- How far does the damage go?

ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
//ENT.DeathAnimationTime = 0.8 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 2 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 1
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH,ACT_BIG_FLINCH} -- If it uses normal based animation, use this

ENT.WorldShakeOnMoveAmplitude = 14 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 1000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.7 -- How long the screen shake will last, in seconds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {
	"vj_hlr/hl1_npc/garg/gar_step1.wav",
	"vj_hlr/hl1_npc/garg/gar_step2.wav",
}
ENT.SoundTbl_Idle = {
	"vj_hlr/hl1_npc/garg/gar_breathe1.wav",
	"vj_hlr/hl1_npc/garg/gar_breathe2.wav",
	"vj_hlr/hl1_npc/garg/gar_breathe3.wav",
	"vj_hlr/hl1_npc/garg/gar_idle1.wav",
	"vj_hlr/hl1_npc/garg/gar_idle2.wav",
	"vj_hlr/hl1_npc/garg/gar_idle3.wav",
	"vj_hlr/hl1_npc/garg/gar_idle4.wav",
	"vj_hlr/hl1_npc/garg/gar_idle5.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl1_npc/garg/gar_alert1.wav",
	"vj_hlr/hl1_npc/garg/gar_alert2.wav",
	"vj_hlr/hl1_npc/garg/gar_alert3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/hl1_npc/garg/gar_attack1.wav",
	"vj_hlr/hl1_npc/garg/gar_attack2.wav",
	"vj_hlr/hl1_npc/garg/gar_attack3.wav",
}
ENT.SoundTbl_MeleeAttackExtra = {
	"weapons/cbar_hitbod1.wav",
	"weapons/cbar_hitbod2.wav",
	"weapons/cbar_hitbod3.wav",
}
ENT.SoundTbl_MeleeAttackMiss = {
	"vj_hlr/hl1_npc/zombie/claw_miss1.wav",
	"vj_hlr/hl1_npc/zombie/claw_miss2.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl1_npc/garg/gar_pain1.wav",
	"vj_hlr/hl1_npc/garg/gar_pain2.wav",
	"vj_hlr/hl1_npc/garg/gar_pain3.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl1_npc/garg/gar_die1.wav",
	"vj_hlr/hl1_npc/garg/gar_die2.wav",
}

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Bip01 Head"
ENT.Controller_FirstPersonOffset = Vector(0,0,0)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

ENT.FootStepSoundLevel = 95
ENT.GeneralSoundPitch1 = 100
ENT.GargFlameDamage = 3
ENT.GargDamageScale = 0.1
ENT.BloodScale = 500
ENT.GibColor = Color(0,255,255)
ENT.FlameAttackDistance = 250
ENT.FlameAnimation = ACT_RANGE_ATTACK1
ENT.NextFlameDMGT = CurTime()
ENT.NextDecalT = CurTime()
ENT.DeathExplosions = 6
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(78,78,220),Vector(-78,-78,0))
	local eyeGlow = ents.Create( "env_sprite" )
	eyeGlow:SetKeyValue( "rendercolor","255 45 0" )
	eyeGlow:SetKeyValue( "GlowProxySize","2.0" )
	eyeGlow:SetKeyValue( "HDRColorScale","1.0" )
	eyeGlow:SetKeyValue( "renderfx","14" )
	eyeGlow:SetKeyValue( "rendermode","3" )
	eyeGlow:SetKeyValue( "renderamt","255" )
	eyeGlow:SetKeyValue( "disablereceiveshadows","0" )
	eyeGlow:SetKeyValue( "mindxlevel","0" )
	eyeGlow:SetKeyValue( "maxdxlevel","0" )
	eyeGlow:SetKeyValue( "framerate","10.0" )
	eyeGlow:SetKeyValue( "model","sprites/blueflare1.spr" )
	eyeGlow:SetKeyValue( "spawnflags","0" )
	eyeGlow:SetKeyValue( "scale","2" )
	-- eyeGlow:SetKeyValue( "setparentattachment","0.75" )
	eyeGlow:SetPos( self.Entity:GetPos() )
	eyeGlow:Spawn()
	eyeGlow:Fire("SetParentAttachment","eyes",0)
	eyeGlow:SetParent( self.Entity )
	self:DeleteOnRemove(eyeGlow)
	glowLight = ents.Create("light_dynamic")
	glowLight:SetKeyValue("brightness","1")
	glowLight:SetKeyValue("distance","150")
	glowLight:SetLocalPos(self:GetPos())
	glowLight:SetLocalAngles(self:GetAngles())
	glowLight:Fire("Color", "255 45 0")
	glowLight:SetParent(self)
	glowLight:Spawn()
	glowLight:Activate()
	glowLight:Fire("SetParentAttachment","eyes",0)
	glowLight:Fire("TurnOn","",0)
	self:DeleteOnRemove(glowLight)
	
	self.UsingFlameAttack = false
	self.HasFlameParticle = false
	self.FlameLoop = CreateSound(self,"vj_hlr/hl1_npc/garg/gar_flamerun1.wav")
	self.FlameLoop:SetSoundLevel(80)
	self.NextFlameLoopT = 0
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	if self.UsingFlameAttack then
		self:ResetFlameAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetFlameAttack()
	if self.HasFlameParticle then
		VJ_EmitSound(self,"vj_hlr/hl1_npc/garg/gar_flameoff1.wav",85,100)
		self:StartEngineTask(GetTaskList("TASK_RESET_ACTIVITY"), 0)
		self:StopMoving()
		self:ClearSchedule()
	end
	self.UsingFlameAttack = false
	self.HasFlameParticle = false
	self:StopParticles()
	self.FlameLoop:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local ent = self:GetEnemy()
	if IsValid(ent) then
		if self.Dead then return end
		local dist = self:VJ_GetNearestPointToEntityDistance(ent)
		if dist <= self.FlameAttackDistance && dist > self.MeleeAttackDistance && ent:Visible(self) && (self:GetForward():Dot((ent:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius))) then
			self.UsingFlameAttack = true
			self:StopMoving()
			self:VJ_ACT_PLAYACTIVITY(self.FlameAnimation,true,false,true)
		else
			self:ResetFlameAttack()
		end
	else
		self:ResetFlameAttack()
	end
	if self.UsingFlameAttack then
		if CurTime() > self.NextFlameLoopT then
			self.FlameLoop:Stop()
			self.FlameLoop:Play()
			self.NextFlameLoopT = CurTime() +SoundDuration("vj_hlr/hl1_npc/garg/gar_flamerun1.wav")
		end
		if CurTime() > self.NextDecalT then
			local tr = util.TraceLine({
				start = self:GetAttachment(2).Pos,
				endpos = self:GetAttachment(2).Pos +self:GetForward() *self.FlameAttackDistance,
				filter = self
			})
			util.Decal("Scorch",tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)
			local tr = util.TraceLine({
				start = self:GetAttachment(3).Pos,
				endpos = self:GetAttachment(3).Pos +self:GetForward() *self.FlameAttackDistance,
				filter = self
			})
			util.Decal("Scorch",tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)
			self.NextDecalT = CurTime() +math.Rand(0.1,0.5)
		end
		if CurTime() > self.NextFlameDMGT then
			local FindEnts = ents.FindInSphere(self:GetPos() + self:GetForward(), self.FlameAttackDistance +100)
			if FindEnts != nil then
				for _,v in pairs(FindEnts) do
					if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
					if (v != self && v:GetClass() != self:GetClass()) && (((v:IsNPC() or (v:IsPlayer() && v:Alive() && GetConVarNumber("ai_ignoreplayers") == 0)) && (self:Disposition(v) != D_LI)) or VJ_IsProp(v) == true or v:GetClass() == "func_breakable_surf" or self.EntitiesToDestroyClass[v:GetClass()] or v.VJ_AddEntityToSNPCAttackList == true) then
						if (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeAttackDamageAngleRadius))) then
							local dmg = self.GargFlameDamage
							local dmginfo = DamageInfo()
							dmginfo:SetDamage(dmg)
							dmginfo:SetAttacker(self)
							dmginfo:SetInflictor(self)
							dmginfo:SetDamageType(DMG_BURN)
							dmginfo:SetDamagePosition(v:NearestPoint(self:GetPos() +self:OBBCenter()))
							v:TakeDamageInfo(dmginfo)
							v:Ignite(2)
						end
					end
				end
			end
			self.NextFlameDMGT = CurTime() +0.2
		end
		if self.HasFlameParticle == false then
			print("A")
			VJ_EmitSound(self,"vj_hlr/hl1_npc/garg/gar_flameon1.wav",85,100)
			ParticleEffectAttach("vj_hl_torch",PATTACH_POINT_FOLLOW,self,2)
			ParticleEffectAttach("vj_hl_torch",PATTACH_POINT_FOLLOW,self,3)
			self.HasFlameParticle = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if dmginfo:IsBulletDamage() then dmginfo:ScaleDamage(self.GargDamageScale) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	for i = 1,self.DeathExplosions do
		timer.Simple(math.Rand(0.3,0.5) *i,function()
			if IsValid(self) then
				local effectdata = EffectData()
				effectdata:SetOrigin(self:GetPos()+self:OBBCenter())
				util.Effect("Explosion",effectdata)
				util.Effect("HelicopterMegaBomb",effectdata)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
		util.ScreenShake(self:GetPos(),self.WorldShakeOnMoveAmplitude,self.WorldShakeOnMoveFrequency,self.WorldShakeOnMoveDuration,self.WorldShakeOnMoveRadius)
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
	if key == "explode_death" then
		util.BlastDamage(self,self,self:GetPos(),300,150)
		util.ScreenShake(self:GetPos(),100,200,1,2500)
		if self.HasGibDeathParticles == true then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos()+Vector(0,0,32))
			util.Effect("Explosion",effectdata)
			util.Effect("HelicopterMegaBomb",effectdata)
			ParticleEffect("vj_explosion1",self:GetPos(),Angle(0,0,0),nil)

			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
			bloodeffect:SetScale(self.BloodScale)
			util.Effect("VJ_Blood1",bloodeffect)
			
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodspray:SetScale(5)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(1)
			util.Effect("bloodspray",bloodspray)
			util.Effect("bloodspray",bloodspray)
		end
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
		bloodeffect:SetScale(self.BloodScale)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodspray:SetScale(5)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)

		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos()+self:OBBCenter())
		util.Effect("Explosion",effectdata)
		util.Effect("HelicopterMegaBomb",effectdata)
	end
	local tb = {
		"models/vj_hlr/gibs/metalgib_p10.mdl",
		"models/vj_hlr/gibs/metalgib_p2.mdl",
		"models/vj_hlr/gibs/metalgib_p3.mdl",
		"models/vj_hlr/gibs/metalgib_p6.mdl",
		"models/vj_hlr/gibs/metalgib_p9.mdl",
	}
	for i = 1,self:GetBoneCount() -1 do
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib" .. math.random(1,10) .. ".mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:GetBonePosition(i)})
		if math.random(1,7) == 1 then
			self:CreateGibEntity("obj_vj_gib",VJ_PICKRANDOMTABLE(tb),{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:GetBonePosition(i)},function(gib) gib:SetColor(self.GibColor) end)
		end
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.FlameLoop:Stop()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
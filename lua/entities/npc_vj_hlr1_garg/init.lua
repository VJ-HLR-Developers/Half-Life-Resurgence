AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/garg.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 1000
ENT.HullType = HULL_HUMAN
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.VJC_Data = {
    ThirdP_Offset = Vector(-50, 0, -45), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(7, 0, -12), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow_large"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 30 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageType = DMG_CRUSH -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDistance = 160 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 165 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK2
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_garg_stomp" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 120 -- How close does it have to be until it uses melee?
ENT.NextRangeAttackTime = 10 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 13 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?

ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.GibOnDeathDamagesTable = {"All"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.DeathAnimationTime = 3.7 -- Time until the NPC spawns its corpse and gets removed
ENT.AnimTbl_Death = ACT_DIESIMPLE -- Death Animations
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 2 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 2 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/garg/gar_step1.wav","vj_hlr/hl1_npc/garg/gar_step2.wav"}
ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/garg/gar_breathe1.wav","vj_hlr/hl1_npc/garg/gar_breathe2.wav","vj_hlr/hl1_npc/garg/gar_breathe3.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/garg/gar_idle1.wav","vj_hlr/hl1_npc/garg/gar_idle2.wav","vj_hlr/hl1_npc/garg/gar_idle3.wav","vj_hlr/hl1_npc/garg/gar_idle4.wav","vj_hlr/hl1_npc/garg/gar_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/garg/gar_alert1.wav","vj_hlr/hl1_npc/garg/gar_alert2.wav","vj_hlr/hl1_npc/garg/gar_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/garg/gar_attack1.wav","vj_hlr/hl1_npc/garg/gar_attack2.wav","vj_hlr/hl1_npc/garg/gar_attack3.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav","vj_hlr/hl1_npc/zombie/claw_strike2.wav","vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/garg/gar_stomp1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/garg/gar_pain1.wav","vj_hlr/hl1_npc/garg/gar_pain2.wav","vj_hlr/hl1_npc/garg/gar_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/garg/gar_die1.wav","vj_hlr/hl1_npc/garg/gar_die2.wav"}

local sdExplosions = {"vj_hlr/hl1_weapon/explosion/explode3.wav", "vj_hlr/hl1_weapon/explosion/explode4.wav", "vj_hlr/hl1_weapon/explosion/explode5.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.ExtraMeleeSoundPitch = VJ.SET(80, 80)

-- Custom
ENT.Garg_Type = 0
	-- 0 = Default Garg
	-- 1 = Baby Garg
	-- 2 = Custom (Not immune to bullets)
ENT.Garg_CanFlame = false
ENT.Garg_FlameLevel = 0 -- 0 = Not started | 1 = Preparing | 2 = Flame active
ENT.Garg_NextFlameT = 0
ENT.Garg_MeleeLargeKnockback = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if GetConVar("vj_hlr_hd"):GetInt() == 1 && VJ.HLR_INSTALLED_HD then
		if self:GetClass() == "npc_vj_hlr1_garg" then
			self.Model = "models/vj_hlr/hl_hd/garg.mdl"
		elseif self:GetClass() == "npc_vj_hlrsv_garg_baby" then
			self.Model = "models/vj_hlr/hl_hd/babygarg.mdl"
		end
	end
	self.TimersToRemove[#self.TimersToRemove + 1] = "garg_flame_reset"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if self.Garg_Type == 0 then -- Adult garg
		self:SetCollisionBounds(Vector(70, 70, 210),  Vector(-70, -70, 0))
	elseif self.Garg_Type == 1 then -- Baby garg
		self:SetCollisionBounds(Vector(32, 32, 105),  Vector(-32, -32, 0))
	end
	
	local glow1 = ents.Create("env_sprite")
	glow1:SetKeyValue("model", "vj_hl/sprites/gargeye1.vmt")
	glow1:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
	glow1:SetKeyValue("renderfx", "14")
	glow1:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
	glow1:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
	glow1:SetKeyValue("spawnflags", "0")
	glow1:SetParent(self)
	glow1:Fire("SetParentAttachment", "eyes")
	glow1:Spawn()
	glow1:Activate()
	self:DeleteOnRemove(glow1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	if self.Garg_Type == 1 then return end
	ply:ChatPrint("Right Mouse + CTRL: Preform Stomp attack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
		util.ScreenShake(self:GetPos(), 10, 100, 0.4, self.Garg_Type == 1 and 300 or 1000)
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
	if key == "laser" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Garg_ResetFlame()
	if self.Garg_CanFlame then
		self:ResetTurnTarget()
	end
	if self.Garg_FlameLevel == 2 then
		VJ.EmitSound(self, "vj_hlr/hl1_npc/garg/gar_flameoff1.wav", 80)
	end
	self.Garg_CanFlame = false
	self.Garg_FlameLevel = 0
	self.DisableChasingEnemy = false
	VJ.STOPSOUND(self.Garg_FlameSd)
	self:StopParticles()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && self.Garg_FlameLevel >= 1 then
		return ACT_RANGE_ATTACK1
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Garg_CanFlame && self.Garg_NextFlameT < CurTime() && self.AttackType == VJ.ATTACK_TYPE_NONE then
		self.DisableChasingEnemy = true
		self:StopMoving()
		
		-- Startup animation and sound
		if self.Garg_FlameLevel == 0 then
			self:VJ_ACT_PLAYACTIVITY("shootflames1", "LetAttacks", false)
			self.Garg_FlameLevel = 1
			self.Garg_NextFlameT = CurTime() + 0.8 -- Don't use anim duration because we want it to start playing the flame animation mid way
			timer.Simple(0.5, function() -- Play flame start sound
				if IsValid(self) && self.Garg_CanFlame then
					VJ.EmitSound(self, "vj_hlr/hl1_npc/garg/gar_flameon1.wav", 80)
				end
			end)
			return
		end
		
		self.Garg_FlameLevel = 2
		self.Garg_NextFlameT = CurTime() + 0.2
		
		local range = (self.Garg_Type == 1 and 280) or 460
		VJ.ApplyRadiusDamage(self, self, self:GetPos() + self:OBBCenter() + self:GetForward()*15, range, 3, DMG_BURN, true, true, {UseCone=true, UseConeDegree=35}, function(ent) if !ent:IsOnFire() && (ent:IsPlayer() or ent:IsNPC()) then ent:Ignite(2) end end)
		
		-- COSMETICS: Sound, particle and decal
		self.Garg_FlameSd = VJ.CreateSound(self, "vj_hlr/hl1_npc/garg/gar_flamerun1.wav")
		self:StopParticles()
		if self.Garg_Type == 1 then -- Baby Garg
			ParticleEffectAttach("vj_hlr_garg_flame_small", PATTACH_POINT_FOLLOW, self, 2)
			ParticleEffectAttach("vj_hlr_garg_flame_small", PATTACH_POINT_FOLLOW, self, 3)
		else
			ParticleEffectAttach("vj_hlr_garg_flame", PATTACH_POINT_FOLLOW, self, 2)
			ParticleEffectAttach("vj_hlr_garg_flame", PATTACH_POINT_FOLLOW, self, 3)
		end
		local startPos1 = self:GetAttachment(2).Pos
		local startPos2 = self:GetAttachment(3).Pos
		local tr1 = util.TraceLine({start = startPos1, endpos = startPos1 + self:GetForward()*range, filter = self})
		local tr2 = util.TraceLine({start = startPos2, endpos = startPos2 + self:GetForward()*range, filter = self})
		local hitPos1 = tr1.HitPos
		local hitPos2 = tr2.HitPos
		sound.EmitHint(SOUND_DANGER, (hitPos1 + startPos1) / 2, 300, 1, self) -- Pos: Midpoint of start and hit pos, same as Vector((hitPos1.x + startPos1.x ) / 2, (hitPos1.y + startPos1.y ) / 2, (hitPos1.z + startPos1.z ) / 2)
		sound.EmitHint(SOUND_DANGER, (hitPos2 + startPos2) / 2, 300, 1, self)
		util.Decal("VJ_HLR_Scorch", hitPos1 + tr1.HitNormal, hitPos1 - tr1.HitNormal)
		util.Decal("VJ_HLR_Scorch", hitPos2 + tr2.HitNormal, hitPos2 - tr2.HitNormal)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttack(ene, eneVisible)
	local range = (self.Garg_Type == 1 and 250) or 400
	if self.VJ_IsBeingControlled then
		range = 9999999
		eneVisible = true -- Skip enemy visibility check when being controlled!
		if !self.VJ_TheController:KeyDown(IN_ATTACK2) then -- Do flame attack only when player is holding down right click
			self:Garg_ResetFlame()
			return
		end
	end
	if eneVisible && self.AttackType == VJ.ATTACK_TYPE_NONE && self.NearestPointToEnemyDistance <= range && self.NearestPointToEnemyDistance > self.MeleeAttackDistance then
		self.Garg_CanFlame = true
		self:SetTurnTarget(ene, -1)
		//self.NextDoAnyAttackT = 1
		-- Make it constantly delay the range attack timer by 1 second (Which will also successfully play the flame-end sound)
		timer.Create("garg_flame_reset"..self:EntIndex(), 1, 0, function()
			self:Garg_ResetFlame()
		end)
	else
		self:Garg_ResetFlame()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*500 + self:GetUp()*(self.Garg_MeleeLargeKnockback and 300 or 10)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randMelee = math.random(1, 3)
	if randMelee == 1 then
		self.AnimTbl_MeleeAttack = "vjseq_smash"
		self.HasMeleeAttackKnockBack = false
		self.Garg_MeleeLargeKnockback = false
	elseif randMelee == 2 then
		self.AnimTbl_MeleeAttack = "vjseq_attack"
		self.HasMeleeAttackKnockBack = true
		self.Garg_MeleeLargeKnockback = false
	elseif randMelee == 3 then
		self.AnimTbl_MeleeAttack = "vjseq_kickcar"
		self.HasMeleeAttackKnockBack = true
		self.Garg_MeleeLargeKnockback = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	if self.VJ_IsBeingControlled then
		if self.VJ_TheController:KeyDown(IN_DUCK) && self.VJ_TheController:KeyDown(IN_ATTACK2) then
			return true
		end
		return false
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetPos() + self:GetUp() * 20 + self:GetForward() * 50 + self:GetRight() * -20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Line", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 200), 200)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
	util.Decal("VJ_HLR_Gargantua_Stomp", self:GetPos() + self:GetRight()*-20 + self:GetForward()*50, self:GetPos() + self:GetRight()*-20 + self:GetForward()*50 + self:GetUp()*-100, self)
	local ene = self:GetEnemy()
	if IsValid(ene) then
		projectile.Track_Enemy = ene
		projectile:SetAngles(Angle(self:GetAngles().p, 0, 0))
		timer.Simple(10, function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	-- Make a metal ricochet effect
	if dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	-- Handle bullet damage scaling
	if dmginfo:IsBulletDamage() == true then
		if self.Garg_Type == 1 then -- Make babies take half damage for bullets
			dmginfo:ScaleDamage(0.5)
		elseif self.Garg_Type == 2 then -- Custom Gargantua
			dmginfo:ScaleDamage(1)
		else -- Make regular Gargantua take no bullet damage
			dmginfo:ScaleDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	-- Death sequence (With explosions)
	for i = 0.3, 3.5, 0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
				local myPos = self:GetPos()
				local spr = ents.Create("env_sprite")
				spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
				spr:SetKeyValue("GlowProxySize","2.0")
				spr:SetKeyValue("HDRColorScale","1.0")
				spr:SetKeyValue("renderfx","14")
				spr:SetKeyValue("rendermode","5")
				spr:SetKeyValue("renderamt","255")
				spr:SetKeyValue("disablereceiveshadows","0")
				spr:SetKeyValue("mindxlevel","0")
				spr:SetKeyValue("maxdxlevel","0")
				spr:SetKeyValue("framerate","15.0")
				spr:SetKeyValue("spawnflags","0")
				spr:SetKeyValue("scale", self.Garg_Type == 1 and "3" or "6")
				spr:SetPos(myPos + self:GetUp()*(self.Garg_Type == 1 and math.random(60, 120) or math.random(120, 200)))
				spr:Spawn()
				spr:Fire("Kill", "", 0.9)
				util.BlastDamage(self, self, myPos, 150, 50)
				util.ScreenShake(myPos, 100, 200, 1, 2500)
				VJ.EmitSound(self, sdExplosions, 90, 100)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
local sdMetalCollision = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	timer.Simple(3.6, function()
		if IsValid(self) then
			local myPos = self:GetPos()
			if self.HasGibDeathParticles == true then
				local effectData = EffectData()
				effectData:SetOrigin(myPos + self:OBBCenter())
				effectData:SetColor(colorYellow)
				effectData:SetScale(self.Garg_Type == 1 and 140 or 400)
				util.Effect("VJ_Blood1", effectData)
				effectData:SetScale(8)
				effectData:SetFlags(3)
				effectData:SetColor(1)
				util.Effect("bloodspray", effectData)
				util.Effect("bloodspray", effectData)
				
				local spr = ents.Create("env_sprite")
				spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
				spr:SetKeyValue("GlowProxySize","2.0")
				spr:SetKeyValue("HDRColorScale","1.0")
				spr:SetKeyValue("renderfx","14")
				spr:SetKeyValue("rendermode","5")
				spr:SetKeyValue("renderamt","255")
				spr:SetKeyValue("disablereceiveshadows","0")
				spr:SetKeyValue("mindxlevel","0")
				spr:SetKeyValue("maxdxlevel","0")
				spr:SetKeyValue("framerate","15.0")
				spr:SetKeyValue("spawnflags","0")
				spr:SetKeyValue("scale", self.Garg_Type == 1 and "3" or "6")
				spr:SetPos(myPos + self:GetUp()*150)
				spr:Spawn()
				spr:Fire("Kill","",0.9)
				timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
			end
			
			util.BlastDamage(self,self,myPos,150,80)
			util.ScreenShake(myPos,100,200,1,2500)
			
			VJ.EmitSound(self, sdExplosions, 90, 100)
			VJ.EmitSound(self, "vj_base/gib/splat.wav", 90, 100)
			
			util.Decal("VJ_HLR_Scorch", myPos, myPos + self:GetUp()*-100, self)
			 
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 20))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 2, 30))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(2, 0, 35))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 3, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(3, 0, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 4, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(4, 0, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 5, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(5, 0, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 6, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(6, 0, 100))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 7, 50))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(7, 0, 55))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 8, 40))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(8, 0, 45))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 25))})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 15))})
			
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 40)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 41)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 50)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 42)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 43)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 100)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 101)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 102)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 103)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 104)), CollideSound=sdMetalCollision})
			self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 105)), CollideSound=sdMetalCollision})
			util.BlastDamage(self, self, myPos, 150, 20) -- To make the gibs FLY
		end
	end)
	return true, {DeathAnim = true}-- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.Garg_FlameSd)
end
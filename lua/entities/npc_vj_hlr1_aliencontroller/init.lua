AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/controller.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 120 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 300 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.VJC_Data = {
	FirstP_Bone = "bip01 neck", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(10, 0, -3), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_energyorb" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.RangeDistance = 2048 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE -- Death Animations
ENT.DeathAnimationTime = 1.2 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_BIG_FLINCH -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/controller/con_idle1.wav","vj_hlr/hl1_npc/controller/con_idle2.wav","vj_hlr/hl1_npc/controller/con_idle3.wav","vj_hlr/hl1_npc/controller/con_idle4.wav","vj_hlr/hl1_npc/controller/con_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/controller/con_alert1.wav","vj_hlr/hl1_npc/controller/con_alert2.wav","vj_hlr/hl1_npc/controller/con_alert3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/controller/con_attack1.wav","vj_hlr/hl1_npc/controller/con_attack2.wav","vj_hlr/hl1_npc/controller/con_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/controller/con_pain1.wav","vj_hlr/hl1_npc/controller/con_pain2.wav","vj_hlr/hl1_npc/controller/con_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/controller/con_die1.wav","vj_hlr/hl1_npc/controller/con_die2.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.AlienC_HomingAttack = false -- false = Regular, true = Homing
ENT.AlienC_FlyAnim_Forward  = 0
ENT.AlienC_FlyAnim_Backward  = 0
ENT.AlienC_FlyAnim_Right  = 0
ENT.AlienC_FlyAnim_Left  = 0
ENT.AlienC_FlyAnim_Up  = 0
ENT.AlienC_FlyAnim_Down  = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 70), Vector(-20, -20, -10))
	
	local zapSpr1 = ents.Create("env_sprite")
	zapSpr1:SetKeyValue("model","vj_hl/sprites/xspark4.vmt")
	zapSpr1:SetKeyValue("scale","1")
	zapSpr1:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	zapSpr1:SetKeyValue("renderfx","14")
	zapSpr1:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	zapSpr1:SetKeyValue("renderamt","255") -- Transparency
	zapSpr1:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	zapSpr1:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	zapSpr1:SetKeyValue("spawnflags","0")
	zapSpr1:SetParent(self)
	zapSpr1:Fire("SetParentAttachment", "2")
	zapSpr1:Spawn()
	zapSpr1:Activate()
	zapSpr1:SetNoDraw(true)
	self:DeleteOnRemove(zapSpr1)
	self.ZapSpr1 = zapSpr1
	
	local zapSpr2 = ents.Create("env_sprite")
	zapSpr2:SetKeyValue("model","vj_hl/sprites/xspark4.vmt")
	zapSpr2:SetKeyValue("scale","1")
	zapSpr2:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	zapSpr2:SetKeyValue("renderfx","14")
	zapSpr2:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	zapSpr2:SetKeyValue("renderamt","255") -- Transparency
	zapSpr2:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	zapSpr2:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	zapSpr2:SetKeyValue("spawnflags","0")
	zapSpr2:SetParent(self)
	zapSpr2:Fire("SetParentAttachment", "3")
	zapSpr2:Spawn()
	zapSpr2:Activate()
	zapSpr2:SetNoDraw(true)
	self:DeleteOnRemove(zapSpr2)
	self.ZapSpr2 = zapSpr2
	
	self.AlienC_FlyAnim_Forward  = self:GetSequenceActivity(self:LookupSequence("forward"))
	self.AlienC_FlyAnim_Backward  = self:GetSequenceActivity(self:LookupSequence("backward"))
	self.AlienC_FlyAnim_Right  = self:GetSequenceActivity(self:LookupSequence("right"))
	self.AlienC_FlyAnim_Left  = self:GetSequenceActivity(self:LookupSequence("left"))
	self.AlienC_FlyAnim_Up  = self:GetSequenceActivity(self:LookupSequence("up"))
	self.AlienC_FlyAnim_Down  = self:GetSequenceActivity(self:LookupSequence("down"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "rangeattack" or key == "rangeattack_close" then
		if IsValid(self.ZapSpr1) then
			self.ZapSpr1:SetNoDraw(true)
		end
		if IsValid(self.ZapSpr2) then
			self.ZapSpr2:SetNoDraw(true)
		end
		self.AlienC_HomingAttack = key == "rangeattack_close"
		self:RangeAttackCode()
	elseif key == "sprite" && self.AttackType == VJ.ATTACK_TYPE_RANGE && self.AlienC_HomingAttack == false then
		if IsValid(self.ZapSpr1) then
			self.ZapSpr1:SetNoDraw(false)
		end
		if IsValid(self.ZapSpr2) then
			self.ZapSpr2:SetNoDraw(false)
		end
		-- Backup timer to make sure the sprites are hidden in case event doesn't run!
		timer.Simple(2, function()
			if IsValid(self) then
				if IsValid(self.ZapSpr1) then
					self.ZapSpr1:SetNoDraw(true)
				end
				if IsValid(self.ZapSpr2) then
					self.ZapSpr2:SetNoDraw(true)
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_FLY then
		if self.AA_CurrentMovePosDir then
			local moveDir = self.AA_CurrentMovePosDir:GetNormal()
			-- Up-down
			local dotUp = moveDir:Dot(self:GetUp())
			if dotUp > 0.60 then
				return self.AlienC_FlyAnim_Up
			elseif dotUp < -0.60 then
				return self.AlienC_FlyAnim_Down
			end
			-- Forward-backward
			local dotForward = moveDir:Dot(self:GetForward())
			if dotForward > 0.5 then
				return self.AlienC_FlyAnim_Forward
			elseif dotForward < -0.5 then
				return self.AlienC_FlyAnim_Backward
			end
			-- Right-left
			local dotRight = moveDir:Dot(self:GetRight())
			if dotRight > 0.5 then
				return self.AlienC_FlyAnim_Right
			elseif dotRight < -0.5 then
				return self.AlienC_FlyAnim_Left
			end
		end
		return self.AlienC_FlyAnim_Up -- Fallback animation
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("Right Mouse + CTRL: Fire a homing orb")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	if (math.random(1, 2) == 1 && self.NearestPointToEnemyDistance < 850) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_DUCK)) then
		self.AnimTbl_RangeAttack = ACT_RANGE_ATTACK2
		self.AlienC_HomingAttack = true
	else
		self.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
		self.AlienC_HomingAttack = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
	local ene = self:GetEnemy()
	if self.AlienC_HomingAttack && IsValid(ene) then
		projectile.Track_Enemy = ene
		timer.Simple(10, function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetPos() + self:GetUp() * (self.AlienC_HomingAttack and 80 or 20)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Line", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 700), 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles then
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,1,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(2,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,2,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(3,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,3,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,1,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(1,2,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(2,0,20))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_gib/default_gib_splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt)
end
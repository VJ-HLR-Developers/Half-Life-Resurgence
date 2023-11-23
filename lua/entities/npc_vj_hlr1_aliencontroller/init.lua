AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/controller.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 120 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 300 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {"forward"} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {"forward"} -- Animations it plays when it's moving while alerted
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
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = 1.2 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_BIG_FLINCH} -- If it uses normal based animation, use this
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 70), Vector(-20, -20, -10))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "rangeattack_close" then
		if IsValid(self.Glow1) then self.Glow1:Remove() end
		if IsValid(self.Glow2) then self.Glow2:Remove() end
		self.AlienC_HomingAttack = true
		self:RangeAttackCode()
	elseif key == "rangeattack" then
		if IsValid(self.Glow1) then self.Glow1:Remove() end
		if IsValid(self.Glow2) then self.Glow2:Remove() end
		self.AlienC_HomingAttack = false
		self:RangeAttackCode()
	elseif key == "sprite" && self.AttackType == VJ.ATTACK_TYPE_RANGE && self.AlienC_HomingAttack == false then
		if IsValid(self.Glow1) then self.Glow1:Remove() end
		if IsValid(self.Glow2) then self.Glow2:Remove() end
		self.Glow1 = ents.Create("env_sprite")
		self.Glow1:SetKeyValue("model","vj_hl/sprites/xspark4.vmt")
		self.Glow1:SetKeyValue("scale","1")
		//self.Glow1:SetKeyValue("rendercolor","255 128 0")
		self.Glow1:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
		//self.Glow1:SetKeyValue("HDRColorScale","1.0")
		self.Glow1:SetKeyValue("renderfx","14")
		self.Glow1:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
		self.Glow1:SetKeyValue("renderamt","255") -- Transparency
		self.Glow1:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
		self.Glow1:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
		self.Glow1:SetKeyValue("spawnflags","0")
		self.Glow1:SetParent(self)
		self.Glow1:Fire("SetParentAttachment","2")
		self.Glow1:Spawn()
		self.Glow1:Activate()
		self:DeleteOnRemove(self.Glow1)
		timer.Simple(2,function() if IsValid(self) && IsValid(self.Glow1) then self.Glow1:Remove() end end)
		
		self.Glow2 = ents.Create("env_sprite")
		self.Glow2:SetKeyValue("model","vj_hl/sprites/xspark4.vmt")
		self.Glow2:SetKeyValue("scale","1")
		//self.Glow2:SetKeyValue("rendercolor","255 128 0")
		self.Glow2:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
		//self.Glow2:SetKeyValue("HDRColorScale","1.0")
		self.Glow2:SetKeyValue("renderfx","14")
		self.Glow2:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
		self.Glow2:SetKeyValue("renderamt","255") -- Transparency
		self.Glow2:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
		self.Glow2:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
		self.Glow2:SetKeyValue("spawnflags","0")
		self.Glow2:SetParent(self)
		self.Glow2:Fire("SetParentAttachment","3")
		self.Glow2:Spawn()
		self.Glow2:Activate()
		self:DeleteOnRemove(self.Glow2)
		timer.Simple(2,function() if IsValid(self) && IsValid(self.Glow2) then self.Glow2:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("Right Mouse + CTRL: Fire single homing orb")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	if (math.random(1, 2) == 1 && self.NearestPointToEnemyDistance < 850) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_DUCK)) then
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2}
		self.RangeAttackPos_Up = 80
		self.AlienC_HomingAttack = true
	else
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
		self.RangeAttackPos_Up = 20
		self.AlienC_HomingAttack = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
	if self.AlienC_HomingAttack == true && IsValid(self:GetEnemy()) then
		projectile.Track_Enemy = self:GetEnemy()
		timer.Simple(10,function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
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
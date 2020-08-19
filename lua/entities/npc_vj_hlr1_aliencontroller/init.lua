AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/controller.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 120 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 300 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {"forward"} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {"forward"} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_energyorb" -- The entity that is spawned when range attacking
ENT.RangeDistance = 2000 -- This is how far away it can shoot
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

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Bip01 Head"
ENT.Controller_FirstPersonOffset = Vector(4,0,0)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

-- Custom
ENT.AlienC_AttackType = false -- 0 = Regular, 1 = Homing
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	if math.random(1,2) == 1 && self.NearestPointToEnemyDistance < 850 then
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2}
		self.RangeAttackPos_Up = 80
		self.AlienC_AttackType = true
	else
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
		self.RangeAttackPos_Up = 20
		self.AlienC_AttackType = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 70), Vector(-20, -20, -10))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "rangeattack_close" then
		if IsValid(self.Glow1) then self.Glow1:Remove() end
		if IsValid(self.Glow2) then self.Glow2:Remove() end
		self.AlienC_AttackType = true
		self:RangeAttackCode()
	end
	if key == "rangeattack" then
		if IsValid(self.Glow1) then self.Glow1:Remove() end
		if IsValid(self.Glow2) then self.Glow2:Remove() end
		self.AlienC_AttackType = false
		self:RangeAttackCode()
	end
	if key == "sprite" && self.RangeAttacking == true && self.AlienC_AttackType == false then
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
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(TheProjectile)
	if self.AlienC_AttackType == true && IsValid(self:GetEnemy()) then
		TheProjectile.EO_Enemy = self:GetEnemy()
		timer.Simple(10,function() if IsValid(TheProjectile) then TheProjectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return self:CalculateProjectile("Line", self:GetPos() + self:GetUp()*20, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() +self:OBBCenter())
		effectdata:SetScale(1)
		util.Effect("StriderBlood",effectdata)
		util.Effect("StriderBlood",effectdata)
	end
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
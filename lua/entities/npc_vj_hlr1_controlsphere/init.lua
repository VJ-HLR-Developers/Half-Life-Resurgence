AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/sphere.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
ENT.Aerial_FlyingSpeed_Calm = 50 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 80 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeDistance = 1020 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "Regular" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/sphere/BUTTON.WAV","vj_hlr/hl1_npc/sphere/sp_idle.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/sphere/sp_alert1.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/fx/zap4.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/hassault/hw_shoot1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/sphere/sp_pain1.wav","vj_hlr/hl1_npc/sphere/sp_pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/sphere/sp_die.wav"}

ENT.GeneralSoundPitch1 = 100

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(8,8,12), Vector(-8,-8,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "shoot" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self:GetEnemy()) then
		AnimTbl_IdleStand = {ACT_IDLE_ANGRY}
	else
		AnimTbl_IdleStand = {ACT_IDLE}
	end
	
	if self:Health() <= (self:GetMaxHealth() / 2.2) then
		self:SetSkin(1)
	else
		self:SetSkin(0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControlSphere_DoElecEffect(sp,hp)
	local elec = EffectData()
	elec:SetStart(sp)
	elec:SetOrigin(hp)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	elec:SetScale(0)
	util.Effect("VJ_HLR_Electric_Charge",elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	-- Tsakh --------------------------
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
		endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200,
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
	
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
		endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*-math.Rand(150,500),
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
	
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
		endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*math.Rand(150,500),
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
	
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
		endpos = self:GetPos() + self:GetRight()*math.Rand(1,150) + self:GetUp()*200 + self:GetForward()*math.Rand(-100,100),
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
	
	-- Ach --------------------------
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
		endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200,
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
	
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
		endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*-math.Rand(150,500),
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
	
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
		endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*math.Rand(150,500),
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
	
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
		endpos = self:GetPos() + self:GetRight()*-math.Rand(1,150) + self:GetUp()*200 + self:GetForward()*math.Rand(-100,100),
		filter = self
	})
	if tr.Hit == true then self:ControlSphere_DoElecEffect(tr.StartPos, tr.HitPos) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local startpos = self:GetPos() + self:GetForward()*8
	local tr = util.TraceLine({
		start = self:GetPos() + self:GetUp()*45 + self:GetForward()*40,
		endpos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter(),
		filter = self
	})
	local hitpos = tr.HitPos
	
	local elec = EffectData()
	elec:SetStart(startpos)
	elec:SetOrigin(hitpos)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	util.Effect("VJ_HLR_Electric",elec)
	
	util.VJ_SphereDamage(self,self,hitpos,30,10,DMG_SHOCK,true,false,{Force=90})
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,0))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,0))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,0))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,0))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
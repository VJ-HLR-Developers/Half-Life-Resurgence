AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/bullsquid.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 120
ENT.HullType = HULL_WIDE_SHORT
ENT.VJC_Data = {
    FirstP_Bone = "Bip01 Spine1", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(10, 0, 11.5), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_AcidPoisonRadiation = true -- Makes the SNPC not get damage from Acid, posion, radiation
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 35 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 125 -- How far does the damage go?
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 50 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 60 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 250 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 260 -- How far it will push you up | Second in math.random
ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_toxicspit" -- The entity that is spawned when range attacking
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 1.5 -- How much time until it can use a range attack?
ENT.RangeDistance = 784 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 250 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?
ENT.RangeAttackPos_Up = 20 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 0 -- Forward/ Backward spawning position for range attack
ENT.RangeAttackPos_Right = 0 -- Right/Left spawning position for range attack
ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE, ACT_DIEFORWARD} -- Death Animations
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/pl_step1.wav","vj_hlr/pl_step2.wav","vj_hlr/pl_step3.wav","vj_hlr/pl_step4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/bullchicken/bc_idle1.wav","vj_hlr/hl1_npc/bullchicken/bc_idle2.wav","vj_hlr/hl1_npc/bullchicken/bc_idle2.wav","vj_hlr/hl1_npc/bullchicken/bc_idle3.wav","vj_hlr/hl1_npc/bullchicken/bc_idle4.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/bullchicken/bc_idle1.wav","vj_hlr/hl1_npc/bullchicken/bc_idle2.wav","vj_hlr/hl1_npc/bullchicken/bc_idle2.wav","vj_hlr/hl1_npc/bullchicken/bc_idle3.wav","vj_hlr/hl1_npc/bullchicken/bc_idle4.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/bullchicken/bc_attackgrowl.wav","vj_hlr/hl1_npc/bullchicken/bc_attackgrowl2.wav","vj_hlr/hl1_npc/bullchicken/bc_attackgrowl3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/bullchicken/bc_bite1.wav","vj_hlr/hl1_npc/bullchicken/bc_bite2.wav","vj_hlr/hl1_npc/bullchicken/bc_bite3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/bullchicken/bc_attack2.wav","vj_hlr/hl1_npc/bullchicken/bc_attack3.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/bullchicken/bc_pain1.wav","vj_hlr/hl1_npc/bullchicken/bc_pain2.wav","vj_hlr/hl1_npc/bullchicken/bc_pain3.wav","vj_hlr/hl1_npc/bullchicken/bc_pain4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/bullchicken/bc_die1.wav","vj_hlr/hl1_npc/bullchicken/bc_die2.wav","vj_hlr/hl1_npc/bullchicken/bc_die3.wav"}

-- Custom
ENT.Bullsquid_Type = 0 -- 0 = Retail Half-Life 1 | Alpha Half-Life 1
ENT.Bullsquid_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if self.Bullsquid_Type == 1 then
		self:SetCollisionBounds(Vector(35, 35 , 60), Vector(-35, -35, 0))
	else
		self:SetCollisionBounds(Vector(30, 30 , 44), Vector(-30, -30, 0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "event_emit step" then
		self:FootStepSoundCode()
	end
	if key == "melee_bite" or key == "melee_whip" then
		self:MeleeAttackCode()
	end
	if key == "rangeattack" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Bullsquid_Type == 1 then return end
	if self.Dead == false && CurTime() > self.Bullsquid_BlinkingT then
		self:SetSkin(1)
		timer.Simple(0.3,function() if IsValid(self) then self:SetSkin(0) end end)
		self.Bullsquid_BlinkingT = CurTime() + math.Rand(2,3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.Bullsquid_Type == 1 then return end
	if math.random(1, 3) == 1 then
		if ent.HLR_Type == "Headcrab" or ent:GetClass() == "npc_headcrab" or ent:GetClass() == "npc_headcrab_black" or ent:GetClass() == "npc_headcrab_fast" then
			self:VJ_ACT_PLAYACTIVITY("seecrab", true, false, true)
		else
			self:VJ_ACT_PLAYACTIVITY(ACT_HOP, true, false, true)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	if self.Bullsquid_BullSquidding == true then
		return self:CalculateProjectile("Line", self:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 250000)
	else
		return self:CalculateProjectile("Curve", self:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 1500)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randAttack = math.random(1,2)
	if randAttack == 1 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.MeleeAttackDamage = 35
	elseif randAttack == 2 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
		self.MeleeAttackDamage = 20
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetSkin(1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() + self:OBBCenter())
		effectdata:SetScale(1)
		util.Effect("StriderBlood",effectdata)
		util.Effect("StriderBlood",effectdata)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
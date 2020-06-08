AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/islave.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.MeleeAttackDamage = 20
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeDistance = 1020 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 100 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
ENT.HasHitGroupFlinching = true -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}},{HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}},{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_IdleDialogue = {
	"vo/eli_lab/vort_elab_use01.wav",
	"vo/eli_lab/vort_elab_use02.wav",
	"vo/eli_lab/vort_elab_use03.wav",
	"vo/eli_lab/vort_elab_use04.wav",
	"vo/eli_lab/vort_elab_use05.wav",
}
ENT.SoundTbl_IdleDialogueAnswer = {}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_OnReceiveOrder = {}
ENT.SoundTbl_FollowPlayer = {
	"vo/coast/vgossip_02.wav",
}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {
	"vo/canals/vort_reckoning.wav",
	"vo/coast/bugbait/vbaittrain01a.wav",
}
ENT.SoundTbl_Investigate = {}
ENT.SoundTbl_LostEnemy = {}
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_CallForHelp = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_BeforeRangeAttack = {}
ENT.SoundTbl_RangeAttack = {}
ENT.SoundTbl_BeforeLeapAttack = {}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_AllyDeath = {}
ENT.SoundTbl_Pain = {}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {}
ENT.SoundTbl_Death = {}

ENT.FootStepSoundLevel = 60

ENT.GeneralSoundPitch1 = 100
ENT.RangeAttackPitch1 = 130
ENT.RangeAttackPitch2 = 160

--[[ UNUSED
-- Complementing the player
vo/coast/bugbait/vbaittrain_fine.wav
vo/coast/bugbait/vbaittrain_gotit.wav
vo/coast/bugbait/vbaittrain_great.wav

]]--

-- CustomBlood_Decal
ENT.Vort_RunAway = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20,20,65), Vector(-20,-20,0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "event_emit step" or key == "step" then
		self:FootStepSoundCode()
	end
	if key == "right" or key == "left" then
		self:MeleeAttackCode()
	end
	if key == "shoot" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Vort_DoElecEffect(sp,hp,a,t)
	local elec = EffectData()
	elec:SetStart(sp)
	elec:SetOrigin(hp)
	elec:SetEntity(self)
	elec:SetAttachment(a)
	elec:SetScale(t)
	util.Effect("VJ_HLR_Electric_Charge",elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	-- Tsakh --------------------------
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200,
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*-math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(1,150) + self:GetUp()*200 + self:GetForward()*math.Rand(-100,100),
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	-- Ach --------------------------
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200,
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*-math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.6)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(1,150) + self:GetUp()*200 + self:GetForward()*math.Rand(-100,100),
				filter = self
			})
			if tr.Hit == true then self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local startpos = self:GetPos() + self:GetUp()*45 + self:GetForward()*40
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
	
	local elec = EffectData()
	elec:SetStart(startpos)
	elec:SetOrigin(hitpos)
	elec:SetEntity(self)
	elec:SetAttachment(2)
	util.Effect("VJ_HLR_Electric",elec)
	
	util.VJ_SphereDamage(self,self,hitpos,30,20,DMG_SHOCK,true,false,{Force=90})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule()
	if self.Dead == false && self.vACT_StopAttacks == false && self.Vort_RunAway == true && self.PlayingAttackAnimation == false then
		self.Vort_RunAway = false
		self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.RunCode_OnFail = function() self.NextDoAnyAttackT = 0 end end)
		self.NextDoAnyAttackT = CurTime() + 5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	if (self.NextDoAnyAttackT + 2) > CurTime() then return end
	self.Vort_RunAway = true
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
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/islavegib.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup)
	if hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = {ACT_DIE_HEADSHOT}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
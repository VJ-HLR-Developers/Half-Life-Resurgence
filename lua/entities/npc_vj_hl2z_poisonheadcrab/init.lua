AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/headcrabblack.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 30
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_green_01"}
ENT.HasMeleeAttack = false
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {ACT_RANGE_ATTACK1} -- Melee Attack Animations
ENT.LeapDistance = 250 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 1.8 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 1.8 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 1.8 -- How much time until it can use any attack again? | Counted in Seconds
ENT.TimeUntilLeapAttackVelocity = 1.48 -- How much time until it runs the velocity code?
ENT.LeapAttackVelocityForward = 50 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 300 -- How much upward force should it apply?
ENT.LeapAttackDamageType = DMG_POISON
ENT.LeapAttackDamageDistance = 40 -- How far does the damage go?
ENT.LeapAttackAnimationFaceEnemy = true
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/headcrab_poison/ph_step1.wav","npc/headcrab_poison/ph_step2.wav","npc/headcrab_poison/ph_step3.wav","npc/headcrab_poison/ph_step4.wav"}
ENT.SoundTbl_AlertAnim = {"npc/headcrab_poison/ph_warning1.wav","npc/headcrab_poison/ph_warning2.wav","npc/headcrab_poison/ph_warning3.wav"}
ENT.SoundTbl_CombatIdle = {"npc/headcrab_poison/ph_hiss1.wav"}
ENT.SoundTbl_BeforeLeapAttack = {"npc/headcrab_poison/ph_scream1.wav","npc/headcrab_poison/ph_scream2.wav","npc/headcrab_poison/ph_scream3.wav"}
ENT.SoundTbl_LeapAttackDamage = {"npc/headcrab_poison/ph_poisonbite1.wav","npc/headcrab_poison/ph_poisonbite2.wav","npc/headcrab_poison/ph_poisonbite3.wav"}
ENT.SoundTbl_LeapAttackJump = {"npc/headcrab_poison/ph_jump1.wav","npc/headcrab_poison/ph_jump2.wav","npc/headcrab_poison/ph_jump3.wav"}
ENT.SoundTbl_Pain = {"npc/headcrab_poison/ph_pain1.wav","npc/headcrab_poison/ph_pain2.wav","npc/headcrab_poison/ph_pain3.wav","npc/headcrab_poison/ph_wallpain1.wav","npc/headcrab_poison/ph_wallpain2.wav","npc/headcrab_poison/ph_wallpain3.wav"}
ENT.SoundTbl_Death = {"npc/headcrab_poison/ph_rattle1.wav","npc/headcrab_poison/ph_rattle2.wav","npc/headcrab_poison/ph_rattle3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(14,14,15), Vector(-14,-14,0))
	self.CustomRunActivites = {self:VJ_LookupAnimationString("Scurry")}
	//sequence = Spitattack
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert()
	if self.CanAlertCrab != true then return end
	VJ_STOPSOUND(self.CurrentIdleSound)
	self.NextIdleSoundT = self.NextIdleSoundT + 2
	self.CurrentAlertSound = VJ_CreateSound(self,VJ_PICKRANDOMTABLE(self.SoundTbl_AlertAnim),self.AlertSoundLevel,self:VJ_DecideSoundPitch(self.AlertSoundPitch1,self.AlertSoundPitch2))
	self:VJ_ACT_PLAYACTIVITY("Threatdisplay",true,VJ_GetSequenceDuration(self,"Threatdisplay"),false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local changedtbl = true
	for _,v in ipairs(ents.FindInSphere(self:GetPos(),1500)) do
		if v:IsNPC() && v != self && v:GetClass() == self:GetClass() then
			changedtbl = true
		else
			changedtbl = false
		end
	end
	if changedtbl == true then
		self.NextSoundTime_Idle2 = 11
		self.SoundTbl_Idle = {"npc/headcrab_poison/ph_idle1.wav","npc/headcrab_poison/ph_idle2.wav","npc/headcrab_poison/ph_idle3.wav"}
	else
		self.NextSoundTime_Idle2 = 4
		self.SoundTbl_Idle = {"npc/headcrab_poison/ph_talk1.wav","npc/headcrab_poison/ph_talk2.wav","npc/headcrab_poison/ph_talk3.wav"}
	end
	if self.VJ_IsBeingControlled == false then
		self.AnimTbl_Run = {ACT_RUN}
		self.AnimTbl_Walk = {ACT_RUN}
		self.FootStepTimeRun = 0.5
		self.FootStepTimeWalk = 0.5
		if self:Health() <= 10 then
			self.AnimTbl_Run = {self:VJ_LookupAnimationString("Scurry")}
			self.FootStepTimeRun = 0.09
		end
	else
		self.AnimTbl_Run = {self:VJ_LookupAnimationString("Scurry")}
		self.AnimTbl_Walk = {ACT_RUN}
		self.FootStepTimeRun = 0.09
		self.FootStepTimeWalk = 0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThrown(enemy,owner)
	self:SetOwner(owner)
	timer.Simple(0.05,function()
		if self:IsValid() then
			self.CanAlertCrab = false
		end
	end)
	if owner.VJ_IsBeingControlled == false then
		enemy = enemy
		self:SetEnemy(enemy)
	else
		enemy = owner.VJ_TheControllerBullseye
	end
	self:FaceCertainEntity(enemy,true)
	self:SetGroundEntity(NULL)
	local jumpcode = ((enemy:GetPos() +self:OBBCenter()) -(self:GetPos() +self:OBBCenter())):GetNormal() *400 +self:GetForward() *500 +self:GetUp() *200
	self:SetLocalVelocity(jumpcode)
	self:VJ_ACT_PLAYACTIVITY("Drown",true,VJ_GetSequenceDuration(self,"Drown"),false)
	timer.Simple(VJ_GetSequenceDuration(self,"Drown"),function()
		if self:IsValid() then
			self.CanAlertCrab = true
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttackVelocityCode()
	self:SetGroundEntity(NULL)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FootStepSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasFootStepSound == false or self.MovementType == VJ_MOVETYPE_STATIONARY then return end
	if self:IsOnGround() && self:GetGroundEntity() != NULL && self:IsMoving() then
		if self.DisableFootStepSoundTimer == true then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if VJ_PICKRANDOMTABLE(soundtbl) != false then
				VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
			end
		end
		if self.DisableFootStepSoundTimer == false && CurTime() > self.FootStepT then
			self:CustomOnFootStepSound()
			local soundtbl = self.SoundTbl_FootStep
			if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
			if VJ_PICKRANDOMTABLE(soundtbl) != false then
				//VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
				if self.DisableFootStepOnRun == false && (table.HasValue(self.CustomRunActivites,self:GetMovementActivity())) then
					self:CustomOnFootStepSound_Run()
					VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					self.FootStepT = CurTime() + self.FootStepTimeRun
				elseif self.DisableFootStepOnWalk == false && (self:GetMovementActivity() == ACT_RUN && self:GetMovementActivity() != self:VJ_LookupAnimationString("Scurry")) then
					self:CustomOnFootStepSound_Walk()
					VJ_EmitSound(self,soundtbl,self.FootStepSoundLevel,self:VJ_DecideSoundPitch(self.FootStepPitch1,self.FootStepPitch2))
					self.FootStepT = CurTime() + self.FootStepTimeWalk
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LeapDamageCode()
	if self:Health() <= 0 then return end
	if self.vACT_StopAttacks == true then return end
	if self.Flinching == true then return end
	if self.StopLeapAttackAfterFirstHit == true && self.AlreadyDoneLeapAttackFirstHit == true then return end
	self:CustomOnLeapAttack_BeforeChecks()
	local hitentity = false
	local attackthev = ents.FindInSphere(self:GetPos(),self.LeapAttackDamageDistance)
	if attackthev != nil then
		for _,v in pairs(attackthev) do
			if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
			if (v:IsNPC() || (v:IsPlayer() && v:Alive())) && (self:Disposition(v) != D_LI) && (v != self) && (v:GetClass() != self:GetClass()) or VJ_IsProp(v) == true or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
				self:CustomOnLeapAttack_AfterChecks(v)
				local leapdmg = DamageInfo()
				leapdmg:SetDamage(v:Health() -1)
				leapdmg:SetInflictor(self)
				leapdmg:SetDamageType(self.LeapAttackDamageType)
				leapdmg:SetAttacker(self)
				if v:IsNPC() or v:IsPlayer() then leapdmg:SetDamageForce(self:GetForward()*((leapdmg:GetDamage()+100)*70)) end
				v:TakeDamageInfo(leapdmg, self)
				if v:IsPlayer() then
					v:ViewPunch(Angle(math.random(-1,1)*self.LeapAttackDamage,math.random(-1,1)*self.LeapAttackDamage,math.random(-1,1)*self.LeapAttackDamage))
				end
				hitentity = true
			end
		end
	end
 	if hitentity == false then
		self:CustomOnLeapAttack_Miss()
		self:LeapAttackDamageMissSoundCode()
	else
		self:LeapAttackDamageSoundCode()
		if self.StopLeapAttackAfterFirstHit == true then self.AlreadyDoneLeapAttackFirstHit = true /*self:SetLocalVelocity(Vector(0,0,0))*/ end
	end
	if self.AlreadyDoneFirstLeapAttack == false && self.TimeUntilLeapAttackDamage != false then
		self:LeapAttackCode_DoFinishTimers()
	end
	self.AlreadyDoneFirstLeapAttack = true
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
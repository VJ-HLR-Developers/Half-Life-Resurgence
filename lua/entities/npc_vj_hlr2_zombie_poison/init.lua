AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zombie/Poison.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 250
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_green_01"}
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.MeleeAttackDamage = 18
ENT.TimeUntilMeleeAttackDamage = 1.08
ENT.FootStepTimeRun = 0.21 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombie_poison/pz_left_foot1.wav","npc/zombie_poison/pz_right_foot1.wav"}
ENT.SoundTbl_Idle = {"npc/zombie_poison/pz_idle2.wav","npc/zombie_poison/pz_idle3.wav","npc/zombie_poison/pz_idle4.wav"}
ENT.SoundTbl_Breath = {"npc/zombie_poison/pz_breathe_loop1.wav","npc/zombie_poison/pz_breathe_loop2.wav"}
ENT.SoundTbl_Alert = {"npc/zombie_poison/pz_alert1.wav","npc/zombie_poison/pz_alert2.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/zombie_poison/pz_warn1.wav","npc/zombie_poison/pz_warn2.wav"}
ENT.SoundTbl_Pain = {"npc/zombie_poison/pz_pain1.wav","npc/zombie_poison/pz_pain2.wav","npc/zombie_poison/pz_pain3.wav"}
ENT.SoundTbl_Death = {"npc/zombie_poison/pz_die1.wav","npc/zombie_poison/pz_die2.wav"}
ENT.SoundTbl_Warn = {"npc/zombie_poison/pz_warn1.wav","npc/zombie_poison/pz_warn2.wav"}
ENT.SoundTbl_Throw = {"npc/zombie_poison/pz_throw2.wav","npc/zombie_poison/pz_throw3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSkin(math.random(0,10))
	self:SetBodygroup(1,1)
	self:SetBodygroup(2,1)
	self:SetBodygroup(3,1)
	self:SetBodygroup(4,1)
	self:SetCollisionBounds(Vector(22,22,60), Vector(-22,-22,0))
	self.BlackHeadcrabs = 3
	self.NextThrowT = 0
	self.CustomRunActivites = {self:VJ_LookupAnimationString("FireWalk")}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.CurrentBreathSound:Stop()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetHeadcrabCount()
	return self.BlackHeadcrabs
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChooseCrab()
	local position = self:GetPos() +Vector(0,0,100)
	if self:GetHeadcrabCount() == 3 then
		position = self:GetAttachment(self:LookupAttachment("headcrab4")).Pos
	elseif self:GetHeadcrabCount() == 2 then
		position = self:GetAttachment(self:LookupAttachment("headcrab3")).Pos
	elseif self:GetHeadcrabCount() == 1 then
		position = self:GetAttachment(self:LookupAttachment("headcrab2")).Pos
	end
	return position
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PoisonHeadcrabAttack(type)
	local throwpos = self:ChooseCrab()
	if type == "throw" then
		local dur = VJ_GetSequenceDuration(self,"ThrowWarning") -0.2
		self:VJ_ACT_PLAYACTIVITY("ThrowWarning",true,dur,false)
		timer.Simple(dur,function() if self:IsValid() && ((self.VJ_IsBeingControlled == false && IsValid(self:GetEnemy())) or self.VJ_IsBeingControlled == true) then
			local throwdur = VJ_GetSequenceDuration(self,"Throw") -0.2
			self:VJ_ACT_PLAYACTIVITY("Throw",true,throwdur,false)
			timer.Simple(dur,function() if self:IsValid() && ((self.VJ_IsBeingControlled == false && IsValid(self:GetEnemy())) or self.VJ_IsBeingControlled == true) then
				local crab = ents.Create("npc_vj_hlr2_headcrab_poison")
				crab:SetPos(throwpos +Vector(0,0,18))
				crab:SetAngles(self:GetAngles())
				crab:Spawn()
				crab:Activate()
				crab:OnThrown(self:GetEnemy(),self)
				self.BlackHeadcrabs = self.BlackHeadcrabs -1
				self:StopAttacks()
			end end)
		end end)
	else
		local dur = VJ_GetSequenceDuration(self,"headcrab2Leap") -0.2
		self:VJ_ACT_PLAYACTIVITY("headcrab2Leap",true,dur,false)
		timer.Simple(dur,function() if self:IsValid() && ((self.VJ_IsBeingControlled == false && IsValid(self:GetEnemy())) or self.VJ_IsBeingControlled == true) then
				local crab = ents.Create("npc_vj_hlr2_headcrab_poison")
				crab:SetPos(throwpos +Vector(0,0,18))
				crab:SetAngles(self:GetAngles())
				crab:Spawn()
				crab:Activate()
				crab:OnThrown(self:GetEnemy(),self)
				self.BlackHeadcrabs = self.BlackHeadcrabs -1
				self:StopAttacks()
		end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:GetHeadcrabCount() < 3 && self:GetHeadcrabCount() > 1 then
		self:SetBodygroup(4,0)
	elseif self:GetHeadcrabCount() < 2 && self:GetHeadcrabCount() > 0 then
		self:SetBodygroup(3,0)
	elseif self:GetHeadcrabCount() < 1 then
		self:SetBodygroup(2,0)
	end
	if self.VJ_IsBeingControlled == false then
		self.AnimTbl_Run = {ACT_WALK}
		self.AnimTbl_Walk = {ACT_WALK}
		if IsValid(self:GetEnemy()) then
			if self:GetHeadcrabCount() > 0 && CurTime() > self.NextThrowT && self:GetEnemy():Visible(self) && self:GetEnemy():GetPos():Distance(self:GetPos()) > 200 && self:GetEnemy():GetPos():Distance(self:GetPos()) < 1000 then
				if self:GetEnemy():GetPos():Distance(self:GetPos()) > 500 then
					self:PoisonHeadcrabAttack("throw")
				else
					self:PoisonHeadcrabAttack("leap")
				end
				self.NextThrowT = CurTime() +math.random(8,12)
			end
		end
	else
		if self.VJ_TheController:KeyDown(IN_ATTACK2) && self:GetHeadcrabCount() > 0 && CurTime() > self.NextThrowT then
			if self.VJ_TheControllerBullseye:GetPos():Distance(self:GetPos()) > 500 then
				self:PoisonHeadcrabAttack("throw")
			else
				self:PoisonHeadcrabAttack("leap")
			end
			self.NextThrowT = CurTime() +5
		end
		self.AnimTbl_Run = {self:VJ_LookupAnimationString("FireWalk")}
		self.AnimTbl_Walk = {ACT_WALK}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	if self:GetBodygroup(1) == 0 then return false end
	local randcrab = math.random(1,3)
	local dmgtype = dmginfo:GetDamageType()
	if hitgroup == HITGROUP_HEAD then randcrab = math.random(1,2) end
	if dmgtype == DMG_CLUB or dmgtype == DMG_SLASH then randcrab = 1 end
	if randcrab == 1 then
		self:SetBodygroup(1,1)
	end
	if randcrab == 2 then
		self:CreateExtraDeathCorpse("prop_ragdoll","models/headcrabblack.mdl",{Pos=self:GetAttachment(self:LookupAttachment("headcrab1")).Pos})
		self.Corpse:SetBodygroup(1,0)
	end
	if randcrab == 3 then
		self.Corpse:SetBodygroup(1,0)
		local spawncrab = ents.Create("npc_vj_hlr2_headcrab_poison")
		local enemy = self:GetEnemy()
		local pos = self:GetAttachment(self:LookupAttachment("headcrab1")).Pos
		spawncrab:SetPos(pos)
		spawncrab:SetAngles(self:GetAngles())
		spawncrab:SetVelocity(dmginfo:GetDamageForce()/58)
		spawncrab:Spawn()
		spawncrab:Activate()
		if self.Corpse:IsOnFire() then spawncrab:Ignite(math.Rand(8,10),0) end
		timer.Simple(0.05,function()
			if spawncrab != nil then
				spawncrab:SetPos(pos)
				if IsValid(enemy) then spawncrab:SetEnemy(enemy) spawncrab:SetSchedule(SCHED_CHASE_ENEMY) end
			end
		end)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
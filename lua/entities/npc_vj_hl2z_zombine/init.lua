AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zombie/zombie_soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 110
ENT.HullType = HULL_WIDE_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_green_01"}
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"FastAttack"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 45 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 90 -- How far does the damage go?
ENT.MeleeAttackDamage = 18
ENT.TimeUntilMeleeAttackDamage = 0.45
ENT.FootStepTimeRun = 0.21 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombine/gear1.wav","npc/zombine/gear2.wav","npc/zombine/gear3.wav"}
ENT.SoundTbl_Idle = {"npc/zombine/zombine_idle1.wav","npc/zombine/zombine_idle2.wav","npc/zombine/zombine_idle3.wav","npc/zombine/zombine_idle4.wav","npc/zombine/zombine_alert1.wav","npc/zombine/zombine_alert2.wav","npc/zombine/zombine_alert3.wav","npc/zombine/zombine_alert4.wav","npc/zombine/zombine_alert7.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetSkin(math.random(0,4))
	self:SetBodygroup(1,1)
	self:SetCollisionBounds(Vector(13,13,60), Vector(-13,-13,0))
	self.GrenadePulled = false
	self.BlowTime = 0
	self.IsPlayingSpecialAttack = false
	self.CustomWalkActivites = {VJ_SequenceToActivity(self,"walk_all_grenade")}
	self.CustomRunActivites = {VJ_SequenceToActivity(self,"walk_all_grenade")}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateGrenade()
	local grenent = ents.Create("npc_grenade_frag")
	grenent:SetModel("models/Items/grenadeAmmo.mdl")
	grenent:SetPos(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Pos)
	grenent:SetAngles(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Ang)
	grenent:SetOwner(self)
	grenent:SetParent(self)
	grenent:Fire("SetParentAttachment","grenade_attachment")
	grenent:Spawn()
	grenent:Activate()
	grenent:Input("SetTimer",self:GetOwner(),self:GetOwner(),3.5)
	-- grenent.VJHumanTossingAway = true // Soldiers kept stealing their grenades xD
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GrenadeCode()
	if self.GrenadePulled == true then return end
	self.GrenadePulled = true
	self:VJ_ACT_PLAYACTIVITY("pullGrenade",true,VJ_GetSequenceDuration(self,self:VJ_LookupAnimationString("pullGrenade")))
	timer.Simple(VJ_GetSequenceDuration(self,self:VJ_LookupAnimationString("pullGrenade")) -0.4,function()
		if self:IsValid() then
			self:CreateGrenade()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self.NextMeleeAttackTime = self.CurrentAttackAnimationDuration
	self.NextAnyAttackTime_Melee = self.CurrentAttackAnimationDuration

	if self.VJ_IsBeingControlled == false then
		if self:Health() < 40 && IsValid(self:GetEnemy()) && math.random(1,10) == 1 && self:GetEnemy():GetPos():Distance(self:GetPos()) < 500 then
			self:GrenadeCode()
		end
	else
		if self:Health() < 40 && self.VJ_TheController:KeyDown(IN_ATTACK2) then
			self.AnimTbl_IdleStand = {"Idle_Grenade"}
			self:GrenadeCode()
		end
	end

	if self:GetMovementActivity() == ACT_RUN then
		self.FootStepTimeRun = 0.3
	elseif self:GetMovementActivity() == ACT_WALK then
		self.FootStepTimeWalk = 0.55
	else
		self.FootStepTimeRun = 0.3
		self.FootStepTimeWalk = 0.55
	end

	if self.GrenadePulled == true then
		self.AnimTbl_IdleStand = {"Idle_Grenade"}
		self.AnimTbl_Run = {self:VJ_LookupAnimationString("Run_All_grenade")}
		self.AnimTbl_Walk = {self:VJ_LookupAnimationString("walk_All_Grenade")}
	else
		self.AnimTbl_IdleStand = {ACT_IDLE}
		if IsValid(self:GetEnemy()) && self:GetEnemy():GetPos():Distance(self:GetPos()) < 1000 then
			self.AnimTbl_Walk = {ACT_RUN}
			self.AnimTbl_Run = {ACT_RUN}
		elseif IsValid(self:GetEnemy()) && self:GetEnemy():GetPos():Distance(self:GetPos()) > 1000 then
			self.AnimTbl_Walk = {ACT_WALK}
			self.AnimTbl_Run = {ACT_WALK}
		else
			self.AnimTbl_Walk = {ACT_WALK}
			self.AnimTbl_Run = {ACT_RUN}
		end
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
		self:CreateExtraDeathCorpse("prop_ragdoll","models/headcrabclassic.mdl",{Pos=self:GetAttachment(self:LookupAttachment("headcrab")).Pos})
		self.Corpse:SetBodygroup(1,0)
	end
	if randcrab == 3 then
		self.Corpse:SetBodygroup(1,0)
		local spawncrab = ents.Create("npc_vj_hl2z_headcrab")
		local enemy = self:GetEnemy()
		local pos = self:GetAttachment(self:LookupAttachment("headcrab")).Pos
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if self.GrenadePulled == true then
		local grenent = ents.Create("npc_grenade_frag")
		grenent:SetModel("models/Items/grenadeAmmo.mdl")
		grenent:SetPos(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Pos)
		grenent:SetAngles(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Ang)
		grenent:SetOwner(self)
		grenent:SetParent(self)
		grenent:Fire("SetParentAttachment","grenade_attachment")
		grenent:Spawn()
		grenent:Activate()
		grenent:Input("SetTimer",self:GetOwner(),self:GetOwner(),1.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if (dmginfo:IsBulletDamage()) then
		local attacker = dmginfo:GetAttacker()
		if math.random(1,2) == 1 then
			if math.random(1,2) == 1 then dmginfo:ScaleDamage(0.50) else dmginfo:ScaleDamage(0.25) end
			self.DamageSpark1 = ents.Create("env_spark")
			self.DamageSpark1:SetKeyValue("Magnitude","1")
			self.DamageSpark1:SetKeyValue("Spark Trail Length","1")
			self.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
			self.DamageSpark1:SetAngles(self:GetAngles())
			//self.DamageSpark1:Fire("LightColor", "255 255 255")
			self.DamageSpark1:SetParent(self)
			self.DamageSpark1:Spawn()
			self.DamageSpark1:Activate()
			self.DamageSpark1:Fire("StartSpark", "", 0)
			self.DamageSpark1:Fire("StopSpark", "", 0.001)
			self:DeleteOnRemove(self.DamageSpark1)
			if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
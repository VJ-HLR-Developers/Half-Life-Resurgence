AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/snark.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 5
ENT.HullType = HULL_TINY
ENT.EntitiesToNoCollide = {"npc_vj_hlr1_snark"} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_SNARK"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
--ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {ACT_JUMP} -- Melee Attack Animations
ENT.LeapDistance = 200 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.4 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 0.4 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.4 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.2,0.6} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.LeapAttackVelocityForward = 100 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 180 -- How much upward force should it apply?
ENT.LeapAttackDamage = 10
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.PushProps = false -- Should it push props when trying to move?
ENT.IdleAlwaysWander = true -- If set to true, it will make the SNPC always wander when idling
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.AnimTbl_IdleStand = {ACT_RUN} -- The idle animation when AI is enabled
ENT.AnimTbl_Walk = {ACT_RUN} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Run = {ACT_RUN} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/squeek/sqk_hunt1.wav","vj_hlr/hl1_npc/squeek/sqk_hunt2.wav","vj_hlr/hl1_npc/squeek/sqk_hunt3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/squeek/sqk_deploy1.wav"}
ENT.SoundTbl_LeapAttackDamage = {"vj_hlr/hl1_npc/squeek/sqk_deploy1.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/squeek/sqk_die1.wav"}

ENT.IdleSoundChance = 1

ENT.NextSoundTime_Idle1 = 1
ENT.NextSoundTime_Idle2 = 1

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

ENT.DeathSoundPitch1 = 100
ENT.DeathSoundPitch2 = 100

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "Bip01 Head"
ENT.Controller_FirstPersonOffset = Vector(0,0,0.5)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

-- Custom
ENT.Snark_Explodes = true
ENT.Snark_NextJumpWalkTime1 = 0.35
ENT.Snark_NextJumpWalkTime2 = 0.8
ENT.Snark_NextJumpWalkT = 0
ENT.Snark_Type = 0
	-- 0 = Snark
	-- 1 = Penguin
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Snark_CustomOnInitialize()
	self:SetCollisionBounds(Vector(5, 5, 10), Vector(-5, -5, 0))
	self.Snark_Type = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:Snark_CustomOnInitialize()
	self.Snark_EnergyTime = CurTime() + 20
	self.NextIdleSoundT_RegularChange = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && self.VJ_IsBeingControlled == false then
		if self.Dead == false && self:IsOnGround() && self:Visible(self:GetEnemy()) && self:GetPos():Distance(self:GetEnemy():GetPos()) > self.LeapDistance + 10 && CurTime() > self.Snark_NextJumpWalkT then
			self:VJ_ACT_PLAYACTIVITY(ACT_RUN,false,0.7,true)
			self:SetGroundEntity(NULL)
			self:SetLocalVelocity((self:GetEnemy():GetPos() - self:GetPos()):GetNormal()*400 + self:GetUp()*300)
			self.Snark_NextJumpWalkT = CurTime() + math.Rand(self.Snark_NextJumpWalkTime1,self.Snark_NextJumpWalkTime2)
		end
	end
	if (self.Snark_EnergyTime - CurTime()) < 6 then
		self.UseTheSameGeneralSoundPitch_PickedNumber = self.UseTheSameGeneralSoundPitch_PickedNumber + 1
	else
		self.UseTheSameGeneralSoundPitch_PickedNumber = 100
	end
	
	if self.Dead == false && self.Snark_Explodes == true && CurTime() > self.Snark_EnergyTime then
		self:DeathSoundCode()
		self.Dead = true
		self:SetGroundEntity(NULL)
		self:SetLocalVelocity(self:GetUp()*300)
		timer.Simple(0.7,function()
			if IsValid(self) then
				self:CustomOnKilled(dmginfo,hitgroup)
				self:Remove()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterChecks(TheHitEntity)
	self.Snark_EnergyTime = self.Snark_EnergyTime + 0.5
	self.UseTheSameGeneralSoundPitch_PickedNumber = math.Clamp(self.UseTheSameGeneralSoundPitch_PickedNumber - 5, 100, 255)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_hlr/hl1_npc/squeek/sqk_blast1.wav",90)
	if self.Snark_Type == 0 then
		util.VJ_SphereDamage(self,self,self:GetPos(),50,15,DMG_ACID,true,true)
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
			bloodeffect:SetScale(40)
			util.Effect("VJ_Blood1",bloodeffect)
			
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodspray:SetScale(6)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(1)
			util.Effect("bloodspray",bloodspray)
			util.Effect("bloodspray",bloodspray)
			
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos() + self:OBBCenter())
			effectdata:SetScale(0.4)
			util.Effect("StriderBlood",effectdata)
			util.Effect("StriderBlood",effectdata)
		end
	elseif self.Snark_Type == 1 then
		VJ_EmitSound(self,{"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"},90)
		util.BlastDamage(self,self,self:GetPos(),80,35)
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(40)
			util.Effect("VJ_Blood1",bloodeffect)
			
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodspray:SetScale(6)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("bloodspray",bloodspray)
			util.Effect("bloodspray",bloodspray)
			
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
			spr:SetKeyValue("scale","4")
			spr:SetPos(self:GetPos() + self:GetUp()*80)
			spr:Spawn()
			spr:Fire("Kill","",0.9)
			timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
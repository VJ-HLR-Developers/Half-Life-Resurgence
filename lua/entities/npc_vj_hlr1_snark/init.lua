AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/snark.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 5
ENT.SightAngle = 180
ENT.HullType = HULL_TINY
ENT.EntitiesToNoCollide = {"npc_vj_hlr1_snark"} -- Set to a table of entity class names for the NPC to not collide with otherwise leave it to false
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(1, 0, 0.5), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_SNARK"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.HasMeleeAttack = false -- Can this NPC melee attack?
ENT.HasLeapAttack = true -- Can this NPC leap attack?
ENT.AnimTbl_LeapAttack = ACT_JUMP
ENT.LeapDistance = 200 -- The max distance that the NPC can leap from
ENT.LeapToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.4 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 0.4 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.4 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.2, 0.6} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.LeapAttackDamage = 10
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.HasDeathCorpse = false -- Should a corpse spawn when it's killed?
ENT.PushProps = false -- Should it push props when trying to move?
ENT.IdleAlwaysWander = true -- Should the NPC constantly wander while idling?
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/squeek/sqk_hunt1.wav", "vj_hlr/hl1_npc/squeek/sqk_hunt2.wav", "vj_hlr/hl1_npc/squeek/sqk_hunt3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/squeek/sqk_hunt1.wav", "vj_hlr/hl1_npc/squeek/sqk_hunt2.wav", "vj_hlr/hl1_npc/squeek/sqk_hunt3.wav"}
ENT.SoundTbl_MeleeAttack = "vj_hlr/hl1_npc/squeek/sqk_deploy1.wav"
ENT.SoundTbl_LeapAttackDamage = "vj_hlr/hl1_npc/squeek/sqk_deploy1.wav"
ENT.SoundTbl_Death = "vj_hlr/hl1_npc/squeek/sqk_die1.wav"

ENT.IdleSoundChance = 1

ENT.NextSoundTime_Idle = VJ.SET(1, 3)

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

local SNARK_TYPE_REGULAR = 0 -- Regular Snark
local SNARK_TYPE_PENGUIN = 1 -- Opposing Forces Penguin
	
-- Custom
ENT.Snark_Exploded = false
ENT.Snark_NextJumpWalkT = 0
ENT.Snark_Type = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Snark_CustomOnInitialize()
	self:SetCollisionBounds(Vector(5, 5, 10), Vector(-5, -5, 0))
	self.Snark_Type = SNARK_TYPE_REGULAR
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:Snark_CustomOnInitialize()
	self.Snark_EnergyTime = CurTime() + math.Rand(18, 22)
	self.NextIdleSoundT_RegularChange = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	function controlEnt:OnThink(key)
		self.VJCE_Player:ChatPrint(math.max(0, self.VJCE_NPC.Snark_EnergyTime - CurTime()) .. " seconds left! Eat to gain more!")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act != ACT_JUMP then -- Only let ACT_JUMP, otherwise make all animations ACT_RUN
		return ACT_RUN
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Dead then return end
	local ene = self:GetEnemy()
	
	-- Randomly jump while engaging an enemy
	if IsValid(ene) && self.VJ_IsBeingControlled == false && self:IsOnGround() && self.EnemyData.IsVisible && self.LatestEnemyDistance > (self.LeapDistance + 10) && CurTime() > self.Snark_NextJumpWalkT then
		self:PlayAnim(ACT_RUN, false, 0.7, true)
		self:PlaySoundSystem("Alert")
		self:SetGroundEntity(NULL)
		self:ForceMoveJump((ene:GetPos() - self:GetPos()):GetNormal() * 400 + self:GetUp() * 300)
		self.Snark_NextJumpWalkT = CurTime() + math.Rand(0.35, 1.8)
	end
	
	-- Change the sound pitch depending on its energy
	if (self.Snark_EnergyTime - CurTime()) < 6 then
		self.UseTheSameGeneralSoundPitch_PickedNumber = self.UseTheSameGeneralSoundPitch_PickedNumber + 1
	else
		self.UseTheSameGeneralSoundPitch_PickedNumber = 100
	end
	
	-- No more energy time, explode!
	if !self.Snark_Exploded && CurTime() > self.Snark_EnergyTime then
		self.Snark_Exploded = true
		self:SetState(VJ_STATE_FREEZE)
		self:PlaySoundSystem("Death")
		self.HasDeathSounds = false
		self:SetGroundEntity(NULL)
		self:SetLocalVelocity(self:GetUp() * 300)
		timer.Simple(0.7, function()
			if IsValid(self) then
				self:TakeDamage(self:Health(), self, self)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetLeapAttackVelocity()
	local ene = self:GetEnemy()
	return VJ.CalculateTrajectory(self, ene, "Curve", self:GetPos() + self:OBBCenter(), ene:GetPos() + ene:OBBCenter(), 10) + self:GetForward() * 150 + self:GetUp() * 20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnLeapAttack_AfterChecks(hitEnt)
	self.Snark_EnergyTime = self.Snark_EnergyTime + 0.5
	self.UseTheSameGeneralSoundPitch_PickedNumber = math.Clamp(self.UseTheSameGeneralSoundPitch_PickedNumber - 5, 100, 255)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Finish" then
		local myPos = self:GetPos()
		VJ.EmitSound(self, "vj_hlr/hl1_npc/squeek/sqk_blast1.wav", 90)
		
		if self.Snark_Type == SNARK_TYPE_REGULAR then
			VJ.ApplyRadiusDamage(self, self, myPos, 50, 15, DMG_ACID, true, true)
			if self.HasGibOnDeathEffects == true then
				local effectData = EffectData()
				effectData:SetOrigin(myPos + self:OBBCenter())
				effectData:SetColor(colorYellow)
				effectData:SetScale(40)
				util.Effect("VJ_Blood1", effectData)
				effectData:SetScale(8)
				effectData:SetFlags(3)
				effectData:SetColor(1)
				util.Effect("bloodspray", effectData)
				util.Effect("bloodspray", effectData)
			end
		elseif self.Snark_Type == SNARK_TYPE_PENGUIN then
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3, 5)..".wav", 90)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris"..math.random(1, 3)..".wav", 100)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3, 5).."_dist.wav", 140, 100)
			util.BlastDamage(self, self, myPos, 80, 35)
			if self.HasGibOnDeathEffects == true then
				local effectData = EffectData()
				effectData:SetOrigin(myPos + self:OBBCenter())
				effectData:SetColor(colorRed)
				effectData:SetScale(40)
				util.Effect("VJ_Blood1", effectData)
				effectData:SetScale(8)
				effectData:SetFlags(3)
				effectData:SetColor(0)
				util.Effect("bloodspray", effectData)
				util.Effect("bloodspray", effectData)
				
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
				spr:SetPos(myPos + self:GetUp() * 80)
				spr:Spawn()
				spr:Fire("Kill","",0.9)
				timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
			end
		end
	end
end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/garg.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 1000
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 25 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageType = DMG_CRUSH -- How close does it have to be until it attacks?
ENT.MeleeAttackDistance = 65 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 165 -- How far does the damage go?
ENT.MeleeAttackKnockBack_Forward1 = 500 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 500 -- How far it will push you forward | Second in math.random

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_garglaser" -- The entity that is spawned when range attacking
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 80 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.RangeAttackPos_Up = 10 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 50 -- Forward/Backward spawning position for range attack
ENT.RangeAttackPos_Right = -20 -- Right/Left spawning position for range attack

ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 2 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 2 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {ACT_BIG_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/garg/gar_step1.wav","vj_hlr/hl1_npc/garg/gar_step2.wav"}
ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/garg/gar_breathe1.wav","vj_hlr/hl1_npc/garg/gar_breathe2.wav","vj_hlr/hl1_npc/garg/gar_breathe3.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/garg/gar_idle1.wav","vj_hlr/hl1_npc/garg/gar_idle2.wav","vj_hlr/hl1_npc/garg/gar_idle3.wav","vj_hlr/hl1_npc/garg/gar_idle4.wav","vj_hlr/hl1_npc/garg/gar_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/garg/gar_alert1.wav","vj_hlr/hl1_npc/garg/gar_alert2.wav","vj_hlr/hl1_npc/garg/gar_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/garg/gar_attack1.wav","vj_hlr/hl1_npc/garg/gar_attack2.wav","vj_hlr/hl1_npc/garg/gar_attack3.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav","vj_hlr/hl1_npc/zombie/claw_strike2.wav","vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/garg/gar_pain1.wav","vj_hlr/hl1_npc/garg/gar_pain2.wav","vj_hlr/hl1_npc/garg/gar_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/garg/gar_die1.wav","vj_hlr/hl1_npc/garg/gar_die2.wav"}

ENT.GeneralSoundPitch1 = 100

ENT.ExtraMeleeSoundPitch1 = 80
ENT.ExtraMeleeSoundPitch2 = 80

/*
vj_hlr/hl1_npc/garg/gar_flameoff1.wav
vj_hlr/hl1_npc/garg/gar_flameon1.wav
vj_hlr/hl1_npc/garg/gar_flamerun1.wav
*/

-- Custom
ENT.Garg_AttackType = -1
ENT.Garg_AbleToFlame = false
ENT.Garg_NextAbleToFlameT = 0
ENT.Garg_NextStompAttackT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(70,70,210),Vector(-70,-70,0))
	
	self.Glow1 = ents.Create("env_sprite")
	self.Glow1:SetKeyValue("model","vj_hl/sprites/gargeye1.vmt")
	self.Glow1:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	self.Glow1:SetKeyValue("renderfx","14")
	self.Glow1:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	self.Glow1:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	self.Glow1:SetKeyValue("spawnflags","0")
	self.Glow1:SetParent(self)
	self.Glow1:Fire("SetParentAttachment","eyes")
	self.Glow1:Spawn()
	self.Glow1:Activate()
	self:DeleteOnRemove(self.Glow1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
		self:WorldShakeOnMoveCode()
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
	if key == "laser" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local r = math.random(1,3)
	if r == 1 then
		self.AnimTbl_MeleeAttack = {"vjseq_smash"}
		self.HasMeleeAttackKnockBack = false
	elseif r == 2 then
		self.AnimTbl_MeleeAttack = {"vjseq_attack"}
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackKnockBack_Up1 = 10
		self.MeleeAttackKnockBack_Up2 = 10
	elseif r == 3 then
		self.AnimTbl_MeleeAttack = {"vjseq_kickcar"}
		self.HasMeleeAttackKnockBack = true
		self.MeleeAttackKnockBack_Up1 = 300
		self.MeleeAttackKnockBack_Up2 = 300
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && self.NearestPointToEnemyDistance <= 200 && self.Garg_AbleToFlame == true && self.Garg_NextAbleToFlameT < CurTime() && self.Garg_AttackType == 0 && timer.Exists("timer_range_start"..self:EntIndex()) then
		//self:VJ_ACT_PLAYACTIVITY("vjseq_shootflames2",false,false,true)
		self.AnimTbl_IdleStand = {ACT_RANGE_ATTACK1}
		self:StopMoving()
		self.DisableChasingEnemy = true
		
		util.VJ_SphereDamage(self, self, self:GetPos() + self:OBBCenter() + self:GetForward()*50, 280, 3, DMG_BURN, true, true, {UseCone=true, UseConeDegree=50},function(ent) ent:Ignite(2) end)
		self.Garg_FlameSd = VJ_CreateSound(self, "vj_hlr/hl1_npc/garg/gar_flamerun1.wav" ) //soundlevel,soundpitch,stoplatestsound,sounddsp)
		local tr1 = util.TraceLine({start = self:GetAttachment(2).Pos, endpos = self:GetAttachment(2).Pos + self:GetForward()*280, filter = self})
		local tr2 = util.TraceLine({start = self:GetAttachment(3).Pos, endpos = self:GetAttachment(3).Pos + self:GetForward()*280, filter = self})
		util.Decal("VJ_HLR_Scorch", tr1.HitPos + tr1.HitNormal, tr1.HitPos - tr1.HitNormal)
		util.Decal("VJ_HLR_Scorch", tr2.HitPos + tr2.HitNormal, tr2.HitPos - tr2.HitNormal)
		
		self.Garg_NextAbleToFlameT = CurTime() + 0.2 //0.74
		timer.Adjust("timer_range_start"..self:EntIndex(), 1, 0, function()
			self:RangeAttackCode()
			self.Garg_AttackType = -1
			timer.Remove("timer_range_start"..self:EntIndex())
		end)
	elseif self.Garg_AbleToFlame == false or self.RangeAttacking == false then
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self.DisableChasingEnemy = false
		VJ_STOPSOUND(self.Garg_FlameSd)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	self.NextRangeAttackTime = 2
	self.NextRangeAttackTime_DoRand = 2
	if self.NearestPointToEnemyDistance <= 200 then
		self.Garg_AttackType = 0
		self.Garg_AbleToFlame = true
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
		self.TimeUntilRangeAttackProjectileRelease = 0.1
		self.RangeDistance = 200
		self.DisableRangeAttackAnimation = true
		self.DisableDefaultRangeAttackCode = true
		self.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/garg/gar_flameon1.wav"}
		self.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/garg/gar_flameoff1.wav"}
	elseif self.Garg_NextStompAttackT < CurTime() then
		self.Garg_AttackType = 1
		self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2}
		self.TimeUntilRangeAttackProjectileRelease = false
		self.DisableRangeAttackAnimation = false
		self.DisableDefaultRangeAttackCode = false
		self.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/garg/gar_stomp1.wav"}
	else
		self.Garg_AttackType = -1
		self.Garg_AbleToFlame = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	if self.Garg_AttackType == -1 then return false end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return self:CalculateProjectile("Line", self:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 200)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(TheProjectile)
	self.Garg_NextStompAttackT = CurTime() + math.Rand(10,13)
	if IsValid(self:GetEnemy()) then
		TheProjectile.EO_Enemy = self:GetEnemy()
		TheProjectile:SetAngles(Angle(self:GetAngles().p,0,0))
		timer.Simple(10,function() if IsValid(TheProjectile) then TheProjectile:Remove() end end)
	end
	
	util.Decal("VJ_HLR_Gargantua_Stomp", self:GetPos() + self:GetRight()*-20 + self:GetForward()*50, self:GetPos() + self:GetRight()*-20 + self:GetForward()*50 + self:GetUp()*-100, self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup)
	if dmginfo:IsBulletDamage() == true then
		dmginfo:ScaleDamage(0.4)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.Garg_FlameSd)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/pit_worm_up.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 2000
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.HullType = HULL_LARGE
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.VJC_Data = {
    ThirdP_Offset = Vector(15, 0, -50), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(7, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow_large"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.MeleeAttackDamage = 30
ENT.MeleeAttackDistance = 180 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 380 -- How far does the damage go?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1} -- Range Attack Animations
ENT.RangeDistance = 4000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 200 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH,ACT_BIG_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/pitworm/pit_worm_idle1.wav","vj_hlr/hl1_npc/pitworm/pit_worm_idle2.wav","vj_hlr/hl1_npc/pitworm/pit_worm_idle3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/pitworm/pit_worm_alert(scream).wav","vj_hlr/hl1_npc/pitworm/pit_worm_alert.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/pitworm/pit_worm_attack_swipe1.wav","vj_hlr/hl1_npc/pitworm/pit_worm_attack_swipe2.wav","vj_hlr/hl1_npc/pitworm/pit_worm_attack_swipe3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/pitworm/pit_worm_attack_eyeblast.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/pitworm/pit_worm_flinch1.wav","vj_hlr/hl1_npc/pitworm/pit_worm_flinch2.wav","vj_hlr/hl1_npc/pitworm/pit_worm_angry1.wav","vj_hlr/hl1_npc/pitworm/pit_worm_angry2.wav","vj_hlr/hl1_npc/pitworm/pit_worm_angry3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/pitworm/pit_worm_death.wav"}

ENT.AlertSoundLevel = 90
ENT.BeforeMeleeAttackSoundLevel = 80
ENT.BeforeRangeAttackSoundLevel = 80
ENT.PainSoundLevel = 80
ENT.DeathSoundLevel = 90

-- Custom
ENT.PitWorm_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(100, 100, 390), Vector(-100, -100, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "melee" then
		self:MeleeAttackCode()
	end
	if key == "beam" then
		self:RangeAttackCode()
	end
end
// ACT_SPECIAL_ATTACK1,ACT_SPECIAL_ATTACK2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Dead == false && CurTime() > self.PitWorm_BlinkingT then
		self:SetSkin(1)
		timer.Simple(0.1, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.2, function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.5, function() if IsValid(self) then self:SetSkin(0) end end)
		self.PitWorm_BlinkingT = CurTime() + math.Rand(2, 3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	self:VJ_ACT_PLAYACTIVITY(ACT_ARM, true, false, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	self.PitWorm_BlinkingT = CurTime() + 2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PitWorm_DoLaserEffects()
	local startPos = self:GetPos() + self:GetUp()*250 + self:GetForward()*230
	local tr = util.TraceLine({
		start = startPos,
		endpos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(),
		filter = self
	})
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(tr.HitPos)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	util.Effect("VJ_HLR_PitWorm_Beam", elec)
	return tr.HitPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	self:PitWorm_DoLaserEffects()
	
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model","vj_hl/sprites/flare3.vmt")
	spr:SetKeyValue("rendercolor","124 252 0")
	spr:SetKeyValue("GlowProxySize","5.0")
	spr:SetKeyValue("HDRColorScale","1.0")
	spr:SetKeyValue("renderfx","14")
	spr:SetKeyValue("rendermode","3")
	spr:SetKeyValue("renderamt","255")
	spr:SetKeyValue("disablereceiveshadows","0")
	spr:SetKeyValue("mindxlevel","0")
	spr:SetKeyValue("maxdxlevel","0")
	spr:SetKeyValue("framerate","10.0")
	spr:SetKeyValue("spawnflags","0")
	spr:SetKeyValue("scale","3")
	spr:SetPos(self:GetPos())
	spr:Spawn()
	spr:SetParent(self)
	spr:Fire("SetParentAttachment", "0")
	self:DeleteOnRemove(spr)
	timer.Simple(0.65, function() if IsValid(self) && IsValid(spr) then spr:Remove() end end)
	
	for i = 0.1, 0.5, 0.1 do
		timer.Simple(i,function()
			if IsValid(self) && IsValid(self:GetEnemy()) && self.RangeAttacking == true then
				local hitpos = self:PitWorm_DoLaserEffects()
				util.VJ_SphereDamage(self, self, hitpos, 30, 10, DMG_SHOCK, true, false, {Force=90})
				sound.Play("vj_hlr/hl1_npc/pitworm/pit_worm_attack_eyeblast_impact.wav", hitpos, 80)
			end
		end)
	end
end
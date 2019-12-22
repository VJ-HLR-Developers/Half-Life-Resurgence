AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/pit_worm_up.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 2000
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.HullType = HULL_LARGE
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
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
function ENT:CustomOnAcceptInput(key,activator,caller,data)
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
		timer.Simple(0.1,function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.2,function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.3,function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4,function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.5,function() if IsValid(self) then self:SetSkin(0) end end)
		self.PitWorm_BlinkingT = CurTime() + math.Rand(2,3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	self:VJ_ACT_PLAYACTIVITY(ACT_ARM,true,false,true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	self.PitWorm_BlinkingT = CurTime() + 2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local startpos = self:GetPos() + self:GetUp()*250 + self:GetForward()*230
	local tr = util.TraceLine({
		start = startpos,
		endpos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter(),
		filter = self
	})
	local hitpos = tr.HitPos
	
	local elec = EffectData()
	elec:SetStart(startpos)
	elec:SetOrigin(hitpos)
	elec:SetEntity(self)
	elec:SetAttachment(1)
	util.Effect("VJ_HLR_PitWorm_Beam",elec)
	
	local StartGlow1 = ents.Create("env_sprite")
	StartGlow1:SetKeyValue("model","vj_hl/sprites/flare3.vmt")
	StartGlow1:SetKeyValue("rendercolor","124 252 0")
	StartGlow1:SetKeyValue("GlowProxySize","5.0")
	StartGlow1:SetKeyValue("HDRColorScale","1.0")
	StartGlow1:SetKeyValue("renderfx","14")
	StartGlow1:SetKeyValue("rendermode","3")
	StartGlow1:SetKeyValue("renderamt","255")
	StartGlow1:SetKeyValue("disablereceiveshadows","0")
	StartGlow1:SetKeyValue("mindxlevel","0")
	StartGlow1:SetKeyValue("maxdxlevel","0")
	StartGlow1:SetKeyValue("framerate","10.0")
	StartGlow1:SetKeyValue("spawnflags","0")
	StartGlow1:SetKeyValue("scale","3")
	StartGlow1:SetPos(self:GetPos())
	StartGlow1:Spawn()
	StartGlow1:SetParent(self)
	StartGlow1:Fire("SetParentAttachment", "0")
	self:DeleteOnRemove(StartGlow1)
	timer.Simple(0.65,function() if IsValid(self) && IsValid(StartGlow1) then StartGlow1:Remove() end end)
	
	for i = 0.1, 0.5, 0.1 do
		timer.Simple(i,function()
			if IsValid(self) && IsValid(self:GetEnemy()) && self.RangeAttacking == true then
				local startpos = self:GetPos() + self:GetUp()*250 + self:GetForward()*230
				local tr = util.TraceLine({
					start = startpos,
					endpos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter(),
					filter = self
				})
				local hitpos = tr.HitPos
				
				local elec = EffectData()
				elec:SetStart(startpos)
				elec:SetOrigin(hitpos)
				elec:SetEntity(self)
				elec:SetAttachment(1)
				util.Effect("VJ_HLR_PitWorm_Beam",elec)
			
				util.VJ_SphereDamage(self,self,hitpos,30,10,DMG_SHOCK,true,false,{Force=90})
				sound.Play("vj_hlr/hl1_npc/pitworm/pit_worm_attack_eyeblast_impact.wav", hitpos, 80)
			end
		end)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
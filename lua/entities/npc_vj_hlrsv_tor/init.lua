AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/sven/tor.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 3000
ENT.SightAngle = 220
ENT.HullType = HULL_HUMAN
ENT.VJ_ID_Boss = true
ENT.VJC_Data = {
    ThirdP_Offset = Vector(15, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "TorSkel Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(15, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

-- ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1    = Swing / stab
-- ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK_SWING = Cutting (dozen times)
-- ACT_RANGE_ATTACK2						 = Sonic attack (This must be inputted twice so it has a fair chance to the other attacks!)
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1, ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK_SWING, ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1, ACT_RANGE_ATTACK2, ACT_RANGE_ATTACK2}
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 45 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 75 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_orb_electrical" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.RangeDistance = 2000 -- How far can it range attack?
ENT.RangeToMeleeDistance = 100 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.NoChaseAfterCertainRange = true -- Should the NPC stop chasing when the enemy is within the given far and close distances?
ENT.NoChaseAfterCertainRange_FarDistance = 1000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 250 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEFORWARD, ACT_DIESIMPLE}
ENT.DeathAnimationTime = false -- How long should the death animation play?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/aslave/vort_foot1.wav","vj_hlr/hl1_npc/aslave/vort_foot2.wav","vj_hlr/hl1_npc/aslave/vort_foot3.wav","vj_hlr/hl1_npc/aslave/vort_foot4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hlsc_npc/tor/tor-idle.wav","vj_hlr/hlsc_npc/tor/tor-idle2.wav","vj_hlr/hlsc_npc/tor/tor-idle3.wav","vj_hlr/hlsc_npc/tor/tor-test1.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hlsc_npc/tor/tor-alerted.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hlsc_npc/tor/tor-attack1.wav","vj_hlr/hlsc_npc/tor/tor-attack2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav","vj_hlr/hl1_npc/zombie/claw_strike2.wav","vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hlsc_npc/tor/tor-staff-discharge.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hlsc_npc/tor/tor-pain.wav","vj_hlr/hlsc_npc/tor/tor-pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hlsc_npc/tor/tor-die.wav","vj_hlr/hlsc_npc/tor/tor-die2.wav"}

ENT.IdleSoundLevel = 80
ENT.AlertSoundLevel = 85

-- Custom
ENT.Tor_NextSpawnT = 0
ENT.Tor_Level = 0 -- 0 = Normal (Green) | 1 = Buffed (Blue)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(25, 25, 90), Vector(-25, -25, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("SPACE: Spawn an Alien Grunt")
	
	function controlEnt:OnKeyPressed(key)
		if key == KEY_SPACE then
			self.VJCE_NPC:Tor_StartSpawnAlly()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ20 = Vector(0, 0, 20)
--
function ENT:Tor_SpawnAlly()
	-- Can have a total of 3, only 1 can be spawned at a time with a delay until another one is spawned
	local spawnPos = self:GetPos() + self:GetForward() * 100 + self:GetUp() * 5
	local effectTeleport = VJ.HLR1_Effect_Portal(spawnPos + vecZ20, nil, nil, function()
		-- onSpawn
		if IsValid(self) then
			local ally = ents.Create("npc_vj_hlr1_aliengrunt")
			ally:SetPos(spawnPos)
			ally:SetAngles(self:GetAngles())
			ally.VJ_NPC_Class = self.VJ_NPC_Class
			ally:Spawn()
			ally:Activate()
			if !IsValid(self.Tor_Ally1) then
				self.Tor_Ally1 = ally
			elseif !IsValid(self.Tor_Ally2) then
				self.Tor_Ally2 = ally
			elseif !IsValid(self.Tor_Ally3) then
				self.Tor_Ally3 = ally
			end
		end
	end)
	self:DeleteOnRemove(effectTeleport)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tor_StartSpawnAlly()
	if !self:BusyWithActivity() && CurTime() > self.Tor_NextSpawnT && (!IsValid(self.Tor_Ally1) or !IsValid(self.Tor_Ally2) or !IsValid(self.Tor_Ally3)) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*150,
			filter = self
		})
		if !tr.Hit then
			self:PlayAnim(ACT_SIGNAL_GROUP, true, false)
			VJ.EmitSound(self, "vj_hlr/hlsc_npc/tor/tor-summon.wav")
			self.Tor_NextSpawnT = CurTime() + 10
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "summon" then
		self:Tor_SpawnAlly()
	elseif key == "melee_single" then
		self.HasMeleeAttackMissSounds = true
		self.DisableDefaultMeleeAttackCode = false
		self.MeleeAttackDamage = (self.Tor_Level == 0 and 20) or 40
		self:MeleeAttackCode()
	elseif key == "melee" then
		self.HasMeleeAttackMissSounds = false
		self.DisableDefaultMeleeAttackCode = false
		self.MeleeAttackDamage = (self.Tor_Level == 0 and 3) or 5
		self:MeleeAttackCode()
	elseif key == "slam" then
		local startPos = self:GetPos() + self:GetForward()*20
		self.HasMeleeAttackMissSounds = false
		self.DisableDefaultMeleeAttackCode = true
		VJ.EmitSound(self, "vj_hlr/hlsc_npc/tor/tor-staff-discharge.wav", 90)
		effects.BeamRingPoint(startPos, 0.3, 2, 600, 36, 0, (self.Tor_Level == 0 and Color(0, 255, 0)) or Color(0, 0, 255), {framerate=20, flags=0})
		util.ScreenShake(startPos, 10, 10, 1, 1000)
		util.Decal("VJ_HLR_Gargantua_Stomp", startPos, startPos + self:GetUp()*-100, self)
		VJ.ApplyRadiusDamage(self, self, startPos, 500, (self.Tor_Level == 0 and 40) or 60, DMG_SONIC, true, true, {DisableVisibilityCheck=true, Force=20})
		//self:MeleeAttackCode()
	elseif key == "range" then
		self:RangeAttackCode()
	elseif key == "body" then
		VJ.EmitSound(self, "vj_hlr/fx/bodydrop"..math.random(3, 4)..".wav", 75, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Dead or self.VJ_IsBeingControlled then return end
	
	-- Spawn an ally
	if IsValid(self:GetEnemy()) then
		self:Tor_StartSpawnAlly()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	self:PlayAnim(ACT_DEPLOY, true, false, true) -- Angry animation
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
	if IsValid(self:GetEnemy()) then
		projectile.Track_Enemy = self:GetEnemy()
		projectile.Track_SpriteScale = (self.Tor_Level == 0 and 0.6) or 1
		projectile.DirectDamage = (self.Tor_Level == 0 and 10) or 20
		timer.Simple(10,function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetAttachment(self:LookupAttachment("0")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Line", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 700), 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PostDamage" && self.Tor_Level == 0 && (self:Health() < (self:GetMaxHealth() * 0.5)) then
		self.Tor_Level = 1
		self:PlayAnim(ACT_VICTORY_DANCE, true, false)
		timer.Simple(1.2, function()
			if IsValid(self) && self.Dead != true then
				self:SetSkin(1)
				VJ.EmitSound(self, "vj_hlr/hlsc_npc/tor/tor-summon.wav", 80)
				effects.BeamRingPoint(self:GetPos() + self:GetForward()*20, 0.3, 2, 600, 60, 0, Color(0,0,255), {framerate=20, flags=0})
				util.ScreenShake(self:GetPos(), 10, 10, 1, 1000)
				VJ.ApplyRadiusDamage(self, self, self:GetPos(), 500, 20, DMG_SONIC, true, true, {DisableVisibilityCheck=true, Force=80})
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
--
function ENT:HandleGibOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorYellow)
		effectData:SetScale(120)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(1)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib1.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 0, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib2.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib3.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 30))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib4.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 35))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib5.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 50))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib6.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 55))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib7.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(1, 1, 40))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib8.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 45))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib9.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 25))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/agib10.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 1, 15))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/islavegib.mdl", {BloodType="Yellow", BloodDecal="VJ_HLR_Blood_Yellow", Pos=self:LocalToWorld(Vector(0, 0, 41))})
	self:PlaySoundSystem("Gib", "vj_base/gib/splat.wav")
	return true, {AllowSound = false}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" && hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = ACT_DIEBACKWARD
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gibs = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl", "models/vj_hlr/gibs/islavegib.mdl"}
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:SetBodygroup(1, 1)
	local att = self:GetAttachment(self:LookupAttachment("0")) //self:GetBonePosition(self:LookupBone("Dummy01"))
	self:CreateExtraDeathCorpse("prop_physics", "models/vj_hlr/sven/tor_staff.mdl", {Pos=att.Pos, Ang=att.Ang}, function(x)
		x:SetSkin(self:GetSkin())
	end)
	VJ.HLR_ApplyCorpseSystem(self, corpseEnt, nil, {ExtraGibs = gibs})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	-- If the NPC was removed, then remove its children as well, but not when it's killed!
	if !self.Dead then
		if IsValid(self.Tor_Ally1) then self.Tor_Ally1:Remove() end
		if IsValid(self.Tor_Ally2) then self.Tor_Ally2:Remove() end
		if IsValid(self.Tor_Ally3) then self.Tor_Ally3:Remove() end
	end
end
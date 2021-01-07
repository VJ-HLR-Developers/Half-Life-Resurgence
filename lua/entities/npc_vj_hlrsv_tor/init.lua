AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/sven/tor.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 3000
ENT.HullType = HULL_HUMAN
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.VJC_Data = {
    ThirdP_Offset = Vector(15, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "TorSkel Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(15, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

-- ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1    = Swing / stab
-- ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK_SWING = Cutting (dozen times)
-- ACT_RANGE_ATTACK2						 = Sonic attack (This must be inputted twice so it has a fair chance to the other attacks!)
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1, ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK_SWING, ACT_MELEE_ATTACK2, ACT_SPECIAL_ATTACK1} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_orb_electrical" -- The entity that is spawned when range attacking
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 100 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.RangeUseAttachmentForPos = true -- Should the projectile spawn on a attachment?
ENT.RangeUseAttachmentForPosID = "0" -- The attachment used on the range attack if RangeUseAttachmentForPos is set to true

ENT.NoChaseAfterCertainRange = true -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 1000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack

ENT.DeathCorpseBodyGroup = VJ_Set(1, 1) -- #1 = the category of the first bodygroup | #2 = the value of the second bodygroup | Set -1 for #1 to let the base decide the corpse's bodygroup
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEFORWARD, ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH} -- If it uses normal based animation, use this
ENT.HasHitGroupFlinching = true -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/aslave/vort_foot1.wav","vj_hlr/hl1_npc/aslave/vort_foot2.wav","vj_hlr/hl1_npc/aslave/vort_foot3.wav","vj_hlr/hl1_npc/aslave/vort_foot4.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hlsc_npc/tor/tor-idle.wav","vj_hlr/hlsc_npc/tor/tor-idle2.wav","vj_hlr/hlsc_npc/tor/tor-idle3.wav","vj_hlr/hlsc_npc/tor/tor-test1.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hlsc_npc/tor/tor-alerted.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hlsc_npc/tor/tor-attack1.wav","vj_hlr/hlsc_npc/tor/tor-attack2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_hlr/hl1_npc/zombie/claw_strike1.wav","vj_hlr/hl1_npc/zombie/claw_strike2.wav","vj_hlr/hl1_npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_MeleeAttackSlowPlayer = {"vj_player/heartbeat.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hlsc_npc/tor/tor-staff-discharge.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hlsc_npc/tor/tor-pain.wav","vj_hlr/hlsc_npc/tor/tor-pain2.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hlsc_npc/tor/tor-die.wav","vj_hlr/hlsc_npc/tor/tor-die2.wav"}

ENT.IdleSoundLevel = 80
ENT.AlertSoundLevel = 85

-- Custom
ENT.Tor_NextSpawnT = 0
ENT.Tor_Level = 0 -- 0 = Normal (Green) | 1 = Buffed (Blue)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(25, 25, 90), Vector(-25, -25, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "summon" then
		self:Tor_SpawnAlly()
	end
	if key == "attack_melee_single" or key == "attack_melee_stab" then
		self.HasMeleeAttackMissSounds = true
		self.DisableDefaultMeleeAttackCode = false
		self.MeleeAttackDamage = (self.Tor_Level == 0 and 20) or 40
		self:MeleeAttackCode()
	end
	if key == "attack_melee" then
		self.HasMeleeAttackMissSounds = false
		self.DisableDefaultMeleeAttackCode = false
		self.MeleeAttackDamage = (self.Tor_Level == 0 and 3) or 5
		self:MeleeAttackCode()
	end
	if key == "attack_slam" then
		self.HasMeleeAttackMissSounds = false
		self.DisableDefaultMeleeAttackCode = true
		VJ_EmitSound(self, {"vj_hlr/hlsc_npc/tor/tor-staff-discharge.wav"}, 90)
		effects.BeamRingPoint(self:GetPos() + self:GetForward()*20, 0.3, 2, 600, 36, 0, (self.Tor_Level == 0 and Color(0, 255, 0)) or Color(0, 0, 255), {framerate=20, flags=0})
		util.ScreenShake(self:GetPos() + self:GetForward()*20, 10, 10, 1, 1000)
		util.Decal("VJ_HLR_Gargantua_Stomp", self:GetPos() + self:GetForward()*20, self:GetPos() + self:GetForward()*20 + self:GetUp()*-100, self)
		util.VJ_SphereDamage(self, self, self:GetPos() + self:GetForward()*20, 500, (self.Tor_Level == 0 and 40) or 60, DMG_SONIC, true, true, {DisableVisibilityCheck=true, Force=20})
		//self:MeleeAttackCode()
	end
	if key == "attack_range" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	if IsValid(self:GetEnemy()) && self:BusyWithActivity() != true && CurTime() > self.Tor_NextSpawnT && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP))) && (!IsValid(self.Tor_Ally1) or !IsValid(self.Tor_Ally2) or !IsValid(self.Tor_Ally3)) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local tr = util.TraceLine({
			start = self:GetPos() + self:OBBCenter(),
			endpos = self:GetPos() + self:OBBCenter() + self:GetForward()*150,
			filter = self
		})
		if !tr.Hit then
			self:VJ_ACT_PLAYACTIVITY(ACT_SIGNAL_GROUP, true, false)
			VJ_EmitSound(self, "vj_hlr/hlsc_npc/tor/tor-summon.wav")
			self.Tor_NextSpawnT = CurTime() + 10
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	self:VJ_ACT_PLAYACTIVITY(ACT_DEPLOY, true, false, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
	if IsValid(self:GetEnemy()) then
		projectile.EO_Enemy = self:GetEnemy()
		projectile.EO_SpriteScale = (self.Tor_Level == 0 and 0.6) or 1
		projectile.DirectDamage = (self.Tor_Level == 0 and 10) or 20
		timer.Simple(10,function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	return self:CalculateProjectile("Line", self:GetAttachment(self:LookupAttachment("0")).Pos, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tor_CreateAlly()
	local spawnpos = self:GetPos() + self:GetForward() * 100 + self:GetUp() * 5
	local ally = ents.Create("npc_vj_hlr1_aliengrunt")
	ally:SetPos(spawnpos)
	ally:SetAngles(self:GetAngles())
	ally:Spawn()
	ally:Activate()
	
	local effectTeleport = VJ_HLR_Effect_PortalSpawn(spawnpos + Vector(0,0,20))
	effectTeleport:Fire("Kill","",1)
	self:DeleteOnRemove(effectTeleport)
	return ally
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tor_SpawnAlly()
	-- Can have a total of 4, only 1 can be spawned at a time with a delay until another one is spawned
	if !IsValid(self.Tor_Ally1) then
		self.Tor_Ally1 = self:Tor_CreateAlly()
		return
	elseif !IsValid(self.Tor_Ally2) then
		self.Tor_Ally2 = self:Tor_CreateAlly()
		return
	elseif !IsValid(self.Tor_Ally3) then
		self.Tor_Ally3 = self:Tor_CreateAlly()
		return
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self.Tor_Level == 0 && (self:Health() < (self:GetMaxHealth() * 0.5)) then
		self.Tor_Level = 1
		self:VJ_ACT_PLAYACTIVITY(ACT_VICTORY_DANCE, true, false)
		timer.Simple(1.2, function()
			if IsValid(self) && self.Dead != true then
				self:SetSkin(1)
				VJ_EmitSound(self, "vj_hlr/hlsc_npc/tor/tor-summon.wav", 80)
				effects.BeamRingPoint(self:GetPos() + self:GetForward()*20, 0.3, 2, 600, 60, 0, Color(0,0,255), {framerate=20, flags=0})
				util.ScreenShake(self:GetPos(), 10, 10, 1, 1000)
				util.VJ_SphereDamage(self, self, self:GetPos(), 500, 20, DMG_SONIC, true, true, {DisableVisibilityCheck=true, Force=80})
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	local at = self:GetAttachment(self:LookupAttachment("0")) //self:GetBonePosition(self:LookupBone("Dummy01"))
	self:CreateExtraDeathCorpse("prop_physics", "models/vj_hlr/sven/tor_staff.mdl", {Pos=at.Pos, Ang=at.Ang}, function(x)
		x:SetSkin(self:GetSkin())
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
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
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, math.random(100,100))
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	if hitgroup == HITGROUP_HEAD then
		self.AnimTbl_Death = {ACT_DIEBACKWARD}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	-- If the NPC was removed, then remove its children as well, but not when it's killed!
	if self.Dead == false then
		if IsValid(self.Tor_Ally1) then self.Tor_Ally1:Remove() end
		if IsValid(self.Tor_Ally2) then self.Tor_Ally2:Remove() end
		if IsValid(self.Tor_Ally3) then self.Tor_Ally3:Remove() end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
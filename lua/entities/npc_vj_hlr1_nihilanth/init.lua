AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/nihilanth.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 3000
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.SightDistance = 15000 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow_large"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeDistance = 15000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.RangeAttackPos_Up = -140 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 430 -- Forward/Backward spawning position for range attack
ENT.RangeAttackPos_Right = 0 -- Right/Left spawning position for range attack

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = 16 -- Time until the SNPC spawns its corpse and gets removed
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.IdleSounds_PlayOnAttacks = true -- It will be able to continue and play idle sounds when it performs an attack
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/x/x_laugh1.wav","vj_hlr/hl1_npc/x/x_laugh2.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/nihilanth/nil_man_notman.wav","vj_hlr/hl1_npc/nihilanth/nil_win.wav","vj_hlr/hl1_npc/nihilanth/nil_slaves.wav","vj_hlr/hl1_npc/nihilanth/nil_thelast.wav","vj_hlr/hl1_npc/nihilanth/nil_thetruth.wav","vj_hlr/hl1_npc/nihilanth/nil_thieves.wav","vj_hlr/hl1_npc/nihilanth/nil_last.wav","vj_hlr/hl1_npc/nihilanth/nil_die.wav","vj_hlr/hl1_npc/nihilanth/nil_alone.wav","vj_hlr/hl1_npc/nihilanth/nil_deceive.wav","vj_hlr/hl1_npc/nihilanth/nil_now_die.wav","vj_hlr/hl1_npc/x/x_laugh1.wav","vj_hlr/hl1_npc/x/x_laugh2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/nihilanth/nil_comes.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/x/x_attack1.wav","vj_hlr/hl1_npc/x/x_attack2.wav","vj_hlr/hl1_npc/x/x_attack3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/x/x_shoot1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/x/x_pain1.wav","vj_hlr/hl1_npc/x/x_pain2.wav","vj_hlr/hl1_npc/x/x_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/x/x_die1.wav"}

ENT.NextSoundTime_Idle1 = 14
ENT.NextSoundTime_Idle2 = 20

ENT.GeneralSoundPitch1 = 100

ENT.IdleSoundLevel = 120
ENT.CombatIdleSoundLevel = 120
ENT.AlertSoundLevel = 120
ENT.BeforeRangeAttackSoundLevel = 120
ENT.RangeAttackSoundLevel = 120
ENT.PainSoundLevel = 120
ENT.DeathSoundLevel = 120

-- Custom
ENT.Nih_TeleportingOrb = false
ENT.Nih_NextSpawn = 0 -- Max 4
ENT.Nih_NumAllies = 0
ENT.Nih_CrystalsDestroyed = false
ENT.Nih_BrainOpen = false
ENT.Nih_DidBrainOpenAnim = false

/*
vj_hl/sprites/flare6.vmt    right before nihilanth disappears on death he releases these bubbles
vj_hl/sprites/nhth1.vmt     purple electric projectiles
vj_hl/sprites/muzzleflash3.vmt       orb ring around his head that displays his health sorta
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(250, 250, 430), Vector(-250, -250, -530))
	
	self:SetPos(self:GetPos() + self:GetUp() * 1000)
	
	for i = 1, 3 do
		local tr_offset;
		if i == 1 then
			tr_pos = self:GetForward() * 3000 + self:GetRight() * 3000
			tr_offset = self:GetForward() * -50 + self:GetRight() * -50
		elseif i == 2 then
			tr_pos = self:GetForward() * -3000 + self:GetRight() * -3000
			tr_offset = self:GetForward() * 50 + self:GetRight() * 50
		elseif i == 3 then
			tr_pos = self:GetForward() * -3000 + self:GetRight() * 3000
			tr_offset = self:GetForward() * 50 + self:GetRight() * -50
		end
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + tr_pos,
			filter = self,
		})
		local tr_d = util.TraceLine({
			start = (tr.HitPos + tr_offset),
			endpos = (tr.HitPos + tr_offset) + Vector(0,0,-4000),
			filter = self,
		})
		
		local crystal = ents.Create("sent_vj_xen_crystal")
		crystal:SetPos(tr_d.HitPos + self:GetUp() * -10)
		crystal:SetAngles(tr_d.HitPos:Angle())
		crystal.Assignee = self
		crystal:Spawn()
		crystal:Activate()
		
		if i == 1 then
			self.Nih_Crystal1 = crystal
		elseif i == 2 then
			self.Nih_Crystal2 = crystal
		elseif i == 3 then
			self.Nih_Crystal3 = crystal
		end
	end
	
	self.Nih_Charges = {}
	
	local function MakeChargeOrb(pos)
		local charge = ents.Create("sent_vj_hlr1_orb_crystal_charge")
		charge:SetAngles(self:GetAngles())
		charge:SetPos(pos)
		charge.Assignee = self
		charge:Spawn()
		charge:Activate()
		charge:SetParent(self)
		self:DeleteOnRemove(charge)
		self.Nih_Charges[#self.Nih_Charges+1] = charge
	end
	
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(400,330))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-220,-450))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(20,-450))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(220,-450))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(420,-350))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(480,-150))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(480,150))
	--------------------- ROTATE ---------------------
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(220,450))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-20,450))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-220,450))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-420,350))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-480,150))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-480,-150))
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-400,-330))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	print(key)
	if key == "orb-o-death" then
		self.Nih_TeleportingOrb = false
		self.RangeUseAttachmentForPos = false
		self:RangeAttackCode()
		if self.Nih_BrainOpen == false then
			self.RangeUseAttachmentForPos = true
			for i = 0.1, 0.6, 0.1 do
				timer.Simple(i,function() if IsValid(self) then self.RangeUseAttachmentForPosID = "2" self:RangeAttackCode() end end)
			end
			for i = 0.1, 0.6, 0.1 do
				timer.Simple(i,function() if IsValid(self) then self.RangeUseAttachmentForPosID = "3" self:RangeAttackCode() end end)
			end
		end
	end
	if key == "wtf" then
		self.Nih_TeleportingOrb = true
		self.RangeUseAttachmentForPos = false
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if argent:IsPlayer() then
		self.SoundTbl_Alert = {"vj_hlr/hl1_npc/nihilanth/nil_freeman.wav"}
	else
		self.SoundTbl_Alert = {"vj_hlr/hl1_npc/nihilanth/nil_comes.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local num = #self.Nih_Charges
	if num > 0 then
		for k, v in ipairs(self.Nih_Charges) do
			local test = v:GetAngles()
			test:Add(Angle(5,5,5))
			test:Normalize()
			v:SetAngles(test)
		end
	else
		self.Nih_BrainOpen = true
		if self.Nih_DidBrainOpenAnim == false then
			self:VJ_ACT_PLAYACTIVITY("vjseq_transition_to_hurt", true, false)
			self.Nih_DidBrainOpenAnim = true
		end
	end
	
	if self.Nih_BrainOpen == true then
		self.AnimTbl_IdleStand = {ACT_IDLE_HURT}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	if IsValid(self:GetEnemy()) && CurTime() > self.Nih_NextSpawn && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP))) then
		self.Nih_NextSpawn = CurTime() + self:Nih_SpawnAlly()
	end
	
	if self.Nih_CrystalsDestroyed == false && !IsValid(self.Nih_Crystal1) && !IsValid(self.Nih_Crystal2) && !IsValid(self.Nih_Crystal3) then
		print("CRYSTALS BROKE!")
		self.Nih_CrystalsDestroyed = true
		VJ_EmitSound(self, "vj_hlr/hl1_npc/nihilanth/nil_done.wav", 120)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	if math.random(1,3) == 1 then
		if self.Nih_BrainOpen == true then
			self.AnimTbl_RangeAttack = {"attack2_open"}
		else
			self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2}
		end
		self.RangeAttackEntityToSpawn = "obj_vj_hlr1_orb_teleport"
	else
		if self.Nih_BrainOpen == true then
			self.AnimTbl_RangeAttack = {"attack1_open"}
		else
			self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
		end
		self.RangeAttackEntityToSpawn = "obj_vj_hlr1_orb_electrical"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(TheProjectile)
	if self.Nih_TeleportingOrb == true && IsValid(self:GetEnemy()) then
		TheProjectile.EO_Enemy = self:GetEnemy()
		timer.Simple(10,function() if IsValid(TheProjectile) then TheProjectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return self:CalculateProjectile("Line", TheProjectile:GetPos(), self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Nih_CreateAlly()
	-- Trace to a random point around the Nihilanth then trace down
	local tr_randp = math.random(1,4)
	local tr_offset;
	if tr_randp == 1 then
		tr_pos = self:GetForward() * 2000
		tr_offset = self:GetForward() * -50
	elseif tr_randp == 2 then
		tr_pos = self:GetForward() * -2000
		tr_offset = self:GetForward() * 50
	elseif tr_randp == 3 then
		tr_pos = self:GetRight() * 2000
		tr_offset = self:GetRight() * -50
	elseif tr_randp == 4 then
		tr_pos = self:GetRight() * -2000
		tr_offset = self:GetRight() * 50
	end
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() + tr_pos,
		filter = self,
	})
	local tr_d = util.TraceLine({
		start = (tr.HitPos + tr_offset),
		endpos = (tr.HitPos + tr_offset) + Vector(0,0,-4000),
		filter = self,
	})
	
	local spawnpos = tr_d.HitPos + Vector(0,0,10) -- 10 WU ere vor kednin mech chi dzaki
	local ally = ents.Create(VJ_PICK({"npc_vj_hlr1_aliengrunt", "npc_vj_hlr1_alienslave", "npc_vj_hlr1_aliencontroller"}))
	if ally:GetClass() == "npc_vj_hlr1_aliencontroller" then spawnpos = tr_d.HitPos + Vector(0,0,300) end -- Yete controller e, ere vor kichme partser dzaki
	ally:SetPos(spawnpos)
	ally:SetAngles(self:GetAngles())
	ally:Spawn()
	ally:Activate()
	
	local StartGlow1 = ents.Create("env_sprite")
	StartGlow1:SetKeyValue("model","vj_hl/sprites/exit1.vmt")
	StartGlow1:SetKeyValue("GlowProxySize","2.0")
	StartGlow1:SetKeyValue("HDRColorScale","1.0")
	StartGlow1:SetKeyValue("renderfx","14")
	StartGlow1:SetKeyValue("rendermode","3")
	StartGlow1:SetKeyValue("renderamt","255")
	StartGlow1:SetKeyValue("disablereceiveshadows","0")
	StartGlow1:SetKeyValue("mindxlevel","0")
	StartGlow1:SetKeyValue("maxdxlevel","0")
	StartGlow1:SetKeyValue("framerate","10.0")
	StartGlow1:SetKeyValue("spawnflags","0")
	StartGlow1:SetKeyValue("scale","1")
	StartGlow1:SetPos(spawnpos + Vector(0,0,20))
	StartGlow1:Spawn()
	StartGlow1:Fire("Kill","",1)
	self:DeleteOnRemove(StartGlow1)
	
	VJ_EmitSound(ally, "vj_hlr/fx/beamstart" .. math.random(1,2) .. ".wav", 85, 100)
	
	return ally
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Nih_SpawnAlly()
	-- Can have a total of 4, only 1 can be spawned at a time with a delay until another one is spawned
	if !IsValid(self.Nih_Ally1) then
		self.Nih_Ally1 = self:Nih_CreateAlly()
		return 15
	elseif !IsValid(self.Nih_Ally2) then
		self.Nih_Ally2 = self:Nih_CreateAlly()
		return 15
	elseif !IsValid(self.Nih_Ally3) then
		self.Nih_Ally3 = self:Nih_CreateAlly()
		return 15
	elseif !IsValid(self.Nih_Ally4) then
		self.Nih_Ally4 = self:Nih_CreateAlly()
		return 15
	end
	return 8
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	/*if self.Nih_CrystalsDestroyed == false then dmginfo:SetDamage(0) return end
	
	if self.Nih_BrainOpen == false then
		local num = #self.Nih_Charges
		if num > 0 then
			local charge = self.Nih_Charges[num]
			charge:Remove()
			table.remove(self.Nih_Charges, num)
			num = num - 1
			dmginfo:SetDamage(0)
			return
		end
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo,hitgroup)
	ParticleEffectAttach("vj_hlr_nihilanth_deathorbs", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("0")) -- Ganach louys ere
	timer.Simple(14, function() -- Jermag louys ere
		if IsValid(self) then
			ParticleEffect("vj_hlr_nihilanth_deathorbs_white", self:GetAttachment(self:LookupAttachment("0")).Pos, self:GetAngles())
			VJ_EmitSound(self, "vj_hlr/hl1_npc/x/nih_die2.wav", 120)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if IsValid(self.Nih_Crystal1) then self.Nih_Crystal1:Remove() end
	if IsValid(self.Nih_Crystal2) then self.Nih_Crystal2:Remove() end
	if IsValid(self.Nih_Crystal3) then self.Nih_Crystal3:Remove() end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
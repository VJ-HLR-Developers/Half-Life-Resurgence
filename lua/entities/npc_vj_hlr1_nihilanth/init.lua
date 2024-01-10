AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/nihilanth.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 3000
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.SightDistance = 20000 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(80, 0, 0), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_yellow_large"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeDistance = 20000 -- This is how far away it can shoot
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
ENT.HasSoundTrack = true
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_SoundTrack = {"vj_hlr/hl1_npc/nihilanth/Prospero03.mp3"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/x/x_laugh1.wav","vj_hlr/hl1_npc/x/x_laugh2.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/nihilanth/nil_man_notman.wav","vj_hlr/hl1_npc/nihilanth/nil_win.wav","vj_hlr/hl1_npc/nihilanth/nil_slaves.wav","vj_hlr/hl1_npc/nihilanth/nil_thelast.wav","vj_hlr/hl1_npc/nihilanth/nil_thetruth.wav","vj_hlr/hl1_npc/nihilanth/nil_thieves.wav","vj_hlr/hl1_npc/nihilanth/nil_last.wav","vj_hlr/hl1_npc/nihilanth/nil_die.wav","vj_hlr/hl1_npc/nihilanth/nil_alone.wav","vj_hlr/hl1_npc/nihilanth/nil_deceive.wav","vj_hlr/hl1_npc/nihilanth/nil_now_die.wav","vj_hlr/hl1_npc/x/x_laugh1.wav","vj_hlr/hl1_npc/x/x_laugh2.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/nihilanth/nil_comes.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/x/x_attack1.wav","vj_hlr/hl1_npc/x/x_attack2.wav","vj_hlr/hl1_npc/x/x_attack3.wav"}
ENT.SoundTbl_RangeAttack = {"vj_hlr/hl1_npc/x/x_shoot1.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/x/x_pain1.wav","vj_hlr/hl1_npc/x/x_pain2.wav","vj_hlr/hl1_npc/x/x_pain3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/x/x_die1.wav"}

ENT.NextSoundTime_Idle = VJ.SET(14, 20)

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
ENT.Nih_CrystalsDestroyed = false
ENT.Nih_BrainOpen = false
ENT.Nih_DidBrainOpenAnim = false
ENT.Nih_LerpAngleDeath = nil
ENT.Nih_OriginalGravity = 600

/*
vj_hl/sprites/flare6.vmt    	right before nihilanth disappears on death he releases these bubbles
vj_hl/sprites/nhth1.vmt     	purple electric projectiles
vj_hl/sprites/muzzleflash3.vmt	orb ring around his head that displays his health sorta
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	-- Allow only 1 Nihilanth at a time
	local entsAll = ents.GetAll()
	for x = 1, #entsAll do
		if entsAll[x]:GetClass() == "npc_vj_hlr1_nihilanth" && entsAll[x] != self then
			if IsValid(self:GetCreator()) then
				self:GetCreator():PrintMessage(HUD_PRINTTALK, "WARNING: Only one Nihilanth is allowed in the map!")
			end
			self:Remove()
		end
	end
	
	self.Nih_OriginalGravity = GetConVar("sv_gravity"):GetFloat()
	RunConsoleCommand("sv_gravity", 200)
	
	self:SetCollisionBounds(Vector(250, 250, 430), Vector(-250, -250, -530))
	self:SetPos(self:GetPos() + self:GetUp() * 1000)
	self.Nih_Charges = {}
	
	-- Crystals
	for i = 1, 3 do
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + self:GetForward() * math.Rand(-10000, 10000) + self:GetRight() * math.Rand(-10000, 10000) + self:GetUp() * -3000,
			filter = self,
		})
		-- HitNormal = Number between 0 to 1, use this to get the position the trace came from. Ex: Add it to the hit position to make it go farther away.
		local crystal = ents.Create("sent_vj_xen_crystal")
		crystal:SetPos(tr.HitPos - tr.HitNormal*10) -- Take the HitNormal and minus it by 10 units to make it go inside the position a bit
		crystal:SetAngles(tr.HitNormal:Angle() + Angle(math.Rand(60, 120), math.Rand(-15, 15), math.Rand(-15, 15))) -- 90 = middle and 30 degree difference to make the pitch rotate randomly | yaw and roll are applied a bit of a random number
		crystal.Assignee = self
		crystal:Spawn()
		crystal:Activate()
		table.insert(self.VJ_AddCertainEntityAsFriendly, crystal) -- In case relation class is changed dynamically!
		
		if i == 1 then
			self.Nih_Crystal1 = crystal
		elseif i == 2 then
			self.Nih_Crystal2 = crystal
		elseif i == 3 then
			self.Nih_Crystal3 = crystal
		end
	end
	
	-- Charges
	/*self.Nih_Charges = {}
	local function MakeChargeOrb(pos)
		local charge = ents.Create("sent_vj_hlr1_orb_crystal_charge")
		charge:SetAngles(self:GetAngles())
		charge:SetPos(pos)
		charge.Assignee = self
		charge:Spawn()
		charge:Activate()
		//charge:SetParent(self)
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
	MakeChargeOrb(self:GetPos() + self:GetUp() * 220 + Vector(-400,-330))*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "elec_orbs" then
		self.Nih_TeleportingOrb = false
		self.RangeUseAttachmentForPos = false
		self:RangeAttackCode()
		self.RangeUseAttachmentForPos = true
		for i = 0.1, 0.6, 0.1 do
			timer.Simple(i, function() if IsValid(self) then self.RangeUseAttachmentForPosID = "2" self:RangeAttackCode() end end)
		end
		for i = 0.1, 0.6, 0.1 do
			timer.Simple(i, function() if IsValid(self) then self.RangeUseAttachmentForPosID = "3" self:RangeAttackCode() end end)
		end
	-- We have been weakend, we should only fire 1 orb!
	elseif key == "elec_orbs_open" then
		self.Nih_TeleportingOrb = false
		self.RangeUseAttachmentForPos = false
		self:RangeAttackCode()
	elseif key == "tele_orb" then
		self.Nih_TeleportingOrb = true
		self.RangeUseAttachmentForPos = false
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if ent:IsPlayer() then
		self.SoundTbl_Alert = {"vj_hlr/hl1_npc/nihilanth/nil_freeman.wav"}
	else
		self.SoundTbl_Alert = {"vj_hlr/hl1_npc/nihilanth/nil_comes.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.Dead then
		if self.Nih_LerpAngleDeath == nil then self.Nih_LerpAngleDeath = self:GetAngles() end
		self.Nih_LerpAngleDeath = LerpAngle(0.25, self.Nih_LerpAngleDeath, self.Nih_LerpAngleDeath + Angle(0,30,0))
		self:SetAngles(self.Nih_LerpAngleDeath)
	end
	
	local num = #self.Nih_Charges
	if num > 0 then
		/*for k, v in ipairs(self.Nih_Charges) do
			local test = v:GetAngles()
			test:Add(Angle(5,5,5))
			test:Normalize()
			v:SetAngles(test)
		end*/
	else
		self.Nih_BrainOpen = true
		self.AnimTbl_IdleStand = {ACT_IDLE_HURT}
		if self.Nih_DidBrainOpenAnim == false then
			self:VJ_ACT_PLAYACTIVITY("vjseq_transition_to_hurt", true, false)
			self.Nih_DidBrainOpenAnim = true
		end
	end
	
	if self.Nih_CrystalsDestroyed == false && !IsValid(self.Nih_Crystal1) && !IsValid(self.Nih_Crystal2) && !IsValid(self.Nih_Crystal3) then
		self.Nih_CrystalsDestroyed = true
		VJ.EmitSound(self, "vj_hlr/hl1_npc/nihilanth/nil_done.wav", 120)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead then return end
	if IsValid(self:GetEnemy()) && CurTime() > self.Nih_NextSpawn && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP))) && (!IsValid(self.Nih_Ally1) or !IsValid(self.Nih_Ally2) or !IsValid(self.Nih_Ally3) or !IsValid(self.Nih_Ally4) or !IsValid(self.Nih_Ally5)) then
		self:Nih_SpawnAlly()
		self.Nih_NextSpawn = CurTime() + 15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	if math.random(1, 3) == 1 then
		if self.Nih_BrainOpen == true then
			self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2_LOW}
		else
			self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK2}
		end
		self.RangeAttackEntityToSpawn = "obj_vj_hlr1_orb_teleport"
	else
		if self.Nih_BrainOpen == true then
			self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1_LOW}
		else
			self.AnimTbl_RangeAttack = {ACT_RANGE_ATTACK1}
		end
		self.RangeAttackEntityToSpawn = "obj_vj_hlr1_orb_electrical"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
	if self.Nih_TeleportingOrb == true && IsValid(self:GetEnemy()) then
		projectile.Track_Enemy = self:GetEnemy()
		timer.Simple(10, function() if IsValid(projectile) then projectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Line", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 700), 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local regTroops = {"npc_vj_hlr1_aliengrunt", "npc_vj_hlr1_alienslave", "npc_vj_hlr1_aliencontroller"}
local aquaticTroops = {"npc_vj_hlr1_ichthyosaur", "npc_vj_hlr1_archer"}
local vecNZ100 = Vector(0, 0, -100)
local vecZ250 = Vector(0, 0, 250)
local vecZ20 = Vector(0, 0, 20)
--
function ENT:Nih_SpawnAlly()
	-- Can have a total of 5, only 1 can be spawned at a time with a delay until another one is spawned
	-- Update the relation class tables for all the crystals in case it has changed!
	if IsValid(self.Nih_Crystal1) then
		self.Nih_Crystal1.VJ_NPC_Class = self.VJ_NPC_Class
	end
	if IsValid(self.Nih_Crystal2) then
		self.Nih_Crystal2.VJ_NPC_Class = self.VJ_NPC_Class
	end
	if IsValid(self.Nih_Crystal3) then
		self.Nih_Crystal3.VJ_NPC_Class = self.VJ_NPC_Class
	end
	
	local myPos = self:GetPos()
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos + self:GetForward() * math.Rand(-10000, 10000) + self:GetRight() * math.Rand(-10000, 10000) + self:GetUp() * -1000,
		filter = self,
		mask = MASK_ALL,
	})
	local spawnPos = tr.HitPos + tr.HitNormal*30 -- 30 WU kichme tours hane
	VJ.HLR_Effect_Portal(spawnPos + vecZ20, nil, nil, function()
		-- onSpawn
		if IsValid(self) then
			local troops;
			if tr.MatType == MAT_SLOSH then -- If the hit pos is in water then spawn an aquatic NPC instead
				troops = VJ.PICK(aquaticTroops)
				spawnPos = spawnPos + vecNZ100
			else
				troops = VJ.PICK(regTroops)
			end
			local ally = ents.Create(troops)
			if ally:GetClass() == "npc_vj_hlr1_aliencontroller" then spawnPos = spawnPos + vecZ250 end -- Yete controller e, ere vor kichme partser dzaki
			ally:SetPos(spawnPos)
			ally:SetAngles(self:GetAngles())
			ally.VJ_NPC_Class = self.VJ_NPC_Class
			ally:Spawn()
			ally:Activate()
			if !IsValid(self.Nih_Ally1) then
				self.Nih_Ally1 = ally
			elseif !IsValid(self.Nih_Ally2) then
				self.Nih_Ally2 = ally
			elseif !IsValid(self.Nih_Ally3) then
				self.Nih_Ally3 = ally
			elseif !IsValid(self.Nih_Ally4) then
				self.Nih_Ally4 = ally
			elseif !IsValid(self.Nih_Ally5) then
				self.Nih_Ally5 = ally
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if self.Nih_CrystalsDestroyed == false then dmginfo:SetDamage(0) return end
	
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
	end
	
	-- Scale the damage if we aren't hitting inside the brain!
	if hitgroup != HITGROUP_CHEST then
		dmginfo:ScaleDamage(0.4)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Nih_DoElecEffect_Blue(sp, hp, a)
	local elec = EffectData()
	elec:SetStart(sp)
	elec:SetOrigin(hp)
	elec:SetEntity(self)
	elec:SetAttachment(self:LookupAttachment(a))
	util.Effect("VJ_HLR_Electric_Nihilanth_Blue", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Nih_DoElecEffect_Green(sp, hp)
	local elec = EffectData()
	elec:SetStart(sp)
	elec:SetOrigin(hp)
	elec:SetEntity(self)
	elec:SetAttachment(self:LookupAttachment("0"))
	util.Effect("VJ_HLR_Electric_Nihilanth_Green", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	util.ScreenShake(self:GetPos(), 16, 5, 16, 30000)
	ParticleEffectAttach("vj_hlr_nihilanth_deathorbs", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("0")) -- Ganach louys ere
	
	local spr1 = ents.Create("env_sprite")
	spr1:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
	spr1:SetKeyValue("rendercolor","100 255 0")
	spr1:SetKeyValue("GlowProxySize","2.0")
	spr1:SetKeyValue("HDRColorScale","1.0")
	spr1:SetKeyValue("renderfx","14")
	spr1:SetKeyValue("rendermode","5")
	spr1:SetKeyValue("renderamt","255")
	spr1:SetKeyValue("disablereceiveshadows","0")
	spr1:SetKeyValue("mindxlevel","0")
	spr1:SetKeyValue("maxdxlevel","0")
	spr1:SetKeyValue("framerate","15.0")
	spr1:SetKeyValue("spawnflags","0")
	spr1:SetKeyValue("scale","10")
	spr1:SetPos(self:GetAttachment(self:LookupAttachment("0")).Pos)
	spr1:Spawn()
	spr1:Fire("Kill","",0.9)
	
	local function DoBlueElectric()
		-- Keloukhen ver --------------------------
		local tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(10000,20000) + self:GetUp()*20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "0")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(10000,20000) + self:GetUp()*20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "0")
		
		-- Poren var --------------------------
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("1")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(10000,20000) + self:GetUp()*-20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "1")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("1")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(10000,20000) + self:GetUp()*-20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "1")
		
		-- Tsakh --------------------------
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("3")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(10000,20000) + self:GetUp()*20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "3")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("3")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(10000,20000) + self:GetUp()*-20000 + self:GetForward()*-math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "3")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("3")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(10000,20000) + self:GetUp()*-20000 + self:GetForward()*math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "3")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("3")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(100,20000) + self:GetUp()*20000 + self:GetForward()*math.Rand(-10000,10000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "3")
		
		-- Ach --------------------------
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("2")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(10000,20000) + self:GetUp()*20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "2")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("2")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(10000,20000) + self:GetUp()*-20000 + self:GetForward()*-math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "2")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("2")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(10000,20000) + self:GetUp()*-200 + self:GetForward()*math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "2")
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("2")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(100,20000) + self:GetUp()*20000 + self:GetForward()*math.Rand(-10000,10000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 12, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, "2")
	end
	DoBlueElectric()
	for i = 0.5, 15.5, 0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
				DoBlueElectric()
			end
		end)
	end
	
	local function DoGreenElectric()
		-- Tsakh --------------------------
		local tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(20000,20000) + self:GetUp()*-20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(20000,20000) + self:GetUp()*-20000 + self:GetForward()*-math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(20000,20000) + self:GetUp()*-20000 + self:GetForward()*math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*math.Rand(100,20000) + self:GetUp()*20000 + self:GetForward()*math.Rand(-10000,10000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
		
		-- Ach --------------------------
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(20000,20000) + self:GetUp()*-20000,
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(20000,20000) + self:GetUp()*-20000 + self:GetForward()*-math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(20000,20000) + self:GetUp()*-200 + self:GetForward()*math.Rand(20000,20000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
		
		tr = util.TraceLine({
			start = self:GetAttachment(self:LookupAttachment("0")).Pos,
			endpos = self:GetPos() + self:GetRight()*-math.Rand(100,20000) + self:GetUp()*20000 + self:GetForward()*math.Rand(-10000,10000),
			filter = self
		})
		VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 20, DMG_ALWAYSGIB, false, true)
		self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
	end
	
	for i = 10, 16, 0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
				DoGreenElectric()
				
				local spr = ents.Create("env_sprite")
				spr:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
				spr:SetKeyValue("rendercolor","100 255 0")
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
				spr:SetKeyValue("scale","20")
				spr:SetPos(self:GetAttachment(self:LookupAttachment("0")).Pos + self:GetRight() * math.random(-200,200) + self:GetForward() * math.random(-200,200))
				spr:Spawn()
				spr:Fire("Kill","",0.9)
			end
		end)
	end
	
	timer.Simple(10, function()
		if IsValid(self) then
			local spr = ents.Create("env_sprite")
			spr:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
			spr:SetKeyValue("rendercolor","100 255 0")
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
			spr:SetKeyValue("scale","20")
			spr:SetPos(self:GetAttachment(self:LookupAttachment("0")).Pos)
			spr:Spawn()
			spr:Fire("Kill","",0.9)
		end
	end)
	
	timer.Simple(14, function() -- Jermag louys ere
		if IsValid(self) then
			ParticleEffect("vj_hlr_nihilanth_deathorbs_white", self:GetAttachment(self:LookupAttachment("0")).Pos, self:GetAngles())
			VJ.EmitSound(self, "vj_hlr/hl1_npc/x/nih_die2.wav", 120)
			
			timer.Simple(1, function()
				if IsValid(self) then
					local spr = ents.Create("env_sprite")
					spr:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
					spr:SetKeyValue("rendercolor","100 255 0")
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
					spr:SetKeyValue("scale","20")
					spr:SetPos(self:GetAttachment(self:LookupAttachment("1")).Pos)
					spr:Spawn()
					spr:Fire("Kill","",0.9)
				end
			end)
			
			timer.Simple(1.5, function()
				if IsValid(self) then
					local spr = ents.Create("env_sprite")
					spr:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
					spr:SetKeyValue("rendercolor","100 255 0")
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
					spr:SetKeyValue("scale","20")
					spr:SetPos(self:GetAttachment(self:LookupAttachment("1")).Pos + self:GetUp() * 100 + self:GetRight() * 300)
					spr:Spawn()
					spr:Fire("Kill","",0.9)
					
					spr = ents.Create("env_sprite")
					spr:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
					spr:SetKeyValue("rendercolor","100 255 0")
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
					spr:SetKeyValue("scale","20")
					spr:SetPos(self:GetAttachment(self:LookupAttachment("1")).Pos + self:GetUp() * 100 + self:GetRight() * -300)
					spr:Spawn()
					spr:Fire("Kill","",0.9)
				end
			end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorGreen = Color(0, 255, 0, 255)
--
function ENT:CustomOnKilled(dmginfo, hitgroup)
	-- Screen flash effect for all the players
	for _,v in ipairs(player.GetHumans()) do
		v:ScreenFade(SCREENFADE.IN, colorGreen, 1, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	RunConsoleCommand("sv_gravity", self.Nih_OriginalGravity)
	
	if IsValid(self.Nih_Crystal1) then self.Nih_Crystal1:Remove() end
	if IsValid(self.Nih_Crystal2) then self.Nih_Crystal2:Remove() end
	if IsValid(self.Nih_Crystal3) then self.Nih_Crystal3:Remove() end
	
	-- Remove allies if we were removed without being killed
	if !self.Dead then
		if IsValid(self.Nih_Ally1) then self.Nih_Ally1:Remove() end
		if IsValid(self.Nih_Ally2) then self.Nih_Ally2:Remove() end
		if IsValid(self.Nih_Ally3) then self.Nih_Ally3:Remove() end
		if IsValid(self.Nih_Ally4) then self.Nih_Ally4:Remove() end
		if IsValid(self.Nih_Ally5) then self.Nih_Ally5:Remove() end
	end
end
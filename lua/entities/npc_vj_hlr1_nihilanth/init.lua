AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/nihilanth.mdl"
ENT.StartHealth = 3000
ENT.HullType = HULL_LARGE
ENT.VJ_ID_Boss = true
ENT.SightDistance = 20000
ENT.SightAngle = 360
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "Bip01 head",
    FirstP_Offset = Vector(80, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow_large"}
ENT.BloodDecal = {"VJ_HLR_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = true
ENT.RangeAttackMaxDistance = 20000
ENT.RangeAttackMinDistance = 1
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = VJ.SET(3, 4)

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathAnimationTime = 16
ENT.IdleSoundsWhileAttacking = true
ENT.HasSoundTrack = true

ENT.SoundTbl_SoundTrack = {"vj_hlr/hl1_npc/nihilanth/Prospero03.mp3"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/x/x_laugh1.wav", "vj_hlr/hl1_npc/x/x_laugh2.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/nihilanth/nil_man_notman.wav", "vj_hlr/hl1_npc/nihilanth/nil_win.wav", "vj_hlr/hl1_npc/nihilanth/nil_slaves.wav", "vj_hlr/hl1_npc/nihilanth/nil_thelast.wav", "vj_hlr/hl1_npc/nihilanth/nil_thetruth.wav", "vj_hlr/hl1_npc/nihilanth/nil_thieves.wav", "vj_hlr/hl1_npc/nihilanth/nil_last.wav", "vj_hlr/hl1_npc/nihilanth/nil_die.wav", "vj_hlr/hl1_npc/nihilanth/nil_alone.wav", "vj_hlr/hl1_npc/nihilanth/nil_deceive.wav", "vj_hlr/hl1_npc/nihilanth/nil_now_die.wav", "vj_hlr/hl1_npc/x/x_laugh1.wav", "vj_hlr/hl1_npc/x/x_laugh2.wav"}
ENT.SoundTbl_Alert = "vj_hlr/hl1_npc/nihilanth/nil_comes.wav"
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/hl1_npc/x/x_attack1.wav", "vj_hlr/hl1_npc/x/x_attack2.wav", "vj_hlr/hl1_npc/x/x_attack3.wav"}
ENT.SoundTbl_RangeAttack = "vj_hlr/hl1_npc/x/x_shoot1.wav"
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/x/x_pain1.wav", "vj_hlr/hl1_npc/x/x_pain2.wav", "vj_hlr/hl1_npc/x/x_pain3.wav"}
ENT.SoundTbl_Death = "vj_hlr/hl1_npc/x/x_die1.wav"

ENT.NextSoundTime_Idle = VJ.SET(14, 20)

ENT.MainSoundPitch = 100

ENT.IdleSoundLevel = 120
ENT.CombatIdleSoundLevel = 120
ENT.AlertSoundLevel = 120
ENT.BeforeRangeAttackSoundLevel = 120
ENT.RangeAttackSoundLevel = 120
ENT.PainSoundLevel = 120
ENT.DeathSoundLevel = 120

-- Custom
ENT.Nih_TeleportingOrb = false
ENT.Nih_NextSpawn = 0
ENT.Nih_CrystalsDestroyed = false
ENT.Nih_BrainOpen = false
ENT.Nih_LerpAngleDeath = nil
ENT.Nih_OriginalGravity = 600
ENT.Nih_RangeAttach = -1

/*
vj_hl/sprites/flare6.vmt    		Right before nihilanth disappears on death he releases these bubbles
vj_hl/sprites/nhth1.vmt     		Purple electric projectiles
vj_hl/sprites/muzzleflash3.vmt		Orb ring around his head that displays his health sorta
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
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
	
	-- Set the gravity
	self.Nih_OriginalGravity = GetConVar("sv_gravity"):GetFloat()
	RunConsoleCommand("sv_gravity", 200)
	
	self:SetCollisionBounds(Vector(250, 250, 430), Vector(-250, -250, -530))
	self:SetPos(self:GetPos() + self:GetUp() * 1000)
	
	-- Create the 3 Crystals
	local myPos = self:GetPos()
	local myForward = self:GetForward()
	local myRight = self:GetRight()
	local myUp = self:GetUp()
	self.Nih_Charges = {}
	for i = 1, 3 do
		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos + myForward * math.Rand(-10000, 10000) + myRight * math.Rand(-10000, 10000) + myUp * -3000,
			filter = self,
		})
		-- HitNormal = Number between 0 to 1, use this to get the position the trace came from. Ex: Add it to the hit position to make it go farther away.
		local crystal = ents.Create("sent_vj_xen_crystal")
		crystal:SetPos(tr.HitPos - tr.HitNormal * 10) -- Take the HitNormal and minus it by 10 units to make it go inside the position a bit
		crystal:SetAngles(tr.HitNormal:Angle() + Angle(math.Rand(60, 120), math.Rand(-15, 15), math.Rand(-15, 15))) -- 90 = middle and 30 degree difference to make the pitch rotate randomly | yaw and roll are applied a bit of a random number
		crystal.Assignee = self
		crystal:Spawn()
		crystal:Activate()
		self:SetRelationshipMemory(crystal, VJ.MEM_OVERRIDE_DISPOSITION, D_LI) -- In case relation class is changed dynamically!
		if i == 1 then
			self.Nih_Crystal1 = crystal
		elseif i == 2 then
			self.Nih_Crystal2 = crystal
		elseif i == 3 then
			self.Nih_Crystal3 = crystal
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	-- Regular attack
	if key == "elec_orbs" then
		self.Nih_TeleportingOrb = false
		self.Nih_RangeAttach = -1
		self:ExecuteRangeAttack()
		for i = 0.1, 0.6, 0.1 do
			timer.Simple(i, function() if IsValid(self) then self.Nih_RangeAttach = "2" self:ExecuteRangeAttack() end end)
		end
		for i = 0.1, 0.6, 0.1 do
			timer.Simple(i, function() if IsValid(self) then self.Nih_RangeAttach = "3" self:ExecuteRangeAttack() end end)
		end
	-- We have been weakened, we should only fire 1 orb!
	elseif key == "elec_orbs_open" then
		self.Nih_TeleportingOrb = false
		self.Nih_RangeAttach = -1
		self:ExecuteRangeAttack()
	-- Teleport attack
	elseif key == "tele_orb" then
		self.Nih_TeleportingOrb = true
		self.Nih_RangeAttach = -1
		self:ExecuteRangeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- Run like crazy when half health
	if act == ACT_IDLE && self.Nih_BrainOpen then
		return ACT_IDLE_HURT
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	if math.random(1, 2) == 1 && ent:IsPlayer() then
		self.SoundTbl_Alert = "vj_hlr/hl1_npc/nihilanth/nil_freeman.wav"
	else
		self.SoundTbl_Alert = "vj_hlr/hl1_npc/nihilanth/nil_comes.wav"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local angY30 = Angle(0, 30, 0)
--
function ENT:OnThinkActive()
	if self.Dead then -- Make it rotate around as it's dying
		if self.Nih_LerpAngleDeath == nil then self.Nih_LerpAngleDeath = self:GetAngles() end
		self.Nih_LerpAngleDeath = LerpAngle(0.25, self.Nih_LerpAngleDeath, self.Nih_LerpAngleDeath + angY30)
		self:SetAngles(self.Nih_LerpAngleDeath)
	elseif IsValid(self:GetEnemy()) && CurTime() > self.Nih_NextSpawn && ((!self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP))) && (!IsValid(self.Nih_Ally1) or !IsValid(self.Nih_Ally2) or !IsValid(self.Nih_Ally3) or !IsValid(self.Nih_Ally4) or !IsValid(self.Nih_Ally5)) then
		self:Nih_SpawnAlly()
		self.Nih_NextSpawn = CurTime() + 15
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleRangeAttacks()
	if math.random(1, 4) == 1 then
		self.AnimTbl_RangeAttack = self.Nih_BrainOpen == true and ACT_RANGE_ATTACK2_LOW or ACT_RANGE_ATTACK2
		self.RangeAttackProjectiles = "obj_vj_hlr1_orb_teleport"
	else
		self.AnimTbl_RangeAttack = self.Nih_BrainOpen == true and ACT_RANGE_ATTACK1_LOW or ACT_RANGE_ATTACK1
		self.RangeAttackProjectiles = "obj_vj_hlr1_orb_electrical"
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
function ENT:RangeAttackProjPos(projectile)
	if self.Nih_RangeAttach != -1 then
		return self:GetAttachment(self:LookupAttachment(self.Nih_RangeAttach)).Pos
	else
		return self:GetPos() + self:GetUp() * -140 + self:GetForward() * 430
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return VJ.CalculateTrajectory(self, self:GetEnemy(), "Line", projectile:GetPos(), 1, 700)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Nih_NotifyCrystalChange(crystal)
	-- Check which one is getting removed
	if crystal == self.Nih_Crystal1 then
		self.Nih_Crystal1 = NULL
	elseif crystal == self.Nih_Crystal2 then
		self.Nih_Crystal2 = NULL
	elseif crystal == self.Nih_Crystal3 then
		self.Nih_Crystal3 = NULL
	end
	
	-- Check if all crystals are removed
	if !self.Dead && self.Nih_CrystalsDestroyed == false && !IsValid(self.Nih_Crystal1) && !IsValid(self.Nih_Crystal2) && !IsValid(self.Nih_Crystal3) then
		self.Nih_CrystalsDestroyed = true
		VJ.EmitSound(self, "vj_hlr/hl1_npc/nihilanth/nil_done.wav", 120)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local regTroops = {"npc_vj_hlr1_aliengrunt", "npc_vj_hlr1_alienslave", "npc_vj_hlr1_aliencontroller"}
local aquaticTroops = {"npc_vj_hlr1_ichthyosaur", "npc_vj_hlr1_archer"}
local vecZ20 = Vector(0, 0, 20)
local vecNZ100 = Vector(0, 0, -100)
local vecZ250 = Vector(0, 0, 250)
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
	VJ.HLR1_Effect_Portal(spawnPos + vecZ20, nil, nil, function()
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
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" then
		if !self.Nih_CrystalsDestroyed then dmginfo:SetDamage(0) return end
	
		if !self.Nih_BrainOpen then
			local num = #self.Nih_Charges
			if num > 0 then
				dmginfo:SetDamage(0)
				local charge = self.Nih_Charges[num]
				charge:Remove()
				table.remove(self.Nih_Charges, num)
				-- Check if any charges remain, if num is 1 then it was the last one!
				if num <= 1 then
					self.Nih_BrainOpen = true
					self:PlayAnim("vjseq_transition_to_hurt", true, false)
				end
				return
			end
		end
		
		-- Scale the damage if we aren't hitting inside the brain!
		if hitgroup != HITGROUP_CHEST then
			dmginfo:ScaleDamage(0.4)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Nih_DoElecEffect_Blue(startPos, hitPos, attachment)
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetEntity(self)
	elec:SetAttachment(attachment)
	util.Effect("VJ_HLR_Electric_Nihilanth_Blue", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Nih_DoElecEffect_Green(startPos, hitPos)
	local elec = EffectData()
	elec:SetStart(startPos)
	elec:SetOrigin(hitPos)
	elec:SetEntity(self)
	elec:SetAttachment(self:LookupAttachment("0"))
	util.Effect("VJ_HLR_Electric_Nihilanth_Green", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local dmgBeamType = bit.bor(DMG_SHOCK, DMG_ENERGYBEAM, DMG_ALWAYSGIB)
local colorGreen = Color(0, 255, 0, 255)
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		util.ScreenShake(self:GetPos(), 16, 5, 16, 30000)
		ParticleEffectAttach("vj_hlr_nihilanth_deathorbs", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("0")) -- Bezdig ganach louyser
		
		-- Initial regular size green explosion
		local spr1 = ents.Create("env_sprite")
		spr1:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
		spr1:SetKeyValue("rendercolor", "100 255 0")
		spr1:SetKeyValue("GlowProxySize", "2.0")
		spr1:SetKeyValue("HDRColorScale", "1.0")
		spr1:SetKeyValue("renderfx", "14")
		spr1:SetKeyValue("rendermode", "5")
		spr1:SetKeyValue("renderamt", "255")
		spr1:SetKeyValue("disablereceiveshadows", "0")
		spr1:SetKeyValue("mindxlevel", "0")
		spr1:SetKeyValue("maxdxlevel", "0")
		spr1:SetKeyValue("framerate", "15.0")
		spr1:SetKeyValue("spawnflags", "0")
		spr1:SetKeyValue("scale", "10")
		spr1:SetPos(self:GetAttachment(self:LookupAttachment("0")).Pos)
		spr1:Spawn()
		spr1:Fire("Kill", "", 0.9)

		-- Create blue beams
		for t = 0, 15.5, 0.5 do
			timer.Simple(t, function()
				if IsValid(self) then
					local myPos = self:GetPos()
					local myForward = self:GetForward()
					local myRight = self:GetRight()
					local myUp = self:GetUp()
					local attach0 = self:LookupAttachment("0")
					local attach1 = self:LookupAttachment("1")
					local attach2 = self:LookupAttachment("2")
					local attach3 = self:LookupAttachment("3")
					local beams = {
						-- Keloukhen ver --------------------------
						{attach = attach0,
							endPos = myPos + myRight * math.Rand(10000, 20000) + myUp * 20000},
						{attach = attach0,
							endPos = myPos + myRight * -math.Rand(10000, 20000) + myUp * 20000},
						-- Poren var --------------------------
						{attach = attach1,
							endPos = myPos + myRight * math.Rand(10000, 20000) + myUp * -20000},
						{attach = attach1,
							endPos = myPos + myRight * -math.Rand(10000, 20000) + myUp * -20000},
						-- Tsakh --------------------------
						{attach = attach3,
							endPos = myPos + myRight * math.Rand(10000, 20000) + myUp * 20000},
						{attach = attach3,
							endPos = myPos + myRight * math.Rand(10000, 20000) + myUp * -20000 + myForward * -math.Rand(20000, 20000)},
						{attach = attach3,
							endPos = myPos + myRight * math.Rand(10000, 20000) + myUp * -20000 + myForward * math.Rand(20000, 20000)},
						{attach = attach3,
							endPos = myPos + myRight * math.Rand(100, 20000) + myUp * 20000 + myForward * math.Rand(-10000, 10000)},
						-- Ach --------------------------
						{attach = attach2,
							endPos = myPos + myRight * -math.Rand(10000, 20000) + myUp * 20000},
						{attach = attach2,
							endPos = myPos + myRight * -math.Rand(10000, 20000) + myUp * -20000 + myForward * -math.Rand(20000, 20000)},
						{attach = attach2,
							endPos = myPos + myRight * -math.Rand(10000, 20000) + myUp * -200 + myForward * math.Rand(20000, 20000)},
						{attach = attach2,
							endPos = myPos + myRight * -math.Rand(100, 20000) + myUp * 20000 + myForward * math.Rand(-10000, 10000)},
					}
					for i = 1, 12 do
						local iBeam = beams[i]
						local tr = util.TraceLine({
							start = self:GetAttachment(iBeam.attach).Pos,
							endpos = iBeam.endPos,
							filter = self
						})
						VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 80, dmgBeamType, false, true)
						self:Nih_DoElecEffect_Blue(tr.StartPos, tr.HitPos, iBeam.attach)
					end
				end
			end)
		end
		
		-- Create green beams and explosions
		for t = 10, 16, 0.5 do
			timer.Simple(t, function()
				if IsValid(self) then
					local myPos = self:GetPos()
					local myForward = self:GetForward()
					local myRight = self:GetRight()
					local myUp = self:GetUp()
					local attachPos = self:GetAttachment(self:LookupAttachment("0")).Pos
					
					-- Green beams
					local beams = {
						-- Tsakh --------------------------
						myPos + myRight * math.Rand(20000, 20000) + myUp * -20000,
						myPos + myRight * math.Rand(20000, 20000) + myUp * -20000 + myForward * -math.Rand(20000, 20000),
						myPos + myRight * math.Rand(20000, 20000) + myUp * -20000 + myForward * math.Rand(20000, 20000),
						myPos + myRight * math.Rand(100, 20000) + myUp * 20000 + myForward * math.Rand(-10000, 10000),
						-- Ach --------------------------
						myPos + myRight * -math.Rand(20000, 20000) + myUp * -20000,
						myPos + myRight * -math.Rand(20000, 20000) + myUp * -20000 + myForward * -math.Rand(20000, 20000),
						myPos + myRight * -math.Rand(20000, 20000) + myUp * -200 + myForward * math.Rand(20000, 20000),
						myPos + myRight * -math.Rand(100, 20000) + myUp * 20000 + myForward * math.Rand(-10000, 10000),
					}
					for i = 1, 8 do
						local tr = util.TraceLine({
							start = attachPos,
							endpos = beams[i],
							filter = self
						})
						VJ.ApplyRadiusDamage(self, self, tr.HitPos, 50, 100, dmgBeamType, false, true)
						self:Nih_DoElecEffect_Green(tr.StartPos, tr.HitPos)
					end
					
					-- Green explosion
					local spr = ents.Create("env_sprite")
					spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
					spr:SetKeyValue("rendercolor", "100 255 0")
					spr:SetKeyValue("GlowProxySize", "2.0")
					spr:SetKeyValue("HDRColorScale", "1.0")
					spr:SetKeyValue("renderfx", "14")
					spr:SetKeyValue("rendermode", "5")
					spr:SetKeyValue("renderamt", "255")
					spr:SetKeyValue("disablereceiveshadows", "0")
					spr:SetKeyValue("mindxlevel", "0")
					spr:SetKeyValue("maxdxlevel", "0")
					spr:SetKeyValue("framerate", "15.0")
					spr:SetKeyValue("spawnflags", "0")
					spr:SetKeyValue("scale", "20")
					spr:SetPos(attachPos + myForward * math.random(-200, 200) + myRight * math.random(-200, 200))
					spr:Spawn()
					spr:Fire("Kill", "", 0.9)
				end
			end)
		end
		
		-- Large green explosion
		timer.Simple(10, function()
			if IsValid(self) then
				local spr = ents.Create("env_sprite")
				spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
				spr:SetKeyValue("rendercolor", "100 255 0")
				spr:SetKeyValue("GlowProxySize", "2.0")
				spr:SetKeyValue("HDRColorScale", "1.0")
				spr:SetKeyValue("renderfx", "14")
				spr:SetKeyValue("rendermode", "5")
				spr:SetKeyValue("renderamt", "255")
				spr:SetKeyValue("disablereceiveshadows", "0")
				spr:SetKeyValue("mindxlevel", "0")
				spr:SetKeyValue("maxdxlevel", "0")
				spr:SetKeyValue("framerate", "15.0")
				spr:SetKeyValue("spawnflags", "0")
				spr:SetKeyValue("scale", "20")
				spr:SetPos(self:GetAttachment(self:LookupAttachment("0")).Pos)
				spr:Spawn()
				spr:Fire("Kill", "", 0.9)
			end
		end)
		
		-- Ending scene: White orbs + green explosions
		timer.Simple(14, function()
			if IsValid(self) then
				ParticleEffect("vj_hlr_nihilanth_deathorbs_white", self:GetAttachment(self:LookupAttachment("0")).Pos, self:GetAngles())
				VJ.EmitSound(self, "vj_hlr/hl1_npc/x/nih_die2.wav", 120)
				
				timer.Simple(1, function()
					if IsValid(self) then
						local spr = ents.Create("env_sprite")
						spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
						spr:SetKeyValue("rendercolor", "100 255 0")
						spr:SetKeyValue("GlowProxySize", "2.0")
						spr:SetKeyValue("HDRColorScale", "1.0")
						spr:SetKeyValue("renderfx", "14")
						spr:SetKeyValue("rendermode", "5")
						spr:SetKeyValue("renderamt", "255")
						spr:SetKeyValue("disablereceiveshadows", "0")
						spr:SetKeyValue("mindxlevel", "0")
						spr:SetKeyValue("maxdxlevel", "0")
						spr:SetKeyValue("framerate", "15.0")
						spr:SetKeyValue("spawnflags", "0")
						spr:SetKeyValue("scale", "20")
						spr:SetPos(self:GetAttachment(self:LookupAttachment("1")).Pos)
						spr:Spawn()
						spr:Fire("Kill", "", 0.9)
					end
				end)
				
				timer.Simple(1.5, function()
					if IsValid(self) then
						local spr = ents.Create("env_sprite")
						spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
						spr:SetKeyValue("rendercolor", "100 255 0")
						spr:SetKeyValue("GlowProxySize", "2.0")
						spr:SetKeyValue("HDRColorScale", "1.0")
						spr:SetKeyValue("renderfx", "14")
						spr:SetKeyValue("rendermode", "5")
						spr:SetKeyValue("renderamt", "255")
						spr:SetKeyValue("disablereceiveshadows", "0")
						spr:SetKeyValue("mindxlevel", "0")
						spr:SetKeyValue("maxdxlevel", "0")
						spr:SetKeyValue("framerate", "15.0")
						spr:SetKeyValue("spawnflags", "0")
						spr:SetKeyValue("scale", "20")
						spr:SetPos(self:GetAttachment(self:LookupAttachment("1")).Pos + self:GetUp() * 100 + self:GetRight() * 300)
						spr:Spawn()
						spr:Fire("Kill", "", 0.9)
						
						spr = ents.Create("env_sprite")
						spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
						spr:SetKeyValue("rendercolor", "100 255 0")
						spr:SetKeyValue("GlowProxySize", "2.0")
						spr:SetKeyValue("HDRColorScale", "1.0")
						spr:SetKeyValue("renderfx", "14")
						spr:SetKeyValue("rendermode", "5")
						spr:SetKeyValue("renderamt", "255")
						spr:SetKeyValue("disablereceiveshadows", "0")
						spr:SetKeyValue("mindxlevel", "0")
						spr:SetKeyValue("maxdxlevel", "0")
						spr:SetKeyValue("framerate", "15.0")
						spr:SetKeyValue("spawnflags", "0")
						spr:SetKeyValue("scale", "20")
						spr:SetPos(self:GetAttachment(self:LookupAttachment("1")).Pos + self:GetUp() * 100 + self:GetRight() * -300)
						spr:Spawn()
						spr:Fire("Kill", "", 0.9)
					end
				end)
			end
		end)
	elseif status == "Finish" then
		-- Screen flash effect for all the players
		for _,v in ipairs(player.GetHumans()) do
			v:ScreenFade(SCREENFADE.IN, colorGreen, 1, 0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	RunConsoleCommand("sv_gravity", self.Nih_OriginalGravity)
	
	-- Remove crystals
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
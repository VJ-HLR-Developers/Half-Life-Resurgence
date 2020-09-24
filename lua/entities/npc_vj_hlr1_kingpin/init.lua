AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/kingpin.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 450
ENT.SightAngle = 180
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Dissolve = true
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 105 -- How close does it have to be until it attacks?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.SlowPlayerOnMeleeAttack = true
ENT.MeleeAttackBleedEnemy = true
ENT.MeleeAttackBleedEnemyChance = 1 -- How much chance there is that the enemy will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 3 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 10 -- How many reps?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_kingpin_orb" -- The entity that is spawned when range attacking
ENT.RangeDistance = 3000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 200 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?
ENT.RangeAttackPos_Up = 65
ENT.RangeAttackPos_Forward = 65
ENT.NextRangeAttackTime = 8 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 10 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE,ACT_DIEFORWARD,ACT_DIEBACKWARD} -- Death Animations
ENT.DeathAnimationChance = 1//3 -- Put 1 if you want it to play the animation all the time
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {"vjseq_flinch_small"} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {
	"vj_hlr/hl1_weapon/crossbow/xbow_hit1.wav"
}
ENT.SoundTbl_Idle = {
	"vj_hlr/hl1_npc/kingpin/kingpin_idle1.wav",
	"vj_hlr/hl1_npc/kingpin/kingpin_idle2.wav",
	"vj_hlr/hl1_npc/kingpin/kingpin_idle3.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl1_npc/kingpin/kingpin_alert1.wav",
	"vj_hlr/hl1_npc/kingpin/kingpin_alert2.wav",
	"vj_hlr/hl1_npc/kingpin/kingpin_alert3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {

}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl1_npc/kingpin/kingpin_pain1.wav",
	"vj_hlr/hl1_npc/kingpin/kingpin_pain2.wav",
	"vj_hlr/hl1_npc/kingpin/kingpin_pain3.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl1_npc/kingpin/kingpin_death1.wav",
	"vj_hlr/hl1_npc/kingpin/kingpin_death2.wav",
}

	-- ====== Controller Variables ====== --
ENT.Controller_FirstPersonBone = "MDLDEC_Bone23"
ENT.Controller_FirstPersonOffset = Vector(8,0,6)
ENT.Controller_FirstPersonAngle = Angle(90,0,90)

ENT.GeneralSoundPitch1 = 100
ENT.TeleportTime = 1.3
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(35,35,120),Vector(-35,-35,0))
	self.ShieldHealth = 250
	self.IsGeneratingShield = false
	self:SetNWBool("shield",true)
	self.IsZapping = false
	self.NextZapT = CurTime()
	self.IsTeleporting = false
	self.NextTeleportT = CurTime()
	self.tbl_Summons = {}
	self.NextSummonT = CurTime()
	self.NextCheckAIT = CurTime()
	
	-- for _,v in pairs(player.GetAll()) do
		-- v:ChatPrint("Message from Cpt. Hazama:")
		-- v:ChatPrint("Kingpin is still very much WIP")
		-- v:ChatPrint("I still need to make proper particles for its' teleportation, so you may notice it turn invisible while teleporting. During this time it would normally be shrouded in a teleportation effect so you wouldn't notice.")
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_AfterProjectileSpawn(TheProjectile)
	if IsValid(self:GetEnemy()) then
		TheProjectile.EO_Enemy = self:GetEnemy()
		timer.Simple(20,function() if IsValid(TheProjectile) then TheProjectile:Remove() end end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return self:CalculateProjectile("Line", self:GetPos() + self:GetUp()*20, self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(), 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
		timer.Simple(0.35,function() if IsValid(self) then VJ_EmitSound(self,"vj_hlr/hl1_npc/bullchicken/bc_acid2.wav",78,100) end end)
	end
	if key == "he_die3" then
		VJ_EmitSound(self,"vj_hlr/hl1_npc/houndeye/he_die3.wav",78,100)
	end
	if key == "attack strike" || key == "attack left" || key == "attack right" then
		self:MeleeAttackCode()
	end
	if key == "range distance" then
		if self.IsZapping then self:ZapAttack(self:GetEnemy()) return end
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HasShield()
	return self:GetNWBool("shield")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ControllerAI()
	local ply = self.VJ_TheController
	local ent = self.VJ_TheControllerBullseye
	local dist = self:VJ_GetNearestPointToEntityDistance(ent)
	local lmb = ply:KeyDown(IN_ATTACK)
	local rmb = ply:KeyDown(IN_ATTACK2)
	local ctrl = ply:KeyDown(IN_DUCK)
	local space = ply:KeyDown(IN_JUMP)
	local alt = ply:KeyDown(IN_WALK)
	self.NextCtrl = self.NextCtrl or CurTime() +1
	self.NextSpace = self.NextSpace or CurTime() +1
	self.NextAlt = self.NextAlt or CurTime() +1
	if ctrl && CurTime() > self.NextCtrl then
		self:SummonAllies()
		self.NextCtrl = CurTime() +1
	end
	if space && CurTime() > self.NextSpace then
		self:UseZapAttack()
		self.NextSpace = CurTime() +1
	end
	if alt && CurTime() > self.NextAlt then
		self:UseTeleport(ent,true)
		self.NextAlt = CurTime() +1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SummonAllies()
	if #self.tbl_Summons <= 3 && CurTime() > self.NextSummonT then
		-- local x = ents.Create(VJ_PICK({
			-- "npc_vj_hlr1_bullsquid",
			-- "npc_vj_hlr1_bullsquid",
			-- "npc_vj_hlr1_bullsquid",
			-- "npc_vj_hlr1_houndeye",
			-- "npc_vj_hlr1_houndeye",
			-- "npc_vj_hlr1_houndeye",
			-- "npc_vj_hlr1_houndeye",
			-- "npc_vj_hlr1_aliencontroller",
			-- "npc_vj_hlr1_aliencontroller",
			-- "npc_vj_hlrsv_babygarg"
		-- }))
		-- x:SetPos(self:GetPos() +self:GetForward() *125)
		-- x:SetAngles(self:GetAngles())
		-- x:Spawn()
		local x = ents.Create("sent_vj_hlr_alientp")
		x:SetPos(self:GetPos() +self:GetForward() *125)
		x:SetAngles(self:GetAngles())
		x:SetNPC("npc_vj_hlr1_bullsquid")
		x:SetNPC("npc_vj_hlr1_bullsquid")
		x:SetNPC("npc_vj_hlr1_bullsquid")
		x:SetNPC("npc_vj_hlr1_houndeye")
		x:SetNPC("npc_vj_hlr1_houndeye")
		x:SetNPC("npc_vj_hlr1_houndeye")
		x:SetNPC("npc_vj_hlr1_aliencontroller")
		x:SetNPC("npc_vj_hlr1_aliencontroller")
		x:SetNPC("npc_vj_hlrsv_garg_baby")
		x:Spawn()
		x.TeleportOwner = self
		-- local blast = ents.Create("prop_combine_ball")
		-- blast:SetPos(self:GetPos() +self:GetForward() *125)
		-- blast:SetParent(x)
		-- blast:Spawn()
		-- blast:Fire("explode","",0)
		-- blast:Fire("disablepuntsound","1")
		-- table.insert(self.tbl_Summons,x)
		if self.VJ_IsBeingControlled then
			self.NextSummonT = CurTime() +5
		else
			self.NextSummonT = CurTime() +math.Rand(8,14)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseZapAttack()
	if CurTime() > self.NextZapT then
		self:VJ_ACT_PLAYACTIVITY("distanceattack", true, false, true, 0)
		timer.Simple(self:SequenceDuration(self:LookupSequence("distanceattack")),function()
			if IsValid(self) then
				self.IsZapping = false
			end
		end)
		self.IsZapping = true
		self.NextZapT = CurTime() +math.Rand(4,5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UseTeleport(ent,forcepos)
	if CurTime() > self.NextTeleportT then
		self:Teleport(ent,forcepos)
		self.NextTeleportT = CurTime() +3
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local ent = self:GetEnemy()
	self.DisableChasingEnemy = self.IsTeleporting
	self.HasMeleeAttack = !self.IsTeleporting
	self.HasRangeAttack = !self.IsTeleporting
	self.GodMode = self.IsTeleporting
	if self:HasShield() then
		self:RemoveAllDecals()
	end
	if CurTime() > self.NextCheckAIT then
		for i = 1,#self.tbl_Summons do
			if !self.tbl_Summons[i] then return end
			if !IsValid(self.tbl_Summons[i]) then
				table.remove(self.tbl_Summons,i)
			end
		end
		self.NextCheckAIT = CurTime() +10
	end
	if self.IsTeleporting then self:StopMoving(); self:StopMoving() end
	if self.VJ_IsBeingControlled then self:ControllerAI() return end
	if IsValid(ent) then
		if self.Dead then return end
		local dist = self:VJ_GetNearestPointToEntityDistance(ent)
		if dist <= 2500 && dist > 150 then
			if !self.RangeAttacking && !self.IsTeleporting && !self.IsZapping && CurTime() > self.NextTeleportT && math.Rand(1,1) == 1 then
				self:Teleport(ent)
			end
			if !self.RangeAttacking && !self.IsTeleporting && !self.IsZapping && CurTime() > self.NextSummonT then
				if math.random(1,50) == 1 then
					self:SummonAllies()
				end
			end
			if !self.RangeAttacking && !self.IsTeleporting && !self.IsZapping && CurTime() > self.NextZapT then
				self:UseZapAttack()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZapAttack(ent)
	if !IsValid(ent) then return end
	if !ent:Visible(self) then return end
	local pos = ent:GetPos() +ent:OBBCenter() +VectorRand() *8
	self:ZapEffect(pos)
	util.VJ_SphereDamage(self,self,pos,30,75,DMG_SHOCK,true,false,{Force=90})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZapEffect(pos,rand)
	if !rand then
		local startpos = self:GetPos() + self:GetUp()*45 + self:GetForward()*40
		local endpos = pos
		local tr = util.TraceLine({
			start = startpos,
			endpos = pos,
			filter = self
		})
		local hitpos = tr.HitPos
		
		local elec = EffectData()
		elec:SetStart(startpos)
		elec:SetOrigin(hitpos)
		elec:SetEntity(self)
		elec:SetAttachment(1)
		util.Effect("VJ_HLR_KINGPIN",elec)
		
		local elec = EffectData()
		elec:SetStart(startpos)
		elec:SetOrigin(hitpos)
		elec:SetEntity(self)
		elec:SetAttachment(2)
		util.Effect("VJ_HLR_KINGPIN",elec)
	else
		local startpos = self:GetPos() + self:GetUp()*45 + self:GetForward()*40
		local tr = util.TraceLine({
			start = startpos,
			endpos = pos,
			filter = self
		})
		if tr.Hit == true then
			local elec = EffectData()
			elec:SetStart(tr.StartPos)
			elec:SetOrigin(tr.HitPos)
			elec:SetEntity(self)
			elec:SetAttachment(1)
			elec:SetScale(math.Rand(0,0.5))
			util.Effect("VJ_HLR_KINGPIN_CHARGE",elec)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Teleport(ent,forcepos)
	local pos = ent:GetPos() +ent:GetForward() *math.Rand(-300,300) +ent:GetRight() *math.Rand(-300,300)
	if forcepos then
		pos = ent:GetPos() +Vector(0,0,5)
	end
	if !ent:VisibleVec(pos) then return end
	if !util.IsInWorld(pos) then return end
	self.NextTeleportT = CurTime() +math.Rand(7,15)
	VJ_EmitSound(self,"vj_hlr/hl1_npc/kingpin/port_suckin1.wav",80,100)
	self.IsTeleporting = true
	for i = 1,math.random(6,10) do
		self:ZapEffect(pos +VectorRand() *90,true)
	end
	timer.Simple(0.5,function()
		if IsValid(self) then
			self:SetNoDraw(true)
			for i = 1,2 do
				self:ZapEffect(pos +VectorRand() *10)
			end
		end
	end)
	timer.Simple(self.TeleportTime,function()
		if IsValid(self) then
			self.IsTeleporting = false
			self:SetPos(pos)
			self:SetNoDraw(false)
			self:TeleportEnd(pos)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TeleportEnd(pos)
	local blast = ents.Create("prop_combine_ball")
	blast:SetPos(pos)
	blast:SetParent(self)
	blast:Spawn()
	blast:Fire("explode","",0)
	blast:Fire("disablepuntsound","1")

	util.VJ_SphereDamage(self,self,pos,400,25,DMG_SHOCK,true,true,{DisableVisibilityCheck=true,Force=80})
	VJ_EmitSound(self,"vj_hlr/hl1_npc/kingpin/port_suckout1.wav",80,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Kingpin_DoElecEffect(sp,hp,a,t)
	local elec = EffectData()
	elec:SetStart(sp)
	elec:SetOrigin(hp)
	elec:SetEntity(self)
	elec:SetAttachment(a)
	elec:SetScale(t)
	util.Effect("VJ_HLR_KINGPIN_CHARGE",elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	-- Tsakh --------------------------
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200,
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*-math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*20,
				endpos = self:GetPos() + self:GetRight()*math.Rand(1,150) + self:GetUp()*200 + self:GetForward()*math.Rand(-100,100),
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt) end
		end
	end)
	
	-- Ach --------------------------
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200,
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*-math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(150,500) + self:GetUp()*-200 + self:GetForward()*math.Rand(150,500),
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
	
	local randt = math.Rand(0,0.35)
	timer.Simple(randt,function()
		if IsValid(self) then
			local tr = util.TraceLine({
				start = self:GetPos() + self:GetUp()*45 + self:GetRight()*-20,
				endpos = self:GetPos() + self:GetRight()*-math.Rand(1,150) + self:GetUp()*200 + self:GetForward()*math.Rand(-100,100),
				filter = self
			})
			if tr.Hit == true then self:Kingpin_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt) end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if self:HasShield() then
		local dmg = dmginfo:GetDamage()
		dmginfo:SetDamage(0)
		VJ_EmitSound(self,"vj_hlr/hl1_npc/kingpin/port_suckin1.wav",70,200)
		self.ShieldHealth = self.ShieldHealth -dmg
		if self.ShieldHealth <= 0 && !self.IsGeneratingShield then
			self:SetNWBool("shield",false)
			self.IsGeneratingShield = true
			timer.Simple(15,function()
				if IsValid(self) then
					self:SetNWBool("shield",true)
					self.IsGeneratingShield = false
					self.ShieldHealth = 250
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
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
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
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
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
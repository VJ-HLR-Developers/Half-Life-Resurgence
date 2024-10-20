AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/prdroid.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL -- How the NPC moves around
ENT.Aerial_FlyingSpeed_Calm = 100 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking compared to ground NPCs
ENT.Aerial_FlyingSpeed_Alerted = 200 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running compared to ground NPCs
ENT.VJC_Data = {
	FirstP_Bone = "sphere01", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(15, 0, -3), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this NPC be friends with other player allies?
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?

ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.MeleeAttackDamage = 20
ENT.MeleeAttackDistance = 55 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasRangeAttack = true -- Can this NPC range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_hlr1_probed_needle" -- Entities that it can spawn when range attacking | If set as a table, it picks a random entity
ENT.RangeDistance = 1500 -- How far can it range attack?
ENT.RangeToMeleeDistance = 110 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the needle code is ran?
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 4 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code

ENT.NoChaseAfterCertainRange = true -- Should the NPC stop chasing when the enemy is within the given far and close distances?
ENT.NoChaseAfterCertainRange_FarDistance = "UseRangeDistance" -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = "UseRangeDistance" -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_Type = "OnlyRange" -- "Regular" = Default behavior | "OnlyRange" = Only does it if it's able to range attack

ENT.IsMedicSNPC = true -- Is this NPC a medic? It will heal friendly players and NPCs
ENT.AnimTbl_Medic_GiveHealth = ACT_ARM -- Animations is plays when giving health to an ally
ENT.Medic_CheckDistance = 1000 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 600 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_NextHealTime = VJ.SET(5, 8) -- How much time until it can give health to an ally again
ENT.Medic_SpawnPropOnHeal = false -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_CanBeHealed = false -- Can this NPC be healed by medics?

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathAnimationTime = 0.6 -- How long should the death animation play?
ENT.HasDeathCorpse = false -- Should a corpse spawn when it's killed?
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Breath = "vj_hlr/hla_npc/prdroid/engine.wav"
ENT.SoundTbl_MedicAfterHeal = "vj_hlr/hla_npc/prdroid/shoot_heal.wav"
ENT.SoundTbl_Alert = "vj_hlr/hla_npc/prdroid/alert.wav"
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav", "vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_BeforeRangeAttack = "vj_hlr/hla_npc/prdroid/readytoattack.wav"
ENT.SoundTbl_RangeAttack = "vj_hlr/hla_npc/prdroid/shoot.wav"
ENT.SoundTbl_Death = "vj_hlr/hla_npc/prdroid/die.wav"

ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 80)
--
function ENT:Init()
	self:SetCollisionBounds(Vector(35, 35, 15), Vector(-35, -35, -50))
	self:SetPos(self:GetPos() + spawnPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("Hold-SPACE: Fires healing needle while range attacking")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "melee" then
		self:MeleeAttackCode()
	elseif key == "shoot" then
		self:RangeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_FLY then
		return ACT_IDLE
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMedicBehavior(status, statusData)
	if status == "BeforeHeal" then
		VJ.EmitSound(self, "vj_hlr/hla_npc/prdroid/readytoattack.wav", 90, 100) -- Preparing sound same as range attack
	elseif status == "OnHeal" then
		self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1, true, 0, true, 0, {OnFinish = function()
			self:VJ_ACT_PLAYACTIVITY(ACT_RELOAD, true, false, true)
			VJ.EmitSound(self, "vj_hlr/hla_npc/prdroid/reload.wav", 90, 100) -- Reload sound
		end})
		local attPos = self:GetAttachment(self:LookupAttachment("0")).Pos
		local needle = ents.Create("obj_vj_hlr1_probed_needle")
		needle:SetPos(attPos)
		needle:SetAngles((statusData:GetPos() - needle:GetPos()):Angle())
		needle:SetOwner(self)
		needle:SetPhysicsAttacker(self)
		needle.Needle_Heal = true
		needle:Spawn()
		needle:Activate()
		local phys = needle:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(self:CalculateProjectile("Line", attPos, self:GetAimPosition(statusData, attPos, 1, 1500), 1500))
		end
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--  ACT_RANGE_ATTACK2 -- Rapid firing (3-shot burst) range attack animation | !!! UNUSED !!!
--
function ENT:CustomOnRangeAttack_BeforeStartTimer()
	local anim, animDur = self:VJ_ACT_PLAYACTIVITY(ACT_ARM, false, 0, true, 0, {OnFinish = function()
		self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1, false, 0, true, 0, {OnFinish = function()
			self:VJ_ACT_PLAYACTIVITY(ACT_RELOAD, true, false, true)
			VJ.EmitSound(self, "vj_hlr/hla_npc/prdroid/reload.wav", 90, 100) -- Reload sound
		end})
	end})
	self.CurrentAttackAnimation = anim
	self.CurrentAttackAnimationDuration = animDur + VJ.AnimDuration(self, ACT_RANGE_ATTACK1)
	self.CurrentAttackAnimationTime = CurTime() + self.CurrentAttackAnimationDuration
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
	if self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP) then
		projectile.Needle_Heal = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjSpawnPos(projectile)
	return self:GetAttachment(self:LookupAttachment("0")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVelocity(projectile)
	local projPos = projectile:GetPos()
	return self:CalculateProjectile("Line", projPos, self:GetAimPosition(self:GetEnemy(), projPos, 1, 1500), 1500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Initial" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local collideSds = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" && dmginfo:IsDamageType(DMG_BLAST) then
		self.HasDeathAnimation = false
	elseif status == "Finish" then
		VJ.ApplyRadiusDamage(self, self, self:GetPos(), 75, 25, DMG_BLAST, false, true)
		VJ.EmitSound(self, "vj_hlr/hla_npc/prdroid/explode.wav", 90, 100)
		local applyForce = self.HasDeathAnimation and false or true
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_cap.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("sphere01")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_armpiece.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed011")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_armpiece.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed007")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_claw.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed012")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_claw.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed008")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_dshooter.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed005")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_tail.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed014")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_upperarm.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed011")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_upperarm.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed007")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_body.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed003")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_forearm.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed011")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/pb_forearm.mdl", {BloodDecal="", Ang=self:GetAngles(), Pos=self:GetBonePosition(self:LookupBone("unnamed007")), CollideSound=collideSds, Vel_ApplyDmgForce=applyForce})

		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
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
		spr:SetKeyValue("scale", "2")
		spr:SetPos(self:GetPos())
		spr:Spawn()
		spr:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
	end
end
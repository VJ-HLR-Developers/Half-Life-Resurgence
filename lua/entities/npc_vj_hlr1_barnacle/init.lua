AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/barnacle.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.SightDistance = 1024 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.StartHealth = 30
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How the NPC moves around
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.HullType = HULL_SMALL_CENTERED
ENT.VJC_Data = {
	FirstP_Bone = "bone01", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, -44), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hlr_blood_red"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB -- Type of Damage
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 10 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDistance = 30 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the NPC | 180 = All around the NPC
ENT.MeleeAttackDamageAngleRadius = 120 -- What is the damage angle radius? | 100 = In front of the NPC | 180 = All around the NPC

ENT.CanReceiveOrders = false -- Can the NPC receive orders from others? | Ex: Allies calling for help, allies requesting backup on damage, etc.
ENT.BringFriendsOnDeath = false -- Should the NPC's allies come to its position while it's dying?
ENT.AlertFriendsOnDeath = true -- Should the NPC's allies get alerted while it's dying? | Its allies will also need to have this variable set to true!
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForHelp = false -- Can the NPC request allies for help while in combat?
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_SMALL_FLINCH -- The regular flinch animations to play
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = ACT_DIESIMPLE
ENT.DeathCorpseEntityClass = "prop_vj_animatable" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/barnacle/bcl_tongue1.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_hlr/hl1_npc/barnacle/bcl_chew1.wav","vj_hlr/hl1_npc/barnacle/bcl_chew2.wav","vj_hlr/hl1_npc/barnacle/bcl_chew3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/barnacle/bcl_die1.wav","vj_hlr/hl1_npc/barnacle/bcl_die3.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Barnacle_LastHeight = 180
ENT.Barnacle_CurEnt = NULL
ENT.Barnacle_CurEntMoveType = MOVETYPE_WALK
ENT.Barnacle_PullingEnt = false
ENT.Barnacle_NextPullSoundT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(18, 18, 0), Vector(-18, -18, -50))
	//VJ.GetPoseParameters(self) -- tongue_height 0 / 1024
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "melee_attack" then
		self:MeleeAttackCode()
	end
	if key == "death_gibs" then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(1,0,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,2,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(3,0,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,4,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_bone.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(5,0,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_gib.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,6,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_guts.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(-1,0,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_hmeat.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,-2,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_lung.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(-3,0,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(0,-4,-30))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_legbone.mdl",{BloodDecal="VJ_HLR_Blood_Red",Pos=self:LocalToWorld(Vector(-5,0,-30))})
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*hook.Add("SetupMove", "VJ_Barnacle_SetupMove", function(ply, mv)
	-- Make the player not be able to walk
	if ply.Barnacle_Grabbed == true then
    	mv:SetMaxClientSpeed(0)
	end
end)*/
---------------------------------------------------------------------------------------------------------------------------------------------
local velInitial = Vector(0, 0, 2)
--
function ENT:Barnacle_CalculateTongue()
	//print(self.Barnacle_LastHeight)
	local myPos = self:GetPos()
	local myUpPos = self:GetUp()
	local tr = util.TraceLine({
		start = myPos,
		endpos = myPos + myUpPos * -self.Barnacle_LastHeight,
		filter = self
	})
	local trHitEnt = tr.Entity
	local trHitPos = tr.HitPos
	local height = myPos:Distance(trHitPos)
	-- Increase the height by 10 every tick | minimum = 0, maximum = 1024
	self.Barnacle_LastHeight = math.Clamp(height + 10, 0, 1024)

	if IsValid(trHitEnt) && (trHitEnt:IsNPC() or trHitEnt:IsPlayer()) && self:CheckRelationship(trHitEnt) == D_HT && trHitEnt.VJTag_ID_Boss != true then
		-- If the grabbed enemy is a new enemy then reset the enemy values
		if self.Barnacle_CurEnt != trHitEnt then
			self:Barnacle_ResetEnt()
			self.Barnacle_CurEntMoveType = trHitEnt:GetMoveType()
		end
		self.Barnacle_CurEnt = trHitEnt
		trHitEnt:AddEFlags(EFL_IS_BEING_LIFTED_BY_BARNACLE)
		if trHitEnt:IsNPC() then
			trHitEnt:StopMoving()
			trHitEnt:SetVelocity(velInitial)
			trHitEnt:SetMoveType(MOVETYPE_FLY)
		elseif trHitEnt:IsPlayer() then
			trHitEnt:SetMoveType(MOVETYPE_NONE)
			//trHitEnt:AddFlags(FL_ATCONTROLS)
		end
		trHitEnt:SetGroundEntity(NULL)
		-- Make it pull the enemy up
		if height >= 50 then
			trHitEnt:SetPos(Vector(trHitPos.x, trHitPos.y, (trHitEnt:GetPos() + trHitEnt:GetUp() * 5).z)) -- Set the position for the enemy
			if CurTime() > self.Barnacle_NextPullSoundT then -- Play the pulling sound
				VJ.EmitSound(self, "vj_hlr/hl1_npc/barnacle/bcl_alert2.wav")
				self.Barnacle_NextPullSoundT = CurTime() + 2.7950113378685 // Magic number is the sound duration of "bcl_alert2.wav"
			end
		end
		self:SetPoseParameter("tongue_height", myPos:Distance(trHitPos + myUpPos * 125))
		return true
	else
		self:Barnacle_ResetEnt()
	end
	self:SetPoseParameter("tongue_height", myPos:Distance(trHitPos + myUpPos * 193))
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Barnacle_ResetEnt()
	if !IsValid(self.Barnacle_CurEnt) then return end
	self.Barnacle_CurEnt:RemoveEFlags(EFL_IS_BEING_LIFTED_BY_BARNACLE)
	//self.Barnacle_CurEnt:RemoveFlags(FL_ATCONTROLS)
	self.Barnacle_CurEnt:SetMoveType(self.Barnacle_CurEntMoveType) -- Reset the enemy's move type
	self.Barnacle_CurEnt = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		return (self.Barnacle_PullingEnt and ACT_BARNACLE_PULL) or ACT_IDLE
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Dead then return end
	self.Barnacle_PullingEnt = self:Barnacle_CalculateTongue()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp)
	if hitEnt.IsVJBaseSNPC_Human then -- Make human NPCs die instantly
		self.MeleeAttackDamage = hitEnt:Health() + 10
	elseif hitEnt:IsPlayer() then
		self.MeleeAttackDamage = 80
	else
		self.MeleeAttackDamage = 100
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:CustomAttackCheck_MeleeAttack()
	return IsValid(self.Barnacle_CurEnt)
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilledEnemy(ent, inflictor, wasLast)
	VJ.EmitSound(self, "vj_hlr/hl1_npc/barnacle/bcl_bite3.wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		self:Barnacle_ResetEnt()
	elseif status == "Finish" then
		self:SetPos(self:GetPos() + self:GetUp()*-4)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	corpseEnt:DrawShadow(false)
	corpseEnt:ResetSequence("Death")
	corpseEnt:SetCycle(1)
	corpseEnt:SetPoseParameter("tongue_height", 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibOnDeathEffects == true then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos() + self:OBBCenter())
		effectData:SetColor(colorRed)
		effectData:SetScale(120)
		util.Effect("VJ_Blood1", effectData)
		effectData:SetScale(8)
		effectData:SetFlags(3)
		effectData:SetColor(0)
		util.Effect("bloodspray", effectData)
		util.Effect("bloodspray", effectData)
	end
	
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,1,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,2,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,3,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,4,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,5,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,6,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,-1,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,-2,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh1.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,-3,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh2.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,-4,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh3.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,-5,-20))})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/flesh4.mdl", {BloodDecal="VJ_HLR_Blood_Red", Pos=self:LocalToWorld(Vector(0,-6,-20))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ.EmitSound(self, "vj_base/gib/splat.wav", 90, 100)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self:Barnacle_ResetEnt()
end
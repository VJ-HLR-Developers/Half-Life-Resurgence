AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/baby_voltigore.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 80
ENT.HullType = HULL_MEDIUM
ENT.VJC_Data = {
    ThirdP_Offset = Vector(25, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bone41", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(3, 0, 2), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.MeleeAttackDamage = 15
ENT.AnimTbl_MeleeAttack = {"vjseq_mattack2","vjseq_mattack3"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 25 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 50 -- How far does the damage go?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {"vjseq_distanceattack"} -- Range Attack Animations
ENT.RangeDistance = 1000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 100 -- How close does it have to be until it uses melee?
ENT.NextRangeAttackTime = 15 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 20 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIEBACKWARD,ACT_DIEFORWARD,ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_hlr/hl1_npc/voltigore/voltigore_footstep1.wav","vj_hlr/hl1_npc/voltigore/voltigore_footstep2.wav","vj_hlr/hl1_npc/voltigore/voltigore_footstep3.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/voltigore/voltigore_idle1.wav","vj_hlr/hl1_npc/voltigore/voltigore_idle2.wav","vj_hlr/hl1_npc/voltigore/voltigore_idle3.wav"}
ENT.SoundTbl_IdleDialogue = {"vj_hlr/hl1_npc/voltigore/voltigore_communicate1.wav","vj_hlr/hl1_npc/voltigore/voltigore_communicate2.wav","vj_hlr/hl1_npc/voltigore/voltigore_communicate3.wav"}
ENT.SoundTbl_IdleDialogueAnswer = {"vj_hlr/hl1_npc/voltigore/voltigore_communicate1.wav","vj_hlr/hl1_npc/voltigore/voltigore_communicate2.wav","vj_hlr/hl1_npc/voltigore/voltigore_communicate3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/voltigore/voltigore_alert1.wav","vj_hlr/hl1_npc/voltigore/voltigore_alert2.wav","vj_hlr/hl1_npc/voltigore/voltigore_alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/hl1_npc/voltigore/voltigore_attack_melee1.wav","vj_hlr/hl1_npc/voltigore/voltigore_attack_melee2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/voltigore/voltigore_pain1.wav","vj_hlr/hl1_npc/voltigore/voltigore_pain2.wav","vj_hlr/hl1_npc/voltigore/voltigore_pain3.wav","vj_hlr/hl1_npc/voltigore/voltigore_pain4.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/voltigore/voltigore_die1.wav","vj_hlr/hl1_npc/voltigore/voltigore_die2.wav","vj_hlr/hl1_npc/voltigore/voltigore_die3.wav"}

ENT.FootStepSoundLevel = 55
ENT.FootStepPitch = VJ_Set(130, 130)
ENT.GeneralSoundPitch1 = 120
ENT.GeneralSoundPitch2 = 125
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 40), Vector(-20, -20, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "single" or key == "both" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Vort_DoElecEffect(sp,hp,a,t)
	local elec = EffectData()
	elec:SetStart(sp)
	elec:SetOrigin(hp)
	elec:SetEntity(self)
	elec:SetAttachment(a)
	elec:SetScale(t)
	util.Effect("VJ_HLR_Electric_Charge_Purple",elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	local randt = 0.9
	local tr = util.TraceLine({
		start = self:GetAttachment(self:LookupAttachment("0")).Pos,
		endpos = self:GetAttachment(self:LookupAttachment("3")).Pos,
		filter = self
	})
	self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 0, randt)
	
	local tr = util.TraceLine({
		start = self:GetAttachment(self:LookupAttachment("1")).Pos,
		endpos = self:GetAttachment(self:LookupAttachment("3")).Pos,
		filter = self
	})
	self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 1, randt)
	
	local tr = util.TraceLine({
		start = self:GetAttachment(self:LookupAttachment("2")).Pos,
		endpos = self:GetAttachment(self:LookupAttachment("3")).Pos,
		filter = self
	})
	self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, 2, randt)
	
	self.Glow1 = ents.Create("env_sprite")
	self.Glow1:SetKeyValue("model","vj_hl/sprites/flare3.vmt")
	self.Glow1:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	self.Glow1:SetKeyValue("renderfx","14")
	self.Glow1:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	self.Glow1:SetKeyValue("renderamt","255") -- Transparency
	self.Glow1:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	self.Glow1:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	self.Glow1:SetKeyValue("spawnflags","0")
	self.Glow1:SetParent(self)
	self.Glow1:Fire("SetParentAttachment","3")
	self.Glow1:Spawn()
	self.Glow1:Activate()
	self:DeleteOnRemove(self.Glow1)
	timer.Simple(randt,function() if IsValid(self) && IsValid(self.Glow1) then self.Glow1:Remove() end end)
	
	if math.random(1,150) == 1 then
		timer.Simple(1, function()
			if IsValid(self) then
				local d = DamageInfo()
				d:SetDamage(self:Health() + 10)
				d:SetAttacker(self)
				d:SetInflictor(self)
				d:SetDamageType(DMG_ALWAYSGIB)
				self:TakeDamageInfo(d)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	self.HasDeathSounds = false
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() + self:OBBCenter())
		effectdata:SetScale(1)
		util.Effect("StriderBlood",effectdata)
		util.Effect("StriderBlood",effectdata)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_HLR_Blood_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo, hitgroup)
	VJ_EmitSound(self, "vj_gib/default_gib_splat.wav", 90, math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Antlion.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 30
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ANTLION"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_yellow_01"}
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,"pounce","pounce2"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 10
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_Postures = "Moving" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 500 -- How close does it have to be until it starts to face the enemy?
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/antlion/foot1.wav","npc/antlion/foot2.wav","npc/antlion/foot3.wav","npc/antlion/foot4.wav"}
ENT.SoundTbl_Idle = {
	"npc/antlion/idle1.wav",
	"npc/antlion/idle2.wav",
	"npc/antlion/idle3.wav",
	"npc/antlion/idle4.wav",
	"npc/antlion/idle5.wav",
}
ENT.SoundTbl_Alert = {
	"npc/antlion/distract1.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"npc/antlion/attack_single1.wav",
	"npc/antlion/attack_single2.wav",
	"npc/antlion/attack_single3.wav",
}
ENT.SoundTbl_Pain = {
	"npc/antlion/pain1.wav",
	"npc/antlion/pain2.wav",
}
ENT.SoundTbl_Death = {
	"npc/antlion/pain1.wav",
	"npc/antlion/pain2.wav",
}

ENT.MaxJumpHeight = 1000
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsJumpLegal(startPos,apex,endPos)
	local result = self:CustomOnIsJumpLegal(startPos,apex,endPos)
	if result != nil then if result == true then self.JumpLegalLandingTime = CurTime() + (endPos:Distance(startPos) / 190) end return result end
	local dist_apex = startPos:Distance(apex)
	local dist_end = startPos:Distance(apex)
	if dist_apex > self.MaxJumpHeight then return nil end
	if dist_end > self.MaxJumpHeight then return nil end
	self.JumpLegalLandingTime = CurTime() + (endPos:Distance(startPos) / 190)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsDirt(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos -Vector(0,0,40),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	local mat = tr.MatType
	return tr.HitWorld && (mat == MAT_SAND || mat == MAT_DIRT || mat == MAT_FOLIAGE || mat == MAT_SLOSH || mat == 85)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Dig(forceRemove)
	if self:IsDirt(self:GetPos()) then
		self:SetNoDraw(true)
		self.IsDigging = true
		timer.Simple(0.02,function()
			if IsValid(self) then
				self:VJ_ACT_PLAYACTIVITY("digout",true,VJ_GetSequenceDuration(self,"digout"),false)
				self.HasMeleeAttack = false
				timer.Simple(0.15,function() if IsValid(self) then self:SetNoDraw(false) end end)
				timer.Simple(VJ_GetSequenceDuration(self,"digout"),function() if IsValid(self) then self.HasMeleeAttack = true self.IsDigging = false end end)
			end
		end)
	else
		if forceRemove then self:Remove() end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20,20,64),Vector(-20,-20,0))
	self:SetSkin(math.random(0,3))
	if self:GetSkin() > 0 then
		local mul = self:GetSkin()
		if self:GetSkin() == 1 then
			mul = 2
		end
		local hp = self:Health() *mul
		self:SetHealth(hp)
		self:SetMaxHealth(hp)
		self.DefaultDamage = self.MeleeAttackDamage *mul
		self.MeleeAttackDamage = self.DefaultDamage
	end
	self.FlyLoop = CreateSound(self,"npc/antlion/fly1.wav")
	self.FlyLoop:SetSoundLevel(80)
	self.IsDigging = false
	self:Dig()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.FlyLoop:IsPlaying() then
		if self:GetSequenceActivity(self:GetSequence()) == 27 or self:GetSequenceActivity(self:GetSequence()) == 30 then
			return
		end
		self.FlyLoop:Stop()
		self:SetBodygroup(1,0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert()
	if self.IsDiging == true then return end
	if math.random(1,6) == 1 then
		local tbl = VJ_PICKRANDOMTABLE({"distract","roar"})
		self:VJ_ACT_PLAYACTIVITY(tbl,true,VJ_GetSequenceDuration(self,tbl),false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnHandleAnimEvent(ev,evTime,evCycle,evType,evOptions)
	local key = ev
	-- print(key)
	if key == 76 then
		self.MeleeAttackDamage = self.DefaultDamage
		self:MeleeAttackCode()
	end
	if key == 78 then
		self.MeleeAttackDamage = self.DefaultDamage *1.5
		self:MeleeAttackCode()
	end
	if key == 75 then
		self:FootStepSoundCode()
	end
	if key == 83 then
		self:EmitSound("physics/concrete/concrete_break2.wav",80,100)
		VJ_EmitSound(self,"npc/antlion/digup1.wav",75,100)
		ParticleEffect("advisor_plat_break",self:GetPos(),self:GetAngles(),self)
		ParticleEffect("strider_impale_ground",self:GetPos(),self:GetAngles(),self)
	end
	if key == 79 || key == 80 then
		VJ_EmitSound(self,"npc/antlion/shell_impact" .. math.random(1,4) .. ".wav",75,100)
	end
	if key == 78 then
		VJ_EmitSound(self,"npc/antlion/attack_double" .. math.random(1,3) .. ".wav",75,100)
	end
	if key == 85 then
		self:SetBodygroup(1,1)
		self.FlyLoop:Play()
	end
	if key == 86 then
		self:SetBodygroup(1,0)
		self.FlyLoop:Stop()
		VJ_EmitSound(self,"npc/antlion/land1.wav",75,100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.FlyLoop:Stop()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
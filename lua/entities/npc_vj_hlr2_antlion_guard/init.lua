AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/antlion_guard.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ANTLION"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 70 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 150 -- How far does the damage go?
ENT.MeleeAttackDamage = 85
ENT.MeleeAttackDamageType = DMG_CRUSH
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 400 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 500 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 300 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 300 -- How far it will push you up | Second in math.random
ENT.Immune_Physics = true
ENT.FootStepTimeRun = 0.21 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.GeneralSoundPitch1 = 100
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/antlion_guard/foot_heavy1.wav","npc/antlion_guard/foot_heavy2.wav","npc/antlion_guard/foot_light1.wav","npc/antlion_guard/foot_light2.wav"}
ENT.SoundTbl_Death = {"npc/antlion_guard/antlion_guard_die1.wav","npc/antlion_guard/antlion_guard_die2.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"npc/antlion_guard/angry1.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/antlion_guard/shove1.wav"}

ENT.IsGuardian = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(45,45,115),Vector(-45,-45,0))
	self.IsDiging = false
	if self.IsGuardian then self:SetSkin(1) end
	if self:IsDirt(self:GetPos()) then
		self.IsDiging = true
		self:SetNoDraw(true)
		self:VJ_ACT_PLAYACTIVITY("floor_break",true,VJ_GetSequenceDuration(self,"floor_break"),false)
		self.HasMeleeAttack = false
		timer.Simple(0.5,function()
			if self:IsValid() then
				self:SetNoDraw(false)
				self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				if self.IsGuardian then self:CreateEffects() end
			end
		end)
		timer.Simple(0.7,function()
			if self:IsValid() then
				self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
			end
		end)
		timer.Simple(1.4,function()
			if self:IsValid() then
				self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
			end
		end)
		timer.Simple(2,function()
			if self:IsValid() then
				self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
			end
		end)
		timer.Simple(2.5,function()
			if self:IsValid() then
				self:EmitSound("physics/concrete/concrete_break2.wav",110,100)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("advisor_plat_break",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
				ParticleEffect("strider_impale_ground",self:GetPos() +VectorRand() *50,self:GetAngles(),nil)
			end
		end)
		timer.Simple(VJ_GetSequenceDuration(self,"floor_break"),function()
			if self:IsValid() then
				self.IsDiging = false
				self.HasMeleeAttack = true
			end
		end)
	else
		if self.IsGuardian then self:CreateEffects() end
	end
	//charge_cancel, charge_crash, charge_loop, charge_stop, floor_break, flinch1, flinch2, pain
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateEffects()
	local glow1 = ents.Create("env_sprite")
	glow1:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow1:SetKeyValue("scale","1")
	glow1:SetKeyValue("rendermode","5")
	glow1:SetKeyValue("rendercolor","127 225 0")
	glow1:SetKeyValue("spawnflags","1") -- If animated
	glow1:SetParent(self)
	glow1:Fire("SetParentAttachment","attach_glow1",0)
	glow1:Spawn()
	glow1:Activate()
	self:DeleteOnRemove(glow1)
	local glow2 = ents.Create("env_sprite")
	glow2:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow2:SetKeyValue("scale","0.4")
	glow2:SetKeyValue("rendermode","5")
	glow2:SetKeyValue("rendercolor","127 225 0")
	glow2:SetKeyValue("spawnflags","1") -- If animated
	glow2:SetParent(self)
	glow2:Fire("SetParentAttachment","attach_glow2",0)
	glow2:Spawn()
	glow2:Activate()
	self:DeleteOnRemove(glow2)
	local glow3 = ents.Create("env_sprite")
	glow3:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow3:SetKeyValue("scale","0.4")
	glow3:SetKeyValue("rendermode","5")
	glow3:SetKeyValue("rendercolor","127 225 0")
	glow3:SetKeyValue("spawnflags","1") -- If animated
	glow3:SetParent(self)
	glow3:Fire("SetParentAttachment","0",0)
	glow3:Spawn()
	glow3:Activate()
	self:DeleteOnRemove(glow3)
	local glow4 = ents.Create("env_sprite")
	glow4:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow4:SetKeyValue("scale","0.4")
	glow4:SetKeyValue("rendermode","5")
	glow4:SetKeyValue("rendercolor","127 225 0")
	glow4:SetKeyValue("spawnflags","1") -- If animated
	glow4:SetParent(self)
	glow4:Fire("SetParentAttachment","1",0)
	glow4:Spawn()
	glow4:Activate()
	self:DeleteOnRemove(glow4)
	local glowlight = ents.Create("light_dynamic")
	glowlight:SetKeyValue("_light","127 225 0 200")
	glowlight:SetKeyValue("brightness","1")
	glowlight:SetKeyValue("distance","200")
	glowlight:SetKeyValue("style","0")
	glowlight:SetPos(self:GetPos())
	glowlight:SetParent(self)
	glowlight:Spawn()
	glowlight:Activate()
	glowlight:Fire("SetParentAttachment","attach_glow2")
	glowlight:Fire("TurnOn","",0)
	glowlight:DeleteOnRemove(self)
	local glowlight_top = ents.Create("light_dynamic")
	glowlight_top:SetKeyValue("_light","127 225 0 200")
	glowlight_top:SetKeyValue("brightness","2")
	glowlight_top:SetKeyValue("distance","150")
	glowlight_top:SetKeyValue("style","0")
	glowlight_top:SetPos(self:GetPos())
	glowlight_top:SetParent(self)
	glowlight_top:Spawn()
	glowlight_top:Activate()
	glowlight_top:Fire("SetParentAttachment","attach_glow1")
	glowlight_top:Fire("TurnOn","",0)
	glowlight_top:DeleteOnRemove(self)
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
function ENT:CustomOnAlert()
	if self.IsDiging == true then return end
	if math.random(1,3) == 1 then
		local tbl = VJ_PICKRANDOMTABLE({"bark","roar"})
		self:VJ_ACT_PLAYACTIVITY(tbl,true,VJ_GetSequenceDuration(self,tbl),false)
		if tbl == "bark" && self.IsGuardian then
			timer.Simple(0.5,function()
				if self:IsValid() then
					VJ_CreateSound(self,"npc/antlion_guard/angry2.wav",95,100)
					self:CreateAntlion(self:GetRight()*math.random(-350,350) +self:GetForward()*math.random(-350,350))
					self:CreateAntlion(self:GetRight()*math.random(-350,350) +self:GetForward()*math.random(-350,350))
					self:CreateAntlion(self:GetRight()*math.random(-350,350) +self:GetForward()*math.random(-350,350))
					self:CreateAntlion(self:GetRight()*math.random(-350,350) +self:GetForward()*math.random(-350,350))
					self:CreateAntlion(self:GetRight()*math.random(-350,350) +self:GetForward()*math.random(-350,350))
				end
			end)
			timer.Simple(1,function()
				if self:IsValid() then
					VJ_CreateSound(self,"npc/antlion_guard/angry3.wav",95,100)
				end
			end)
			timer.Simple(1.65,function()
				if self:IsValid() then
					self:EmitSound("npc/antlion_guard/angry2.wav",95,100)
				end
			end)
		else
			timer.Simple(1.4,function()
				if self:IsValid() then
					VJ_CreateSound(self,"npc/antlion_guard/angry1.wav",95,100)
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateAntlion(pos)
	local antlion = ents.Create("npc_vj_hlr2_antlion")
	antlion:SetPos(self:GetPos() +pos +Vector(0,0,10))
	antlion:SetAngles(self:GetAngles())
	antlion:Spawn()
	antlion:Activate()
	antlion:Dig(true)
	ParticleEffect("advisor_plat_break",antlion:GetPos(),antlion:GetAngles(),antlion)
	ParticleEffect("strider_impale_ground",antlion:GetPos(),antlion:GetAngles(),antlion)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if dmginfo:IsBulletDamage() then
		dmginfo:SetDamage(math.random(1,2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self.NextMeleeAttackTime = self.CurrentAttackAnimationDuration
	self.NextAnyAttackTime_Melee = self.CurrentAttackAnimationDuration
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
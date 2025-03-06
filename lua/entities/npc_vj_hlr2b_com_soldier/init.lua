AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2b/combine_soldier.mdl"
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodParticle = {"blood_impact_red_01_mist"}
ENT.MeleeAttackDamage = 10
ENT.HasGrenadeAttack = true
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl"
ENT.GrenadeAttackAttachment = "righthand"
ENT.AnimTbl_WeaponAttackSecondary = "vjseq_shoot_ar2grenade"
ENT.Weapon_SecondaryFireTime = 0.55

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = "vjges_flinch_gesture"

//ENT.SoundTbl_FootStep = {"npc/combine_soldier/gear1.wav", "npc/combine_soldier/gear2.wav", "npc/combine_soldier/gear3.wav", "npc/combine_soldier/gear4.wav", "npc/combine_soldier/gear5.wav", "npc/combine_soldier/gear6.wav"}
ENT.SoundTbl_CombatIdle = {
	"vj_hlr/src/npc/combine_soldier_beta/go_alert1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/go_alert2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/go_alert3.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vj_hlr/src/npc/combine_soldier_beta/lost_long1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/lost_long2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/lost_long3.wav",
	"vj_hlr/src/npc/combine_soldier_beta/lost_short1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/lost_short2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/lost_short3.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/src/npc/combine_soldier_beta/announce1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/announce2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/announce3.wav",
	"vj_hlr/src/npc/combine_soldier_beta/refind_enemy1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/refind_enemy2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/refind_enemy3.wav",
}
ENT.SoundTbl_GrenadeAttack = {
	"vj_hlr/src/npc/combine_soldier_beta/throw_grenade1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/throw_grenade2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/throw_grenade3.wav",
}
ENT.SoundTbl_DangerSight = {
	"vj_hlr/src/npc/combine_soldier_beta/spot_grenade1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/spot_grenade2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/spot_grenade3.wav",
}
ENT.SoundTbl_KilledEnemy = {
	"vj_hlr/src/npc/combine_soldier_beta/player_dead1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/player_dead2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/player_dead3.wav",
}
ENT.SoundTbl_AllyDeath = {
	"vj_hlr/src/npc/combine_soldier_beta/man_down1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/man_down2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/man_down3.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/src/npc/combine_soldier_beta/assault1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/assault2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/assault3.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/src/npc/combine_soldier_beta/die1.wav",
	"vj_hlr/src/npc/combine_soldier_beta/die2.wav",
	"vj_hlr/src/npc/combine_soldier_beta/die3.wav",
}

/* -- Vault over objects test
ENT.CanClimb = true
ENT.IsClimbing = false
ENT.NextClimbT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self.CanClimb == true && !self.Dead && self.IsClimbing == false && CurTime() > self.NextClimbT then
		local anim = false
		local finalpos = self:GetPos()
		local tr1 = util.TraceLine({start = self:GetPos() + self:GetUp()*32, endpos = self:GetPos() + self:GetUp()*32 +self:GetForward() *200, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end}) -- 32
		local tru = util.TraceLine({start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*100, filter = self})
		if !IsValid(tru.Entity) then
			if IsValid(tr1.Entity) then
				anim = "vjseq_Run_jumpup_32"
				finalpos = tr1.HitPos +self:GetForward() *25
			end
			if anim != false then
			-- VJ.DEBUG_TempEnt(tr1.StartPos,self:GetAngles(),Color(0,0,255))
			-- VJ.DEBUG_TempEnt(finalpos,self:GetAngles(),Color(0,255,0))
				self:SetGroundEntity(NULL)
				self.IsClimbing = true
				timer.Simple(1.21,function()
					if IsValid(self) then
						self:SetPos(finalpos)
					end
				end)
				self:PlayAnim(anim,true,false,true,0,{},function(sched)
					sched.RunCode_OnFinish = function()
						self.IsClimbing = false
					end
				end)
			end
			self.NextClimbT = CurTime() + 0.1
		end
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAnimationTranslations(wepHoldType)
	-- Most animations don't need translating as they are the same as the default activity name
	self.AnimationTranslations[ACT_GESTURE_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_AR2
	self.AnimationTranslations[ACT_COVER_LOW] = {ACT_COVER_LOW, "vjseq_crouch_leanwall_idle01"}
	
	self.AnimationTranslations[ACT_WALK_CROUCH] = ACT_WALK_CROUCH_RIFLE
	self.AnimationTranslations[ACT_WALK_CROUCH_AIM] = ACT_WALK_CROUCH_AIM_RIFLE
	
	self.AnimationTranslations[ACT_RUN_CROUCH] = ACT_RUN_CROUCH_RIFLE
	self.AnimationTranslations[ACT_RUN_CROUCH_AIM] = ACT_RUN_CROUCH_AIM_RIFLE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_Death, sdFile) then
		VJ.EmitSound(self,"vj_hlr/src/npc/combine_soldier_beta/click_terminated.wav")
		return
	end
	VJ.EmitSound(self,"vj_hlr/src/npc/combine_soldier_beta/clik.wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self,"vj_hlr/src/npc/combine_soldier_beta/click_off.wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnGrenadeAttackExecute(status, grenade, overrideEnt, landDir, landingPos)
	if status == "PostSpawn" && !IsValid(overrideEnt) then
		-- Glow and trail are both based on the original: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/hl2/grenade_frag.cpp#L158
		local redGlow = ents.Create("env_sprite")
		redGlow:SetKeyValue("model", "sprites/redglow1.vmt")
		redGlow:SetKeyValue("scale", "0.2")
		redGlow:SetKeyValue("rendermode", "3") -- kRenderGlow
		redGlow:SetKeyValue("renderfx", "14") -- kRenderFxNoDissipation
		redGlow:SetKeyValue("renderamt", "200")
		redGlow:SetKeyValue("rendercolor", "255 255 255")
		redGlow:SetKeyValue("GlowProxySize", "4.0")
		redGlow:SetParent(grenade)
		redGlow:Fire("SetParentAttachment", "fuse")
		redGlow:Spawn()
		redGlow:Activate()
		grenade:DeleteOnRemove(redGlow)
		local redTrail = util.SpriteTrail(grenade, 1, Color(255, 0, 0), true, 8, 1, 0.5, 0.0555, "sprites/bluelaser1.vmt")
		redTrail:SetKeyValue("rendermode", "5") -- kRenderTransAdd
		redTrail:SetKeyValue("renderfx", "0") -- kRenderFxNone
		grenade.SoundTbl_Idle = "Grenade.Blip"
		grenade.IdleSoundPitch = VJ.SET(100, 100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	-- Absorb bullet damage, play metallic sound, and create sparks
	if status == "PreDamage" && dmginfo:IsBulletDamage() then
		if self.HasSounds && self.HasImpactSounds then
			VJ.EmitSound(self, "VJ.Impact.Armor")
		end
		if math.random(1, 3) == 1 then
			dmginfo:ScaleDamage(0.50)
			local effectData = EffectData()
			effectData:SetOrigin(dmginfo:GetDamagePosition())
			effectData:SetNormal(dmginfo:GetDamageForce():GetNormalized())
			effectData:SetMagnitude(3)
			effectData:SetScale(1)
			util.Effect("ElectricSpark", effectData)
		else
			dmginfo:ScaleDamage(0.80)
		end
	end
end
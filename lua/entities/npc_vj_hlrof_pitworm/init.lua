AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/pit_worm_up.mdl"
ENT.StartHealth = 2000
ENT.VJ_ID_Boss = true
ENT.HullType = HULL_LARGE
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanTurnWhileStationary = true
ENT.ControllerParams = {
    ThirdP_Offset = Vector(15, 0, -50),
    FirstP_Bone = "Head",
    FirstP_Offset = Vector(7, 0, 0),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_RACE_X"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow_large"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false

ENT.MeleeAttackDamage = 30
ENT.MeleeAttackDistance = 300
ENT.MeleeAttackDamageDistance = 320
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.TimeUntilMeleeAttackDamage = false

ENT.HasRangeAttack = true
ENT.AnimTbl_RangeAttack = ACT_RANGE_ATTACK1
ENT.RangeAttackMaxDistance = 4000
ENT.RangeAttackMinDistance = 250
ENT.TimeUntilRangeAttackProjectileRelease = false
ENT.NextRangeAttackTime = 3

ENT.HasDeathCorpse = false
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = ACT_DIESIMPLE

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH, ACT_BIG_FLINCH}

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/pitworm/pit_worm_idle1.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_idle2.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_idle3.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/pitworm/pit_worm_alert(scream).wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_alert.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_hlr/gsrc/npc/pitworm/pit_worm_attack_swipe1.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_attack_swipe2.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_attack_swipe3.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"vj_hlr/gsrc/npc/pitworm/pit_worm_attack_eyeblast.wav"}
ENT.SoundTbl_Pain = {"vj_hlr/gsrc/npc/pitworm/pit_worm_flinch1.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_flinch2.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_angry1.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_angry2.wav", "vj_hlr/gsrc/npc/pitworm/pit_worm_angry3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/npc/pitworm/pit_worm_death.wav"}

ENT.AlertSoundLevel = 90
ENT.BeforeMeleeAttackSoundLevel = 80
ENT.BeforeRangeAttackSoundLevel = 80
ENT.PainSoundLevel = 80
ENT.DeathSoundLevel = 90

-- Custom
ENT.PitWorm_BlinkingT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(100, 100, 390), Vector(-100, -100, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "melee" then
		self:ExecuteMeleeAttack()
	end
	if key == "beam" then
		self:ExecuteRangeAttack()
	end
end
// ACT_SPECIAL_ATTACK1, ACT_SPECIAL_ATTACK2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Handle blinking
	if !self.Dead && CurTime() > self.PitWorm_BlinkingT then
		self:SetSkin(1)
		timer.Simple(0.1, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.2, function() if IsValid(self) then self:SetSkin(3) end end)
		timer.Simple(0.3, function() if IsValid(self) then self:SetSkin(2) end end)
		timer.Simple(0.4, function() if IsValid(self) then self:SetSkin(1) end end)
		timer.Simple(0.5, function() if IsValid(self) then self:SetSkin(0) end end)
		self.PitWorm_BlinkingT = CurTime() + math.Rand(2, 3.5)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	self:PlayAnim(ACT_ARM, true, false, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttack(status, enemy)
	if status == "PostInit" then
		self.PitWorm_BlinkingT = CurTime() + 2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PitWorm_DoLaserEffects()
	local startPos = self:GetPos() + self:GetUp() * 250 + self:GetForward() * 230
	local tr = util.TraceLine({
		start = startPos,
		endpos = self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter(),
		filter = self
	})
	local beam = EffectData()
	beam:SetStart(startPos)
	beam:SetOrigin(tr.HitPos)
	beam:SetEntity(self)
	beam:SetAttachment(1)
	util.Effect("VJ_HLR_PitWorm_Beam", beam)
	return tr.HitPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRangeAttackExecute(status, enemy, projectile)
	if status == "Init" then
		self:PitWorm_DoLaserEffects()
		
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/flare3.vmt")
		spr:SetKeyValue("rendercolor", "124 252 0")
		spr:SetKeyValue("GlowProxySize", "5.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "3")
		spr:SetKeyValue("renderamt", "255")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "10.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "3")
		spr:SetPos(self:GetPos())
		spr:Spawn()
		spr:SetParent(self)
		spr:Fire("SetParentAttachment", "0")
		self:DeleteOnRemove(spr)
		timer.Simple(0.65, function() if IsValid(self) && IsValid(spr) then spr:Remove() end end)
		
		for i = 0.1, 0.5, 0.1 do
			timer.Simple(i, function()
				if IsValid(self) && IsValid(self:GetEnemy()) && self.AttackType == VJ.ATTACK_TYPE_RANGE then
					local hitpos = self:PitWorm_DoLaserEffects()
					sound.EmitHint(SOUND_DANGER, hitpos, 100, 1, self)
					VJ.ApplyRadiusDamage(self, self, hitpos, 30, 10, DMG_SHOCK, true, false, {Force=90})
					sound.Play("vj_hlr/gsrc/npc/pitworm/pit_worm_attack_eyeblast_impact.wav", hitpos, 80)
				end
			end)
		end
		return true
	end
end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/sqknest.mdl"
ENT.StartHealth = 20
ENT.HullType = HULL_TINY
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, 0),
    FirstP_Bone = "Bip01 nECK",
    FirstP_Offset = Vector(3, 0, 1),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_SNARK"}
ENT.BloodColor = VJ.BLOOD_COLOR_YELLOW
ENT.BloodParticle = {"vj_hlr_blood_yellow"}
ENT.BloodDecal = {"VJ_HLR1_Blood_Yellow"}
ENT.HasBloodPool = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE
ENT.HasMeleeAttack = false

ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/squeek/sqk_hunt1.wav", "vj_hlr/gsrc/npc/squeek/sqk_hunt2.wav", "vj_hlr/gsrc/npc/squeek/sqk_hunt3.wav"}
ENT.SoundTbl_Death = "vj_hlr/gsrc/npc/squeek/sqk_blast1.wav"

ENT.IdleSoundLevel = 65
ENT.MainSoundPitch = 50

-- Custom
ENT.Nest_SpawnEnt = "npc_vj_hlr1_snark"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(15, 15, 18), Vector(-15, -15, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_RUN then
		return ACT_WALK
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Finish" then
		local myPos = self:GetPos()
		if self.Nest_SpawnEnt == "npc_vj_hlr1_snark" then
			VJ.ApplyRadiusDamage(self, self, myPos, 50, 15, DMG_ACID, true, true)
			if self.HasGibOnDeathEffects then
				local effectData = EffectData()
				effectData:SetOrigin(myPos + self:OBBCenter())
				effectData:SetColor(colorYellow)
				effectData:SetScale(40)
				util.Effect("VJ_Blood1", effectData)
				effectData:SetScale(8)
				effectData:SetFlags(3)
				effectData:SetColor(1)
				util.Effect("bloodspray", effectData)
				util.Effect("bloodspray", effectData)
			end
		elseif self.Nest_SpawnEnt == "npc_vj_hlrof_penguin" then
			VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/explode" .. math.random(3, 5) .. ".wav", 90)
			VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris" .. math.random(1, 3) .. ".wav", 100)
			VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/explode" .. math.random(3, 5) .. "_dist.wav", 140, 100)
			util.BlastDamage(self, self, myPos, 80, 35)
			if self.HasGibOnDeathEffects then
				local effectData = EffectData()
				effectData:SetOrigin(myPos + self:OBBCenter())
				effectData:SetColor(colorRed)
				effectData:SetScale(120)
				util.Effect("VJ_Blood1", effectData)
				effectData:SetScale(8)
				effectData:SetFlags(3)
				effectData:SetColor(0)
				util.Effect("bloodspray", effectData)
				util.Effect("bloodspray", effectData)
				
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
				spr:SetKeyValue("scale", "4")
				spr:SetPos(myPos + self:GetUp() * 80)
				spr:Spawn()
				spr:Fire("Kill", "", 0.9)
				timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
			end
		end
		
		if math.random(1, 1000) == 1 then -- Secret =)
			if self.Nest_SpawnEnt == "npc_vj_hlr1_snark" then
				self.Nest_SpawnEnt = "npc_vj_hlrof_penguin"
			elseif self.Nest_SpawnEnt == "npc_vj_hlrof_penguin" then
				self.Nest_SpawnEnt = "npc_vj_hlr1_snark"
			end
		end
		
		-- Spawn random amount of children
		for _ = 1, math.random(4, 8) do
			local ent = ents.Create(self.Nest_SpawnEnt)
			ent:SetPos(myPos)
			ent:SetAngles(self:GetAngles())
			ent:SetVelocity(self:GetUp()*math.Rand(250, 350) + self:GetRight()*math.Rand(-100, 100) + self:GetForward()*math.Rand(-100, 100))
			ent:Spawn()
			ent:Activate()
			ent.VJ_NPC_Class = self.VJ_NPC_Class
		end
	end
end
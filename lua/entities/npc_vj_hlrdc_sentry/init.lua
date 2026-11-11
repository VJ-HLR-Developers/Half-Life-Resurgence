include("entities/npc_vj_hlr1_sentry/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/decay/sentry.mdl"
ENT.ControllerParams = {
	ThirdP_Offset = Vector(10, 0, -20),
	FirstP_Bone = "Dummy04",
	FirstP_Offset = Vector(0, 0, 6)
}
ENT.DeathAnimationTime = 5

-- Custom
ENT.Sentry_RegularType = 1
ENT.Sentry_MuzzleAttach = "muzzle"
ENT.Sentry_AlarmAttach = "sensor"
---------------------------------------------------------------------------------------------------------------------------------------------
local vecUp20 = Vector(0, 0, 20)
local parentDeathFunc = ENT.OnDeath
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	parentDeathFunc(self, dmginfo, hitgroup, status)
	if status == "DeathAnim" then
		-- Behavior: Smoke and spark for 5 seconds and then blow up (Based on original HL Decay)
		local attCenter = self:LookupAttachment("center")
		local attSensor = self:LookupAttachment("sensor")
		sound.EmitHint(SOUND_DANGER, self:GetPos(), 120, self.DeathAnimationTime, self)
		for i = 0.1, 5, 0.5 do
			timer.Simple(i, function()
				if IsValid(self) then
					local effectData = EffectData()
					effectData:SetOrigin(self:GetAttachment(attCenter).Pos)
					effectData:SetScale(15)
					util.Effect("VJ_HLR_Smoke", effectData)
					effectData:SetOrigin(self:GetAttachment(attSensor).Pos)
					effectData:SetScale(6)
					util.Effect("VJ_HLR_Spark", effectData)
					VJ.EmitSound(self, "ambient/energy/zap" .. math.random(5, 9) .. ".wav", 70, 100)
				end
			end)
		end
	elseif status == "Finish" then
		-- Explosion sprite
		local pos = self:GetAttachment(self:LookupAttachment("center")).Pos + vecUp20
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
		spr:SetKeyValue("scale", "1.5")
		spr:SetPos(pos)
		spr:Spawn()
		spr:Fire("Kill", nil, 0.9)
		
		util.BlastDamage(self, self, pos, 50, 30)
		VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris" .. math.random(1, 3) .. ".wav", 80, 100)
		VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/explode" .. math.random(3, 5) .. "_dist.wav", 140, 100)
		self.GibOnDeathFilter = false
		self:GibOnDeath(DamageInfo(), hitgroup) -- dmginfo is corrupt by now, declare a new one
	end
end
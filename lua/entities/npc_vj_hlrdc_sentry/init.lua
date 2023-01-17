AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/decay/sentry.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
    ThirdP_Offset = Vector(10, 0, -20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy04", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 6), -- The offset for the controller when the camera is in first person
}
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
ENT.DeathAnimationTime = 5 -- Time until the SNPC spawns its corpse and gets removed

-- Custom
ENT.Sentry_GroundType = 1
ENT.Sentry_MuzzleAttach = "muzzle"
ENT.Sentry_AlarmAttach = "sensor"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomDeathAnimationCode(dmginfo, hitgroup)
	local att = self:LookupAttachment("center")
	local attSensor = self:LookupAttachment("sensor")
	sound.EmitHint(SOUND_DANGER, self:GetPos(), 120, self.DeathAnimationTime, self)
	for i = 0.1, 5, 0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
				local effectSmoke = EffectData()
				effectSmoke:SetOrigin(self:GetAttachment(att).Pos)
				effectSmoke:SetScale(15)
				util.Effect("VJ_HLR_Smoke", effectSmoke)
				local effectSpark = EffectData()
				effectSpark:SetOrigin(self:GetAttachment(attSensor).Pos)
				effectSpark:SetScale(6)
				util.Effect("VJ_HLR_Spark", effectSpark)
				VJ_EmitSound(self, "ambient/energy/zap"..math.random(5, 9)..".wav", 70, 100)
			end
		end)
	end
end
include("entities/npc_vj_hlr2_com_civilp/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl2b/elitepolice.mdl"
ENT.StartHealth = 60

ENT.GeneralSoundPitch1 = 80
ENT.GeneralSoundPitch2 = 80
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && dmginfo:IsBulletDamage() then
		if self.HasSounds && self.HasImpactSounds then VJ.EmitSound(self, "VJ.Impact.Armor") end
		if math.random(1, 3) == 1 then
			dmginfo:ScaleDamage(0.50)
			local spark = ents.Create("env_spark")
			spark:SetKeyValue("Magnitude", "1")
			spark:SetKeyValue("Spark Trail Length", "1")
			spark:SetPos(dmginfo:GetDamagePosition())
			spark:SetAngles(self:GetAngles())
			spark:SetParent(self)
			spark:Spawn()
			spark:Activate()
			spark:Fire("StartSpark", "", 0)
			spark:Fire("StopSpark", "", 0.001)
			self:DeleteOnRemove(spark)
		else
			dmginfo:ScaleDamage(0.80)
		end
	end
end
include("entities/npc_vj_hlr1_houndeye/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hla/houndeye.mdl"
ENT.CanFlinch = 0

-- Custom
ENT.Houndeye_Type = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- Overwrite it to do nothing
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	-- Overwrite it to do nothing
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	-- Overwrite it to do nothing
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnAlert(ent)
	-- Overwrite it to do nothing
end
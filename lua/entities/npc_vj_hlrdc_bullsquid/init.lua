include("entities/npc_vj_hlr1_bullsquid/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/bullsquid_dreamcast.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 90
---------------------------------------------------------------------------------------------------------------------------------------------
local baseAcceptInput = ENT.OnInput
--
function ENT:OnInput(key, activator, caller, data)
	if key == "melee_whip" then
		self.MeleeAttackDamage = 38
		self:MeleeAttackCode()
	elseif key == "melee_bite" then
		self.MeleeAttackDamage = 27
		self:MeleeAttackCode()
	else
		baseAcceptInput(self, key, activator, caller, data)
	end
end
include("entities/npc_vj_hlr1a_hgrunt_serg/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.DisableWeapons = true -- If set to true, it won't be able to use weapons
ENT.NoWeapon_UseScaredBehavior = false -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}

-- Custom
ENT.Serg_Type = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		return ACT_CROUCH
	elseif act == ACT_WALK then
		return ACT_RUN
	elseif act == ACT_RUN then
		return ACT_RUN_PROTECTED
	end
	return self.BaseClass.TranslateActivity(self, act)
end
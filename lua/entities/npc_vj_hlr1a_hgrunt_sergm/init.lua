AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2, ACT_MELEE_ATTACK_SWING} -- Melee Attack Animations
ENT.DisableWeapons = true -- If set to true, it won't be able to use weapons
ENT.NoWeapon_UseScaredBehavior = false -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?

-- Custom
ENT.Serg_Type = 1
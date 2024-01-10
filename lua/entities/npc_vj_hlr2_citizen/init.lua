AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 40
ENT.HullType = HULL_HUMAN
ENT.Behavior = VJ_BEHAVIOR_PASSIVE
ENT.Weapon_NoSpawnMenu = true -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
ENT.HasGrenadeAttack = false -- Should the NPC have a grenade attack?
ENT.HasItemDropsOnDeath = false -- Should it drop items on death?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self.Human_Gender == 0 or (self.Human_Gender == nil && math.random(1, 2) == 1) then
		self.Human_Gender = 0
		self.Model = {"models/Humans/Group01/male_01.mdl","models/Humans/Group01/male_02.mdl","models/Humans/Group01/male_03.mdl","models/Humans/Group01/male_04.mdl","models/Humans/Group01/male_05.mdl","models/Humans/Group01/male_06.mdl","models/Humans/Group01/male_07.mdl","models/Humans/Group01/male_08.mdl","models/Humans/Group01/male_09.mdl"}
	else
		self.Human_Gender = 1
		self.Model = {"models/Humans/Group01/female_01.mdl","models/Humans/Group01/female_02.mdl","models/Humans/Group01/female_03.mdl","models/Humans/Group01/female_04.mdl","models/Humans/Group01/female_06.mdl","models/Humans/Group01/female_07.mdl"}
	end
end
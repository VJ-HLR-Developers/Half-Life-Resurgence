include("entities/npc_vj_hlr2_rebel/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 40
ENT.HullType = HULL_HUMAN
ENT.HasGrenadeAttack = false

local mdlMale = {"models/Humans/Group02/male_01.mdl", "models/Humans/Group02/male_02.mdl", "models/Humans/Group02/male_03.mdl", "models/Humans/Group02/male_04.mdl", "models/Humans/Group02/male_05.mdl", "models/Humans/Group02/male_06.mdl", "models/Humans/Group02/male_07.mdl", "models/Humans/Group02/male_08.mdl", "models/Humans/Group02/male_09.mdl"}
local mdlFemale = {"models/Humans/Group02/female_01.mdl", "models/Humans/Group02/female_02.mdl", "models/Humans/Group02/female_03.mdl", "models/Humans/Group02/female_04.mdl", "models/Humans/Group02/female_06.mdl", "models/Humans/Group02/female_07.mdl"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit()
	if self.Human_Gender == 1 or (self.Human_Gender == -1 && math.random(1, 2) == 1) then
		self.Human_Gender = 1
		self.Model = mdlFemale
	else
		self.Human_Gender = 0
		self.Model = mdlMale
	end
end
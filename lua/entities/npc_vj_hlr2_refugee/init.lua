AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 40
ENT.HullType = HULL_HUMAN
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if self.Human_Gender == 0 or math.random(1,2) == 1 then
		self.Human_Gender = 0
		self.Model = {"models/Humans/Group02/male_01.mdl","models/Humans/Group02/male_02.mdl","models/Humans/Group02/male_03.mdl","models/Humans/Group02/male_04.mdl","models/Humans/Group02/male_05.mdl","models/Humans/Group02/male_06.mdl","models/Humans/Group02/male_07.mdl","models/Humans/Group02/male_08.mdl","models/Humans/Group02/male_09.mdl"}
	else
		self.Human_Gender = 1
		self.Model = {"models/Humans/Group02/female_01.mdl","models/Humans/Group02/female_02.mdl","models/Humans/Group02/female_03.mdl","models/Humans/Group02/female_04.mdl","models/Humans/Group02/female_06.mdl","models/Humans/Group02/female_07.mdl"}
	end
end
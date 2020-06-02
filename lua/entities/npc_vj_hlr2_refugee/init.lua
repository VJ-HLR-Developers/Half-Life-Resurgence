AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = GetConVarNumber("vj_hl2r_rebel_h")
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	-- if math.random(1,5) == 1 then
		-- self.Model = {"models/Humans/Group03m/Male_01.mdl","models/Humans/Group03m/male_02.mdl","models/Humans/Group03m/male_03.mdl","models/Humans/Group03m/male_04.mdl","models/Humans/Group03m/male_05.mdl","models/Humans/Group03m/male_06.mdl","models/Humans/Group03m/male_07.mdl","models/Humans/Group03m/male_08.mdl","models/Humans/Group03m/male_09.mdl"}
		-- self.Gender = 2
	-- else
		self.Model = {"models/Humans/Group02/male_01.mdl","models/Humans/Group02/male_02.mdl","models/Humans/Group02/male_03.mdl","models/Humans/Group02/male_04.mdl","models/Humans/Group02/male_05.mdl","models/Humans/Group02/male_06.mdl","models/Humans/Group02/male_07.mdl","models/Humans/Group02/male_08.mdl","models/Humans/Group02/male_09.mdl"}
		self.Gender = 1
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	self:VJ_ACT_PLAYACTIVITY({"vjseq_cheer1"},false,false,false,0,{vTbl_SequenceInterruptible=true})
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
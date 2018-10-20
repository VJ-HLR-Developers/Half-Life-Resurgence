AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/hgrunt_medic.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	-- Medic bodygroup starts from 2
	self:SetBodygroup(2,math.random(0,1))
	
	self:SetBodygroup(3,math.random(0,1))
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
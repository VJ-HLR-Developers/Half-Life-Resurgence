include("entities/npc_vj_hlr2_com_soldier/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/combine_soldier_prisonguard.mdl"
ENT.StartHealth = 75
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSkin(1)
end
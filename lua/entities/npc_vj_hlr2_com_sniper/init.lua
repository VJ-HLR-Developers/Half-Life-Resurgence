include("entities/npc_vj_hlr2_com_soldier/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 80
ENT.Weapon_Accuracy = 0.5
ENT.Weapon_FiringDistanceFar = 10000
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetMaterial("models/hl_resurgence/hl2/sniper/combinesoldiersheet")
end
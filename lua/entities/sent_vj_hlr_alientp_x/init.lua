AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
function ENT:DefaultPortalValues()
	if #self.VJ_NPC_Class == 0 then
		self:SetClass("CLASS_RACE_X")
	end
	if #self.SpawnableNPC == 0 then
		self:SetNPC("npc_vj_hlrof_shocktrooper")
		self:SetNPC("npc_vj_hlrof_pitdrone")
		self:SetNPC("npc_vj_hlrof_voltigore")
		self:SetNPC("npc_vj_hlrof_voltigore_baby")
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
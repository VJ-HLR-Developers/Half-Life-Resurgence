AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/hassault.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2, ACT_MELEE_ATTACK_SWING} -- Melee Attack Animations
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:GetDamage() > 30 then
		self.FlinchChance = 8
		self.AnimTbl_Flinch = {ACT_BIG_FLINCH}
	else
		self.FlinchChance = 16
		self.AnimTbl_Flinch = {ACT_SMALL_FLINCH}
	end
end
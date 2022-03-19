AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hla/houndeye.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want

local blastSd = {"vj_hlr/hl1_npc/houndeye/he_blast1.wav","vj_hlr/hl1_npc/houndeye/he_blast2.wav","vj_hlr/hl1_npc/houndeye/he_blast3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20 , 40), Vector(-20, -20, 0))
	self.AnimTbl_Death = {ACT_DIESIMPLE} -- Death Animations
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	-- overwrite with nothing
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	-- overwrite with nothing
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	-- overwrite with nothing
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnResetEnemy()
	-- overwrite with nothing
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeChecks()
	local friNum = 0 -- How many allies exist around the Houndeye
	local color = Color(188, 220, 255) -- The shock wave color
	local dmg = 15 -- How much damage should the shock wave do?
	local myPos = self:GetPos()
	for _, v in ipairs(ents.FindInSphere(myPos, 400)) do
		if v != self && v:GetClass() == "npc_vj_hlr1a_houndeye" then
			friNum = friNum + 1
		end
	end
	-- More allies = more damage and different colors
	if friNum == 1 then
		color = Color(101, 133, 221)
		dmg = 30
	elseif friNum == 2 then
		color = Color(67, 85, 255)
		dmg = 45
	elseif friNum >= 3 then
		color = Color(62, 33, 211)
		dmg = 60
	end
	
	-- flags 0 = No fade!
	effects.BeamRingPoint(myPos, 0.3, 2, 400, 16, 0, color, {material="vj_hl/sprites/shockwave", framerate=20, flags=0})
	effects.BeamRingPoint(myPos, 0.3, 2, 200, 16, 0, color, {material="vj_hl/sprites/shockwave", framerate=20, flags=0})
	
	if self.HasSounds == true && GetConVar("vj_npc_sd_meleeattack"):GetInt() == 0 then
		VJ_EmitSound(self, blastSd, 100, math.random(80, 100))
	end
	util.VJ_SphereDamage(self, self, myPos, 400, dmg, self.MeleeAttackDamageType, true, true, {DisableVisibilityCheck=true, Force=80})
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	-- overwrite with nothing
end
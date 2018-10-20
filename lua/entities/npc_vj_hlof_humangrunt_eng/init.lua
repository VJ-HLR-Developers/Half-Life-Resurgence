AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/hgrunt_engineer.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want

-- Custom
ENT.HECU_MyTurret = NULL
ENT.HECU_GasTankHit = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && self.HECU_MyTurret == NULL then
		self:VJ_ACT_PLAYACTIVITY("open_floor_grate",true,false,false)
		timer.Simple(0.4,function()
			if IsValid(self) && IsValid(self:GetEnemy()) && self.HECU_MyTurret == NULL then
				self.HECU_MyTurret = ents.Create("npc_vj_bmssold_turret")
				self.HECU_MyTurret:SetPos(self:GetPos() + self:GetForward()*50)
				self.HECU_MyTurret:SetAngles(self:GetAngles())
				self.HECU_MyTurret:Spawn()
				self.HECU_MyTurret:Activate()
				self.HECU_MyTurret.VJ_NPC_Class = table.Merge(self.HECU_MyTurret.VJ_NPC_Class,self.VJ_NPC_Class)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if hitgroup == HITGROUP_GEAR then
		self.HECU_GasTankHit = true
		dmginfo:SetDamage(9999999999999999)
		dmginfo:SetDamageType(DMG_BLAST)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
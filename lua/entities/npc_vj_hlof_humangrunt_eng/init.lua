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
ENT.HECU_PlacingTurret = false
ENT.HECU_NextTurretT = 0
ENT.HECU_GasTankHit = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && self.HECU_NextTurretT < CurTime() && self.HECU_PlacingTurret == false && !IsValid(self.HECU_MyTurret) then
		self.HECU_NextTurretT = CurTime() + 30
		self.HECU_PlacingTurret = true
		self:VJ_ACT_PLAYACTIVITY("pull_torch_wgun",true,false,true,0,{},function(vsched)
			vsched.RunCode_OnFinish = function()
				self:VJ_ACT_PLAYACTIVITY("open_floor_grate",true,false,false,0,{},function(vsched)
					vsched.RunCode_OnFinish = function()
						self:VJ_ACT_PLAYACTIVITY("store_torch",true,false,false)
					end
				end)
			end
		end)
		timer.Simple(4.5,function()
			if IsValid(self) && IsValid(self:GetEnemy()) && !IsValid(self.HECU_MyTurret) then
				self.HECU_MyTurret = ents.Create("npc_vj_bmssold_turret")
				self.HECU_MyTurret:SetPos(self:GetPos() + self:GetForward()*50)
				self.HECU_MyTurret:SetAngles(self:GetAngles())
				self.HECU_MyTurret:Spawn()
				self.HECU_MyTurret:Activate()
				self.HECU_MyTurret.VJ_NPC_Class = table.Merge(self.HECU_MyTurret.VJ_NPC_Class,self.VJ_NPC_Class)
				self.HECU_PlacingTurret = false
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if hitgroup == HITGROUP_GEAR then
		self.HECU_GasTankHit = true
		dmginfo:SetDamage(999999999999)
		dmginfo:SetDamageType(DMG_BLAST)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
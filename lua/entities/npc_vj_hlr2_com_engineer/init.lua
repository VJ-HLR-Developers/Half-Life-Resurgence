include("entities/npc_vj_hlr2_com_soldier/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

-- Custom
ENT.Combine_TurretEnt = NULL
ENT.Combine_TurretPlacing = false
ENT.Combine_NextTurretCheckT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetMaterial("models/hl_resurgence/hl2/engineer/combinesoldiersheet")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("CROUCH (CTRL): Deploy Sentry Gun")
	
	function controlEnt:OnKeyBindPressed(key)
		local npc = self.VJCE_NPC
		if key == IN_DUCK then
			npc:Combine_DeployTurret()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Combine_DeployTurret()
	if self.Combine_NextTurretCheckT < CurTime() && !self.Combine_TurretPlacing && !IsValid(self.Combine_TurretEnt) then
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*80,
			filter = self
		})
		-- Make sure not to place it if the front of the NPC is blocked!
		if !tr.Hit then
			self.Combine_NextTurretCheckT = CurTime() + 30
			self.Combine_TurretPlacing = true
			self:PlayAnim("vjseq_Turret_Drop" ,true, false, false)
			timer.Simple(0.9, function()
				if IsValid(self) && !IsValid(self.Combine_TurretEnt) then
					local turret = ents.Create("npc_vj_hlr2_com_sentry")
					turret:SetPos(self:GetPos() + self:GetForward()*50)
					turret:SetAngles(self:GetAngles())
					turret:Spawn()
					turret:Activate()
					turret.VJ_NPC_Class = self.VJ_NPC_Class
					turret:SetState(VJ_STATE_FREEZE, 1)
					VJ.EmitSound(turret, "npc/roller/blade_cut.wav", 75, 100)
					if IsValid(self:GetCreator()) then -- If it has a creator, then add it to that player's undo list
						undo.Create(self:GetName().."'s Turret")
							undo.AddEntity(turret)
							undo.SetPlayer(self:GetCreator())
						undo.Finish()
					end
					self.Combine_TurretEnt = turret
					self.Combine_TurretPlacing = false
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if !self.VJ_IsBeingControlled && IsValid(self:GetEnemy()) && self.EnemyData.IsVisible then
		self:Combine_DeployTurret()
	end
end
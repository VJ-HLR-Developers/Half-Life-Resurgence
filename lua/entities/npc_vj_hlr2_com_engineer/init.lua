AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

-- Custom
ENT.Combine_TurretEnt = NULL
ENT.Combine_TurretPlacing = false
ENT.Combine_NextTurretCheckT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetMaterial("models/hl_resurgence/hl2/engineer/combinesoldiersheet")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("CTRL: Deploy Sentry Gun")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if ((self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_DUCK)) or !self.VJ_IsBeingControlled) && IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.Combine_NextTurretCheckT < CurTime() && self.Combine_TurretPlacing == false && !IsValid(self.Combine_TurretEnt) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*80,
			filter = self
		})
		if !tr.Hit then
			self.Combine_NextTurretCheckT = CurTime() + 30
			self.Combine_TurretPlacing = true
			self:VJ_ACT_PLAYACTIVITY("vjseq_Turret_Drop" ,true, false, false)
			timer.Simple(0.9, function()
				if IsValid(self) && !IsValid(self.Combine_TurretEnt) then
					self.Combine_TurretEnt = ents.Create("npc_vj_hlr2_com_sentry")
					self.Combine_TurretEnt:SetPos(self:GetPos() + self:GetForward()*50)
					self.Combine_TurretEnt:SetAngles(self:GetAngles())
					self.Combine_TurretEnt:Spawn()
					self.Combine_TurretEnt:Activate()
					self.Combine_TurretEnt.VJ_NPC_Class = self.VJ_NPC_Class
					self.Combine_TurretEnt:SetState(VJ_STATE_FREEZE, 1)
					VJ.EmitSound(self.Combine_TurretEnt, "npc/roller/blade_cut.wav", 75, 100)
					if IsValid(self:GetCreator()) then -- If it has a creator, then add it to that player's undo list
						undo.Create(self:GetName().."'s Turret")
							undo.AddEntity(self.Combine_TurretEnt)
							undo.SetPlayer(self:GetCreator())
						undo.Finish()
					end
					self.Combine_TurretPlacing = false
				end
			end)
		end
	end
end
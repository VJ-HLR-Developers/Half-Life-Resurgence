AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

-- Custom
ENT.Human_Type = 1
ENT.Human_TurretEnt = NULL
ENT.Human_TurretPlacing = false
ENT.Human_NextTurretCheckT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("CTRL: Deploy Sentry Gun")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if ((self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_DUCK)) or !self.VJ_IsBeingControlled) && IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.Human_NextTurretCheckT < CurTime() && self.Human_TurretPlacing == false && !IsValid(self.Human_TurretEnt) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*80,
			filter = self
		})
		if !tr.Hit then
			self.Human_NextTurretCheckT = CurTime() + 30
			self.Human_TurretPlacing = true
			self:VJ_ACT_PLAYACTIVITY("vjseq_pickup" ,true, false, false)
			timer.Simple(0.45, function()
				if IsValid(self) && !IsValid(self.Human_TurretEnt) then
					self.Human_TurretEnt = ents.Create("npc_vj_hlr2_res_sentry")
					self.Human_TurretEnt:SetPos(self:GetPos() + self:GetForward()*50)
					self.Human_TurretEnt:SetAngles(self:GetAngles())
					self.Human_TurretEnt:Spawn()
					self.Human_TurretEnt:Activate()
					self.Human_TurretEnt.VJ_NPC_Class = self.VJ_NPC_Class
					self.Human_TurretEnt:SetState(VJ_STATE_FREEZE, 1)
					VJ.EmitSound(self.Human_TurretEnt, "npc/roller/blade_cut.wav", 75, 100)
					if IsValid(self:GetCreator()) then -- If it has a creator, then add it to that player's undo list
						undo.Create(self:GetName().."'s Turret")
							undo.AddEntity(self.Human_TurretEnt)
							undo.SetPlayer(self:GetCreator())
						undo.Finish()
					end
					self.Human_TurretPlacing = false
				end
			end)
		end
	end
end
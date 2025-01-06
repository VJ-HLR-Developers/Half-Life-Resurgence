include("entities/npc_vj_hlr2_rebel/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

-- Custom
ENT.Human_Type = 1
ENT.Human_TurretEnt = NULL
ENT.Human_NextTurretCheckT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("CTRL: Deploy Sentry Gun")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if ((self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_DUCK)) or !self.VJ_IsBeingControlled) && IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.Human_NextTurretCheckT < CurTime() && !IsValid(self.Human_TurretEnt) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*80,
			filter = self
		})
		if !tr.Hit then
			self.Human_NextTurretCheckT = CurTime() + 30
			self:PlayAnim("vjseq_pickup" ,true, false, false)
			timer.Simple(0.45, function()
				if IsValid(self) && !IsValid(self.Human_TurretEnt) then
					local turret = ents.Create("npc_vj_hlr2_res_sentry")
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
					self.Human_TurretEnt = turret
				end
			end)
		end
	end
end
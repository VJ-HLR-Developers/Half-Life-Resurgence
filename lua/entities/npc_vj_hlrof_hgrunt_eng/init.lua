include("entities/npc_vj_hlrof_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/hgrunt_engineer.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(5, 0, 5),
}

-- Custom
ENT.HECU_TurretEnt = NULL
ENT.HECU_TurretPlacing = false
ENT.HECU_NextTurretCheckT = 0
ENT.HECU_GasTankHit = false -- Signals the code to preform an explosion
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("CTRL: Deploy Sentry Gun")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if ((self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_DUCK)) or !self.VJ_IsBeingControlled) && IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.HECU_NextTurretCheckT < CurTime() && !IsValid(self.HECU_TurretEnt) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local myCenterPos = self:GetPos() + self:OBBCenter()
		local tr = util.TraceLine({
			start = myCenterPos,
			endpos = myCenterPos + self:GetForward()*80,
			filter = self
		})
		if !tr.Hit then
			self.HECU_NextTurretCheckT = CurTime() + math.Rand(25, 35)
			self:PlayAnim("pull_torch_wgun", true, false, false, 0, {OnFinish=function(interrupted, anim)
				if interrupted then -- If interrupted, put torch away and try again very soon!
					self.HECU_NextTurretCheckT = CurTime() + math.Rand(5, 10)
					self:StopParticles()
					self:SetBodygroup(1, 0)
					return
				end
				timer.Simple(0.5, function()
					if IsValid(self) && IsValid(self:GetEnemy()) && !IsValid(self.HECU_TurretEnt) then
						local turret = ents.Create("npc_vj_hlr1_sentry")
						turret:SetPos(self:GetPos() + self:GetForward()*50)
						turret:SetAngles(self:GetAngles())
						turret:Spawn()
						turret:Activate()
						turret.VJ_NPC_Class = self.VJ_NPC_Class
						self.HECU_TurretEnt = turret
						if IsValid(self:GetCreator()) then -- If it has a creator, then add it to that player's undo list
							undo.Create(self:GetName() .. "'s Turret")
								undo.AddEntity(turret)
								undo.SetPlayer(self:GetCreator())
							undo.Finish()
						end
					end
				end)
				self:PlayAnim("open_floor_grate", true, false, false, 0, {OnFinish=function(interrupted2, anim2)
					self:PlayAnim("store_torch", true, false)
				end})
			end})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	-- Instant kill when hit in the gas tank!
	if status == "PreDamage" && hitgroup == HITGROUP_GEAR then
		self.HECU_GasTankHit = true -- Signals the code to preform an explosion
		dmginfo:SetDamage(self:Health())
		dmginfo:SetDamageType(DMG_BLAST)
	end
end
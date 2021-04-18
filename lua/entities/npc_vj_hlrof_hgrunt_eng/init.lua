AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/hgrunt_engineer.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Bip01 Head", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(5, 0, 5), -- The offset for the controller when the camera is in first person
}

-- Custom
ENT.HECU_TurretEnt = NULL
ENT.HECU_TurretPlacing = false
ENT.HECU_NextTurretCheckT = 0
ENT.HECU_GasTankHit = false -- Signals the code to preform an explosion
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.HECU_NextTurretCheckT < CurTime() && !IsValid(self.HECU_TurretEnt) then
		-- Make sure not to place it if the front of the NPC is blocked!
		local tr = util.TraceLine({
			start = self:GetPos() + self:OBBCenter(),
			endpos = self:GetPos() + self:OBBCenter() + self:GetForward()*80,
			filter = self
		})
		if !tr.Hit then
			self.HECU_NextTurretCheckT = CurTime() + 30
			self:VJ_ACT_PLAYACTIVITY("pull_torch_wgun", true, false, false, 0, {OnFinish=function(interrupted, anim)
				if interrupted then self:StopParticles() self:SetBodygroup(1, 0) return end -- If interrupted, then put the torch away!
				timer.Simple(0.5, function()
					if IsValid(self) && IsValid(self:GetEnemy()) && !IsValid(self.HECU_TurretEnt) then
						self.HECU_TurretEnt = ents.Create("npc_vj_hlr1_sentry")
						self.HECU_TurretEnt:SetPos(self:GetPos() + self:GetForward()*50)
						self.HECU_TurretEnt:SetAngles(self:GetAngles())
						self.HECU_TurretEnt:Spawn()
						self.HECU_TurretEnt:Activate()
						self.HECU_TurretEnt.VJ_NPC_Class = self.VJ_NPC_Class
						if IsValid(self:GetCreator()) then -- If it has a creator, then add it to that player's undo list
							undo.Create(self:GetName().."'s Turret")
								undo.AddEntity(self.HECU_TurretEnt)
								undo.SetPlayer(self:GetCreator())
							undo.Finish()
						end
					end
				end)
				self:VJ_ACT_PLAYACTIVITY("open_floor_grate", true, false, false, 0, {OnFinish=function(interrupted2, anim2)
					self:VJ_ACT_PLAYACTIVITY("store_torch", true, false)
				end})
			end})
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	-- Instant kill when hit in the gas tank!
	if hitgroup == HITGROUP_GEAR then
		self.HECU_GasTankHit = true -- Signals the code to preform an explosion
		dmginfo:SetDamage(self:Health())
		dmginfo:SetDamageType(DMG_BLAST)
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
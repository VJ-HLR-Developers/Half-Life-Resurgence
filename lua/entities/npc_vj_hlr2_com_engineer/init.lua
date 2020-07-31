AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = GetConVarNumber("vj_hl2c_soldier_h")

-- Custom
ENT.HLR_HL2_MyTurret = NULL
ENT.HLR_HL2_PlacingTurret = false
ENT.HLR_HL2_NextTurretT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetMaterial("models/hl_resurgence/hl2/engineer/combinesoldiersheet")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.HLR_HL2_NextTurretT < CurTime() && self.HLR_HL2_PlacingTurret == false && !IsValid(self.HLR_HL2_MyTurret) then
		self.HLR_HL2_NextTurretT = CurTime() +30
		self.HLR_HL2_PlacingTurret = true
		self:VJ_ACT_PLAYACTIVITY("vjseq_Turret_Drop",true,false,true)
		timer.Simple(0.9,function()
			if IsValid(self) && !IsValid(self.HLR_HL2_MyTurret) then
				self.HLR_HL2_MyTurret = ents.Create("npc_vj_hlr2_com_turret")
				self.HLR_HL2_MyTurret:SetPos(self:GetPos() +self:GetForward() *50)
				self.HLR_HL2_MyTurret:SetAngles(self:GetAngles())
				self.HLR_HL2_MyTurret:Spawn()
				self.HLR_HL2_MyTurret:Activate()
				self.HLR_HL2_MyTurret.VJ_NPC_Class = table.Merge(self.HLR_HL2_MyTurret.VJ_NPC_Class,self.VJ_NPC_Class)
				self.HLR_HL2_PlacingTurret = false
				self.HLR_HL2_MyTurret.DisableFindEnemy = true
				VJ_EmitSound(self.HLR_HL2_MyTurret,"npc/roller/blade_cut.wav",75,100)
				local turret = self.HLR_HL2_MyTurret
				undo.Create(self:GetName() .. "'s Turret")
					undo.AddEntity(turret)
					undo.SetPlayer(self:GetCreator() or Entity(1))
				undo.Finish()
				timer.Simple(1,function()
					if IsValid(turret) then
						turret.DisableFindEnemy = false
						VJ_EmitSound(turret,"npc/roller/remote_yes.wav",80,100)

						local glow = ents.Create("env_sprite")
						glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
						glow:SetKeyValue("scale","0.125")
						glow:SetKeyValue("rendermode","5")
						glow:SetKeyValue("rendercolor","0 255 63")
						glow:SetKeyValue("spawnflags","1") -- If animated
						glow:SetParent(turret)
						glow:Fire("SetParentAttachment",turret.Turret_AlarmAttachment,0)
						glow:Spawn()
						glow:Activate()
						glow:Fire("Kill","",0.1)
						turret:DeleteOnRemove(glow)
					end
				end)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if (dmginfo:IsBulletDamage()) then
		dmginfo:ScaleDamage(0.5)
		if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end
		local attacker = dmginfo:GetAttacker()
		if math.random(1,3) == 1 then
			dmginfo:ScaleDamage(0.35)
			self.DamageSpark1 = ents.Create("env_spark")
			self.DamageSpark1:SetKeyValue("Magnitude","1")
			self.DamageSpark1:SetKeyValue("Spark Trail Length","1")
			self.DamageSpark1:SetPos(dmginfo:GetDamagePosition())
			self.DamageSpark1:SetAngles(self:GetAngles())
			//self.DamageSpark1:Fire("LightColor", "255 255 255")
			self.DamageSpark1:SetParent(self)
			self.DamageSpark1:Spawn()
			self.DamageSpark1:Activate()
			self.DamageSpark1:Fire("StartSpark", "", 0)
			self.DamageSpark1:Fire("StopSpark", "", 0.001)
			self:DeleteOnRemove(self.DamageSpark1)
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

-- Custom
ENT.HLR_HL2_MyTurret = NULL
ENT.HLR_HL2_PlacingTurret = false
ENT.HLR_HL2_NextTurretT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if math.random(1,2) == 1 then
		self.Human_Gender = 0
		self.Model = {"models/Humans/Group03/male_01.mdl","models/Humans/Group03/male_02.mdl","models/Humans/Group03/male_03.mdl","models/Humans/Group03/male_04.mdl","models/Humans/Group03/male_05.mdl","models/Humans/Group03/male_06.mdl","models/Humans/Group03/male_07.mdl","models/Humans/Group03/male_08.mdl","models/Humans/Group03/male_09.mdl"}
	else
		self.Human_Gender = 1
		self.Model = {"models/Humans/Group03/female_01.mdl","models/Humans/Group03/female_02.mdl","models/Humans/Group03/female_03.mdl","models/Humans/Group03/female_04.mdl","models/Humans/Group03/female_06.mdl","models/Humans/Group03/female_07.mdl"}
	end
	if math.random(1,3) == 1 then
		self.WeaponInventory_Melee = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.Human_NextPlyReloadSd = CurTime()
	if self.Human_Gender == 1 then
		self:HLR_ApplyFemaleSounds()
		self.Human_SdFolder = "female01"
	else
		self:HLR_ApplyMaleSounds()
		self.Human_SdFolder = "male01"
	end

	-- Set different clothing
	for k, v in ipairs(self:GetMaterials()) do
		if v == "models/humans/female/group03/citizen_sheet" then
			self:SetSubMaterial(k - 1, "models/hl_resurgence/hl2/humans/female/group03/citizen_sheet_engineer")
		elseif v == "models/humans/male/group03/citizen_sheet" then
			self:SetSubMaterial(k - 1, "models/hl_resurgence/hl2/humans/male/group03/citizen_sheet_engineer")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.HLR_HL2_NextTurretT < CurTime() && self.HLR_HL2_PlacingTurret == false && !IsValid(self.HLR_HL2_MyTurret) then
		self.HLR_HL2_NextTurretT = CurTime() +30
		self.HLR_HL2_PlacingTurret = true
		self:VJ_ACT_PLAYACTIVITY("vjseq_pickup",true,false,true)
		timer.Simple(0.45,function()
			if IsValid(self) && !IsValid(self.HLR_HL2_MyTurret) then
				self.HLR_HL2_MyTurret = ents.Create("npc_vj_hlr2_turret")
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
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
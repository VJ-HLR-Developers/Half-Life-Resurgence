AddCSLuaFile("shared.lua")
include('shared.lua')
include("hlr_sounds.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = GetConVarNumber("vj_hl2r_rebel_h")
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_MeleeAttack01"} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = GetConVarNumber("vj_hl2r_rebel_d")
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.AnimTbl_GrenadeAttack = {ACT_RANGE_ATTACK_THROW} -- Grenade Attack Animations
ENT.TimeUntilGrenadeIsReleased = 0.87 -- Time until the grenade is released
ENT.GrenadeAttackAttachment = "anim_attachment_RH" -- The attachment that the grenade will spawn at
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.AnimTbl_Medic_GiveHealth = {"heal"} -- Animations is plays when giving health to an ally
ENT.WeaponInventory_AntiArmorList = {"weapon_vj_rpg", "weapon_vj_hl2_rpg"} -- It will randomly be given one of these weapons
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/footsteps/hardboot_generic1.wav","npc/footsteps/hardboot_generic2.wav","npc/footsteps/hardboot_generic3.wav","npc/footsteps/hardboot_generic4.wav","npc/footsteps/hardboot_generic5.wav","npc/footsteps/hardboot_generic6.wav","npc/footsteps/hardboot_generic8.wav"}

-- Custom
ENT.Human_Gender = 0 -- 0 = Male | 1 = Female
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if math.random(1,2) == 1 then
		self.Human_Gender = 0
		if math.random(1,5) == 1 then
			self.Model = {"models/Humans/Group03m/male_01.mdl","models/Humans/Group03m/male_02.mdl","models/Humans/Group03m/male_03.mdl","models/Humans/Group03m/male_04.mdl","models/Humans/Group03m/male_05.mdl","models/Humans/Group03m/male_06.mdl","models/Humans/Group03m/male_07.mdl","models/Humans/Group03m/male_08.mdl","models/Humans/Group03m/male_09.mdl"}
			self.IsMedicSNPC = true
		else
			self.Model = {"models/Humans/Group03/male_01.mdl","models/Humans/Group03/male_02.mdl","models/Humans/Group03/male_03.mdl","models/Humans/Group03/male_04.mdl","models/Humans/Group03/male_05.mdl","models/Humans/Group03/male_06.mdl","models/Humans/Group03/male_07.mdl","models/Humans/Group03/male_08.mdl","models/Humans/Group03/male_09.mdl"}
		end
	else
		self.Human_Gender = 1
		if math.random(1,5) == 1 then
			self.Model = {"models/Humans/Group03m/female_01.mdl","models/Humans/Group03m/female_02.mdl","models/Humans/Group03m/female_03.mdl","models/Humans/Group03m/female_04.mdl","models/Humans/Group03m/female_06.mdl","models/Humans/Group03m/female_07.mdl"}
			self.IsMedicSNPC = true
		else
			self.Model = {"models/Humans/Group03/female_01.mdl","models/Humans/Group03/female_02.mdl","models/Humans/Group03/female_03.mdl","models/Humans/Group03/female_04.mdl","models/Humans/Group03/female_06.mdl","models/Humans/Group03/female_07.mdl"}
		end
	end
	if self.IsMedicSNPC == false && math.random(1,3) == 1 then
		self.WeaponInventory_AntiArmor = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if self.Human_Gender == 1 then
		self:HLR_ApplyFemaleSounds()
	else
		self:HLR_ApplyMaleSounds()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoChangeWeapon(newWeapon, oldWeapon, invSwitch)
	if invSwitch == true then -- Only if it's a inventory switch
		self:VJ_ACT_PLAYACTIVITY(ACT_PICKUP_RACK, true, false, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	self:VJ_ACT_PLAYACTIVITY("vjseq_cheer1", false, false, false, 0, {vTbl_SequenceInterruptible=true})
end
/* -- Disable for now
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if !self.IsEngineer then return end
	if IsValid(self:GetEnemy()) && self:Visible(self:GetEnemy()) && self.HLR_HL2_NextTurretT < CurTime() && self.HLR_HL2_PlacingTurret == false && !IsValid(self.HLR_HL2_MyTurret) && math.random(1,10) == 1 then
		self.HLR_HL2_NextTurretT = CurTime() +30
		self.HLR_HL2_PlacingTurret = true
		self:VJ_ACT_PLAYACTIVITY("vjseq_ThrowItem",true,false,true) // gunrack
		timer.Simple(1.2,function()
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
end*/
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
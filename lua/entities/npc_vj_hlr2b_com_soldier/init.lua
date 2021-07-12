AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/combine_soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_red"}

ENT.MeleeAttackDamage = 10
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl" -- The model for the grenade entity
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 500 -- How close should the player be until it runs the code?

ENT.AnimTbl_WeaponAttackFiringGesture = {"gesture_shoot_ar2"}
ENT.AnimTbl_WeaponAttackSecondary = {"shootAR2g"}
ENT.GrenadeAttackAttachment = "righthand"
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/combine_soldier/gear1.wav","npc/combine_soldier/gear2.wav","npc/combine_soldier/gear3.wav","npc/combine_soldier/gear4.wav","npc/combine_soldier/gear5.wav","npc/combine_soldier/gear6.wav"}
ENT.SoundTbl_CombatIdle = {
	"vj_hlr/hl2_npc/combine/go_alert1.wav",
	"vj_hlr/hl2_npc/combine/go_alert2.wav",
	"vj_hlr/hl2_npc/combine/go_alert3.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vj_hlr/hl2_npc/combine/lost_long1.wav",
	"vj_hlr/hl2_npc/combine/lost_long2.wav",
	"vj_hlr/hl2_npc/combine/lost_long3.wav",
	"vj_hlr/hl2_npc/combine/lost_short1.wav",
	"vj_hlr/hl2_npc/combine/lost_short2.wav",
	"vj_hlr/hl2_npc/combine/lost_short3.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl2_npc/combine/announce1.wav",
	"vj_hlr/hl2_npc/combine/announce2.wav",
	"vj_hlr/hl2_npc/combine/announce3.wav",
	"vj_hlr/hl2_npc/combine/refind_enemy1.wav",
	"vj_hlr/hl2_npc/combine/refind_enemy2.wav",
	"vj_hlr/hl2_npc/combine/refind_enemy3.wav",
}
ENT.SoundTbl_GrenadeAttack = {
	"vj_hlr/hl2_npc/combine/throw_grenade1.wav",
	"vj_hlr/hl2_npc/combine/throw_grenade2.wav",
	"vj_hlr/hl2_npc/combine/throw_grenade3.wav",
}
ENT.SoundTbl_OnGrenadeSight = {
	"vj_hlr/hl2_npc/combine/spot_grenade1.wav",
	"vj_hlr/hl2_npc/combine/spot_grenade2.wav",
	"vj_hlr/hl2_npc/combine/spot_grenade3.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vj_hlr/hl2_npc/combine/player_dead1.wav",
	"vj_hlr/hl2_npc/combine/player_dead2.wav",
	"vj_hlr/hl2_npc/combine/player_dead3.wav",
}
ENT.SoundTbl_AllyDeath = {
	"vj_hlr/hl2_npc/combine/man_down1.wav",
	"vj_hlr/hl2_npc/combine/man_down2.wav",
	"vj_hlr/hl2_npc/combine/man_down3.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl2_npc/combine/assault1.wav",
	"vj_hlr/hl2_npc/combine/assault2.wav",
	"vj_hlr/hl2_npc/combine/assault3.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl2_npc/combine/die1.wav",
	"vj_hlr/hl2_npc/combine/die2.wav",
	"vj_hlr/hl2_npc/combine/die3.wav",
}

ENT.CanClimb = false
ENT.IsClimbing = false
ENT.NextClimbT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.CanClimb == true && self.Dead == false && self.IsClimbing == false && CurTime() > self.NextClimbT then
		local anim = false
		local finalpos = self:GetPos()
		local tr1 = util.TraceLine({start = self:GetPos() + self:GetUp()*32, endpos = self:GetPos() + self:GetUp()*32 +self:GetForward() *200, filter = function(ent) if (ent:GetClass() == "prop_physics") then return true end end}) -- 32
		local tru = util.TraceLine({start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*100, filter = self})
		if !IsValid(tru.Entity) then
			if IsValid(tr1.Entity) then
				anim = "vjseq_Run_jumpup_32"
				finalpos = tr1.HitPos +self:GetForward() *25
			end
			if anim != false then
			-- VJ_CreateTestObject(tr1.StartPos,self:GetAngles(),Color(0,0,255))
			-- VJ_CreateTestObject(finalpos,self:GetAngles(),Color(0,255,0))
				self:SetGroundEntity(NULL)
				self.IsClimbing = true
				timer.Simple(1.21,function()
					if IsValid(self) then
						self:SetPos(finalpos)
					end
				end)
				self:VJ_ACT_PLAYACTIVITY(anim,true,false,true,0,{},function(vsched)
					vsched.RunCode_OnFinish = function()
						self.IsClimbing = false
					end
				end)
			end
			self.NextClimbT = CurTime() + 0.1
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if VJ_HasValue(self.SoundTbl_Death,sdFile) then
		VJ_EmitSound(self,"vj_hlr/hl2_npc/combine/click_terminated.wav")
		return
	end
	if VJ_HasValue(self.DefaultSoundTbl_MeleeAttack,sdFile) then return end
	VJ_EmitSound(self,"vj_hlr/hl2_npc/combine/clik.wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ_EmitSound(self,"vj_hlr/hl2_npc/combine/click_off.wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(grenEnt)
	grenEnt.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
	grenEnt.IdleSoundPitch = VJ_Set(100, 100)
	local redglow = ents.Create("env_sprite")
	redglow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	redglow:SetKeyValue("scale","0.07")
	redglow:SetKeyValue("rendermode","5")
	redglow:SetKeyValue("rendercolor","150 0 0")
	redglow:SetKeyValue("spawnflags","1") -- If animated
	redglow:SetParent(grenEnt)
	redglow:Fire("SetParentAttachment","fuse",0)
	redglow:Spawn()
	redglow:Activate()
	grenEnt:DeleteOnRemove(redglow)
	util.SpriteTrail(grenEnt,1,Color(200,0,0),true,15,15,0.35,1/(6+6)*0.5,"VJ_Base/sprites/vj_trial1.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if (dmginfo:IsBulletDamage()) then
		dmginfo:ScaleDamage(0.60)
		if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end
		local attacker = dmginfo:GetAttacker()
		if math.random(1,3) == 1 then
			dmginfo:ScaleDamage(0.50)
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
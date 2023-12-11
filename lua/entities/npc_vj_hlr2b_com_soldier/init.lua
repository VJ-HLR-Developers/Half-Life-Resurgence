AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl2b/combine_soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 60
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"blood_impact_red_01_mist"}
ENT.MeleeAttackDamage = 10
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the NPC have a grenade attack?
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl" -- Overrides the model of the grenade | Can be nil, string, and table | Does NOT apply to picked up grenades and forced grenade attacks with custom entity
ENT.GrenadeAttackAttachment = "righthand" -- The attachment that the grenade will spawn at | false = Custom position
ENT.AnimTbl_WeaponAttackSecondary = {"vjseq_shoot_ar2grenade"}
ENT.WeaponAttackSecondaryTimeUntilFire = 0.55
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {"vjges_flinch_gesture"} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
//ENT.SoundTbl_FootStep = {"npc/combine_soldier/gear1.wav","npc/combine_soldier/gear2.wav","npc/combine_soldier/gear3.wav","npc/combine_soldier/gear4.wav","npc/combine_soldier/gear5.wav","npc/combine_soldier/gear6.wav"}
ENT.SoundTbl_CombatIdle = {
	"vj_hlr/hl2b_npc/combine_soldier/go_alert1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/go_alert2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/go_alert3.wav",
}
ENT.SoundTbl_LostEnemy = {
	"vj_hlr/hl2b_npc/combine_soldier/lost_long1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/lost_long2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/lost_long3.wav",
	"vj_hlr/hl2b_npc/combine_soldier/lost_short1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/lost_short2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/lost_short3.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl2b_npc/combine_soldier/announce1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/announce2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/announce3.wav",
	"vj_hlr/hl2b_npc/combine_soldier/refind_enemy1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/refind_enemy2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/refind_enemy3.wav",
}
ENT.SoundTbl_GrenadeAttack = {
	"vj_hlr/hl2b_npc/combine_soldier/throw_grenade1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/throw_grenade2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/throw_grenade3.wav",
}
ENT.SoundTbl_OnGrenadeSight = {
	"vj_hlr/hl2b_npc/combine_soldier/spot_grenade1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/spot_grenade2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/spot_grenade3.wav",
}
ENT.SoundTbl_OnDangerSight = {
	"vj_hlr/hl2b_npc/combine_soldier/spot_grenade1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/spot_grenade2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/spot_grenade3.wav",
}
ENT.SoundTbl_OnKilledEnemy = {
	"vj_hlr/hl2b_npc/combine_soldier/player_dead1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/player_dead2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/player_dead3.wav",
}
ENT.SoundTbl_AllyDeath = {
	"vj_hlr/hl2b_npc/combine_soldier/man_down1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/man_down2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/man_down3.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl2b_npc/combine_soldier/assault1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/assault2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/assault3.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl2b_npc/combine_soldier/die1.wav",
	"vj_hlr/hl2b_npc/combine_soldier/die2.wav",
	"vj_hlr/hl2b_npc/combine_soldier/die3.wav",
}

/* -- Vault over objects test
ENT.CanClimb = true
ENT.IsClimbing = false
ENT.NextClimbT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self.CanClimb == true && !self.Dead && self.IsClimbing == false && CurTime() > self.NextClimbT then
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
			-- VJ.DEBUG_TempEnt(tr1.StartPos,self:GetAngles(),Color(0,0,255))
			-- VJ.DEBUG_TempEnt(finalpos,self:GetAngles(),Color(0,255,0))
				self:SetGroundEntity(NULL)
				self.IsClimbing = true
				timer.Simple(1.21,function()
					if IsValid(self) then
						self:SetPos(finalpos)
					end
				end)
				self:VJ_ACT_PLAYACTIVITY(anim,true,false,true,0,{},function(sched)
					sched.RunCode_OnFinish = function()
						self.IsClimbing = false
					end
				end)
			end
			self.NextClimbT = CurTime() + 0.1
		end
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSetupWeaponHoldTypeAnims(wepHoldType)
	//self.WeaponAnimTranslations[ACT_RANGE_ATTACK1] 				= ACT_RANGE_ATTACK1 -- No need to translate
	self.WeaponAnimTranslations[ACT_GESTURE_RANGE_ATTACK1] 			= ACT_GESTURE_RANGE_ATTACK_AR2
	//self.WeaponAnimTranslations[ACT_RANGE_ATTACK1_LOW] 			= ACT_RANGE_ATTACK1_LOW -- No need to translate
	//self.WeaponAnimTranslations[ACT_RELOAD] 						= ACT_RELOAD -- No need to translate
	//self.WeaponAnimTranslations[ACT_RELOAD_LOW] 					= ACT_RELOAD_LOW -- No need to translate
	self.WeaponAnimTranslations[ACT_COVER_LOW] 						= {ACT_COVER_LOW, "vjseq_crouch_leanwall_idle01"}
	
	//self.WeaponAnimTranslations[ACT_IDLE] 						= ACT_IDLE -- No need to translate
	//self.WeaponAnimTranslations[ACT_IDLE_ANGRY] 					= ACT_IDLE_ANGRY -- No need to translate
	
	//self.WeaponAnimTranslations[ACT_WALK] 						= ACT_WALK -- No need to translate
	//self.WeaponAnimTranslations[ACT_WALK_AIM] 						= ACT_WALK_AIM -- No need to translate
	self.WeaponAnimTranslations[ACT_WALK_CROUCH] 					= ACT_WALK_CROUCH_RIFLE
	self.WeaponAnimTranslations[ACT_WALK_CROUCH_AIM] 				= ACT_WALK_CROUCH_AIM_RIFLE
	
	//self.WeaponAnimTranslations[ACT_RUN] 							= ACT_RUN -- No need to translate
	//self.WeaponAnimTranslations[ACT_RUN_AIM] 						= ACT_RUN_AIM -- No need to translate
	self.WeaponAnimTranslations[ACT_RUN_CROUCH] 					= ACT_RUN_CROUCH_RIFLE
	self.WeaponAnimTranslations[ACT_RUN_CROUCH_AIM] 				= ACT_RUN_CROUCH_AIM_RIFLE
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if VJ.HasValue(self.SoundTbl_Death,sdFile) then
		VJ.EmitSound(self,"vj_hlr/hl2b_npc/combine_soldier/click_terminated.wav")
		return
	end
	if VJ.HasValue(self.DefaultSoundTbl_MeleeAttack,sdFile) then return end
	VJ.EmitSound(self,"vj_hlr/hl2b_npc/combine_soldier/clik.wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ.EmitSound(self,"vj_hlr/hl2b_npc/combine_soldier/click_off.wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnGrenadeAttack(status, grenade, customEnt, landDir, landingPos)
	if status == "Throw" then
		-- Custom grenade model and sounds
		grenade.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
		grenade.IdleSoundPitch = VJ.SET(100, 100)
		
		local redGlow = ents.Create("env_sprite")
		redGlow:SetKeyValue("model", "vj_base/sprites/vj_glow1.vmt")
		redGlow:SetKeyValue("scale", "0.07")
		redGlow:SetKeyValue("rendermode", "5")
		redGlow:SetKeyValue("rendercolor", "150 0 0")
		redGlow:SetKeyValue("spawnflags", "1") -- If animated
		redGlow:SetParent(grenade)
		redGlow:Fire("SetParentAttachment", "fuse", 0)
		redGlow:Spawn()
		redGlow:Activate()
		grenade:DeleteOnRemove(redGlow)
		util.SpriteTrail(grenade, 1, Color(200,0,0), true, 15, 15, 0.35, 1/(6+6)*0.5, "VJ_Base/sprites/vj_trial1.vmt")
	
		return (landingPos - grenade:GetPos()) + (self:GetUp()*200 + self:GetForward()*500 + self:GetRight()*math.Rand(-20, 20))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	-- Absorb bullet damage
	if dmginfo:IsBulletDamage() then
		if self.HasSounds == true && self.HasImpactSounds == true then VJ.EmitSound(self, "vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav", 70) end
		if math.random(1, 3) == 1 then
			dmginfo:ScaleDamage(0.50)
			local spark = ents.Create("env_spark")
			spark:SetKeyValue("Magnitude","1")
			spark:SetKeyValue("Spark Trail Length","1")
			spark:SetPos(dmginfo:GetDamagePosition())
			spark:SetAngles(self:GetAngles())
			spark:SetParent(self)
			spark:Spawn()
			spark:Activate()
			spark:Fire("StartSpark", "", 0)
			spark:Fire("StopSpark", "", 0.001)
			self:DeleteOnRemove(spark)
		else
			dmginfo:ScaleDamage(0.80)
		end
	end
end
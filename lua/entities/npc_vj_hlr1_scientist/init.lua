AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/scientist.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_Blood_HL1_Red"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- Doesn't attack anything
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?

ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.HasItemDropsOnDeath = false -- Should it drop items on death?
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/scientist/cough.wav","vj_hlr/hl1_npc/scientist/containfail.wav","vj_hlr/hl1_npc/scientist/catchone.wav","vj_hlr/hl1_npc/scientist/cascade.wav","vj_hlr/hl1_npc/scientist/c2a4_sci_arg2a.wav","vj_hlr/hl1_npc/scientist/c2a4_sci_arg4a.wav","vj_hlr/hl1_npc/scientist/c1a4_sci_trainend.wav","vj_hlr/hl1_npc/scientist/c1a4_sci_pwroff.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_darkroom.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_3scan.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_2scan.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_1scan.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_stall.wav","vj_hlr/hl1_npc/scientist/bloodsample.wav","vj_hlr/hl1_npc/scientist/beverage.wav","vj_hlr/hl1_npc/scientist/areyouthink.wav","vj_hlr/hl1_npc/scientist/administrator.wav","vj_hlr/hl1_npc/scientist/alienappeal.wav","vj_hlr/hl1_npc/scientist/alientrick.wav","vj_hlr/hl1_npc/scientist/analysis.wav","vj_hlr/hl1_npc/scientist/announcer.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/scientist/b01_sci01_whereami.wav","vj_hlr/hl1_npc/scientist/cantbeworse.wav","vj_hlr/hl1_npc/scientist/canttakemore.wav"}
ENT.SoundTbl_OnReceiveOrder = {}
ENT.SoundTbl_FollowPlayer = {"vj_hlr/hl1_npc/scientist/d01_sci14_right.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_scanrpt.wav","vj_hlr/hl1_npc/scientist/absolutely.wav","vj_hlr/hl1_npc/scientist/alright.wav"}
ENT.SoundTbl_UnFollowPlayer = {"vj_hlr/hl1_npc/scientist/d01_sci14_right.wav","vj_hlr/hl1_npc/scientist/crowbar.wav","vj_hlr/hl1_npc/scientist/cantbeserious.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_1man.wav","vj_hlr/hl1_npc/scientist/c1a1_sci_5scan.wav","vj_hlr/hl1_npc/scientist/asexpected.wav","vj_hlr/hl1_npc/scientist/beenaburden.wav"}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {"vj_hlr/hl1_npc/scientist/corporal.wav","vj_hlr/hl1_npc/scientist/c3a2_sci_1surv.wav","vj_hlr/hl1_npc/scientist/c2a4_sci_surgury.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_thankgod.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_itsyou.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_gm1.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_gm.wav","vj_hlr/hl1_npc/scientist/afellowsci.wav","vj_hlr/hl1_npc/scientist/ahfreeman.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_bigday.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl4a.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/hl1_npc/scientist/d01_sci10_interesting.wav","vj_hlr/hl1_npc/scientist/c3a2_sci_1glu.wav"}
ENT.SoundTbl_LostEnemy = {}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/scientist/c1a3_sci_silo2a.wav"}
ENT.SoundTbl_CallForHelp = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {"vj_hlr/hl1_npc/scientist/advance.wav","vj_hlr/hl1_npc/scientist/c2a4_sci_alldie.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/scientist/c1a2_sci_1zomb.wav"}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_AllyDeath = {}
ENT.SoundTbl_Pain = {"vj_hlr/hl1_npc/scientist/c1a2_sci_dangling.wav"}
ENT.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/scientist/c3a2_sci_fool.wav","vj_hlr/hl1_npc/scientist/c1a3_sci_team.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_stayback.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_3zomb.wav","vj_hlr/hl1_npc/scientist/c1a2_sci_5zomb.wav"}
ENT.SoundTbl_Death = {}
ENT.SoundTbl_SoundTrack = {}

/*
vj_hlr/hl1_npc/scientist/absolutelynot.wav
vj_hlr/hl1_npc/scientist/allnominal.wav
vj_hlr/hl1_npc/scientist/assist.wav
vj_hlr/hl1_npc/scientist/b01_sci02_briefcase.wav
vj_hlr/hl1_npc/scientist/b01_sci03_sirplease.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_catscream.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_crit1a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_crit2a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_crit3a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl1a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl2a.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_ctrl3a.wav
-- All of the "c1a0_sci_dis"
vj_hlr/hl1_npc/scientist/c1a0_sci_getaway.wav
-- All of the "vj_hlr/hl1_npc/scientist/c1a0_sci_lock1a.wav"
vj_hlr/hl1_npc/scientist/c1a0_sci_mumble.wav
vj_hlr/hl1_npc/scientist/c1a0_sci_samp.wav
vj_hlr/hl1_npc/scientist/c1a1_sci_4scan.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_6zomb.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_elevator.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_lounge.wav
vj_hlr/hl1_npc/scientist/c1a2_sci_transm.wav
vj_hlr/hl1_npc/scientist/c1a3_sci_atlast.wav
vj_hlr/hl1_npc/scientist/c1a3_sci_rescued.wav
vj_hlr/hl1_npc/scientist/c1a3_sci_silo1a.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_blind.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_gener.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_pwr.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_rocket.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_tent.wav
vj_hlr/hl1_npc/scientist/c1a4_sci_trust.wav
vj_hlr/hl1_npc/scientist/c2a3_sci_icky.wav
vj_hlr/hl1_npc/scientist/c2a3_sci_track.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_2tau.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_4tau.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_letout.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_scanner.wav
vj_hlr/hl1_npc/scientist/c2a4_sci_sugicaloff.wav
vj_hlr/hl1_npc/scientist/c2a5_sci_boobie.wav
vj_hlr/hl1_npc/scientist/c2a5_sci_lebuz.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_2sat.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_4sat.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_6sat.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_dome.wav
vj_hlr/hl1_npc/scientist/c3a1_sci_done.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_2glu.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_3glu.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_3surv.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_5surv.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_7surv.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_flood.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_forever.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_linger.wav
vj_hlr/hl1_npc/scientist/c3a2_sci_ljump.wav
-- vj_hlr/hl1_npc/scientist/c3a2_sci_notyet.wav ----> vj_hlr/hl1_npc/scientist/c3a2_sci_uphere_alt.wav
vj_hlr/hl1_npc/scientist/chaostheory.wav
vj_hlr/hl1_npc/scientist/checkatten.wav
vj_hlr/hl1_npc/scientist/chimp.wav
vj_hlr/hl1_npc/scientist/completelywrong.wav
vj_hlr/hl1_npc/scientist/correcttheory.wav
vj_hlr/hl1_npc/scientist/crossgreen.wav
vj_hlr/hl1_npc/scientist/d01_sci01_waiting.wav ----> vj_hlr/hl1_npc/scientist/d01_sci09_pushsample2.wav
vj_hlr/hl1_npc/scientist/d01_sci11_shouldnthappen.wav ----> vj_hlr/hl1_npc/scientist/d01_sci13_jammed.wav
vj_hlr/hl1_npc/scientist/d01_sci15_onschedule.wav ----> vj_hlr/hl1_npc/scientist/d08_sci05_osprey.wav
vj_hlr/hl1_npc/scientist/dangerous.wav
vj_hlr/hl1_npc/scientist/delayagain.wav
*/

-- Custom
ENT.HECU_Type = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	local randbg = math.random(0,3)
	self:SetBodygroup(1,randbg)
	if randbg == 2 then
		self:SetSkin(1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	print(key)
	if key == "step" then
		self:FootStepSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.HECU_GasTankHit == true then
		util.BlastDamage(self,self,self:GetPos(),100,80)
		util.ScreenShake(self:GetPos(),100,200,1,500)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos()+Vector(0,0,32))
		util.Effect("Explosion",effectdata)
		util.Effect("HelicopterMegaBomb",effectdata)
		//ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil)
	end
	if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,60))})
		self.HasDeathAnimation = false
		return true,{DeathAnim=false,AllowCorpse=true}
	else
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(120)
			util.Effect("VJ_Blood1",bloodeffect)
			
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos())
			bloodspray:SetScale(8)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("bloodspray",bloodspray)
			util.Effect("bloodspray",bloodspray)
		end
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_bone.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,50))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_gib.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_guts.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_hmeat.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_lung.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,60))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_legbone.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,15))})
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/gib_hgrunt.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,15))})
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	if self.HECU_Type == 0 && hitgroup == HITGROUP_HEAD then
		VJ_EmitSound(self,{"vj_hlr/fx/headshot1.wav","vj_hlr/fx/headshot2.wav","vj_hlr/fx/headshot3.wav"},75,math.random(100,100))
	else
		VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	end
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
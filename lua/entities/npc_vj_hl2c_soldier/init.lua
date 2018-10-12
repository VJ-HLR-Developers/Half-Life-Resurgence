AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/combine_soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = GetConVarNumber("vj_hl2c_soldier_h")
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = GetConVarNumber("vj_hl2c_soldier_d")
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl" -- The model for the grenade entity
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 500 -- How close should the player be until it runs the code?
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/combine_soldier/gear1.wav","npc/combine_soldier/gear2.wav","npc/combine_soldier/gear3.wav","npc/combine_soldier/gear4.wav","npc/combine_soldier/gear5.wav","npc/combine_soldier/gear6.wav"}
ENT.SoundTbl_Idle = {"npc/combine_soldier/vo/block31mace.wav","npc/combine_soldier/vo/block64jet.wav","npc/combine_soldier/vo/cleaned.wav","npc/combine_soldier/vo/motioncheckallradials.wav","npc/combine_soldier/vo/isfinalteamunitbackup.wav","npc/combine_soldier/vo/isfieldpromoted.wav","npc/combine_soldier/vo/sector.wav","npc/combine_soldier/vo/sectorissecurenovison.wav","npc/combine_soldier/vo/teamdeployedandscanning.wav","npc/combine_soldier/vo/isatcode.wav","npc/combine_soldier/vo/isholdingatcode.wav","npc/combine_soldier/vo/noviscon.wav","npc/combine_soldier/vo/secure.wav","npc/combine_soldier/vo/stayalert.wav","npc/combine_soldier/vo/hasnegativemovement.wav","npc/combine_soldier/vo/reportallpositionsclear.wav","npc/combine_soldier/vo/reportallradialsfree.wav","npc/combine_soldier/vo/reportingclear.wav","npc/combine_soldier/vo/ovewatchorders3ccstimboost.wav","npc/combine_soldier/vo/fullactive.wav","npc/combine_soldier/vo/sightlineisclear.wav","npc/combine_soldier/vo/stabilizationteamhassector.wav","npc/combine_soldier/vo/stabilizationteamholding.wav","npc/combine_soldier/vo/standingby].wav","npc/combine_soldier/vo/stayalertreportsightlines.wav","npc/combine_soldier/vo/bearing.wav","npc/combine_soldier/vo/vamp.wav","npc/combine_soldier/vo/leader.wav"}
ENT.SoundTbl_CombatIdle = {"npc/combine_soldier/vo/sectorisnotsecure.wav","npc/combine_soldier/vo/closing.wav","npc/combine_soldier/vo/closing2.wav","npc/combine_soldier/vo/sweepingin.wav","npc/combine_soldier/vo/outbreakstatusiscode.wav","npc/combine_soldier/vo/sectionlockupdash4.wav","npc/combine_soldier/vo/prioritytwoescapee.wav","npc/combine_soldier/vo/priority1objective.wav","npc/combine_soldier/vo/goactiveintercept.wav","npc/combine_soldier/vo/necrotics.wav","npc/combine_soldier/vo/fixsightlinesmovein.wav","npc/combine_soldier/vo/movein.wav","npc/combine_soldier/vo/savage.wav","npc/combine_soldier/vo/hardenthatposition.wav","npc/combine_soldier/vo/gosharp.wav","npc/combine_soldier/vo/gosharpgosharp.wav","npc/combine_soldier/vo/striker.wav","npc/combine_soldier/vo/containmentproceeding.wav","npc/combine_soldier/vo/confirmsectornotsterile.wav","npc/combine_soldier/vo/displace.wav","npc/combine_soldier/vo/displace2.wav","npc/combine_soldier/vo/engagedincleanup.wav","npc/combine_soldier/vo/executingfullresponse.wav"}
ENT.SoundTbl_MedicBeforeHeal = {"npc/combine_soldier/vo/antiseptic.wav","npc/combine_soldier/vo/delivered.wav"}
ENT.SoundTbl_OnPlayerSight = {"npc/combine_soldier/vo/freeman3.wav"}
ENT.SoundTbl_Alert = {"npc/combine_soldier/vo/sharpzone.wav","npc/combine_soldier/vo/prepforcontact.wav","npc/combine_soldier/vo/necroticsinbound.wav","npc/combine_soldier/vo/readycharges.wav","npc/combine_soldier/vo/readyextractors.wav","npc/combine_soldier/vo/readyweapons.wav","npc/combine_soldier/vo/readyweaponshostilesinbound.wav","npc/combine_soldier/vo/overwatchreportspossiblehostiles.wav","npc/combine_soldier/vo/weaponsoffsafeprepforcontact.wav","npc/combine_soldier/vo/wehavefreeparasites.wav","npc/combine_soldier/vo/target.wav","npc/combine_soldier/vo/targetisat.wav","npc/combine_soldier/vo/targetmyradial.wav","npc/combine_soldier/vo/targetone.wav","npc/combine_soldier/vo/targetcontactat.wav","npc/combine_soldier/vo/inbound.wav","npc/combine_soldier/vo/visualonexogens.wav","npc/combine_soldier/vo/dash.wav","npc/combine_soldier/vo/alert1.wav","npc/combine_soldier/vo/contact.wav","npc/combine_soldier/vo/contactconfim.wav","npc/combine_soldier/vo/callcontactparasitics.wav","npc/combine_soldier/vo/callcontacttarget1.wav","npc/combine_soldier/vo/callhotpoint.wav"}
ENT.SoundTbl_CallForHelp = {"npc/combine_soldier/vo/overwatchrequestreinforcement.wav","npc/combine_soldier/vo/targetcompromisedmovein.wav"}
ENT.SoundTbl_OnReceiveOrder = {"npc/combine_soldier/vo/affirmative.wav","npc/combine_soldier/vo/affirmative2.wav","npc/combine_soldier/vo/copy.wav","npc/combine_soldier/vo/copythat.wav"}
ENT.SoundTbl_Suppressing = {"npc/combine_soldier/vo/unitisinbound.wav","npc/combine_soldier/vo/contactconfirmprosecuting.wav","npc/combine_soldier/vo/prosecuting.wav","npc/combine_soldier/vo/suppressing.wav","npc/combine_soldier/vo/engaging.wav"}
ENT.SoundTbl_WeaponReload = {"npc/combine_soldier/vo/cover.wav","npc/combine_soldier/vo/coverhurt.wav","npc/combine_soldier/vo/coverme.wav"}
ENT.SoundTbl_GrenadeAttack = {"npc/combine_soldier/vo/slam.wav"}
ENT.SoundTbl_OnGrenadeSight = {"npc/combine_soldier/vo/ripcordripcord.wav","npc/combine_soldier/vo/boomer.wav","npc/combine_soldier/vo/bouncerbouncer.wav"}
ENT.SoundTbl_OnKilledEnemy = {"npc/combine_soldier/vo/overwatchtarget1sterilized.wav","npc/combine_soldier/vo/contained.wav","npc/combine_soldier/vo/targetineffective.wav","npc/combine_soldier/vo/onedown.wav","npc/combine_soldier/vo/onecontained.wav","npc/combine_soldier/vo/payback.wav"}
ENT.SoundTbl_Pain = {"npc/combine_soldier/pain1.wav","npc/combine_soldier/pain2.wav","npc/combine_soldier/pain3.wav","npc/combine_soldier/vo/heavyresistance.wav","npc/combine_soldier/vo/bodypackholding.wav","npc/combine_soldier/vo/requestmedical.wav","npc/combine_soldier/vo/requeststimdose.wav"}
ENT.SoundTbl_Death = {"npc/combine_soldier/die1.wav","npc/combine_soldier/die2.wav","npc/combine_soldier/die3.wav"}


-- Reset Enemy: "npc/combine_soldier/vo/ghost2.wav","npc/combine_soldier/vo/lostcontact.wav","npc/combine_soldier/vo/onedutyvacated.wav","npc/combine_soldier/vo/overwatchtargetcontained.wav","npc/combine_soldier/vo/overwatchconfirmhvtcontained.wav","npc/combine_soldier/vo/targetblackout.wav"
---- Add two types: TO DO...

-- Ally die: "npc/combine_soldier/vo/overwatchteamisdown.wav"
---- It's VJ Base SNPC
/*
"npc/combine_soldier/vo/affirmativewegothimnow.wav"
"npc/combine_soldier/vo/flaredown.wav"
"npc/combine_soldier/vo/unitisclosing.wav"
"npc/combine_soldier/vo/unitismovingin.wav"
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(SoundData,SoundFile)
	if VJ_HasValue(self.SoundTbl_Pain,SoundFile) then return end
	timer.Simple(SoundDuration(SoundFile),function() if IsValid(self) && SoundData:IsPlaying() then VJ_EmitSound(self,"npc/combine_soldier/vo/off"..math.random(1,3)..".wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(GrenadeEntity)
	GrenadeEntity.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
	GrenadeEntity.IdleSoundPitch1 = 100
	local redglow = ents.Create("env_sprite")
	redglow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	redglow:SetKeyValue("scale","0.07")
	redglow:SetKeyValue("rendermode","5")
	redglow:SetKeyValue("rendercolor","150 0 0")
	redglow:SetKeyValue("spawnflags","1") -- If animated
	redglow:SetParent(GrenadeEntity)
	redglow:Fire("SetParentAttachment","fuse",0)
	redglow:Spawn()
	redglow:Activate()
	GrenadeEntity:DeleteOnRemove(redglow)
	util.SpriteTrail(GrenadeEntity,1,Color(200,0,0),true,15,15,0.35,1/(6+6)*0.5,"VJ_Base/sprites/vj_trial1.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
	if (dmginfo:IsBulletDamage()) then
		local attacker = dmginfo:GetAttacker()
		if math.random(1,3) == 1 then
			if math.random(1,2) == 1 then dmginfo:ScaleDamage(0.50) else dmginfo:ScaleDamage(0.25) end
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
			if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self,"vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav",70) end
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
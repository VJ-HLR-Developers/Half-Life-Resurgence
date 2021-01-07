AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/combine_soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = GetConVarNumber("vj_hl2c_soldier_h")
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.MeleeAttackDamage = GetConVarNumber("vj_hl2c_soldier_d")
ENT.FootStepTimeRun = 0.25 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackModel = "models/weapons/w_npcnade.mdl" -- The model for the grenade entity
ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 500 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/combine_soldier/gear1.wav","npc/combine_soldier/gear2.wav","npc/combine_soldier/gear3.wav","npc/combine_soldier/gear4.wav","npc/combine_soldier/gear5.wav","npc/combine_soldier/gear6.wav"}
ENT.SoundTbl_Idle = {"npc/combine_soldier/vo/block31mace.wav","npc/combine_soldier/vo/block64jet.wav","npc/combine_soldier/vo/cleaned.wav","npc/combine_soldier/vo/motioncheckallradials.wav","npc/combine_soldier/vo/isfinalteamunitbackup.wav","npc/combine_soldier/vo/isfieldpromoted.wav","npc/combine_soldier/vo/sector.wav","npc/combine_soldier/vo/sectorissecurenovison.wav","npc/combine_soldier/vo/teamdeployedandscanning.wav","npc/combine_soldier/vo/isatcode.wav","npc/combine_soldier/vo/isholdingatcode.wav","npc/combine_soldier/vo/noviscon.wav","npc/combine_soldier/vo/secure.wav","npc/combine_soldier/vo/stayalert.wav","npc/combine_soldier/vo/hasnegativemovement.wav","npc/combine_soldier/vo/reportallpositionsclear.wav","npc/combine_soldier/vo/reportallradialsfree.wav","npc/combine_soldier/vo/reportingclear.wav","npc/combine_soldier/vo/ovewatchorders3ccstimboost.wav","npc/combine_soldier/vo/fullactive.wav","npc/combine_soldier/vo/sightlineisclear.wav","npc/combine_soldier/vo/stabilizationteamhassector.wav","npc/combine_soldier/vo/stabilizationteamholding.wav","npc/combine_soldier/vo/standingby].wav","npc/combine_soldier/vo/stayalertreportsightlines.wav","npc/combine_soldier/vo/bearing.wav","npc/combine_soldier/vo/vamp.wav","npc/combine_soldier/vo/leader.wav"}
ENT.SoundTbl_CombatIdle = {"npc/combine_soldier/vo/unitismovingin.wav","npc/combine_soldier/vo/unitisclosing.wav","npc/combine_soldier/vo/sectorisnotsecure.wav","npc/combine_soldier/vo/closing.wav","npc/combine_soldier/vo/closing2.wav","npc/combine_soldier/vo/sweepingin.wav","npc/combine_soldier/vo/outbreakstatusiscode.wav","npc/combine_soldier/vo/sectionlockupdash4.wav","npc/combine_soldier/vo/prioritytwoescapee.wav","npc/combine_soldier/vo/goactiveintercept.wav","npc/combine_soldier/vo/fixsightlinesmovein.wav","npc/combine_soldier/vo/movein.wav","npc/combine_soldier/vo/savage.wav","npc/combine_soldier/vo/hardenthatposition.wav","npc/combine_soldier/vo/gosharp.wav","npc/combine_soldier/vo/gosharpgosharp.wav","npc/combine_soldier/vo/striker.wav","npc/combine_soldier/vo/containmentproceeding.wav","npc/combine_soldier/vo/confirmsectornotsterile.wav","npc/combine_soldier/vo/displace.wav","npc/combine_soldier/vo/displace2.wav","npc/combine_soldier/vo/engagedincleanup.wav","npc/combine_soldier/vo/executingfullresponse.wav"}
ENT.SoundTbl_MedicBeforeHeal = {"npc/combine_soldier/vo/administer.wav","npc/combine_soldier/vo/antiseptic.wav","npc/combine_soldier/vo/delivered.wav"}
ENT.SoundTbl_OnPlayerSight = {"npc/combine_soldier/vo/freeman3.wav"}
ENT.SoundTbl_LostEnemy = {"npc/combine_soldier/vo/skyshieldreportslostcontact.wav","npc/combine_soldier/vo/shadow.wav","npc/combine_soldier/vo/ghost.wav","npc/combine_soldier/vo/ghost2.wav","npc/combine_soldier/vo/lostcontact.wav","npc/combine_soldier/vo/onedutyvacated.wav","npc/combine_soldier/vo/targetblackout.wav"}
ENT.SoundTbl_Alert = {"npc/combine_soldier/vo/prepforcontact.wav","npc/combine_soldier/vo/readyextractors.wav","npc/combine_soldier/vo/readyweapons.wav","npc/combine_soldier/vo/readyweaponshostilesinbound.wav","npc/combine_soldier/vo/overwatchreportspossiblehostiles.wav","npc/combine_soldier/vo/weaponsoffsafeprepforcontact.wav","npc/combine_soldier/vo/target.wav","npc/combine_soldier/vo/targetisat.wav","npc/combine_soldier/vo/targetmyradial.wav","npc/combine_soldier/vo/targetcontactat.wav","npc/combine_soldier/vo/inbound.wav","npc/combine_soldier/vo/dash.wav","npc/combine_soldier/vo/alert1.wav","npc/combine_soldier/vo/contact.wav","npc/combine_soldier/vo/contactconfim.wav","npc/combine_soldier/vo/callcontacttarget1.wav","npc/combine_soldier/vo/callhotpoint.wav"}
ENT.SoundTbl_CallForHelp = {"npc/combine_soldier/vo/overwatchsectoroverrun.wav","npc/combine_soldier/vo/overwatchrequestreserveactivation.wav","npc/combine_soldier/vo/flush.wav", "npc/combine_soldier/vo/overwatchrequestreinforcement.wav","npc/combine_soldier/vo/targetcompromisedmovein.wav"}
ENT.SoundTbl_OnReceiveOrder = {"npc/combine_soldier/vo/affirmative.wav","npc/combine_soldier/vo/affirmative2.wav","npc/combine_soldier/vo/copy.wav","npc/combine_soldier/vo/copythat.wav"}
ENT.SoundTbl_Suppressing = {"npc/combine_soldier/vo/unitisinbound.wav","npc/combine_soldier/vo/contactconfirmprosecuting.wav","npc/combine_soldier/vo/prosecuting.wav","npc/combine_soldier/vo/suppressing.wav","npc/combine_soldier/vo/engaging.wav"}
ENT.SoundTbl_WeaponReload = {"npc/combine_soldier/vo/cover.wav","npc/combine_soldier/vo/coverhurt.wav","npc/combine_soldier/vo/coverme.wav"}
ENT.SoundTbl_GrenadeAttack = {"npc/combine_soldier/vo/sharpzone.wav","npc/combine_soldier/vo/slam.wav","npc/combine_soldier/vo/readycharges.wav"}
ENT.SoundTbl_OnGrenadeSight = {"npc/combine_soldier/vo/ripcordripcord.wav","npc/combine_soldier/vo/boomer.wav","npc/combine_soldier/vo/bouncerbouncer.wav"}
ENT.SoundTbl_OnKilledEnemy = {"npc/combine_soldier/vo/thatsitwrapitup.wav","npc/combine_soldier/vo/affirmativewegothimnow.wav","npc/combine_soldier/vo/overwatchconfirmhvtcontained.wav","npc/combine_soldier/vo/overwatchtargetcontained.wav","npc/combine_soldier/vo/overwatchtarget1sterilized.wav","npc/combine_soldier/vo/contained.wav","npc/combine_soldier/vo/targetineffective.wav","npc/combine_soldier/vo/onedown.wav","npc/combine_soldier/vo/onecontained.wav","npc/combine_soldier/vo/payback.wav"}
ENT.SoundTbl_AllyDeath = {"npc/combine_soldier/vo/overwatchteamisdown.wav", "npc/combine_soldier/vo/flatline.wav"}
ENT.SoundTbl_Pain = {"npc/combine_soldier/pain1.wav","npc/combine_soldier/pain2.wav","npc/combine_soldier/pain3.wav","npc/combine_soldier/vo/heavyresistance.wav","npc/combine_soldier/vo/bodypackholding.wav","npc/combine_soldier/vo/requestmedical.wav","npc/combine_soldier/vo/requeststimdose.wav"}
ENT.SoundTbl_Death = {"npc/combine_soldier/die1.wav","npc/combine_soldier/die2.wav","npc/combine_soldier/die3.wav"}

-- Radio sounds (background)
local SoundTbl_Combine_Chatter = {
	"npc/combine_soldier/vo/prison_soldier_activatecentral.wav",
	"npc/combine_soldier/vo/prison_soldier_boomersinbound.wav",
	"npc/combine_soldier/vo/prison_soldier_bunker1.wav",
	"npc/combine_soldier/vo/prison_soldier_bunker2.wav",
	"npc/combine_soldier/vo/prison_soldier_bunker3.wav",
	"npc/combine_soldier/vo/prison_soldier_containd8.wav",
	"npc/combine_soldier/vo/prison_soldier_fallback_b4.wav",
	"npc/combine_soldier/vo/prison_soldier_freeman_antlions.wav",
	"npc/combine_soldier/vo/prison_soldier_fullbioticoverrun.wav",
	"npc/combine_soldier/vo/prison_soldier_leader9dead.wav",
	"npc/combine_soldier/vo/prison_soldier_negativecontainment.wav",
	"npc/combine_soldier/vo/prison_soldier_prosecuted7.wav",
	"npc/combine_soldier/vo/prison_soldier_sundown3dead.wav",
	"npc/combine_soldier/vo/prison_soldier_tohighpoints.wav",
	"npc/combine_soldier/vo/prison_soldier_visceratorsa5.wav",
}

/*
-- NOTE: Number sounds aren't included here!

npc/combine_soldier/vo/apex.wav
npc/combine_soldier/vo/blade.wav
npc/combine_soldier/vo/dagger.wav
npc/combine_soldier/vo/degrees.wav
npc/combine_soldier/vo/designatetargetas.wav
npc/combine_soldier/vo/echo.wav
npc/combine_soldier/vo/extractoraway.wav
npc/combine_soldier/vo/extractorislive.wav
npc/combine_soldier/vo/fist.wav
npc/combine_soldier/vo/flaredown.wav
npc/combine_soldier/vo/flash.wav
npc/combine_soldier/vo/grid.wav
npc/combine_soldier/vo/gridsundown46.wav
npc/combine_soldier/vo/hammer.wav
npc/combine_soldier/vo/helix.wav
npc/combine_soldier/vo/hunter.wav
npc/combine_soldier/vo/hurricane.wav
npc/combine_soldier/vo/ice.wav
npc/combine_soldier/vo/ion.wav
npc/combine_soldier/vo/jet.wav
npc/combine_soldier/vo/judge.wav
npc/combine_soldier/vo/kilo.wav
npc/combine_soldier/vo/mace.wav
npc/combine_soldier/vo/meters.wav
npc/combine_soldier/vo/nomad.wav
npc/combine_soldier/vo/nova.wav
npc/combine_soldier/vo/overwatch.wav
npc/combine_soldier/vo/overwatchrequestskyshield.wav -- requesting sky support
npc/combine_soldier/vo/overwatchrequestwinder.wav
npc/combine_soldier/vo/phantom.wav
npc/combine_soldier/vo/quicksand.wav
npc/combine_soldier/vo/range.wav
npc/combine_soldier/vo/ranger.wav
npc/combine_soldier/vo/razor.wav
npc/combine_soldier/vo/reaper.wav
npc/combine_soldier/vo/ripcord.wav
npc/combine_soldier/vo/scar.wav
npc/combine_soldier/vo/slash.wav
npc/combine_soldier/vo/spear.wav
npc/combine_soldier/vo/stab.wav
npc/combine_soldier/vo/star.wav
npc/combine_soldier/vo/stinger.wav
npc/combine_soldier/vo/storm.wav
npc/combine_soldier/vo/sundown.wav
npc/combine_soldier/vo/sweeper.wav
npc/combine_soldier/vo/swift.wav
npc/combine_soldier/vo/sword.wav
npc/combine_soldier/vo/tracker.wav
npc/combine_soldier/vo/uniform.wav
npc/combine_soldier/vo/vamp.wav
npc/combine_soldier/vo/viscon.wav
*/

-- Custom
ENT.Combine_ChatterT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	self.Combine_ChatterT = CurTime() + math.Rand(1, 30)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnPlayCreateSound(sdData, sdFile)
	if VJ_HasValue(self.SoundTbl_Pain, sdFile) or VJ_HasValue(self.DefaultSoundTbl_MeleeAttack, sdFile) or VJ_HasValue(SoundTbl_Combine_Chatter, sdFile) then return end
	VJ_EmitSound(self, "npc/combine_soldier/vo/on"..math.random(1,2)..".wav")
	timer.Simple(SoundDuration(sdFile), function() if IsValid(self) && sdData:IsPlaying() then VJ_EmitSound(self,"npc/combine_soldier/vo/off"..math.random(1,3)..".wav") end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	-- Random background radio sounds
	if self.Combine_ChatterT < CurTime() then
		if math.random(1,2) == 1 then
			self.Combine_ChatterSd = VJ_CreateSound(self, SoundTbl_Combine_Chatter, 50, 90)
		end
		self.Combine_ChatterT = CurTime() + math.Rand(20, 40)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
	if math.random(1,2) == 1 then
		if argent:IsPlayer() or argent.VJ_HLR_Freeman then
			self:PlaySoundSystem("Alert", {"npc/combine_soldier/vo/freeman3.wav","npc/combine_soldier/vo/anticitizenone.wav","npc/combine_soldier/vo/priority1objective.wav","npc/combine_soldier/vo/targetone.wav"})
		elseif argent:IsNPC() && argent.IsVJBaseSNPC_Creature == true then
			if math.random(1,2) == 1 then
				for _,v in ipairs(argent.VJ_NPC_Class or {1}) do
					if v == "CLASS_ZOMBIE" or argent:Classify() == CLASS_ZOMBIE then
						self:PlaySoundSystem("Alert", {"npc/combine_soldier/vo/infected.wav"})
						goto skip_sound -- Skip the regular creature sounds!
					end
				end
			end
			self:PlaySoundSystem("Alert", {"npc/combine_soldier/vo/outbreak.wav","npc/combine_soldier/vo/callcontactparasitics.wav","npc/combine_soldier/vo/necroticsinbound.wav","npc/combine_soldier/vo/necrotics.wav","npc/combine_soldier/vo/swarmoutbreakinsector.wav","npc/combine_soldier/vo/visualonexogens.wav","npc/combine_soldier/vo/wehavefreeparasites.wav","npc/combine_soldier/vo/wehavenontaggedviromes.wav","npc/combine_soldier/vo/weareinaninfestationzone.wav"})
			::skip_sound::
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnGrenadeAttack_OnThrow(grenEnt)
	-- Custom grenade model and sounds
	grenEnt.SoundTbl_Idle = {"weapons/grenade/tick1.wav"}
	grenEnt.IdleSoundPitch1 = 100
	local redglow = ents.Create("env_sprite")
	redglow:SetKeyValue("model", "vj_base/sprites/vj_glow1.vmt")
	redglow:SetKeyValue("scale", "0.07")
	redglow:SetKeyValue("rendermode", "5")
	redglow:SetKeyValue("rendercolor", "150 0 0")
	redglow:SetKeyValue("spawnflags", "1") -- If animated
	redglow:SetParent(grenEnt)
	redglow:Fire("SetParentAttachment", "fuse", 0)
	redglow:Spawn()
	redglow:Activate()
	grenEnt:DeleteOnRemove(redglow)
	util.SpriteTrail(grenEnt, 1, Color(200,0,0), true, 15, 15, 0.35, 1/(6+6)*0.5, "VJ_Base/sprites/vj_trial1.vmt")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	-- Absorb bullet damage
	if dmginfo:IsBulletDamage() then
		if self.HasSounds == true && self.HasImpactSounds == true then VJ_EmitSound(self, "vj_impact_metal/bullet_metal/metalsolid"..math.random(1,10)..".wav", 70) end
		if math.random(1,3) == 1 then
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.Combine_ChatterSd)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
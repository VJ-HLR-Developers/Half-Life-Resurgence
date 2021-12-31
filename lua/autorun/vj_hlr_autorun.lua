/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Half-Life Resurgence"
local AddonName = "Half-Life Resurgence"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_hlr_autorun.lua"
-------------------------------------------------------

local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')
	
	VJBASE_HLR_VERSION = "1.1.0"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ GoldSrc Engine ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local vCat = "HL Resurgence: GoldSrc"
	VJ.AddCategoryInfo(vCat, {Icon = "vj_hl/icons/hl1.png"})
	
	-- Earth
	VJ.AddNPC("Cockroach","npc_vj_hlr1_cockroach",vCat)
	VJ.AddNPC("Rat","npc_vj_hlr1_rat",vCat)
		
		-- Black Mesa Personnel
		VJ.AddNPC("Security Guard","npc_vj_hlr1_securityguard",vCat)
		VJ.AddNPC("Scientist","npc_vj_hlr1_scientist",vCat)
			-- Blue Shift
			VJ.AddNPC("Dr. Rosenberg","npc_vj_hlrbs_rosenberg",vCat)
			-- Opposing Force
			VJ.AddNPC("Cleansuit Scientist","npc_vj_hlrof_cleansuitsci",vCat)
			VJ.AddNPC("Otis Laurey","npc_vj_hlrof_otis",vCat)
			-- Decay
			VJ.AddNPC("Dr. Richard Keller","npc_vj_hlrdc_keller",vCat)
			-- Alpha
			VJ.AddNPC("Alpha Security Guard","npc_vj_hlr1a_securityguard",vCat)
			VJ.AddNPC("Alpha Scientist","npc_vj_hlr1a_scientist",vCat)
			VJ.AddNPC("Ivan the Space Biker","npc_vj_hlr1a_ivan",vCat)
			VJ.AddNPC("Probe Droid","npc_vj_hlr1a_probedroid",vCat)
			
		-- Black Mesa Weaponry
		VJ.AddNPC("Black Mesa Ground Turret","npc_vj_hlr1_gturret",vCat)
		VJ.AddNPC("Black Mesa Ground Turret (Mini)","npc_vj_hlr1_gturret_mini",vCat)
		VJ.AddNPC("Black Mesa Ceiling Turret","npc_vj_hlr1_cturret",vCat,false,function(x) x.OnCeiling = true x.Offset = 0 end)
		VJ.AddNPC("Black Mesa Ceiling Turret (Mini)","npc_vj_hlr1_cturret_mini",vCat,false,function(x) x.OnCeiling = true x.Offset = 0 end)
			
		-- HECU
		VJ.AddNPC("Human Grunt","npc_vj_hlr1_hgrunt",vCat)
		VJ.AddNPC("Human Sergeant","npc_vj_hlr1_hgrunt_serg",vCat)
		VJ.AddNPC("Robot Grunt","npc_vj_hlr1_rgrunt",vCat)
		VJ.AddNPC("HECU Sentry Gun","npc_vj_hlr1_sentry",vCat)
		VJ.AddNPC("M2A3 Bradley","npc_vj_hlr1_m2a3bradley",vCat)
		VJ.AddNPC("M1A1 Abrams","npc_vj_hlr1_m1a1abrams",vCat)
		VJ.AddNPC("AH-64 Apache","npc_vj_hlr1_apache",vCat)
		VJ.AddNPC("V-22 Osprey","npc_vj_hlr1_osprey",vCat)
			-- Opposing Force
			VJ.AddNPC("Human Grunt (OppF)","npc_vj_hlrof_hgrunt",vCat)
			VJ.AddNPC("Human Grunt Medic (OppF)","npc_vj_hlrof_hgrunt_med",vCat)
			VJ.AddNPC("Human Grunt Engineer (OppF)","npc_vj_hlrof_hgrunt_eng",vCat)
			-- Decay
			VJ.AddNPC("HECU Sentry Gun (Decay)","npc_vj_hlrdc_sentry",vCat)
			-- Alpha
			VJ.AddNPC("Alpha Human Grunt","npc_vj_hlr1a_hgrunt",vCat)

		-- Black Ops
		VJ.AddNPC("Black Ops Female Assassin","npc_vj_hlr1_assassin_female",vCat)
		VJ.AddNPC("Black Ops Male Assassin","npc_vj_hlrof_assassin_male",vCat)
		VJ.AddNPC("Black Ops Robot Assassin","npc_vj_hlrof_assassin_rgrunt",vCat)
		VJ.AddNPC("Black Ops AH-64 Apache","npc_vj_hlrof_assassin_apache",vCat)
		VJ.AddNPC("Black Ops V-22 Osprey","npc_vj_hlrof_assassin_osprey",vCat)
	
	-- Xen
	VJ.AddNPC("Gonarch","npc_vj_hlr1_gonarch",vCat)
	VJ.AddNPC("Headcrab","npc_vj_hlr1_headcrab",vCat)
	VJ.AddNPC("Headcrab (Baby)","npc_vj_hlr1_headcrab_baby",vCat)
	VJ.AddNPC("Zombie","npc_vj_hlr1_zombie",vCat)
	VJ.AddNPC("Flocking Floater","npc_vj_hlr1_floater",vCat)
	VJ.AddNPC("Stukabat","npc_vj_hlr1_stukabat",vCat)
	VJ.AddNPC("Alien Controller","npc_vj_hlr1_aliencontroller",vCat)
	VJ.AddNPC("Alien Grunt","npc_vj_hlr1_aliengrunt",vCat)
	VJ.AddNPC("Alien Slave","npc_vj_hlr1_alienslave",vCat)
	VJ.AddNPC("Bullsquid","npc_vj_hlr1_bullsquid",vCat)
	VJ.AddNPC("Gargantua","npc_vj_hlr1_garg",vCat)
	VJ.AddNPC("Houndeye","npc_vj_hlr1_houndeye",vCat)
	VJ.AddNPC("Kingpin","npc_vj_hlr1_kingpin",vCat)
	VJ.AddNPC("Snark","npc_vj_hlr1_snark",vCat)
	VJ.AddNPC("Snark Nest","npc_vj_hlr1_snarknest",vCat)
	VJ.AddNPC("Ichthyosaur","npc_vj_hlr1_ichthyosaur",vCat)
	VJ.AddNPC("Archer","npc_vj_hlr1_archer",vCat)
	VJ.AddNPC("Leech","npc_vj_hlr1_leech",vCat)
	VJ.AddNPC("Chumtoad","npc_vj_hlr1_chumtoad",vCat)
	VJ.AddNPC("Boid","npc_vj_hlr1_boid",vCat)
	VJ.AddNPC("AFlock","npc_vj_hlr1_aflock",vCat)
	VJ.AddNPC("Protozoan","npc_vj_hlr1_protozoan",vCat)
	VJ.AddNPC("Tentacle","npc_vj_hlr1_tentacle",vCat)
	VJ.AddNPC("Panther Eye","npc_vj_hlr1_panthereye",vCat)
	VJ.AddNPC("Control Sphere","npc_vj_hlr1_controlsphere",vCat)
	VJ.AddNPC("Mr. Friendly","npc_vj_hlr1_mrfriendly",vCat)
	VJ.AddNPC("Nihilanth","npc_vj_hlr1_nihilanth",vCat)
	VJ.AddNPC("Barnacle","npc_vj_hlr1_barnacle",vCat,false, function(x) x.OnCeiling = true x.Offset = 0 end)
	VJ.AddNPC("Xen Tree","npc_vj_hlr1_xen_tree",vCat)
	VJ.AddNPC("Xen Hair","sent_vj_xen_hair",vCat)
	VJ.AddNPC("Xen Spore (Large)","sent_vj_xen_spore_large",vCat)
	VJ.AddNPC("Xen Spore (Medium)","sent_vj_xen_spore_medium",vCat)
	VJ.AddNPC("Xen Spore (Small)","sent_vj_xen_spore_small",vCat)
	VJ.AddNPC("Xen Plant Light","sent_vj_xen_plant_light",vCat)
	VJ.AddNPC("Xen Crystal","sent_vj_xen_crystal",vCat)
	VJ.AddNPC("Xen Sentry Cannon","npc_vj_hlr1_xen_cannon",vCat)
	VJ.AddNPC("Xen Ceiling Turret","npc_vj_hlr1_xen_turretc",vCat,false, function(x) x.OnCeiling = true x.Offset = 0 end)
		-- Spawners
		VJ.AddNPC("Portal (Xen)","sent_vj_hlr_alientp",vCat)
		VJ.AddNPC("Portal (Race X)","sent_vj_hlr_alientp_x",vCat)
		-- Alpha
		VJ.AddNPC("Alpha Zombie","npc_vj_hlr1a_zombie",vCat)
		VJ.AddNPC("Alpha Headcrab","npc_vj_hlr1a_headcrab",vCat)
		VJ.AddNPC("Alpha Bullsquid","npc_vj_hlr1a_bullsquid",vCat)
		-- Opposing Force
		VJ.AddNPC("Zombie Security Guard","npc_vj_hlrof_zombie_sec",vCat)
		VJ.AddNPC("Zombie Soldier","npc_vj_hlrof_zombie_soldier",vCat)
		VJ.AddNPC("Gonome","npc_vj_hlrof_gonome",vCat)
		VJ.AddNPC("Penguin","npc_vj_hlrof_penguin",vCat)
		VJ.AddNPC("Penguin Nest","npc_vj_hlrof_penguinnest",vCat)
		-- Sven Co-Op
		VJ.AddNPC("Gargantua (Baby)","npc_vj_hlrsv_garg_baby",vCat)
		VJ.AddNPC("Tor","npc_vj_hlrsv_tor",vCat)
	
	-- Race X (Opposing Force)
	VJ.AddNPC("Shock Trooper","npc_vj_hlrof_shocktrooper",vCat)
	VJ.AddNPC("Shock Roach","npc_vj_hlrof_shockroach",vCat)
	VJ.AddNPC("Pit Drone","npc_vj_hlrof_pitdrone",vCat)
	VJ.AddNPC("Pit Worm","npc_vj_hlrof_pitworm",vCat)
	VJ.AddNPC("Voltigore","npc_vj_hlrof_voltigore",vCat)
	VJ.AddNPC("Voltigore (Baby)","npc_vj_hlrof_voltigore_baby",vCat)
	VJ.AddNPC("Gene Worm","npc_vj_hlrof_geneworm",vCat)
	
	-- Unknown
	VJ.AddNPC("G-Man","npc_vj_hlr1_gman",vCat)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Source Engine ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	vCat = "HL Resurgence: Source"
	VJ.AddCategoryInfo(vCat, {Icon = "vj_hl/icons/hl2.png"})
	
	-- Earth + Resistance
	VJ.AddNPC("Citizen","npc_vj_hlr2_citizen",vCat)
	VJ.AddNPC_HUMAN("Refugee","npc_vj_hlr2_refugee",{"weapon_vj_crowbar","weapon_vj_357","weapon_vj_9mmpistol","weapon_vj_glock17","weapon_vj_smg1"},vCat)
	VJ.AddNPC_HUMAN("Rebel Engineer","npc_vj_hlr2_rebel_engineer",{"weapon_vj_spas12", "weapon_vj_hlr2_chargebow"},vCat)
	VJ.AddNPC_HUMAN("Rebel","npc_vj_hlr2_rebel",{
		-- 5 = Very common, 4 = Common, 3 = Uncommon, 2 = Rare, 1 = Very rare
		"weapon_vj_smg1",
		"weapon_vj_smg1",
		"weapon_vj_smg1",
		"weapon_vj_smg1",
		"weapon_vj_smg1",
		"weapon_vj_ar2",
		"weapon_vj_ar2",
		"weapon_vj_ar2",
		"weapon_vj_ar2",
		"weapon_vj_spas12",
		"weapon_vj_spas12",
		"weapon_vj_spas12",
		"weapon_vj_ak47",
		"weapon_vj_ak47",
		"weapon_vj_ak47",
		"weapon_vj_m16a1",
		"weapon_vj_m16a1",
		"weapon_vj_m16a1",
		"weapon_vj_k3",
		"weapon_vj_k3",
		"weapon_vj_k3",
		"weapon_vj_crossbow",
		"weapon_vj_crossbow",
		"weapon_vj_mp40",
		"weapon_vj_mp40",
		"weapon_vj_hlr2b_oicw",
		"weapon_vj_hlr2b_oicw",
		"weapon_vj_9mmpistol",
		"weapon_vj_9mmpistol",
		"weapon_vj_357",
		"weapon_vj_357",
		"weapon_vj_glock17",
		"weapon_vj_glock17",
		"weapon_vj_ssg08",
		"weapon_vj_rpg",
		"weapon_vj_hlr2_rpg"},vCat)
	VJ.AddNPC_HUMAN("Alyx Vance","npc_vj_hlr2_alyx",{"weapon_vj_hlr2_alyxgun"},vCat)
	VJ.AddNPC_HUMAN("Barney Calhoun","npc_vj_hlr2_barney",{"weapon_vj_smg1","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_ar2","weapon_vj_ar2","weapon_vj_spas12"},vCat)
	VJ.AddNPC_HUMAN("Father Grigori","npc_vj_hlr2_father_grigori",{"weapon_vj_hlr2_annabelle"},vCat)
	VJ.AddNPC("Resistance Sentry Gun","npc_vj_hlr2_res_sentry",vCat)
	-- Beta
		VJ.AddNPC("Merkava","npc_vj_hlr2b_merkava",vCat)
	
	-- Combine
	VJ.AddNPC_HUMAN("Overwatch Soldier","npc_vj_hlr2_com_soldier",{"weapon_vj_smg1","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_smg1","weapon_vj_ar2"},vCat)
	VJ.AddNPC_HUMAN("Overwatch Shotgun Soldier","npc_vj_hlr2_com_shotgunner",{"weapon_vj_spas12"},vCat)
	VJ.AddNPC_HUMAN("Overwatch Elite","npc_vj_hlr2_com_elite",{"weapon_vj_ar2"},vCat)
	VJ.AddNPC_HUMAN("Overwatch Prison Guard","npc_vj_hlr2_com_prospekt",{"weapon_vj_smg1","weapon_vj_smg1","weapon_vj_ar2","weapon_vj_ar2"},vCat)
	VJ.AddNPC_HUMAN("Overwatch Prison Shotgun Guard","npc_vj_hlr2_com_prospekt_sg",{"weapon_vj_spas12"},vCat)
	VJ.AddNPC_HUMAN("Overwatch Sniper","npc_vj_hlr2_com_sniper",{"weapon_vj_hlr2_csniper"},vCat)
	VJ.AddNPC_HUMAN("Overwatch Engineer","npc_vj_hlr2_com_engineer",{"weapon_vj_hlr2_reager"},vCat)
	VJ.AddNPC_HUMAN("Civil Protection","npc_vj_hlr2_com_civilp",{"weapon_vj_9mmpistol","weapon_vj_9mmpistol","weapon_vj_smg1"},vCat)
	VJ.AddNPC("Combine Sentry Gun","npc_vj_hlr2_com_sentry",vCat)
		-- Beta
		VJ.AddNPC_HUMAN("Overwatch Soldier (Beta)","npc_vj_hlr2b_com_soldier",{"weapon_vj_hlr2b_oicw"},vCat)
		VJ.AddNPC_HUMAN("Civil Protection Elite","npc_vj_hlr2_com_civilp_elite",{"weapon_vj_smg1"},vCat) -- Class name should be changed
	
	-- NPC Weapons
	VJ.AddNPCWeapon("VJ_Combine_Sniper","weapon_vj_hlr2_csniper")
	VJ.AddNPCWeapon("VJ_Annabelle","weapon_vj_hlr2_annabelle")
	VJ.AddNPCWeapon("VJ_Alyx_Gun","weapon_vj_hlr2_alyxgun")
	VJ.AddNPCWeapon("VJ_Charge_Bow","weapon_vj_hlr2_chargebow")
	VJ.AddNPCWeapon("VJ_Combine_Reager","weapon_vj_hlr2_reager")
	VJ.AddNPCWeapon("VJ_StunStick","weapon_vj_hlr2_stunstick")
	VJ.AddNPCWeapon("VJ_RPG_Resistance","weapon_vj_hlr2_rpg")
		-- Beta
		VJ.AddNPCWeapon("VJ_OICW","weapon_vj_hlr2b_oicw")
	
	-- Player Weapons
	vCat = "Half-Life Resurgence"
	VJ.AddCategoryInfo(vCat, {Icon = "vj_hl/icons/hl2.png"})
	VJ.AddWeapon("Combine Sniper","weapon_vj_hlr2_csniper",false,vCat)
	VJ.AddWeapon("Alyx Gun","weapon_vj_hlr2_alyxgun",false,vCat)
	VJ.AddWeapon("Charge Bow","weapon_vj_hlr2_chargebow",false,vCat)
	VJ.AddWeapon("Resistance RPG","weapon_vj_hlr2_rpg",false,vCat)
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Decals ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Blood
	game.AddDecal("VJ_HLR_Blood_Red",{"vj_hl/decals/hl_blood01","vj_hl/decals/hl_blood02","vj_hl/decals/hl_blood03","vj_hl/decals/hl_blood04","vj_hl/decals/hl_blood05","vj_hl/decals/hl_blood06","vj_hl/decals/hl_blood07","vj_hl/decals/hl_blood08"})
	game.AddDecal("VJ_HLR_Blood_Red_Large",{"vj_hl/decals/hl_bigblood01","vj_hl/decals/hl_bigblood02"})
	game.AddDecal("VJ_HLR_Blood_Yellow",{"vj_hl/decals/hl_yblood01","vj_hl/decals/hl_yblood02","vj_hl/decals/hl_yblood03","vj_hl/decals/hl_yblood04","vj_hl/decals/hl_yblood05","vj_hl/decals/hl_yblood06"})
	game.AddDecal("VJ_HLR_Blood_Yellow_Large",{"vj_hl/decals/hl_bigyblood01","vj_hl/decals/hl_bigyblood02"})
	-- Spits
	-- game.AddDecal("VJ_HLR_Spit_Acid",{"vj_hl/decals/spit1","vj_hl/decals/spit2"})
	game.AddDecal("VJ_HLR_Spit_Red",{"vj_hl/decals/spit1_red","vj_hl/decals/spit2_red"})
	game.AddDecal("VJ_HLR_Spit_Acid",{"vj_hl/decals/spit1_green","vj_hl/decals/spit2_green"})
	//game.AddDecal("VJ_HLR_Spit_Gonarch",{"vj_hl/decals/gonarch"})
	game.AddDecal("VJ_HLR_Gonarch_Blob",{"vj_hl/decals/mommablob"})
	-- Scorchs
	game.AddDecal("VJ_HLR_Scorch",{"vj_hl/decals/scorch1","vj_hl/decals/scorch2","vj_hl/decals/scorch3"})
	game.AddDecal("VJ_HLR_Scorch_Small",{"vj_hl/decals/smscorch1","vj_hl/decals/smscorch2","vj_hl/decals/smscorch3"})
	game.AddDecal("VJ_HLR_Gargantua_Stomp",{"vj_hl/decals/gargstomp"})
	-- Bullet Holes
	game.AddDecal("VJ_HLR_Bullet_Hole",{"vj_hl/decals/shot1","vj_hl/decals/shot2","vj_hl/decals/shot3","vj_hl/decals/shot4","vj_hl/decals/shot5"})
	/*
	function SWEP:CustomOnPrimaryAttack_BulletCallback(attacker, tr, dmginfo)
		util.Decal("VJ_HLR_Bullet_Hole", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end
	*/
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Particles ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	VJ.AddParticle("particles/vj_hl_blood.pcf",{
		"vj_hl_blood_red",
		"vj_hl_blood_red_large",
		"vj_hl_blood_yellow",
		"vj_hl_blood_yellow_large",
		"vj_hl_blood_boob_red",
		"vj_hl_blood_boob_yellow",
	})
	VJ.AddParticle("particles/vj_hlr_garg_flame.pcf",{
		"vj_hlr_garg_flame",
		"vj_hlr_garg_flame_small",
	})
	VJ.AddParticle("particles/vj_hl_shocktrooper.pcf",{
		"vj_hl_shockroach",
		"vj_hl_shockroach_aura",
		"vj_hl_shockroach_bright",
		"vj_hl_shockroach_trail",
	})
	VJ.AddParticle("particles/vj_hl_sporegrenade.pcf",{
		"vj_hl_spore",
		"vj_hl_spore_idle",
		"vj_hl_spore_splash1",
		"vj_hl_spore_splash2",
	})
	VJ.AddParticle("particles/vj_hl_gonome.pcf",{
		"vj_hl_gonome",
		"vj_hl_gonome_idle",
	})
	VJ.AddParticle("particles/vj_hl_spit.pcf",{
		"vj_hl_spit_bullsquid",
		"vj_hl_spit_bullsquid_impact",
		"vj_hl_spit_drone",
		"vj_hl_spit_drone_impact",
		"vj_hl_spit_drone_spawn",
		"vj_hl_spit_gonarch",
		"vj_hl_spit_gonarch_impact",
		"vj_hl_spit_spore_spawn",
		"vj_hlr_spit_friendly",
		"vj_hlr_spit_friendly_b",
		"vj_hlr_spit_friendly_impact",
	})
	VJ.AddParticle("particles/vj_hl_torch.pcf",{
		"vj_hl_torch",
	})
	VJ.AddParticle("particles/vj_hl_muzzle.pcf",{
        "vj_hl_muz1", -- Tau
        "vj_hl_muz2", -- HD pistol
        "vj_hl_muz3", -- HD MP5
        "vj_hl_muz4", -- HD Hornet
        "vj_hl_muz5", -- LD Hornet 1
        "vj_hl_muz6", -- LD Hornet 2
        "vj_hl_muz7", -- HD Hornet 2?
        "vj_hl_muz8", -- HD Brush turret
        "vj_hl_muzzle1", -- LD Pistol (Also used by LD brush turret, I'll make another one that's bigger)
        "vj_hl_muzzle2", -- LD MP5
        "vj_hl_muzzle3", -- LD Shotgun
        "vj_hl_muzzle4", -- HD Pistol 2?
		"vj_hl_muzzlebigturret",
	})
	VJ.AddParticle("particles/vj_hlr_garg_stomp.pcf",{
		"vj_hlr_garg_stomp",
	})
	VJ.AddParticle("particles/vj_hlr_nihilanth.pcf",{
		"vj_hlr_nihilanth_chargeorb",
		"vj_hlr_nihilanth_deathorbs",
		"vj_hlr_nihilanth_deathorbs_white",
	})
	VJ.AddParticle("particles/vj_hlr_geneworm.pcf",{
		"vj_hlr_geneworm_spit",
		"vj_hlr_geneworm_spit_b",
	})
	VJ.AddParticle("particles/electrical_fx.pcf",{
		"electrical_arc_01", -- Used for the Combine Reager
	})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Precaches ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	util.PrecacheModel("models/vj_hlr/gibs/agib1.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib2.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib3.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib4.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib5.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib6.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib7.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib8.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib9.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/agib10.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/flesh1.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/flesh2.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/flesh3.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/flesh4.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/hgib_b_bone.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/hgib_b_gib.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/hgib_guts.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/hgib_hmeat.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/hgib_lung.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/hgib_skull.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/hgib_legbone.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/gib_hgrunt.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/zombiegib.mdl")
	util.PrecacheModel("models/vj_hlr/gibs/islavegib.mdl")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Functions & Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function VJ_HLR_Effect_PortalSpawn(pos, size, color)
		size = size or 1.5
		color = color or "77 210 130" -- TODO: Not implemented yet!
		local ent = ents.Create("env_sprite")
		ent:SetKeyValue("model","vj_hl/sprites/fexplo1.vmt")
		ent:SetKeyValue("GlowProxySize","2.0")
		ent:SetKeyValue("HDRColorScale","1.0")
		ent:SetKeyValue("rendercolor",color)
		ent:SetKeyValue("renderfx","14")
		ent:SetKeyValue("rendermode","3")
		ent:SetKeyValue("renderamt","255")
		ent:SetKeyValue("disablereceiveshadows","0")
		ent:SetKeyValue("mindxlevel","0")
		ent:SetKeyValue("maxdxlevel","0")
		ent:SetKeyValue("framerate","10.0")
		ent:SetKeyValue("spawnflags","0")
		ent:SetKeyValue("scale",""..size)
		ent:SetPos(pos)
		ent:Spawn()
		
		sound.Play("vj_hlr/fx/beamstart"..math.random(1,2)..".wav", pos, 85)
		return ent
	end
	
	function VJ_HLR_Effect_Explosion(pos, type, size, color)
		size = size or 1
		color = color or "255 255 255"
		type = type or 1
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model",type == 1 && "vj_hl/sprites/zerogxplode.vmt" or "vj_hl/sprites/fexplo1.vmt")
		spr:SetKeyValue("GlowProxySize","2.0")
		spr:SetKeyValue("HDRColorScale","1.0")
		spr:SetKeyValue("rendercolor",color)
		spr:SetKeyValue("renderfx","14")
		spr:SetKeyValue("rendermode","5")
		spr:SetKeyValue("renderamt","255")
		spr:SetKeyValue("disablereceiveshadows","0")
		spr:SetKeyValue("mindxlevel","0")
		spr:SetKeyValue("maxdxlevel","0")
		spr:SetKeyValue("framerate","15.0")
		spr:SetKeyValue("spawnflags","0")
		spr:SetKeyValue("scale",""..size)
		spr:SetPos(pos)
		spr:Spawn()
		spr:Fire("Kill","",0.9)

		sound.Play("vj_hlr/hl1_weapon/explosion/explode"..math.random(1,3)..".wav", pos, 150)
		return spr
	end
	
	local defGibs_Yellow = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
	local defGibs_Red = {"models/vj_hlr/gibs/flesh1.mdl", "models/vj_hlr/gibs/flesh2.mdl", "models/vj_hlr/gibs/flesh3.mdl", "models/vj_hlr/gibs/flesh4.mdl", "models/vj_hlr/gibs/hgib_b_bone.mdl", "models/vj_hlr/gibs/hgib_b_gib.mdl", "models/vj_hlr/gibs/hgib_guts.mdl", "models/vj_hlr/gibs/hgib_hmeat.mdl", "models/vj_hlr/gibs/hgib_lung.mdl", "models/vj_hlr/gibs/hgib_skull.mdl", "models/vj_hlr/gibs/hgib_legbone.mdl"}
	function VJ_HLR_ApplyCorpseEffects(ent, corpse, gibTbl, extraOptions)
		extraOptions = extraOptions or {} -- CollideSound, ExpSound, Gibbable, CanBleed, ExtraGibs
		local entHP = ent:GetMaxHealth() + 100
		corpse:SetMaxHealth(entHP)
		corpse:SetHealth(entHP)
		corpse.HLR_Corpse = true
		corpse.HLR_Corpse_Type = ent.BloodColor
		if ent.HasBloodParticle then corpse.HLR_Corpse_Particle = ent.CustomBlood_Particle end
		corpse.HLR_Corpse_Decal = ent.HasBloodDecal and VJ_PICK(ent.CustomBlood_Decal) or ""
		corpse.HLR_Corpse_Gibbable = extraOptions.Gibbable != false
		if !gibTbl then
			if corpse.HLR_Corpse_Type == "Yellow" then
				gibTbl = defGibs_Yellow
			elseif corpse.HLR_Corpse_Type == "Red" then
				gibTbl = defGibs_Red
			end
		end
		if extraOptions.ExtraGibs then
			gibTbl = table.Copy(gibTbl) -- So Lua doesn't override the localized tables above
			gibTbl = table.Add(gibTbl, extraOptions.ExtraGibs)
		end
		corpse.HLR_Corpse_Gibs = gibTbl
		corpse.HLR_Corpse_CollideSound = extraOptions.CollideSound or "Default"
		corpse.HLR_Corpse_ExpSound = extraOptions.ExpSound or "vj_gib/default_gib_splat.wav"
		corpse.HLR_Corpse_StartT = CurTime() + 1
	end
	
	local defPos = Vector(0, 0, 0)
	local colorYellow = VJ_Color2Byte(Color(255, 221, 35))
	local colorRed = VJ_Color2Byte(Color(130, 19, 10))
	hook.Add("EntityTakeDamage", "VJ_HLR_EntityTakeDamage", function(target, dmginfo)
		if target.HLR_Corpse && !target.Dead && CurTime() > target.HLR_Corpse_StartT && target:GetColor().a > 50 then
			local dmgForce = dmginfo:GetDamageForce()
			
			-- Blood hit effects & decals
			if GetConVar("vj_hlr1_corpse_effects"):GetInt() == 1 then
				local pos = dmginfo:GetDamagePosition()
				if pos == defPos then pos = target:GetPos() + target:OBBCenter() end
				
				-- Blood particle
				local part = VJ_PICK(target.HLR_Corpse_Particle)
				if part then
					local particle = ents.Create("info_particle_system")
					particle:SetKeyValue("effect_name", part)
					particle:SetPos(pos)
					particle:Spawn()
					particle:Activate()
					particle:Fire("Start")
					particle:Fire("Kill", "", 0.1)
				end
				
				-- Blood decal
				local decal = VJ_PICK(target.HLR_Corpse_Decal)
				if decal then
					local tr = util.TraceLine({start = pos, endpos = pos + dmgForce:GetNormal() * math.Clamp(dmgForce:Length() * 10, 100, 150), filter = target})
					util.Decal(decal, tr.HitPos + tr.HitNormal + Vector(math.random(-30, 30), math.random(-30, 30), 0), tr.HitPos - tr.HitNormal, target)
				end
			end
			
			-- Damage & Gibs
			if GetConVar("vj_hlr1_corpse_gibbable"):GetInt() == 1 && !dmginfo:IsBulletDamage() && target.HLR_Corpse_Gibbable then
				local noDamage = false
				local dmgType = dmginfo:GetDamageType()
				
				-- DMG_CRUSH is usually when the ragdoll is slammed to a wall, we want it to only gib if it's hit hard enough!
				if dmgType == DMG_CRUSH && dmginfo:GetDamage() < 500 then
					noDamage = true
				end
				-- If it's a child corpse piece, then we want to make sure it doesn't cause damage
				for _, v in pairs(target.ExtraCorpsesToRemove) do
					if IsValid(v) && v == dmginfo:GetAttacker() then
						noDamage = true
						break
					end
				end
				-- If DMG_BLAST, then increase the damage to make it easier to gib
				if bit.band(dmgType, DMG_BLAST) != 0 then
					dmginfo:ScaleDamage(2)
				end
				if !noDamage then target:SetHealth(target:Health() - dmginfo:GetDamage()) end
				if target:Health() <= 0 then
					local centerPos = target:GetPos() + target:OBBCenter()
					target.Dead = true
					VJ_EmitSound(target, VJ_PICK(target.HLR_Corpse_ExpSound), 90, 100)
					
					-- Spawn gibs
					local gibMaxs = target:OBBMaxs()
					local gibMins = target:OBBMins()
					for _, v in pairs(target.HLR_Corpse_Gibs) do
						local gib = ents.Create("obj_vj_gib")
						gib:SetModel(v)
						gib:SetPos(centerPos + Vector(math.random(gibMins.x, gibMaxs.x), math.random(gibMins.y, gibMaxs.y), 10))
						gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
						gib.BloodType = target.HLR_Corpse_Type
						gib.Collide_Decal = target.HLR_Corpse_Decal
						gib.CollideSound = target.HLR_Corpse_CollideSound or "Default"
						gib:Spawn()
						gib:Activate()
						local phys = gib:GetPhysicsObject()
						if IsValid(phys) then
							phys:AddVelocity(Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(150, 250)) + (dmgForce / 70))
							phys:AddAngleVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
						end
						if GetConVar("vj_npc_fadegibs"):GetInt() == 1 then
							timer.Simple(GetConVar("vj_npc_fadegibstime"):GetInt(), function()
								SafeRemoveEntity(gib)
							end)
						end
					end
					
					local bloodIsYellow = target.HLR_Corpse_Type == "Yellow"
					local bloodIsRed = target.HLR_Corpse_Type == "Red"
					
					-- Death effects & decals
					if bloodIsYellow or bloodIsRed then
						local maxDist = gibMaxs:Length()
						local splatDecal = bloodIsYellow and "VJ_HLR_Blood_Yellow_Large" or "VJ_HLR_Blood_Red_Large"
						local tr = util.TraceLine({start = centerPos, endpos = centerPos - Vector(0, 0, maxDist), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos + Vector(0, 0, maxDist), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos - Vector(maxDist, 0, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos + Vector(maxDist, 0, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos - Vector(0, maxDist, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos + Vector(0, maxDist, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						/*local dmgPos = dmginfo:GetDamagePosition()
						if pos == defPos then pos = target:GetPos() + target:OBBCenter() end
						VJ_CreateTestObject(dmgPos, Angle(0,0,0), Color(0, 225, 255))
						VJ_CreateTestObject(dmgPos + dmgPos:GetNormal() * 10)
						local tr = util.TraceLine({start = dmgPos, endpos = dmgPos + dmgPos:GetNormal() * 10, filter = target})
						VJ_CreateTestObject(tr.HitPos, Angle(0,0,0), Color(94, 255, 0))
						util.Decal("VJ_HLR_Blood_Red_Large", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)*/
						
						local effectBlood = EffectData()
						effectBlood:SetOrigin(centerPos)
						effectBlood:SetColor(bloodIsYellow and colorYellow or colorRed)
						effectBlood:SetScale(120)
						util.Effect("VJ_Blood1",effectBlood)
						
						local bloodspray = EffectData()
						bloodspray:SetOrigin(centerPos)
						bloodspray:SetScale(8)
						bloodspray:SetFlags(3)
						bloodspray:SetColor(bloodIsYellow and 1 or 0)
						util.Effect("bloodspray",bloodspray)
						util.Effect("bloodspray",bloodspray)
						
						if bloodIsYellow then
							local effectdata = EffectData()
							effectdata:SetOrigin(centerPos)
							effectdata:SetScale(1)
							util.Effect("StriderBlood",effectdata)
							util.Effect("StriderBlood",effectdata)
						end
					end
					target:Remove()
				end
			end
		end
	end)
	
	-- Weapon hook that gives the player HL1 weapons on spawn
	-- hook.Add("PlayerSpawn", "VJ_HL1SWEPs_AutoSpawn", function(ply)
		-- if GetConVar("hl1_sv_loadout"):GetInt() == 1 then
			-- ply:Give("weapon_hl1_crowbar")
			-- ply:Give("weapon_hl1_357")
			-- ply:Give("weapon_hl1_glock")
			-- ply:Give("weapon_hl1_crossbow")
			-- ply:Give("weapon_hl1_egon")
			-- ply:Give("weapon_hl1_handgrenade")
			-- ply:Give("weapon_hl1_hornetgun")
			-- ply:Give("weapon_hl1_mp5")
			-- ply:Give("weapon_hl1_rpg")
			-- ply:Give("weapon_hl1_satchel")
			-- ply:Give("weapon_hl1_shotgun")
			-- //ply:Give("weapon_hl1_snark")
			-- ply:Give("weapon_hl1_gauss")
			-- ply:Give("weapon_hl1_tripmine")
		-- end
	-- end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Entity Tags ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
	ent.HLR_Type = Classifies popular type of NPCs
		"Headcrab"
		"Turret"
		"Police"
	ent.HLR_Corpse = If true then this is an HLR corpse
		ent.HLR_Corpse_Type, ent.HLR_Corpse_Particle, ent.HLR_Corpse_Decal
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Convars & Menu ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GoldSrc
VJ.AddConVar("vj_hlr1_corpse_effects", 1, {FCVAR_ARCHIVE})
VJ.AddConVar("vj_hlr1_corpse_gibbable", 1, {FCVAR_ARCHIVE})
VJ.AddConVar("vj_hlr1_gonarch_babylimit", 20, {FCVAR_ARCHIVE})
VJ.AddConVar("vj_hlr1_bradley_deploygrunts", 1, {FCVAR_ARCHIVE})
VJ.AddConVar("vj_hlr1_osprey_deploysoldiers", 1, {FCVAR_ARCHIVE})
VJ.AddConVar("vj_hlr1_assassin_cloaks", 1, {FCVAR_ARCHIVE})
-- Source
VJ.AddConVar("vj_hlr2_merkava_gunner", 1, {FCVAR_ARCHIVE})
VJ.AddConVar("vj_hlr2_custom_skins", 1, {FCVAR_ARCHIVE})

VJ.AddConVar("vj_hlr_autoreplace", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_hl1", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_hl2", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_random", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_essential", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

VJ.AddClientConVar("vj_hlr1_sparkfx", 0, "Create HL1-Style Sparks on Metal Surfaces")	
VJ.AddClientConVar("vj_hlr2_csniper_laser_usebarrel", 1, "Combine Sniper Laser Follows Gun Barrel")

if CLIENT then
	hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_HLR", function()
		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "HL Resurgence (Server)", "HL Resurgence (Server)", "", "", function(Panel)
			if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
				Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
				Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
				return
			end
			Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
			Panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_hlr1_gonarch_babylimit 20\nvj_hlr1_bradley_deploygrunts 1\nvj_hlr1_osprey_deploysoldiers 1\nvj_hlr2_merkava_gunner 1\nvj_hlr1_assassin_cloaks 1\nvj_hlr1_corpse_effects 1\nvj_hlr1_corpse_gibbable 1\nvj_hlr2_custom_skins 1"})
			Panel:AddControl( "Label", {Text = "GoldSrc Engine:"})
			Panel:AddControl("Checkbox", {Label = "Corpses Create Effects & Decals", Command = "vj_hlr1_corpse_effects"})
			Panel:AddControl("Checkbox", {Label = "Corpses Can Be Dismembered", Command = "vj_hlr1_corpse_gibbable"})
			Panel:AddControl("Checkbox", {Label = "M2A3 Bradley Deploys Human Grunts", Command = "vj_hlr1_bradley_deploygrunts"})
			Panel:AddControl("Checkbox", {Label = "V-22 Osprey Deploys Human Grunts / Assassins", Command = "vj_hlr1_osprey_deploysoldiers"})
			Panel:AddControl("Checkbox", {Label = "Female Assassin Cloaks During Combat", Command = "vj_hlr1_assassin_cloaks"})
			Panel:AddControl("Slider", {Label = "Gonarch Baby Headcrab Limit", min = 0, max = 100, Command = "vj_hlr1_gonarch_babylimit"})
			Panel:AddControl( "Label", {Text = "Source Engine:"})
			Panel:AddControl("Checkbox", {Label = "Merkava Spawns With a Gunner", Command = "vj_hlr2_merkava_gunner"})
			Panel:AddControl("Checkbox", {Label = "Allow Custom NPC Skins", Command = "vj_hlr2_custom_skins"})
			Panel:ControlHelp("Ex: Custom skins for Rebels & Refugees")
		end)
		
		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "HL Resurgence (AutoReplace)", "HL Resurgence (AutoReplace)", "", "", function(Panel)
			if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
				Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
				Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
				return
			end
			Panel:AddControl( "Label", {Text = "#vjbase.menu.general.admin.only"})
			Panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_hlr_autoreplace 0\nvj_hlr_autoreplace_hl1 1\nvj_hlr_autoreplace_hl2 1\nvj_hlr_autoreplace_random 0\nvj_hlr_autoreplace_essential 0"})
			Panel:AddControl("Label", {Text = "Half-Life Resurgence Auto Replace script replaces HL1 or HL2 NPCs with the corresponding HLR SNPC!"})
			Panel:AddControl("Checkbox", {Label = "Enable Auto Replacement Script", Command = "vj_hlr_autoreplace"})
			Panel:AddControl("Checkbox", {Label = "Replace HL1 NPCs", Command = "vj_hlr_autoreplace_hl1"})
			Panel:AddControl("Checkbox", {Label = "Replace HL2 NPCs", Command = "vj_hlr_autoreplace_hl2"})
			Panel:AddControl("Checkbox", {Label = "Enable Random Replacements", Command = "vj_hlr_autoreplace_random"})
			Panel:AddControl("Checkbox", {Label = "Main Characters Are Invincible?", Command = "vj_hlr_autoreplace_essential"})
			Panel:AddControl("Label", {Text = "WARNINGS: Certain maps may occasionally break or crash! Some parts of the campaign may require the player to remove invisible barriers or physgun important NPCs to their proper location to continue to the next level."})
		end)
		
		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "HL Resurgence (Client)", "HL Resurgence (Client)", "", "", function(Panel)
			Panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_hlr2_csniper_laser_usebarrel 1\nvj_hlr1_sparkfx 0"})
			Panel:AddControl("Checkbox", {Label = "Create HL1-Style Sparks on Metal Surfaces", Command = "vj_hlr1_sparkfx"})
			Panel:ControlHelp("Applies ONLY to HL1 NPCs & weapons!")
			Panel:AddControl("Checkbox", {Label = "Combine Sniper Laser Follows Gun Barrel", Command = "vj_hlr2_csniper_laser_usebarrel"})
			Panel:ControlHelp("Unchecked = Laser will pinpoint to the enemy instead")
		end)
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Replacement Script ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- If enabled during startup, then just run it!
if GetConVar("vj_hlr_autoreplace"):GetInt() == 1 then
	include("hlr/autoreplace.lua")
end
-- Detect changes to the convar...
cvars.AddChangeCallback("vj_hlr_autoreplace", function(convar_name, value_old, value_new)
    if value_new == "1" then
		include("autorun/hlr/autoreplace.lua")
	else
		hook.Remove("OnEntityCreated", "VJ_HLR_AutoReplace_EntCreate")
		hook.Remove("Think", "VJ_HLR_AutoReplace_Think")
	end
end)
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if CLIENT then
		chat.AddText(Color(0, 200, 200), PublicAddonName,
		Color(0, 255, 0), " was unable to install, you are missing ",
		Color(255, 100, 0), "VJ Base!")
	end
	
	timer.Simple(1, function()
		if not VJBASE_ERROR_MISSING then
			VJBASE_ERROR_MISSING = true
			if CLIENT then
				// Get rid of old error messages from addons running on older code...
				if VJF && type(VJF) == "Panel" then
					VJF:Close()
				end
				VJF = true
				
				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 160)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("Error: VJ Base is missing!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(250, 30)
				labelTitle:SetText("VJ BASE IS MISSING!")
				labelTitle:SetTextColor(Color(255,128,128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(170, 50)
				label1:SetText("Garry's Mod was unable to find VJ Base in your files!")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 70)
				label2:SetText("You have an addon installed that requires VJ Base but VJ Base is missing. To install VJ Base, click on the link below. Once\n                                                   installed, make sure it is enabled and then restart your game.")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(195, 100)
				link:SetText("VJ_Base_Download_Link_(Steam_Workshop)")
				link:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 120)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif (SERVER) then
				VJF = true
				timer.Remove("VJBASEMissing")
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					print("VJ Base is missing! Download it from the Steam Workshop! Link: https://steamcommunity.com/sharedfiles/filedetails/?id=131759821")
				end)
			end
		end
	end)
end
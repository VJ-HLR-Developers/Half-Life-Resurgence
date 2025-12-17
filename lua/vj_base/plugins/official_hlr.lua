/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
local hlrVersion = "1.3.0"
VJ.AddPlugin("Half-Life Resurgence", "NPC", hlrVersion)

VJ.HLR_VERSION = hlrVersion
VJ.HLR_INSTALLED_HD = file.Exists("lua/autorun/vj_hlr_hd_autorun.lua", "GAME")
VJ.HLR_NPC_Boid_Leader = NULL
VJ.HLR_NPC_AFlock_Leader = NULL
VJ.HLR_NPC_Floater_Leader = NULL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ GoldSrc Engine ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local spawnCategory = "HL Resurgence: GoldSrc"
VJ.AddCategoryInfo(spawnCategory, {Icon = "vj_hl/icons/hl1.png"})

-- Earth
VJ.AddNPC("Cockroach", "npc_vj_hlr1_cockroach", spawnCategory)
VJ.AddNPC("Rat", "npc_vj_hlr1_rat", spawnCategory)
	-- Dreamcast
	VJ.AddNPC("Cockroach (Dreamcast)", "npc_vj_hlrdc_cockroach", spawnCategory)

-- Black Mesa Personnel
VJ.AddNPC("Security Guard", "npc_vj_hlr1_securityguard", spawnCategory)
VJ.AddNPC("Scientist", "npc_vj_hlr1_scientist", spawnCategory)
	-- Blue Shift
	VJ.AddNPC("Dr. Rosenberg", "npc_vj_hlrbs_rosenberg", spawnCategory)
	-- Opposing Force
	VJ.AddNPC("Cleansuit Scientist", "npc_vj_hlrof_cleansuitsci", spawnCategory)
	VJ.AddNPC("Otis Laurey", "npc_vj_hlrof_otis", spawnCategory)
	-- Decay
	VJ.AddNPC("Dr. Richard Keller", "npc_vj_hlrdc_keller", spawnCategory)
	-- Alpha
	VJ.AddNPC("Alpha Security Guard", "npc_vj_hlr1a_securityguard", spawnCategory)
	VJ.AddNPC("Alpha Scientist", "npc_vj_hlr1a_scientist", spawnCategory)
	VJ.AddNPC("Ivan the Space Biker", "npc_vj_hlr1a_ivan", spawnCategory)
	VJ.AddNPC("Probe Droid", "npc_vj_hlr1a_probedroid", spawnCategory)

-- Black Mesa Weaponry
VJ.AddNPC("Black Mesa Ground Turret", "npc_vj_hlr1_gturret", spawnCategory)
VJ.AddNPC("Black Mesa Ground Turret (Mini)", "npc_vj_hlr1_gturret_mini", spawnCategory)
VJ.AddNPC("Black Mesa Ceiling Turret", "npc_vj_hlr1_cturret", spawnCategory, false, function(x) x.OnCeiling = true x.Offset = 0 end)
VJ.AddNPC("Black Mesa Ceiling Turret (Mini)", "npc_vj_hlr1_cturret_mini", spawnCategory, false, function(x) x.OnCeiling = true x.Offset = 0 end)

-- HECU
VJ.AddNPC("Human Grunt", "npc_vj_hlr1_hgrunt", spawnCategory)
VJ.AddNPC("Human Sergeant", "npc_vj_hlr1_hgrunt_serg", spawnCategory)
VJ.AddNPC("Robot Grunt", "npc_vj_hlr1_rgrunt", spawnCategory)
VJ.AddNPC("HECU Sentry Gun", "npc_vj_hlr1_sentry", spawnCategory)
VJ.AddNPC("M2A3 Bradley", "npc_vj_hlr1_m2a3bradley", spawnCategory)
VJ.AddNPC("M1A1 Abrams", "npc_vj_hlr1_m1a1abrams", spawnCategory)
VJ.AddNPC("AH-64 Apache", "npc_vj_hlr1_apache", spawnCategory)
VJ.AddNPC("V-22 Osprey", "npc_vj_hlr1_osprey", spawnCategory)
	-- Opposing Force
	VJ.AddNPC("Human Grunt (OppF)", "npc_vj_hlrof_hgrunt", spawnCategory)
	VJ.AddNPC("Human Grunt Medic (OppF)", "npc_vj_hlrof_hgrunt_med", spawnCategory)
	VJ.AddNPC("Human Grunt Engineer (OppF)", "npc_vj_hlrof_hgrunt_eng", spawnCategory)
	-- Decay
	VJ.AddNPC("HECU Sentry Gun (Decay)", "npc_vj_hlrdc_sentry", spawnCategory)
	-- Alpha
	VJ.AddNPC("Alpha Human Grunt", "npc_vj_hlr1a_hgrunt", spawnCategory)
	VJ.AddNPC("Alpha Human Sergeant", "npc_vj_hlr1a_hgrunt_serg", spawnCategory)
	VJ.AddNPC("Alpha Human Sergeant (Melee)", "npc_vj_hlr1a_hgrunt_sergm", spawnCategory)

-- Black Ops
VJ.AddNPC("Black Ops Female Assassin", "npc_vj_hlr1_assassin_female", spawnCategory)
VJ.AddNPC("Black Ops Male Assassin", "npc_vj_hlrof_assassin_male", spawnCategory)
VJ.AddNPC("Black Ops Robot Assassin", "npc_vj_hlrof_assassin_rgrunt", spawnCategory)
VJ.AddNPC("Black Ops AH-64 Apache", "npc_vj_hlrof_assassin_apache", spawnCategory)
VJ.AddNPC("Black Ops V-22 Osprey", "npc_vj_hlrof_assassin_osprey", spawnCategory)

-- Xen
VJ.AddNPC("Gonarch", "npc_vj_hlr1_gonarch", spawnCategory)
VJ.AddNPC("Headcrab", "npc_vj_hlr1_headcrab", spawnCategory)
VJ.AddNPC("Headcrab (Baby)", "npc_vj_hlr1_headcrab_baby", spawnCategory)
VJ.AddNPC("Zombie", "npc_vj_hlr1_zombie", spawnCategory)
VJ.AddNPC("Flocking Floater", "npc_vj_hlr1_floater", spawnCategory)
//VJ.AddNPC("Stukabat", "npc_vj_hlr1_stukabat", spawnCategory)
VJ.AddNPC("Alien Controller", "npc_vj_hlr1_aliencontroller", spawnCategory)
VJ.AddNPC("Alien Grunt", "npc_vj_hlr1_aliengrunt", spawnCategory)
VJ.AddNPC("Alien Slave", "npc_vj_hlr1_alienslave", spawnCategory)
VJ.AddNPC("Bullsquid", "npc_vj_hlr1_bullsquid", spawnCategory)
VJ.AddNPC("Gargantua", "npc_vj_hlr1_garg", spawnCategory)
VJ.AddNPC("Houndeye", "npc_vj_hlr1_houndeye", spawnCategory)
VJ.AddNPC("Kingpin", "npc_vj_hlr1_kingpin", spawnCategory)
VJ.AddNPC("Snark", "npc_vj_hlr1_snark", spawnCategory)
VJ.AddNPC("Snark Nest", "npc_vj_hlr1_snarknest", spawnCategory)
VJ.AddNPC("Ichthyosaur", "npc_vj_hlr1_ichthyosaur", spawnCategory)
VJ.AddNPC("Archer", "npc_vj_hlr1_archer", spawnCategory)
VJ.AddNPC("Leech", "npc_vj_hlr1_leech", spawnCategory)
VJ.AddNPC("Chumtoad", "npc_vj_hlr1_chumtoad", spawnCategory)
VJ.AddNPC("Boid", "npc_vj_hlr1_boid", spawnCategory)
VJ.AddNPC("AFlock", "npc_vj_hlr1_aflock", spawnCategory)
VJ.AddNPC("Protozoan", "npc_vj_hlr1_protozoan", spawnCategory)
VJ.AddNPC("Tentacle", "npc_vj_hlr1_tentacle", spawnCategory)
VJ.AddNPC("Panther Eye", "npc_vj_hlr1_panthereye", spawnCategory)
VJ.AddNPC("Control Sphere", "npc_vj_hlr1_controlsphere", spawnCategory)
VJ.AddNPC("Mr. Friendly", "npc_vj_hlr1_mrfriendly", spawnCategory)
VJ.AddNPC("Nihilanth", "npc_vj_hlr1_nihilanth", spawnCategory)
VJ.AddNPC("Barnacle", "npc_vj_hlr1_barnacle", spawnCategory, false, function(x) x.OnCeiling = true x.Offset = 0 end)
VJ.AddNPC("Xen Tree", "npc_vj_hlr1_xen_tree", spawnCategory)
VJ.AddNPC("Xen Hair", "sent_vj_xen_hair", spawnCategory)
VJ.AddNPC("Xen Spore (Large)", "sent_vj_xen_spore_large", spawnCategory)
VJ.AddNPC("Xen Spore (Medium)", "sent_vj_xen_spore_medium", spawnCategory)
VJ.AddNPC("Xen Spore (Small)", "sent_vj_xen_spore_small", spawnCategory)
VJ.AddNPC("Xen Plant Light", "sent_vj_xen_plant_light", spawnCategory)
VJ.AddNPC("Xen Crystal", "sent_vj_xen_crystal", spawnCategory)
VJ.AddNPC("Xen Sentry Cannon", "npc_vj_hlr1_xen_cannon", spawnCategory)
VJ.AddNPC("Xen Ceiling Turret", "npc_vj_hlr1_xen_turretc", spawnCategory, false, function(x) x.OnCeiling = true x.Offset = 0 end)
	-- Spawners
	VJ.AddNPC("Portal (Xen)", "sent_vj_hlr_alientp", spawnCategory)
	VJ.AddNPC("Portal (Race X)", "sent_vj_hlr_alientp_x", spawnCategory)
	-- Alpha
	VJ.AddNPC("Alpha Alien Grunt", "npc_vj_hlr1a_aliengrunt", spawnCategory)
	VJ.AddNPC("Alpha Zombie", "npc_vj_hlr1a_zombie", spawnCategory)
	VJ.AddNPC("Alpha Headcrab", "npc_vj_hlr1a_headcrab", spawnCategory)
	VJ.AddNPC("Alpha Bullsquid", "npc_vj_hlr1a_bullsquid", spawnCategory)
	VJ.AddNPC("Alpha Houndeye", "npc_vj_hlr1a_houndeye", spawnCategory)
	-- Dreamcast
	VJ.AddNPC("Alien Grunt (Dreamcast)", "npc_vj_hlrdc_aliengrunt", spawnCategory)
	VJ.AddNPC("Headcrab (Dreamcast)", "npc_vj_hlrdc_headcrab", spawnCategory)
	VJ.AddNPC("Zombie (Dreamcast)", "npc_vj_hlrdc_zombie", spawnCategory)
	VJ.AddNPC("Alien Slave (Dreamcast)", "npc_vj_hlrdc_alienslave", spawnCategory)
	VJ.AddNPC("Bullsquid (Dreamcast)", "npc_vj_hlrdc_bullsquid", spawnCategory)
    VJ.AddNPC("Gargantua (Dreamcast)", "npc_vj_hlrdc_garg", spawnCategory)
    VJ.AddNPC("Houndeye (Dreamcast)", "npc_vj_hlrdc_houndeye", spawnCategory)
	VJ.AddNPC("Barnacle (Dreamcast)", "npc_vj_hlrdc_barnacle", spawnCategory, false, function(x) x.OnCeiling = true x.Offset = 0 end)
	VJ.AddNPC("Xen Tree (Dreamcast)", "npc_vj_hlrdc_xen_tree", spawnCategory)
	-- Opposing Force
	VJ.AddNPC("Zombie Security Guard", "npc_vj_hlrof_zombie_sec", spawnCategory)
	VJ.AddNPC("Zombie Soldier", "npc_vj_hlrof_zombie_soldier", spawnCategory)
	VJ.AddNPC("Gonome", "npc_vj_hlrof_gonome", spawnCategory)
	VJ.AddNPC("Penguin", "npc_vj_hlrof_penguin", spawnCategory)
	VJ.AddNPC("Penguin Nest", "npc_vj_hlrof_penguinnest", spawnCategory)
	-- Sven Co-Op
	VJ.AddNPC("Gargantua (Baby)", "npc_vj_hlrsv_garg_baby", spawnCategory)
	VJ.AddNPC("Tor", "npc_vj_hlrsv_tor", spawnCategory)

-- Race X (Opposing Force)
VJ.AddNPC("Shock Trooper", "npc_vj_hlrof_shocktrooper", spawnCategory)
VJ.AddNPC("Shock Roach", "npc_vj_hlrof_shockroach", spawnCategory)
VJ.AddNPC("Pit Drone", "npc_vj_hlrof_pitdrone", spawnCategory)
VJ.AddNPC("Pit Worm", "npc_vj_hlrof_pitworm", spawnCategory)
VJ.AddNPC("Voltigore", "npc_vj_hlrof_voltigore", spawnCategory)
VJ.AddNPC("Voltigore (Baby)", "npc_vj_hlrof_voltigore_baby", spawnCategory)
VJ.AddNPC("Gene Worm", "npc_vj_hlrof_geneworm", spawnCategory)

-- Unknown
VJ.AddNPC("G-Man", "npc_vj_hlr1_gman", spawnCategory)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Source Engine ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
spawnCategory = "HL Resurgence: Source"
VJ.AddCategoryInfo(spawnCategory, {Icon = "games/16/hl2.png"})

-- Earth + Resistance
VJ.AddNPC("Citizen", "npc_vj_hlr2_citizen", spawnCategory)
VJ.AddNPC_HUMAN("Refugee", "npc_vj_hlr2_refugee", {"weapon_vj_crowbar", "weapon_vj_hlr2_pipe", "weapon_vj_357", "weapon_vj_9mmpistol", "weapon_vj_glock17", "weapon_vj_smg1"}, spawnCategory)
VJ.AddNPC_HUMAN("Rebel Engineer", "npc_vj_hlr2_rebel_engineer", {"weapon_vj_spas12", "weapon_vj_hlr2_chargebow"}, spawnCategory)
VJ.AddNPC_HUMAN("Rebel", "npc_vj_hlr2_rebel", {
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
	//"weapon_vj_ssg08",
	"weapon_vj_hlr2b_sniper",
	"weapon_vj_rpg",
	"weapon_vj_hlr2_rpg"}, spawnCategory)
VJ.AddNPC_HUMAN("Alyx Vance", "npc_vj_hlr2_alyx", {"weapon_vj_hlr2_alyxgun"}, spawnCategory)
VJ.AddNPC_HUMAN("Barney Calhoun", "npc_vj_hlr2_barney", {"weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_ar2", "weapon_vj_ar2", "weapon_vj_spas12"}, spawnCategory)
VJ.AddNPC_HUMAN("Father Grigori", "npc_vj_hlr2_father_grigori", {"weapon_vj_hlr2_annabelle"}, spawnCategory)
VJ.AddNPC("Resistance Sentry Gun", "npc_vj_hlr2_res_sentry", spawnCategory)
-- Beta
	VJ.AddNPC("Merkava", "npc_vj_hlr2b_merkava", spawnCategory)

-- Combine
VJ.AddNPC_HUMAN("Overwatch Soldier", "npc_vj_hlr2_com_soldier", {"weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_ar2"}, spawnCategory)
VJ.AddNPC_HUMAN("Overwatch Shotgun Soldier", "npc_vj_hlr2_com_shotgunner", {"weapon_vj_spas12"}, spawnCategory)
VJ.AddNPC_HUMAN("Overwatch Elite", "npc_vj_hlr2_com_elite", {"weapon_vj_ar2"}, spawnCategory)
VJ.AddNPC_HUMAN("Overwatch Prison Guard", "npc_vj_hlr2_com_prospekt", {"weapon_vj_smg1", "weapon_vj_smg1", "weapon_vj_ar2", "weapon_vj_ar2"}, spawnCategory)
VJ.AddNPC_HUMAN("Overwatch Prison Shotgun Guard", "npc_vj_hlr2_com_prospekt_sg", {"weapon_vj_spas12"}, spawnCategory)
VJ.AddNPC_HUMAN("Overwatch Sniper", "npc_vj_hlr2_com_sniper", {"weapon_vj_hlr2_csniper"}, spawnCategory)
VJ.AddNPC_HUMAN("Overwatch Engineer", "npc_vj_hlr2_com_engineer", {"weapon_vj_hlr2_reager"}, spawnCategory)
VJ.AddNPC_HUMAN("Civil Protection", "npc_vj_hlr2_com_civilp", {"weapon_vj_9mmpistol", "weapon_vj_9mmpistol", "weapon_vj_smg1"}, spawnCategory)
VJ.AddNPC("Combine Sentry Gun", "npc_vj_hlr2_com_sentry", spawnCategory)
	-- Beta
	VJ.AddNPC_HUMAN("Overwatch Soldier (Beta)", "npc_vj_hlr2b_com_soldier", {"weapon_vj_hlr2b_oicw"}, spawnCategory)
	VJ.AddNPC_HUMAN("Overwatch Sniper Elite (Beta)", "npc_vj_hlr2b_com_elite_sniper", {"weapon_vj_hlr2b_sniper"}, spawnCategory)
	VJ.AddNPC_HUMAN("Civil Protection Elite", "npc_vj_hlr2b_com_civilp_elite", {"weapon_vj_smg1"}, spawnCategory) -- Class name should be changed

spawnCategory = "Half-Life Resurgence"
-- NPC Weapons
VJ.AddNPCWeapon("VJ_Combine_Sniper", "weapon_vj_hlr2_csniper", spawnCategory)
VJ.AddNPCWeapon("VJ_Combine_Reager", "weapon_vj_hlr2_reager", spawnCategory)
VJ.AddNPCWeapon("VJ_Annabelle", "weapon_vj_hlr2_annabelle", spawnCategory)
VJ.AddNPCWeapon("VJ_Alyx_Gun", "weapon_vj_hlr2_alyxgun", spawnCategory)
VJ.AddNPCWeapon("VJ_Charge_Bow", "weapon_vj_hlr2_chargebow", spawnCategory)
VJ.AddNPCWeapon("VJ_StunStick", "weapon_vj_hlr2_stunstick", spawnCategory)
VJ.AddNPCWeapon("VJ_MetalPipe", "weapon_vj_hlr2_pipe", spawnCategory)
VJ.AddNPCWeapon("VJ_RPG_Resistance", "weapon_vj_hlr2_rpg", spawnCategory)
	-- Beta
	VJ.AddNPCWeapon("VJ_OICW", "weapon_vj_hlr2b_oicw", spawnCategory)
	VJ.AddNPCWeapon("VJ_SniperRifle", "weapon_vj_hlr2b_sniper", spawnCategory)

-- Player Weapons
VJ.AddCategoryInfo(spawnCategory, {Icon = "games/16/hl2.png"})
VJ.AddWeapon("Combine Sniper", "weapon_vj_hlr2_csniper", false, spawnCategory)
VJ.AddWeapon("Alyx Gun", "weapon_vj_hlr2_alyxgun", false, spawnCategory)
VJ.AddWeapon("Charge Bow", "weapon_vj_hlr2_chargebow", false, spawnCategory)
VJ.AddWeapon("Resistance RPG", "weapon_vj_hlr2_rpg", false, spawnCategory)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Decals ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Blood
game.AddDecal("VJ_HLR1_Blood_Red", {"vj_hl/decals/hl_blood01", "vj_hl/decals/hl_blood02", "vj_hl/decals/hl_blood03", "vj_hl/decals/hl_blood04", "vj_hl/decals/hl_blood05", "vj_hl/decals/hl_blood06", "vj_hl/decals/hl_blood07", "vj_hl/decals/hl_blood08"})
game.AddDecal("VJ_HLR1_Blood_Red_Large", {"vj_hl/decals/hl_bigblood01", "vj_hl/decals/hl_bigblood02"})
game.AddDecal("VJ_HLR1_Blood_Yellow", {"vj_hl/decals/hl_yblood01", "vj_hl/decals/hl_yblood02", "vj_hl/decals/hl_yblood03", "vj_hl/decals/hl_yblood04", "vj_hl/decals/hl_yblood05", "vj_hl/decals/hl_yblood06"})
game.AddDecal("VJ_HLR1_Blood_Yellow_Large", {"vj_hl/decals/hl_bigyblood01", "vj_hl/decals/hl_bigyblood02"})
-- Spits
game.AddDecal("VJ_HLR1_Spit_Acid", {"vj_hl/decals/spit1_green", "vj_hl/decals/spit2_green"}) // {"vj_hl/decals/spit1", "vj_hl/decals/spit2"}
game.AddDecal("VJ_HLR1_Spit_Red", {"vj_hl/decals/spit1_red", "vj_hl/decals/spit2_red"})
game.AddDecal("VJ_HLR1_Spit_Gonarch", {"vj_hl/decals/mommablob"}) // {"vj_hl/decals/gonarch"}
-- Scorchs
game.AddDecal("VJ_HLR1_Scorch", {"vj_hl/decals/scorch1", "vj_hl/decals/scorch2", "vj_hl/decals/scorch3"})
game.AddDecal("VJ_HLR1_Scorch_Small", {"vj_hl/decals/smscorch1", "vj_hl/decals/smscorch2", "vj_hl/decals/smscorch3"})
game.AddDecal("VJ_HLR1_Gargantua_Stomp", {"vj_hl/decals/gargstomp"})
-- Bullet Holes
game.AddDecal("VJ_HLR1_Impact", {"vj_hl/decals/shot1", "vj_hl/decals/shot2", "vj_hl/decals/shot3", "vj_hl/decals/shot4", "vj_hl/decals/shot5"})

-- Add to paint tool
list.Add("PaintMaterials", "VJ_HLR1_Blood_Red")
list.Add("PaintMaterials", "VJ_HLR1_Blood_Red_Large")
list.Add("PaintMaterials", "VJ_HLR1_Blood_Yellow")
list.Add("PaintMaterials", "VJ_HLR1_Blood_Yellow_Large")
list.Add("PaintMaterials", "VJ_HLR1_Spit_Red")
list.Add("PaintMaterials", "VJ_HLR1_Spit_Acid")
list.Add("PaintMaterials", "VJ_HLR1_Spit_Gonarch")
list.Add("PaintMaterials", "VJ_HLR1_Scorch")
list.Add("PaintMaterials", "VJ_HLR1_Scorch_Small")
list.Add("PaintMaterials", "VJ_HLR1_Gargantua_Stomp")
list.Add("PaintMaterials", "VJ_HLR1_Impact")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Particles ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddParticle("particles/vj_hlr_goldsrc_blood.pcf", {
	"vj_hlr_blood_red",
	"vj_hlr_blood_red_large",
	"vj_hlr_blood_yellow",
	"vj_hlr_blood_yellow_large",
	"vj_hlr_blood_boob_red",
	"vj_hlr_blood_boob_yellow",
})
VJ.AddParticle("particles/vj_hlr_goldsrc.pcf", {
	"vj_hlr_spit_red_spawn", -- For Gnome
	"vj_hlr_spit_acid_spawn", -- For Bullsquid
	"vj_hlr_torch",
	-- Drone
	"vj_hlr_spit_drone",
	"vj_hlr_spit_drone_impact",
	"vj_hlr_spit_drone_spawn",
	"vj_hlr_spit_drone_spawn_old",
	-- Gonarch
	"vj_hlr_spit_gonarch",
	"vj_hlr_spit_gonarch_impact",
	"vj_hlr_spit_gonarch_spawn",
	-- Mr. Friendly
	"vj_hlr_spit_friendly",
	"vj_hlr_spit_friendly_b",
	"vj_hlr_spit_friendly_impact",
	"vj_hlr_spit_friendly_old",
	"vj_hlr_spit_friendly_b_old",
	"vj_hlr_spit_friendly_impact_old",
	-- Stukabat
	"vj_hlr_spit_stukabat",
	"vj_hlr_spit_stukabat_impact",
	-- Shocktrooper
	"vj_hlr_shockroach_muzzle",
	"vj_hlr_shockroach",
	"vj_hlr_shockroach_aura",
	"vj_hlr_shockroach_bright",
	"vj_hlr_shockroach_trail",
	-- Spore
	"vj_hlr_spore",
	"vj_hlr_spore_b",
	"vj_hlr_spore_c",
	"vj_hlr_spore_small",
	"vj_hlr_spore_small_b",
	"vj_hlr_spore_small_c",
	"vj_hlr_spore_idle",
	"vj_hlr_spore_idle_b",
	"vj_hlr_spore_idle_c",
	"vj_hlr_spore_idle_small",
	"vj_hlr_spore_idle_small_b",
	"vj_hlr_spore_idle_small_c",
	-- Gargantua
	"vj_hlr_garg_flame",
	"vj_hlr_garg_flame_small",
	"vj_hlr_garg_stomp",
	-- Nihilanth
	"vj_hlr_nihilanth_deathorbs",
	"vj_hlr_nihilanth_deathorbs_white",
	-- Gene Worm
	"vj_hlr_geneworm_spit",
	"vj_hlr_geneworm_sprites",
	"vj_hlr_geneworm_sprites_death",
})
VJ.AddParticle("particles/electrical_fx.pcf", {
	"electrical_arc_01", -- Used for the Combine Reager
})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sounds ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Alyx Gun
sound.Add({
	name = "VJ.HLR_Weapon_AlyxGun.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 140,
	pitch = {90, 110},
	sound = {"^vj_hlr/src/wep/alyx_gun/alyx_gun_fire5.wav", "^vj_hlr/src/wep/alyx_gun/alyx_gun_fire6.wav"}
})

-- Annabelle
sound.Add({
	name = "VJ.HLR_Weapon_Annabelle.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 140,
	pitch = {90, 110},
	sound = "^vj_hlr/src/wep/annabelle/annabelle_single.wav"
})

-- OICW (HL2 Beta)
sound.Add({
	name = "VJ.HLR_Weapon_OICW.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 140,
	pitch = {90, 110},
	sound = "^vj_hlr/src/wep/oicw/npc_ar2_fire1.wav"
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
function VJ.HLR1_Effect_Portal(pos, size, color, onSpawn)
	-- Helpful page: https://developer.valvesoftware.com/wiki/Alien_Teleport_Effect_(HL1)
	size = size or 1.5

	-- Main gas sprite
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
	spr:SetKeyValue("scale", "" .. size)
	spr:SetKeyValue("rendercolor", color or "77 210 130")
	spr:SetKeyValue("rendermode", "5") -- 5 = Additive render mode
	spr:SetKeyValue("renderamt", "255")
	spr:SetKeyValue("framerate", "10.0")
	spr:SetKeyValue("spawnflags", "2") -- 2 (SF_SPRITE_ONCE) = Makes it animate / display only once
	spr:SetPos(pos)
	spr:Spawn()
	spr:Fire("Kill", "", 1)

	-- Portal sprite
	local sprPortal = ents.Create("env_sprite")
	sprPortal:SetKeyValue("model", "vj_hl/sprites/XFlare1.vmt")
	sprPortal:SetKeyValue("scale", "" .. (size - 0.5)) -- Make this little bit smaller than the other one!
	sprPortal:SetKeyValue("rendercolor", color or "184 250 214")
	sprPortal:SetKeyValue("rendermode", "5") -- 5 = Additive render mode
	sprPortal:SetKeyValue("renderamt", "255")
	sprPortal:SetKeyValue("framerate", "10.0")
	sprPortal:SetKeyValue("spawnflags", "2") -- 2 (SF_SPRITE_ONCE) = Makes it animate / display only once
	sprPortal:SetPos(pos)
	sprPortal:Spawn()
	sprPortal:Fire("Kill", "", 1)

	-- Beam effects
	local beam = ents.Create("env_beam")
	beam:SetName("hlr_beam_" .. beam:EntIndex())
	beam:SetKeyValue("LightningStart", beam:GetName()) -- Start location (Needs to be an entity name!)
	beam:SetKeyValue("texture", "vj_hl/sprites/lgtning.vmt")
	beam:SetKeyValue("rendercolor", color or "197 243 169")
	beam:SetKeyValue("renderamt", "150")
	beam:SetKeyValue("radius", "600") -- How far a bolt can go
	beam:SetKeyValue("BoltWidth", "10") -- Thickness of each bolt
	beam:SetKeyValue("NoiseAmplitude", "15") -- Amplitude in each bolt, larger number will increase its width
	beam:SetKeyValue("StrikeTime", "-.5")
	beam:SetKeyValue("spawnflags", "5") -- 1 (Start On) + 4 (Random Strike)
	beam:SetKeyValue("life", "0.5")
	beam:SetPos(pos)
	beam:SetParent(spr)
	beam:Spawn()
	beam:Activate()
	beam:Fire("TurnOn", "", 0)

	-- Dynamic light
	local dynLight = ents.Create("light_dynamic")
	dynLight:SetKeyValue("brightness", "2")
	dynLight:SetKeyValue("distance", "200")
	dynLight:SetKeyValue("_light", color and color .. "150" or "77 210 130 150")
	dynLight:SetKeyValue("style", "1") -- 1 = Flicker A (mmnmmommommnonmmonqnmmo)
	dynLight:SetPos(pos)
	dynLight:SetParent(spr)
	dynLight:Spawn()
	dynLight:Activate()
	dynLight:Fire("TurnOn", "", 0)
	//dynLight:Fire("Kill", "", 1)

	sound.Play("vj_hlr/gsrc/fx/beamstart2.wav", pos, 85)
	timer.Simple(0.5, function()
		sound.Play("vj_hlr/gsrc/fx/beamstart4.wav", pos, 85) -- Play the spawn sound
		if onSpawn then onSpawn() end
	end)
	return spr
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.HLR1_Effect_Explosion(pos, type, size, color)
	type = type or 1
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model", type == 1 && "vj_hl/sprites/zerogxplode.vmt" or "vj_hl/sprites/fexplo1.vmt")
	spr:SetKeyValue("scale", "" .. (size or 1))
	spr:SetKeyValue("rendercolor", color or "255 255 255")
	spr:SetKeyValue("rendermode", "5")
	spr:SetKeyValue("renderamt", "255")
	spr:SetKeyValue("framerate", "15.0")
	spr:SetKeyValue("spawnflags", "2") -- 2 (SF_SPRITE_ONCE) = Makes it animate / display only once
	spr:SetPos(pos)
	spr:Spawn()
	spr:Fire("Kill", "", 0.9)

	sound.Play("vj_hlr/gsrc/wep/explosion/explode" .. math.random(1, 3) .. ".wav", pos, 150)
	return spr
end
---------------------------------------------------------------------------------------------------------------------------------------------
local excludedMats = {
	[MAT_ANTLION] = true,
	[MAT_ALIENFLESH] = true,
	[MAT_BLOODYFLESH] = true,
	[MAT_FLESH] = true,
}
function VJ.HLR1_Effect_Impact(tr)
	if !excludedMats[tr.MatType] then
		local effectData = EffectData()
		effectData:SetEntity(tr.Entity)
		effectData:SetStart(tr.StartPos)
		effectData:SetOrigin(tr.HitPos)
		effectData:SetNormal(tr.HitNormal)
		effectData:SetHitBox(tr.HitBox)
		effectData:SetSurfaceProp(tr.SurfaceProps)
		effectData:SetFlags(1)
		util.Effect("Impact_GMOD", effectData)
		util.Decal("VJ_HLR1_Impact", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.HLR_Weapon_CheckModel(wep, models)
	local owner = wep:GetOwner()
	if !models[owner:GetModel()] then
		local creator = owner:GetCreator()
		if IsValid(creator) then
			creator:PrintMessage(HUD_PRINTTALK, wep.PrintName .. " removed! It's made for specific NPCs only!")
		end
		wep:Remove()
		return false
	end
	return true -- Valid model
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defGibs_Yellow = {"models/vj_hlr/gibs/agib1.mdl", "models/vj_hlr/gibs/agib2.mdl", "models/vj_hlr/gibs/agib3.mdl", "models/vj_hlr/gibs/agib4.mdl", "models/vj_hlr/gibs/agib5.mdl", "models/vj_hlr/gibs/agib6.mdl", "models/vj_hlr/gibs/agib7.mdl", "models/vj_hlr/gibs/agib8.mdl", "models/vj_hlr/gibs/agib9.mdl", "models/vj_hlr/gibs/agib10.mdl"}
local defGibs_Red = {"models/vj_hlr/gibs/flesh1.mdl", "models/vj_hlr/gibs/flesh2.mdl", "models/vj_hlr/gibs/flesh3.mdl", "models/vj_hlr/gibs/flesh4.mdl", "models/vj_hlr/gibs/hgib_b_bone.mdl", "models/vj_hlr/gibs/hgib_b_gib.mdl", "models/vj_hlr/gibs/hgib_guts.mdl", "models/vj_hlr/gibs/hgib_hmeat.mdl", "models/vj_hlr/gibs/hgib_lung.mdl", "models/vj_hlr/gibs/hgib_skull.mdl", "models/vj_hlr/gibs/hgib_legbone.mdl"}
--
function VJ.HLR_ApplyCorpseSystem(ent, corpse, gibTbl, extraOptions)
	extraOptions = extraOptions or {} -- CollisionSound, ExpSound, Gibbable, CanBleed, ExtraGibs
	corpse.HLR_Corpse = true
	corpse.HLR_Corpse_Type = ent.BloodColor
	if ent.HasBloodParticle then corpse.HLR_Corpse_Particle = ent.BloodParticle end
	corpse.HLR_Corpse_Decal = ent.HasBloodDecal and VJ.PICK(ent.BloodDecal) or ""
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
	corpse.HLR_Corpse_CollideSound = extraOptions.CollisionSound
	corpse.HLR_Corpse_ExpSound = extraOptions.ExpSound or "vj_base/gib/splat.wav"
	corpse.HLR_Corpse_StartT = CurTime() + 1
end

local defPos = Vector(0, 0, 0)
local colorYellow = VJ.Color2Byte(Color(255, 221, 35))
local colorRed = VJ.Color2Byte(Color(130, 19, 10))
hook.Add("EntityTakeDamage", "VJ_HLR_EntityTakeDamage", function(target, dmginfo)
	if target.HLR_Corpse && !target.Dead && CurTime() > target.HLR_Corpse_StartT && target:GetColor().a > 50 then
		local dmgForce = dmginfo:GetDamageForce()

		-- Blood hit effects & decals
		if GetConVar("vj_hlr1_corpse_effects"):GetInt() == 1 then
			local pos = dmginfo:GetDamagePosition()
			if pos == defPos then pos = target:GetPos() + target:OBBCenter() end

			-- Blood particle
			local part = VJ.PICK(target.HLR_Corpse_Particle)
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
			local decal = VJ.PICK(target.HLR_Corpse_Decal)
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
			for _, v in ipairs(target.ChildEnts) do
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
				VJ.EmitSound(target, VJ.PICK(target.HLR_Corpse_ExpSound), 90, 100)

				-- Spawn gibs
				local gibMaxs = target:OBBMaxs()
				local gibMins = target:OBBMins()
				for _, v in ipairs(target.HLR_Corpse_Gibs) do
					local gib = ents.Create("obj_vj_gib")
					gib:SetModel(v)
					gib:SetPos(centerPos + Vector(math.random(gibMins.x, gibMaxs.x), math.random(gibMins.y, gibMaxs.y), 10))
					gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
					gib.BloodType = target.HLR_Corpse_Type
					gib.CollisionDecal = target.HLR_Corpse_Decal
					if target.HLR_Corpse_CollideSound != nil then
						gib.CollisionSound = target.HLR_Corpse_CollideSound
					end
					gib:Spawn()
					gib:Activate()
					local phys = gib:GetPhysicsObject()
					if IsValid(phys) then
						phys:AddVelocity(Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(150, 250)) + (dmgForce / 70))
						phys:AddAngleVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
					end
					if GetConVar("vj_npc_gib_fade"):GetInt() == 1 then
						timer.Simple(GetConVar("vj_npc_gib_fadetime"):GetInt(), function()
							SafeRemoveEntity(gib)
						end)
					end
				end

				local bloodIsYellow = target.HLR_Corpse_Type == "Yellow"
				local bloodIsRed = target.HLR_Corpse_Type == "Red"

				-- Death effects & decals
				if bloodIsYellow or bloodIsRed then
					local maxDist = gibMaxs:Length()
					local splatDecal = bloodIsYellow and "VJ_HLR1_Blood_Yellow_Large" or "VJ_HLR1_Blood_Red_Large"
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
					VJ.DEBUG_TempEnt(dmgPos, Angle(0, 0, 0), Color(0, 225, 255))
					VJ.DEBUG_TempEnt(dmgPos + dmgPos:GetNormal() * 10)
					local tr = util.TraceLine({start = dmgPos, endpos = dmgPos + dmgPos:GetNormal() * 10, filter = target})
					VJ.DEBUG_TempEnt(tr.HitPos, Angle(0, 0, 0), Color(94, 255, 0))
					util.Decal("VJ_HLR1_Blood_Red_Large", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)*/

					local effectData = EffectData()
					effectData:SetOrigin(centerPos)
					effectData:SetColor(bloodIsYellow and colorYellow or colorRed)
					effectData:SetScale(120)
					util.Effect("VJ_Blood1", effectData)
					effectData:SetScale(8)
					effectData:SetFlags(3)
					effectData:SetColor(bloodIsYellow and 1 or 0)
					util.Effect("bloodspray", effectData)
					util.Effect("bloodspray", effectData)
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
ent.HLR_Corpse = Is this an HLR corpse?
	--> ent.HLR_Corpse_Type, ent.HLR_Corpse_Particle, ent.HLR_Corpse_Decal
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Convars & Menu ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddConVar("vj_hlr_hd", 0, FCVAR_ARCHIVE)
-- GoldSrc
VJ.AddConVar("vj_hlr1_corpse_effects", 1, FCVAR_ARCHIVE)
VJ.AddConVar("vj_hlr1_corpse_gibbable", 1, FCVAR_ARCHIVE)
VJ.AddConVar("vj_hlr1_gonarch_babylimit", 20, FCVAR_ARCHIVE)
VJ.AddConVar("vj_hlr1_bradley_deploygrunts", 1, FCVAR_ARCHIVE)
VJ.AddConVar("vj_hlr1_osprey_deploysoldiers", 1, FCVAR_ARCHIVE)
VJ.AddConVar("vj_hlr1_assassin_cloaks", 1, FCVAR_ARCHIVE)
-- Source
VJ.AddConVar("vj_hlr2_merkava_gunner", 1, FCVAR_ARCHIVE)
VJ.AddConVar("vj_hlr2_custom_skins", 1, FCVAR_ARCHIVE)

VJ.AddConVar("vj_hlr_autoreplace", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_hl1", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_hl2", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_essential", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_random", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_randommix", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
VJ.AddConVar("vj_hlr_autoreplace_alliedagainstply", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

VJ.AddClientConVar("vj_hlr1_sparkfx", 1, "Apply GoldSrc style sparks on metal surfaces for certain NPCs & weapons")
VJ.AddClientConVar("vj_hlr2_csniper_laser_usebarrel", 1, "Combine Sniper Laser Follows Gun Barrel")
VJ.AddClientConVar("vj_hlr2_combine_eyeglow", 0, "Combine Eye Glow Effects")

if CLIENT then
	hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_HLR", function()
		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "HLR - Auto Replace", "HLR - Auto Replace", "", "", function(panel)
			if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
				panel:Help("#vjbase.menu.general.admin.not")
				panel:Help("#vjbase.menu.general.admin.only")
				return
			end
			panel:Help("#vjbase.menu.general.admin.only")
			panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_hlr_autoreplace 0\nvj_hlr_autoreplace_hl1 1\nvj_hlr_autoreplace_hl2 1\nvj_hlr_autoreplace_random 0\nvj_hlr_autoreplace_randommix 0\nvj_hlr_autoreplace_essential 0\nvj_hlr_autoreplace_randommix 0"})
			panel:Help("Auto Replace script replaces HL1 / HL2 NPCs with the corresponding Half-Life Resurgence NPC!")
			local vid = vgui.Create("DButton")
				vid:SetFont("TargetID")
				vid:SetText("What is Auto Replace?")
				vid:SetSize(150, 25)
				vid.DoClick = function()
					gui.OpenURL("https://www.youtube.com/watch?v=I7_I-HFA_Ks")
				end
			panel:AddPanel(vid)
			panel:CheckBox("Enable Auto Replacement Script", "vj_hlr_autoreplace")
			panel:CheckBox("Replace HL1 NPCs", "vj_hlr_autoreplace_hl1")
			panel:CheckBox("Replace HL2 NPCs", "vj_hlr_autoreplace_hl2")
			panel:CheckBox("Main Characters Are Invincible?", "vj_hlr_autoreplace_essential")
			panel:Help("FUN OPTIONS:")
			panel:CheckBox("Enable Random Replacements", "vj_hlr_autoreplace_random")
			panel:CheckBox("Mix GoldSrc and Source in Random Replacements", "vj_hlr_autoreplace_randommix")
			panel:CheckBox("Make All NPCs Allied Against Players", "vj_hlr_autoreplace_alliedagainstply")
			panel:Help("WARNINGS: Certain maps may occasionally break or crash! Some parts of the campaign may require the player to remove invisible barriers or physgun important NPCs to their proper location to continue to the next level.")
		end)

		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "HLR - Server", "HLR - Server", "", "", function(panel)
			if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
				panel:Help("#vjbase.menu.general.admin.not")
				panel:Help("#vjbase.menu.general.admin.only")
				return
			end
			panel:Help("#vjbase.menu.general.admin.only")
			panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_hlr1_gonarch_babylimit 20\nvj_hlr1_bradley_deploygrunts 1\nvj_hlr1_osprey_deploysoldiers 1\nvj_hlr2_merkava_gunner 1\nvj_hlr1_assassin_cloaks 1\nvj_hlr1_corpse_effects 1\nvj_hlr1_corpse_gibbable 1\nvj_hlr2_custom_skins 1\nvj_hlr_hd 0"})
			panel:CheckBox("Enable HD Models (if available)", "vj_hlr_hd")
			panel:ControlHelp("Requires HD extension(s) to be installed!")
			panel:Help("GoldSrc Engine:")
			panel:CheckBox("Corpses Create Effects & Decals", "vj_hlr1_corpse_effects")
			panel:CheckBox("Corpses Can Be Dismembered", "vj_hlr1_corpse_gibbable")
			panel:CheckBox("M2A3 Bradley Deploys Human Grunts", "vj_hlr1_bradley_deploygrunts")
			panel:CheckBox("V-22 Osprey Deploys Human Grunts / Assassins", "vj_hlr1_osprey_deploysoldiers")
			panel:CheckBox("Can Female Assassin Cloak?", "vj_hlr1_assassin_cloaks")
			panel:NumSlider("Gonarch Baby Headcrab Limit", "vj_hlr1_gonarch_babylimit", 0, 100, 0)
			panel:Help("Source Engine:")
			panel:CheckBox("Custom NPC Skins", "vj_hlr2_custom_skins")
			panel:ControlHelp("Ex: Custom skins for Rebels & Refugees")
			panel:CheckBox("Merkava Spawns With a Gunner", "vj_hlr2_merkava_gunner")
		end)

		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "HLR - Client", "HLR - Client", "", "", function(panel)
			panel:AddControl("Button", {Text = "#vjbase.menu.general.reset.everything", Command = "vj_hlr2_csniper_laser_usebarrel 1\nvj_hlr1_sparkfx 1\nvj_hlr2_combine_eyeglow 0"})
			panel:Help("GoldSrc Engine:")
			panel:CheckBox("HL1-Style Sparks On Metal Surfaces", "vj_hlr1_sparkfx")
			panel:ControlHelp("Applies ONLY to HL1 NPCs & weapons!")
			panel:Help("Source Engine:")
			panel:CheckBox("Combine Sniper Laser Follows Gun Barrel", "vj_hlr2_csniper_laser_usebarrel")
			panel:ControlHelp("Unchecked = Laser will pinpoint to the enemy instead")
			panel:CheckBox("Combine Eye Glow Effects", "vj_hlr2_combine_eyeglow")
			panel:ControlHelp("Requires map restart! | WARNING: Causes performance loss!")
		end)
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Auto Replacement Script ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	-- If enabled during startup, then just run it!
	if GetConVar("vj_hlr_autoreplace"):GetInt() == 1 then
		include("vj_base/extensions/hlr_autoreplace.lua")
	end
	-- Detect changes to the convar...
	cvars.AddChangeCallback("vj_hlr_autoreplace", function(convar_name, value_old, value_new)
		if value_new == "1" then
			include("vj_base/extensions/hlr_autoreplace.lua")
		else
			hook.Remove("OnEntityCreated", "VJ_HLR_AutoReplace_EntCreate")
			hook.Remove("Think", "VJ_HLR_AutoReplace_Think")
		end
	end)
end
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Sniper Rifle"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General NPC Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 2 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_TimeUntilFire = 0.5 -- How much time until the bullet/projectile is fired?
SWEP.NPC_CustomSpread = 0.3 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_FiringDistanceScale = 2.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
	-- ====== Reload Variables ====== --
SWEP.NPC_ReloadSound = "vj_hlr/hl2_weapon/sniper_rifle/reload1.wav" -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel = "models/vj_hlr/hl2b/weapons/w_sniper.mdl"
SWEP.HoldType = "ar2"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Primary Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 100 -- Damage
SWEP.Primary.Force = 1.6 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 1 -- Max amount of bullets per clip
SWEP.Primary.Ammo = "357" -- Ammo type
SWEP.Primary.Sound = "vj_hlr/hl2_weapon/sniper_rifle/fire1.wav"
SWEP.Primary.DistantSound = {"vj_base/weapons/ssg08/ssg08_single_dist1.wav", "vj_base/weapons/ssg08/ssg08_single_dist2.wav", "vj_base/weapons/ssg08/ssg08_single_dist3.wav", "vj_base/weapons/ssg08/ssg08_single_dist4.wav"}
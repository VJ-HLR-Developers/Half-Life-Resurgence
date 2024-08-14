SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Annabelle"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"
SWEP.HoldType = "shotgun"
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
SWEP.ReplacementWeapon = "weapon_annabelle"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.9 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_CustomSpread = 0.2 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_BulletSpawnAttachment = "0" -- The attachment that the bullet spawns on, leave empty for base to decide!
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 60 -- Damage
//SWEP.Primary.Force = 2 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 2 -- Max amount of bullets per clip
SWEP.Primary.Ammo = "Buckshot" -- Ammo type
SWEP.Primary.Sound = "VJ.HLR_Weapon_Annabelle.Single"
SWEP.PrimaryEffects_MuzzleAttachment = "0"
SWEP.PrimaryEffects_ShellAttachment = "1"
SWEP.PrimaryEffects_ShellType = "ShotgunShellEject"
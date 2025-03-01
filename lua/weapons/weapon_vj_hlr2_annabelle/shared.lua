SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Annabelle"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"
SWEP.HoldType = "shotgun"
SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = {"weapon_rtbr_annabelle", "weapon_annabelle"}
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.9
SWEP.NPC_CustomSpread = 0.2
SWEP.NPC_BulletSpawnAttachment = "0"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 60
//SWEP.Primary.Force = 2
SWEP.Primary.ClipSize = 2
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Sound = "VJ.HLR_Weapon_Annabelle.Single"
SWEP.PrimaryEffects_MuzzleAttachment = "0"
SWEP.PrimaryEffects_ShellAttachment = "1"
SWEP.PrimaryEffects_ShellType = "ShotgunShellEject"
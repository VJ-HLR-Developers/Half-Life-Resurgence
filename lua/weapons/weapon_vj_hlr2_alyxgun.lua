AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Alyx Gun"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Spawnable = true
SWEP.Category = "Half-Life Resurgence"
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/vj_hlr/hl2/weapons/c_alyxgun.mdl"
SWEP.WorldModel = "models/weapons/w_alyx_gun.mdl"
SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.SwayScale = 4
SWEP.UseHands = true
//SWEP.ReplacementWeapon = "weapon_rtbr_alyxgun"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.95
SWEP.NPC_TimeUntilFireExtraTimers = {0.08, 0.16, 0.24, 0.32, 0.4}
SWEP.NPC_CustomSpread = 0.4
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 6
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Automatic = true
SWEP.Primary.Sound = "VJ.HLR_Weapon_AlyxGun.Single"
SWEP.PrimaryEffects_ShellAttachment = "1"
SWEP.PrimaryEffects_ShellType = "ShellEject"
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true
SWEP.ReloadSound = "weapons/pistol/pistol_reload1.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 1
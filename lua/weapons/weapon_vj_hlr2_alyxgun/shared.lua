if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Alyx Gun"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_alyx_gun.mdl"
SWEP.HoldType = "pistol"
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.95 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFireExtraTimers = {0.08, 0.16, 0.24, 0.32, 0.4}
SWEP.NPC_CustomSpread = 0.4 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 6 -- Damage
SWEP.Primary.ClipSize = 30 -- Max amount of bullets per clip
SWEP.Primary.Delay = 0.1 -- Time until it can shoot again
SWEP.Primary.Ammo = "Pistol" -- Ammo type
SWEP.Primary.Sound = {"vj_hlr/hl2_weapon/alyx_gun/alyx_gun_fire3.wav","vj_hlr/hl2_weapon/alyx_gun/alyx_gun_fire4.wav"}
SWEP.Primary.DistantSound = {"vj_hlr/hl2_weapon/alyx_gun/alyx_gun_fire5.wav","vj_hlr/hl2_weapon/alyx_gun/alyx_gun_fire6.wav"}
SWEP.PrimaryEffects_ShellAttachment = "1"
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
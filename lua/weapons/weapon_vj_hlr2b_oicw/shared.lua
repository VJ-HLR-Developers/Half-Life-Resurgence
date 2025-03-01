SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "OICW"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/vj_hlr/hl2b/weapons/w_oicw.mdl"
SWEP.HoldType = "ar2"
SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = "weapon_rtbr_oicw"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_HasSecondaryFire = true
SWEP.NPC_SecondaryFireSound = "vj_hlr/hl2_weapon/oicw/npc_ar2_altfire.wav"
SWEP.NPC_ReloadSound = "vj_hlr/hl2_weapon/oicw/ar2_reload.wav"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 8
SWEP.Primary.ClipSize = 30
SWEP.Primary.Sound = {
	"vj_hlr/hl2_weapon/oicw/ar2_fire1.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_fire2.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_fire3.wav",
}
SWEP.Primary.DistantSound = {
	"vj_hlr/hl2_weapon/oicw/ar2_echo.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_echo2.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_echo3.wav",
}
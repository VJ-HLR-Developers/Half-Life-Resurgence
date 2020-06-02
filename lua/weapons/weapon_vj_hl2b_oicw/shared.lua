if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "SMG1"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
-- SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/c_smg1.mdl"
SWEP.WorldModel					= "models/vj_hlr/hl2b/weapons/w_oicw.mdl"
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
SWEP.MadeForNPCsOnly 			= true
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 8 -- Damage
SWEP.Primary.ClipSize			= 30 -- Max amount of bullets per clip
SWEP.Primary.Sound				= {
	"vj_hlr/hl2_weapon/oicw/ar2_fire1.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_fire2.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_fire3.wav",
}
SWEP.Primary.DistantSound		= {
	"vj_hlr/hl2_weapon/oicw/ar2_echo.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_echo2.wav",
	"vj_hlr/hl2_weapon/oicw/ar2_echo3.wav",
}
SWEP.NPC_ReloadSound = {"vj_hlr/hl2_weapon/oicw/ar2_reload.wav"}
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
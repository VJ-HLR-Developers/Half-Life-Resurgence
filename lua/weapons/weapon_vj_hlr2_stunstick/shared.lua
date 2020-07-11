if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Stun Stick"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.MadeForNPCsOnly = true
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 1 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0.5 -- How much time until the bullet/projectile is fired?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.HoldType = "melee"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 30 -- Damage
SWEP.IsMeleeWeapon = true -- Should this weapon be a melee weapon?
SWEP.Primary.Sound = {"weapons/stunstick/spark1.wav","weapons/stunstick/spark2.wav","weapons/stunstick/spark3.wav"}
SWEP.MeleeWeaponSound_Hit = {"weapons/stunstick/stunstick_fleshhit1.wav","weapons/stunstick/stunstick_fleshhit2.wav"} -- Sound it plays when it hits something
SWEP.MeleeWeaponSound_Miss = {"weapons/stunstick/stunstick_swing1.wav","weapons/stunstick/stunstick_swing2.wav"} -- Sound it plays when it misses (Doesn't hit anything)
// "physics/body/body_medium_impact_hard1.wav","physics/body/body_medium_impact_hard2.wav","physics/body/body_medium_impact_hard3.wav","physics/body/body_medium_impact_hard4.wav","physics/body/body_medium_impact_hard5.wav","physics/body/body_medium_impact_hard6.wav"
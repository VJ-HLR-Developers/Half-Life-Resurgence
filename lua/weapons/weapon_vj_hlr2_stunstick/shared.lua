SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Stun Stick"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = "weapon_stunstick"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 1
SWEP.NPC_TimeUntilFire = 0.5
SWEP.NPC_BeforeFireSound = {"weapons/stunstick/stunstick_swing1.wav", "weapons/stunstick/stunstick_swing2.wav"} -- Plays a sound before the firing code is ran, usually in the beginning of the animation
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.HoldType = "melee"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 30
SWEP.IsMeleeWeapon = true
SWEP.Primary.Sound = {"weapons/stunstick/spark1.wav", "weapons/stunstick/spark2.wav", "weapons/stunstick/spark3.wav"}
SWEP.MeleeWeaponSound_Hit = {"weapons/stunstick/stunstick_fleshhit1.wav", "weapons/stunstick/stunstick_fleshhit2.wav"} -- Sound it plays when it hits something
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "MeleeHit" then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetAttachment(1).Pos)
		util.Effect("StunstickImpact", effectData)
	end
end
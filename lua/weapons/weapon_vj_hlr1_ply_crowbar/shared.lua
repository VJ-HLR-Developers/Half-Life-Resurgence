if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Crowbar"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.MadeForNPCsOnly = true
SWEP.IsMeleeWeapon = true

SWEP.WorldModel = "models/vj_hlr/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"

SWEP.NPC_NextPrimaryFire = 0.25

SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(90, 0, -90)
SWEP.WorldModel_CustomPositionOrigin = Vector(-3.5, 5, 0)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand"

SWEP.Primary.Damage = 10
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetModelScale(0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDeploy()
	local owner = self:GetOwner()
	if IsValid(owner) then
		owner.SoundTbl_MeleeAttack = {"vj_hlr/hl1_weapon/crowbar/cbar_hitbod1.wav","vj_hlr/hl1_weapon/crowbar/cbar_hitbod2.wav","vj_hlr/hl1_weapon/crowbar/cbar_hitbod3.wav"}
		owner.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_weapon/crowbar/cbar_miss1.wav"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnHolster(newWep)
	self:CustomOnRemove()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	local owner = self:GetOwner()
	if IsValid(owner) then
		owner.SoundTbl_MeleeAttack = {}
		owner.SoundTbl_MeleeAttackMiss = {}
	end
end
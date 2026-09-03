AddCSLuaFile()

SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "SPAS-12"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "Half-Life Resurgence"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false
SWEP.NPC_CustomSpread	 		= 2.5
SWEP.NPC_ReloadSound			= "vj_hlr/gsrc/wep/shotgun/shotgun_reload.wav"
SWEP.NPC_ExtraFireSound			= "vj_hlr/gsrc/wep/shotgun/scock1.wav"
SWEP.NPC_ExtraFireSoundTime		= 0.2
SWEP.NPC_CanBePickedUp			= false
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = {"weapon_hl1_shotgun", "weapon_shotgun_hl1"}
SWEP.WorldModel = "models/vj_hlr/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModelOffsetParams = {
	Enabled = true,
	Bone = "Bip01 R Hand",
	Pos = Vector(13, -1.8, 0.6),
	Ang = Angle(0, 180, 90)
}
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5
SWEP.Primary.NumberOfShots		= 5
SWEP.Primary.ClipSize			= 8
SWEP.Primary.Ammo				= "Buckshot"
SWEP.Primary.Sound				= "vj_hlr/gsrc/wep/shotgun/sbarrel1.wav"
SWEP.Primary.DistantSound		= "vj_hlr/gsrc/wep/shotgun/sbarrel1_distant2.wav"
SWEP.PrimaryEffects_ShellType 	= "ShotgunShellEject"
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.DryFireSound = "vj_hlr/gsrc/wep/dryfire1.wav"

-- Custom
local validModels = {
	["models/vj_hlr/opfor/hgrunt.mdl"] = true,
	["models/vj_hlr/hl1/hgrunt.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt_medic.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt_engineer.mdl"] = true,
	["models/vj_hlr/hl1/rgrunt.mdl"] = true,
	["models/vj_hlr/hl1/rgrunt_black.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt_medic.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt_engineer.mdl"] = true,
	["models/vj_hlr/cracklife/hgrunt.mdl"] = true,
	["models/vj_parr/par1/cut/vts_urban_terrorist.mdl"] = true
}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	timer.Simple(0.1, function()
		if IsValid(self) && IsValid(self:GetOwner()) && VJ.HLR_Weapon_CheckModel(self, validModels) then
			self.NPC_NextPrimaryFire = false
		end
		if self:GetOwner():GetModel() == "models/vj_parr/par1/cut/vts_urban_terrorist.mdl" then
			self.Primary.Damage = 10
			self.WorldModelOffsetParams.Pos = Vector(13, 3.5, 0.6)
			self.WorldModelOffsetParams.Ang = Angle(0, 195, 90)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DoImpactEffect(tr, damageType)
	if self:GetOwner():GetModel() == "models/vj_parr/par1/cut/vts_urban_terrorist.mdl" then
		return VJ.PARR1_Effect_Impact(tr)
	else
		return VJ.HLR1_Effect_Impact(tr)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnDrawWorldModel()
	return !IsValid(self:GetOwner())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects(owner)
	local muz = ents.Create("env_sprite")
	muz:SetKeyValue("model", "vj_hl/sprites/muzzleflash2.vmt")
	muz:SetKeyValue("scale", math.Rand(0.3, 0.5))
	muz:SetKeyValue("GlowProxySize", "2.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale", "1.0")
	muz:SetKeyValue("renderfx", "14")
	muz:SetKeyValue("rendermode", "3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt", "255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows", "0") -- Disable receiving shadows
	muz:SetKeyValue("framerate", "10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags", "0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment", self.PrimaryEffects_MuzzleAttachment)
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill", nil, 0.08)
	self.BaseClass.PrimaryAttackEffects(self, owner)
end
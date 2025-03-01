SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "SPAS-12"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false
SWEP.NPC_CustomSpread	 		= 2.5
SWEP.NPC_ReloadSound			= "vj_hlr/hl1_weapon/shotgun/shotgun_reload.wav"
SWEP.NPC_ExtraFireSound			= "vj_hlr/hl1_weapon/shotgun/scock1.wav"
SWEP.NPC_ExtraFireSoundTime		= 0.2
SWEP.NPC_CanBePickedUp			= false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = {"weapon_hl1_shotgun", "weapon_shotgun_hl1"}
SWEP.WorldModel = "models/vj_hlr/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(0, 180, 90)
SWEP.WorldModel_CustomPositionOrigin = Vector(0, -15, 0)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5
SWEP.Primary.NumberOfShots		= 5
SWEP.Primary.ClipSize			= 8
SWEP.Primary.Ammo				= "Buckshot"
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/shotgun/sbarrel1.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hl1_weapon/shotgun/sbarrel1_distant2.wav"}
SWEP.PrimaryEffects_ShellType 	= "ShotgunShellEject"
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false

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
}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	timer.Simple(0.1, function()
		if IsValid(self) && IsValid(self:GetOwner()) && VJ.HLR_Weapon_CheckModel(self, validModels) then
			self.NPC_NextPrimaryFire = false
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DoImpactEffect(tr, damageType)
	return VJ.HLR1_Effect_Impact(tr)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnDrawWorldModel() -- This is client only!
	if IsValid(self:GetOwner()) then
		self.WorldModel_Invisible = true
		return false
	else
		self.WorldModel_Invisible = false
		return true -- return false to not draw the world model
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects(owner)
	local muz = ents.Create("env_sprite")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash2.vmt")
	muz:SetKeyValue("scale",""..math.Rand(0.3,0.5))
	muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt","255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags","0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment",self.PrimaryEffects_MuzzleAttachment)
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",0.08)
	self.BaseClass.PrimaryAttackEffects(self, owner)
end
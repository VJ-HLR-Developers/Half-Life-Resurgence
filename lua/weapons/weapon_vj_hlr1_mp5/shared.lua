SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "MP5"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = false
SWEP.NPC_ReloadSound = {"vj_hlr/gsrc/wep/mp5/mp_reload.wav"}
SWEP.NPC_CanBePickedUp = false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
SWEP.NPC_HasSecondaryFire = true
SWEP.NPC_SecondaryFireEnt = "obj_vj_hlr1_grenade_40mm" -- The entity to fire, this only applies if self:NPC_SecondaryFire() has NOT been overridden!
SWEP.NPC_SecondaryFireSound = {"vj_hlr/gsrc/wep/mp5/glauncher.wav","vj_hlr/gsrc/wep/mp5/glauncher2.wav"}
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = {"weapon_hl1_mp5", "weapon_mp5_hl1"}
SWEP.WorldModel = "models/vj_hlr/weapons/w_9mmar.mdl"
SWEP.HoldType = "smg"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(90, 180, 90)
SWEP.WorldModel_CustomPositionOrigin = Vector(10, -2, -2)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 5
SWEP.Primary.ClipSize = 50
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Sound = {"vj_hlr/gsrc/wep/mp5/hks1.wav","vj_hlr/gsrc/wep/mp5/hks2.wav","vj_hlr/gsrc/wep/mp5/hks3.wav"}
SWEP.Primary.DistantSound = {"vj_hlr/gsrc/wep/mp5/hks_distant_new.wav"}
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
    ["models/vj_hlr/opfor/massn.mdl"] = true,
    ["models/vj_hlr/hl_hd/hassault.mdl"] = true,
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
			if self:GetOwner():GetModel() == "models/vj_hlr/opfor/massn.mdl" then
				self.WorldModel_CustomPositionAngle = Vector(100, 180, 90)
				self.WorldModel_CustomPositionOrigin = Vector(5.6, -4, -2)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:DoImpactEffect(tr, damageType)
	return VJ.HLR1_Effect_Impact(tr)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnDrawWorldModel()
	return !IsValid(self:GetOwner())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects(owner)
	local muz = ents.Create("env_sprite")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash1.vmt")
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
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Glock 17"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.8
SWEP.NPC_ReloadSound = {"vj_hlr/gsrc/wep/glock/glock_reload.wav"}
SWEP.NPC_CanBePickedUp = false
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true
SWEP.ReplacementWeapon = {"weapon_hl1_glock", "weapon_glock_hl1"}
SWEP.WorldModel = "models/vj_hlr/weapons/w_9mmhandgun.mdl"
SWEP.HoldType = "pistol"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(0, 180, -90)
SWEP.WorldModel_CustomPositionOrigin = Vector(0, -5.5, -1)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 5
SWEP.Primary.ClipSize = 17
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = {"vj_hlr/gsrc/wep/glock/glock_regular.wav"}
SWEP.Primary.DistantSound = {"vj_hlr/gsrc/wep/glock/glock_distant2.wav"}
SWEP.PrimaryEffects_ShellType = "ShellEject"
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false

-- Custom
local validModels = {
	["models/vj_hlr/hl1/barney.mdl"] = true,
	["models/vj_hlr/hla/barney.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt.mdl"] = true,
	["models/vj_hlr/hl1/hgrunt.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt_medic.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt_engineer.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt_medic.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt_engineer.mdl"] = true,
	["models/vj_hlr/cracklife/barney.mdl"] = true,
	["models/vj_hlr/cracklife10/unbarney.mdl"] = true,
	["models/vj_hlr/cracklife10/barney.mdl"] = true,
}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	timer.Simple(0.1, function()
		if IsValid(self) && IsValid(self:GetOwner()) && VJ.HLR_Weapon_CheckModel(self, validModels) then
			self.NPC_NextPrimaryFire = false
			local model = self:GetOwner():GetModel()
			if model == "models/vj_hlr/hl1/barney.mdl" or model == "models/vj_hlr/hla/barney.mdl" or model == "models/vj_hlr/cracklife/barney.mdl" then
				self.Primary.Sound = "vj_hlr/gsrc/npc/barney/ba_attack2.wav"
				self.WorldModel_CustomPositionAngle = Vector(0, 192, -90)
				self.WorldModel_CustomPositionOrigin = Vector(-1.5, -7, -1)
				if model == "models/vj_hlr/hla/barney.mdl" then
					self.WorldModel_CustomPositionBone = "unnamed033"
					self.Primary.TakeAmmo = 0 -- Alpha Security Guard can't reload, so give it unlimited ammo!
				end
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
	muz:SetKeyValue("model", "vj_hl/sprites/muzzleflash2.vmt")
	muz:SetKeyValue("scale", ""..math.Rand(0.3, 0.5))
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
	muz:Fire("Kill", "", 0.08)
	self.BaseClass.PrimaryAttackEffects(self, owner)
end
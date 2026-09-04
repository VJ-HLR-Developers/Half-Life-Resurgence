AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Colt Carbine"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "Half-Life Resurgence"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = false
SWEP.NPC_ReloadSound = "vj_hlr/gsrc/npc/hgrunt_alpha/gr_reload1.wav"
SWEP.NPC_CanBePickedUp = false
SWEP.NPC_HasSecondaryFire = true
SWEP.NPC_SecondaryFireEnt = "obj_vj_hlr1_grenade_40mm"
SWEP.NPC_SecondaryFireSound = {"vj_hlr/gsrc/npc/hgrunt_alpha/glauncher.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/glauncher2.wav"}
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true
SWEP.WorldModel = "models/vj_hlr/weapons/w_coltcarbine.mdl"
SWEP.HoldType = "smg"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModelOffsetParams = {
	Enabled = true,
	Bone = "unnamed035",
	Pos = Vector(12.303, -0.5, 1.044),
	Ang = Angle(4, 0, 0)
}
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 5
SWEP.Primary.ClipSize = 50
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Sound = {"vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun1.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun2.wav", "vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun3.wav"}
SWEP.Primary.DistantSound = "vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun_distant2.wav"
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.DryFireSound = "vj_hlr/gsrc/wep/dryfire1.wav"

-- Custom
local validModels = {
	["models/vj_hlr/hla/hgrunt.mdl"] = true
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
function SWEP:OnDrawWorldModel()
	return !IsValid(self:GetOwner())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PrimaryAttackEffects(owner)
	local muz = ents.Create("env_sprite")
	muz:SetKeyValue("model", "vj_hl/sprites/muzzleflash1.vmt")
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
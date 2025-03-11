SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "M249 SAW"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false
SWEP.NPC_CustomSpread	 		= 2.5
SWEP.NPC_ReloadSound			= {"vj_hlr/gsrc/wep/saw/saw_reload2.wav"}
SWEP.NPC_CanBePickedUp			= false
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true
SWEP.WorldModel					= "models/vj_hlr/weapons/w_saw.mdl"
SWEP.HoldType 					= "ar2"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 94, 2)
SWEP.WorldModel_CustomPositionOrigin = Vector(-6.5, 0, -2)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 8
SWEP.Primary.ClipSize			= 50
SWEP.Primary.Ammo				= "SMG1"
SWEP.Primary.Sound				= {"vj_hlr/gsrc/wep/saw/saw_fire1.wav","vj_hlr/gsrc/wep/saw/saw_fire2.wav","vj_hlr/gsrc/wep/saw/saw_fire3.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/gsrc/wep/saw/saw_distant2.wav"}
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false

-- Custom
local validModels = {
	["models/vj_hlr/opfor/hgrunt.mdl"] = true,
	["models/vj_hlr/hl1/hgrunt.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt_medic.mdl"] = true,
	["models/vj_hlr/opfor/hgrunt_engineer.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt_medic.mdl"] = true,
	["models/vj_hlr/opfor_hd/hgrunt_engineer.mdl"] = true,
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
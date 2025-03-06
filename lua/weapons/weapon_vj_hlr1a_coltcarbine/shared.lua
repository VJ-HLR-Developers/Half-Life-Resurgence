SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Colt Carbine"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.08
SWEP.NPC_ReloadSound = {"vj_hlr/gsrc/npc/hgrunt_alpha/gr_reload1.wav"}
SWEP.NPC_CanBePickedUp = false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
SWEP.NPC_HasSecondaryFire = true
SWEP.NPC_SecondaryFireEnt = "obj_vj_hlr1_grenade_40mm" -- The entity to fire, this only applies if self:NPC_SecondaryFire() has NOT been overridden!
SWEP.NPC_SecondaryFireSound = {"vj_hlr/gsrc/npc/hgrunt_alpha/glauncher.wav","vj_hlr/gsrc/npc/hgrunt_alpha/glauncher2.wav"}
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true
SWEP.WorldModel					= "models/vj_hlr/weapons/w_coltcarbine.mdl"
SWEP.HoldType 					= "smg"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(176, 180, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(0.5, 12.2, 1.9)
SWEP.WorldModel_CustomPositionBone = "unnamed035" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5
SWEP.Primary.ClipSize			= 50
SWEP.Primary.Ammo				= "SMG1"
SWEP.Primary.Sound				= {"vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun1.wav","vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun2.wav","vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun3.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/gsrc/npc/hgrunt_alpha/gr_mgun_distant2.wav"}
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false

-- Custom
local validModels = {
	["models/vj_hlr/hla/hgrunt.mdl"] = true,
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
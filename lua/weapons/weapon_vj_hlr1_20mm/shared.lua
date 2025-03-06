SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "20mm Cannon"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false
SWEP.NPC_CustomSpread	 		= 2
SWEP.NPC_CanBePickedUp			= false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true
SWEP.WorldModel					= "models/vj_hlr/weapons/w_minigun.mdl"
SWEP.HoldType 					= "ar2"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = false -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(100, 0, 100)
SWEP.WorldModel_CustomPositionOrigin = Vector(15, 0.5, -1)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 5
SWEP.Primary.ClipSize = 200
SWEP.Primary.TakeAmmo = 0
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Sound = {"vj_hlr/gsrc/npc/hassault/hw_shoot1.wav","vj_hlr/gsrc/npc/hassault/hw_shoot2.wav","vj_hlr/gsrc/npc/hassault/hw_shoot3.wav"}
SWEP.Primary.DistantSound = {"vj_hlr/gsrc/npc/hassault/hw_shoot_distant2.wav"}
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false

-- Custom
local validModels = {
	["models/vj_hlr/hl1/hassault.mdl"] = true,
	["models/vj_hlr/hl_hd/hassault.mdl"] = true,
	["models/vj_hlr/hla/hassault.mdl"] = true,
}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	timer.Simple(0.1, function()
		if IsValid(self) && IsValid(self:GetOwner()) && VJ.HLR_Weapon_CheckModel(self, validModels) then
			self.NPC_NextPrimaryFire = false
			if self:GetOwner():GetModel() == "models/vj_hlr/hla/hassault.mdl" then
				self.WorldModel_CustomPositionBone = "unnamed_bone_033"
				self.WorldModel_CustomPositionAngle = Vector(104, 0, 100)
				self.WorldModel_CustomPositionOrigin = Vector(27.5, 0, 3)
			end
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
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash3.vmt")
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
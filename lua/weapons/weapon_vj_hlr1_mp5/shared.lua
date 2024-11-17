SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "MP5"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = false -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_ReloadSound = {"vj_hlr/hl1_weapon/mp5/mp_reload.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_CanBePickedUp = false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
SWEP.NPC_HasSecondaryFire = true -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireEnt = "obj_vj_hlr1_grenade_40mm" -- The entity to fire, this only applies if self:NPC_SecondaryFire() has NOT been overridden!
SWEP.NPC_SecondaryFireSound = {"vj_hlr/hl1_weapon/mp5/glauncher.wav","vj_hlr/hl1_weapon/mp5/glauncher2.wav"} -- The sound it plays when the secondary fire is used
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?
SWEP.ReplacementWeapon = {"weapon_hl1_mp5", "weapon_mp5_hl1"}
SWEP.WorldModel = "models/vj_hlr/weapons/w_9mmar.mdl"
SWEP.HoldType = "smg"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(90, 180, 90)
SWEP.WorldModel_CustomPositionOrigin = Vector(10, -2, -2)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 5 -- Damage
SWEP.Primary.ClipSize = 50 -- Max amount of rounds per clip
SWEP.Primary.Ammo = "SMG1" -- Ammo type
SWEP.Primary.Sound = {"vj_hlr/hl1_weapon/mp5/hks1.wav","vj_hlr/hl1_weapon/mp5/hks2.wav","vj_hlr/hl1_weapon/mp5/hks3.wav"}
SWEP.Primary.DistantSound = {"vj_hlr/hl1_weapon/mp5/hks_distant_new.wav"}
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.PrimaryEffects_MuzzleFlash = false

-- Custom
SWEP.HLR_ValidModels = {
	"models/vj_hlr/opfor/hgrunt.mdl",
	"models/vj_hlr/hl1/hgrunt.mdl",
	"models/vj_hlr/opfor/hgrunt_medic.mdl",
	"models/vj_hlr/opfor/hgrunt_engineer.mdl",
	"models/vj_hlr/hl1/rgrunt.mdl",
	"models/vj_hlr/hl1/rgrunt_black.mdl",
	"models/vj_hlr/opfor/massn.mdl",
	"models/vj_hlr/hl_hd/hassault.mdl",
	"models/vj_hlr/opfor_hd/hgrunt.mdl",
	"models/vj_hlr/opfor_hd/hgrunt_medic.mdl",
	"models/vj_hlr/opfor_hd/hgrunt_engineer.mdl",
	"models/vj_hlr/cracklife/hgrunt.mdl"
}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	timer.Simple(0.1,function() -- Minag mikani modelner tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) && IsValid(self:GetOwner()) then
			if self:GetOwner():GetModel() == "models/vj_hlr/opfor/massn.mdl" then
				self.WorldModel_CustomPositionAngle = Vector(100,180,90)
				self.WorldModel_CustomPositionOrigin = Vector(5.6,-4,-2)
			end
			if !VJ.HasValue(self.HLR_ValidModels,self:GetOwner():GetModel()) then
				if IsValid(self:GetOwner():GetCreator()) then
					self:GetOwner():GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for specific NPCs only!")
				end
				self:Remove()
			else
				self.NPC_NextPrimaryFire = false
			end
		end
	end)
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
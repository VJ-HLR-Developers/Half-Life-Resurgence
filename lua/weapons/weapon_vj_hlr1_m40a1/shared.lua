SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "M-40A1 Sniper Rifle"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_CustomSpread	 		= 0.2 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/sniper/sniper_reload_full.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_ExtraFireSound			= {"vj_hlr/hl1_weapon/sniper/sniper_bolt1.wav"} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_ExtraFireSoundTime		= 0.5 -- How much time until it plays the sound (After Firing)?
SWEP.NPC_CanBePickedUp			= false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/vj_hlr/weapons/w_m40a1.mdl"
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-80, 0, 92.5)
SWEP.WorldModel_CustomPositionOrigin = Vector(-10, 0.5, -0.2)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 30 -- Damage
SWEP.Primary.ClipSize			= 5 -- Max amount of rounds per clip
SWEP.Primary.Ammo				= "SniperRound" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/sniper/sniper_fire.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hl1_weapon/sniper/sniper_fire_distant2.wav"}
SWEP.Primary.TracerType = "VJ_HLR_Tracer"

-- Custom
SWEP.HLR_ValidModels = {"models/vj_hlr/opfor/massn.mdl"}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	timer.Simple(0.1,function() -- Minag mikani modelner tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) && IsValid(self:GetOwner()) then
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
function SWEP:CustomOnDrawWorldModel() -- This is client only!
	if IsValid(self:GetOwner()) then
		self.WorldModel_Invisible = true
		return false
	else
		self.WorldModel_Invisible = false
		return true -- return false to not draw the world model
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	self.PrimaryEffects_MuzzleFlash = false
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
	return true
end
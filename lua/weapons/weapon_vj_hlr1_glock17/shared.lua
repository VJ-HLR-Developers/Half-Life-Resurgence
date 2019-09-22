if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Glock 17"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 0.8 -- Next time it can use primary fire
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/glock/glock_reload.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_CanBePickedUp			= false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/vj_hlr/weapons/w_9mmhandgun.mdl"
SWEP.HoldType 					= "pistol"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = false -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0,180,-90)
SWEP.WorldModel_CustomPositionOrigin = Vector(0,-5.5,-1)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 17 -- Max amount of bullets per clip
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/glock/glock_regular.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hl1_weapon/glock/glock_distant.wav"}
SWEP.PrimaryEffects_ShellType 	= "VJ_Weapon_PistolShell1"

-- Custom
SWEP.HLR_ValidModels = {"models/vj_hlr/hl1/barney.mdl","models/vj_hlr/hla/barney.mdl","models/vj_hlr/opfor/hgrunt.mdl","models/vj_hlr/hl1/hgrunt.mdl","models/vj_hlr/opfor/hgrunt_medic.mdl","models/vj_hlr/opfor/hgrunt_engineer.mdl"}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0.1,function() -- Minag mikani modelner tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) && IsValid(self.Owner) then
			if self.Owner:GetModel() == "models/vj_hlr/hla/barney.mdl" then
				self.WorldModel_CustomPositionBone = "unnamed033"
			end
			if !VJ_HasValue(self.HLR_ValidModels,self.Owner:GetModel()) then
				if IsValid(self.Owner:GetCreator()) then
					self.Owner:GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for specific NPCs only!")
				end
				self:Remove()
			else
				self.NPC_NextPrimaryFire = false
				if self.Owner:GetModel() == "models/vj_hlr/hl1/barney.mdl" or self.Owner:GetModel() == "models/vj_hlr/hla/barney.mdl" then
					self.Primary.Sound = {"vj_hlr/hl1_npc/barney/ba_attack2.wav"}
					self.WorldModel_CustomPositionAngle = Vector(0,192,-90)
					self.WorldModel_CustomPositionOrigin = Vector(-1.5,-7,-1)
				end
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel() -- This is client only!
	if IsValid(self.Owner) then
		self.WorldModel_Invisible = true
		return false
	else
		self.WorldModel_Invisible = false
		return true -- return false to not draw the world model
	end
end
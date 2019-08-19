if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Ivan's Glock 17"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 2.5 -- Next time it can use primary fire
SWEP.NPC_CustomSpread	 		= 2 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/glock/glock_reload.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/vj_hlr/hla/w_docgun.mdl"
SWEP.HoldType 					= "pistol"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
//SWEP.PrimaryEffects_MuzzleParticles = {"vj_hl_muz3"}
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 50 -- Max amount of bullets per clip
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hla_npc/doctor/pl_gun1.wav","vj_hlr/hla_npc/doctor/pl_gun2.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hla_npc/doctor/pl_gun_distant.wav"}
SWEP.PrimaryEffects_ShellType 	= "VJ_Weapon_PistolShell1"

SWEP.WorldModel_Invisible = false -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0,0,0)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1,3.3,-0.7)
SWEP.WorldModel_CustomPositionBone = "unnamed037" -- The bone it will use as the main point

SWEP.HLR_ValidModels = {"models/vj_hlr/hla/doctor.mdl"}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0.1,function() -- Minag Ivan-en model-e tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) && IsValid(self.Owner) then
			local hasmdl = VJ_HasValue(self.HLR_ValidModels,self.Owner:GetModel())
			if !hasmdl then
				if IsValid(self.Owner:GetCreator()) then
					self.Owner:GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for Ivan the Space Biker only!")
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
	if IsValid(self.Owner) then
		self.WorldModel_Invisible = false
		return false
	else
		self.WorldModel_Invisible = false
		return true -- return false to not draw the world model
	end
end
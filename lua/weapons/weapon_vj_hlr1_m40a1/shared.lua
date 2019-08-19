if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "M-40A1 Sniper Rifle"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- Next time it can use primary fire
SWEP.NPC_CustomSpread	 		= 0.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/sniper/sniper_reload_full.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_ExtraFireSound			= {"vj_hlr/hl1_weapon/sniper/sniper_bolt1.wav"} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_ExtraFireSoundTime		= 0.2 -- How much time until it plays the sound (After Firing)?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/vj_hlr/weapons/w_m40a1.mdl"
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
//SWEP.PrimaryEffects_MuzzleParticles = {"vj_hl_muz3"}
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 15 -- Damage
SWEP.Primary.ClipSize			= 5 -- Max amount of bullets per clip
SWEP.Primary.Ammo				= "357" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/sniper/sniper_fire.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hl1_weapon/sniper/sniper_fire_distant.wav"}

SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-80,0,92.5)
SWEP.WorldModel_CustomPositionOrigin = Vector(-10,0.5,-0.2)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0.1,function() -- Minag grunt-en model-e tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) then
			if IsValid(self.Owner) && self.Owner:GetModel() != "models/vj_hlr/opfor/massn.mdl" then
				if IsValid(self.Owner:GetCreator()) then
					self.Owner:GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for the Half Life 1 Human Grunts only!")
				end
				self:Remove()
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
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "M249 SAW"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- Next time it can use primary fire
SWEP.NPC_CustomSpread	 		= 2.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_BulletSpawnAttachment 	= "muzzle_saw" -- The attachment that the bullet spawns on, leave empty for base to decide!
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/saw/saw_reload2.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/vj_hlr/weapons/w_saw.mdl"
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
//SWEP.PrimaryEffects_MuzzleParticles = {"vj_hl_muz3"}
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 50 -- Max amount of bullets per clip
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/saw/saw_fire1.wav","vj_hlr/hl1_weapon/saw/saw_fire2.wav","vj_hlr/hl1_weapon/saw/saw_fire3.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hl1_weapon/saw/saw_distant.wav"}

SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0.1,function() -- Minag grunt-en model-e tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) then
			if IsValid(self.Owner) && self.Owner:GetModel() != "models/vj_hlr/opfor/hgrunt.mdl" && self.Owner:GetModel() != "models/vj_hlr/hl1/hgrunt.mdl" && self.Owner:GetModel() != "models/vj_hlr/opfor/hgrunt_medic.mdl" && self.Owner:GetModel() != "models/vj_hlr/opfor/hgrunt_engineer.mdl" then
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
		return false
	else
		self.WorldModel_Invisible = false
		return true -- return false to not draw the world model
	end
end
 ---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition() -- Bedke asiga enenk vorovhedev attachment-e NPC-in veran e, zenkin vera che
	return self.Owner:GetAttachment(self.Owner:LookupAttachment(self.NPC_BulletSpawnAttachment)).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		ParticleEffectAttach(VJ_PICKRANDOMTABLE(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self.Owner,self.Owner:LookupAttachment(self.NPC_BulletSpawnAttachment))
	end
	return false
end
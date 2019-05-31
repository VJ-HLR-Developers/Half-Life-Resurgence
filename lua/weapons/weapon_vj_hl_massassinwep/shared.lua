if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Male Assassin Weapon"
SWEP.Author 					= "Cpt. Hazama"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- Next time it can use primary fire
SWEP.NPC_ExtraFireSoundTime		= 0.2 -- How much time until it plays the sound (After Firing)?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/vj_hlr/weapons/w_9mmar.mdl"
SWEP.HoldType 					= "smg"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
//SWEP.PrimaryEffects_MuzzleParticles = {"vj_hl_muz3"}
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 50 -- Max amount of bullets per clip
SWEP.Primary.Ammo				= "SMG1" -- Ammo type

-- Custom
SWEP.HGrunt_LastBodyGroup = 999
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetNWInt("VJ_MAssassin_BulletAttachmet","muzzle_mp5")
	timer.Simple(0.1,function() -- Minag grunt-en model-e tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) then
			if IsValid(self.Owner) && self.Owner:GetModel() != "models/vj_hlr/opfor/massn.mdl" then
				if IsValid(self.Owner:GetCreator()) then
					self.Owner:GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for the Half Life 1 Male Assassins only!")
				end
				self:Remove()
			end
		end
	end)
	self.WorldModel_Invisible = true -- Vor chereve
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel() -- This is client only!
	self.WorldModel = self:GetNWInt("VJ_MAssassin_WeaponModel")
	return true -- return false to not draw the world model
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink()
	local bgroup = self.Owner:GetBodygroup(2)
	if self.HGrunt_LastBodyGroup != bgroup then
		self.HGrunt_LastBodyGroup = bgroup
		if bgroup == 0 then -- MP5
			self:SetNWString("VJ_MAssassin_WeaponModel","models/vj_hlr/weapons/w_9mmar.mdl")
			self.WorldModel = self:GetNWInt("VJ_MAssassin_WeaponModel")
			self.HoldType = "smg"
			self:SetDefaultValues(self.HoldType,true)
			self:SetNWInt("VJ_MAssassin_BulletAttachmet","muzzle_mp5")
			self.Primary.Sound = {"vj_hlr/hl1_weapon/mp5/hks1.wav","vj_hlr/hl1_weapon/mp5/hks2.wav","vj_hlr/hl1_weapon/mp5/hks3.wav"}
			self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/mp5/mp_reload.wav"}
			self.NPC_ExtraFireSound = {}
			self.NPC_CustomSpread = 1
			self.Primary.ClipSize = 50
			self.Primary.NumberOfShots = 1
		elseif bgroup == 1 then -- Sniper
			self:SetNWString("VJ_MAssassin_WeaponModel","models/vj_hlr/weapons/w_m40a1.mdl")
			self.WorldModel = self:GetNWInt("VJ_MAssassin_WeaponModel")
			self.HoldType = "crossbow"
			self:SetDefaultValues(self.HoldType,true)
			self:SetNWInt("VJ_MAssassin_BulletAttachmet","muzzle_shotgun")
			self.Primary.Sound = {"vj_hlr/hl1_weapon/sniper/sniper_fire.wav"}
			self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/sniper/sniper_reload_first_seq.wav"}
			self.NPC_ExtraFireSound = {"vj_hlr/hl1_weapon/sniper/sniper_bolt1.wav"}
			self.NPC_CustomSpread = 0.7
			self.Primary.ClipSize = 5
			self.Primary.NumberOfShots = 1
		end
	end
end
 ---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	return self.Owner:GetAttachment(self.Owner:LookupAttachment(self:GetNWInt("VJ_MAssassin_BulletAttachmet"))).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		ParticleEffectAttach(VJ_PICKRANDOMTABLE(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self.Owner,self.Owner:LookupAttachment(self:GetNWInt("VJ_MAssassin_BulletAttachmet")))
	end
	return false
end
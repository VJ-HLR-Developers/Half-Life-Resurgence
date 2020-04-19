if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Human Grunt Weapon"
SWEP.Author 					= "DrVrej"
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
SWEP.Primary.TracerType = "VJ_HLR_Tracer"

-- Custom
SWEP.HGrunt_LastBodyGroup = 999
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
	timer.Simple(0.1,function() -- Minag grunt-en model-e tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) then
			if IsValid(self:GetOwner()) && self:GetOwner():GetModel() != "models/vj_hlr/opfor/hgrunt.mdl" && self:GetOwner():GetModel() != "models/vj_hlr/hl1/hgrunt.mdl" && self:GetOwner():GetModel() != "models/vj_hlr/opfor/hgrunt_medic.mdl" && self:GetOwner():GetModel() != "models/vj_hlr/opfor/hgrunt_engineer.mdl" then
				if IsValid(self:GetOwner():GetCreator()) then
					self:GetOwner():GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for the Half Life 1 Human Grunts only!")
				end
				self:Remove()
			end
		end
	end)
	self.WorldModel_Invisible = true -- Vor chereve
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel() -- This is client only!
	self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
	return true -- return false to not draw the world model
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink()
	local bgroup = self:GetOwner():GetBodygroup(self:GetOwner().HECU_WepBG)
	if self.HGrunt_LastBodyGroup != bgroup then
		self.HGrunt_LastBodyGroup = bgroup
		if self:GetOwner().HECU_Type == 0 then
			if bgroup == 0 then -- MP5
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_9mmar.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.HoldType = "smg"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/mp5/hks1.wav","vj_hlr/hl1_weapon/mp5/hks2.wav","vj_hlr/hl1_weapon/mp5/hks3.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/mp5/hks_distant.wav" }
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/mp5/mp_reload.wav"}
				self.NPC_ExtraFireSound = {}
				self.NPC_CustomSpread = 1
				self.Primary.ClipSize = 50
				self.Primary.NumberOfShots = 1
			elseif bgroup == 1 then -- Shotgun
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_shotgun.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.HoldType = "shotgun"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_shotgun")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/shotgun/sbarrel1.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/shotgun/sbarrel1_distant.wav" }
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/shotgun/shotgun_reload.wav"}
				self.NPC_ExtraFireSound = {"vj_hlr/hl1_weapon/shotgun/scock1.wav"}
				self.NPC_CustomSpread = 2.5
				self.Primary.ClipSize = 8
				self.Primary.NumberOfShots = 5
			end
		elseif self:GetOwner().HECU_Type == 1 then
			if bgroup == 0 then -- MP5
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_9mmar_opfor.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.HoldType = "smg"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/mp5/hks1.wav","vj_hlr/hl1_weapon/mp5/hks2.wav","vj_hlr/hl1_weapon/mp5/hks3.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/mp5/hks_distant.wav" }
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/mp5/mp_reload.wav"}
				self.NPC_ExtraFireSound = {}
				self.NPC_CustomSpread = 1
				self.Primary.ClipSize = 50
				self.Primary.NumberOfShots = 1
			elseif bgroup == 1 then -- Shotgun
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_shotgun.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.HoldType = "shotgun"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_shotgun")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/shotgun/sbarrel1.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/shotgun/sbarrel1_distant.wav" }
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/shotgun/shotgun_reload.wav"}
				self.NPC_ExtraFireSound = {"vj_hlr/hl1_weapon/shotgun/scock1.wav"}
				self.NPC_CustomSpread = 2.5
				self.Primary.ClipSize = 8
				self.Primary.NumberOfShots = 5
			elseif bgroup == 2 then -- SAW
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_saw.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.HoldType = "ar2"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_saw")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/saw/saw_fire1.wav","vj_hlr/hl1_weapon/saw/saw_fire2.wav","vj_hlr/hl1_weapon/saw/saw_fire3.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/saw/saw_distant.wav" }
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/saw/saw_reload2.wav"}
				self.NPC_ExtraFireSound = {}
				self.NPC_CustomSpread = 1
				self.Primary.ClipSize = 50
				self.Primary.NumberOfShots = 1
			end
		elseif self:GetOwner().HECU_Type == 2 then
			if bgroup == 0 then -- Desert Eagle
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_desert_eagle.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.Primary.Damage = 15
				self.HoldType = "pistol"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/deagle/desert_eagle_fire.wav"}
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/deagle/desert_eagle_reload.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/deagle/desert_eagle_fire_distant.wav" }
				self.NPC_CustomSpread = 1
				self.Primary.ClipSize = 7
			elseif bgroup == 1 then -- Glock 17
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_9mmhandgun.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.Primary.Damage = 5
				self.HoldType = "pistol"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/glock/glock_regular.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/glock/glock_distant.wav" }
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/glock/glock_reload.wav"}
				self.NPC_CustomSpread = 2.5
				self.Primary.ClipSize = 17
			end
		elseif self:GetOwner().HECU_Type == 3 then
			if bgroup == 0 then -- Desert Eagle
				self:SetNWString("VJ_HGrunt_WeaponModel","models/vj_hlr/weapons/w_desert_eagle.mdl")
				self.WorldModel = self:GetNWInt("VJ_HGrunt_WeaponModel")
				self.Primary.Damage = 15
				self.HoldType = "pistol"
				self:SetDefaultValues(self.HoldType,true)
				self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
				self.Primary.Sound = {"vj_hlr/hl1_weapon/deagle/desert_eagle_fire.wav"}
				self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/deagle/desert_eagle_reload.wav"}
				self.Primary.DistantSound = { "vj_hlr/hl1_weapon/deagle/desert_eagle_fire_distant.wav" }
				self.NPC_CustomSpread = 1
				self.Primary.ClipSize = 7
			end
		end
	end
end
 ---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	return self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment(self:GetNWInt("VJ_HGrunt_BulletAttachmet"))).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		ParticleEffectAttach(VJ_PICK(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self:GetOwner(),self:GetOwner():LookupAttachment(self:GetNWInt("VJ_HGrunt_BulletAttachmet")))
	end
	return false
end
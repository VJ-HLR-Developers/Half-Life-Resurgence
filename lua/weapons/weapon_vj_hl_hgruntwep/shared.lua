if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Human Grunt Weapon"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- Next time it can use primary fire
SWEP.NPC_ExtraFireSoundTime		= 0.2 -- How much time until it plays the sound (After Firing)?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is tihs weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/props_junk/watermelon01_chunk02c.mdl"
SWEP.HoldType 					= "smg"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0,0)
SWEP.WorldModel_CustomPositionOrigin = Vector(0,5,4)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand" -- The bone it will use as the main point
SWEP.WorldModel_NoShadow = true -- Should the world model have a shadow?
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 50 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.09 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"Weapon_SMG1.Single"}
SWEP.Primary.HasDistantSound	= false -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= {"Weapon_SMG1.NPC_Single"}
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)

-- Custom
SWEP.HGrunt_LastBodyGroup = 999
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
	timer.Simple(0.1,function() -- Minag grunt-en model-e tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) then
			if IsValid(self.Owner) && self.Owner:GetModel() != "models/cpthazama/opfor/hgrunt.mdl" then
				if IsValid(self.Owner:GetCreator()) then
					self.Owner:GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for the Half Life 1 Human Grunts only!")
				end
				self:Remove()
			end
		end
	end)
	self:SetMaterial("models/effects/vol_light001.mdl") -- Vor chereve
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink()
	local bgroup = self.Owner:GetBodygroup(3)
	if self.HGrunt_LastBodyGroup != bgroup then
		self.HGrunt_LastBodyGroup = bgroup
		if bgroup == 0 then -- MP5
			self.HoldType = "smg"
			self:SetDefaultValues(self.HoldType,true)
			self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
			self.Primary.Sound = {"vj_hl1/weapons/hks1.wav","vj_hl1/weapons/hks2.wav","vj_hl1/weapons/hks3.wav"}
			self.NPC_ReloadSound = {"vj_hl1/weapons/mp_reload.wav"}
			self.NPC_ExtraFireSound = {}
			self.NPC_CustomSpread = 1
			self.Primary.ClipSize = 50
			self.Primary.NumberOfShots = 1
		elseif bgroup == 1 then -- Shotgun
			self.HoldType = "shotgun"
			self:SetDefaultValues(self.HoldType,true)
			self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_shotgun")
			self.Primary.Sound = {"vj_hl1/weapons/sbarrel1.wav"}
			self.NPC_ReloadSound = {"vj_hl1/weapons/shotgun_reload.wav"}
			self.NPC_ExtraFireSound = {"vj_hl1/weapons/scock1.wav"}
			self.NPC_CustomSpread = 2.5
			self.Primary.ClipSize = 8
			self.Primary.NumberOfShots = 5
		elseif bgroup == 2 then -- SAW
			self.HoldType = "ar2"
			self:SetDefaultValues(self.HoldType,true)
			self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_saw")
			self.Primary.Sound = {"vj_hl1/weapons/saw_fire1.wav","vj_hl1/weapons/saw_fire2.wav","vj_hl1/weapons/saw_fire3.wav"}
			self.NPC_ReloadSound = {"vj_hl1/weapons/saw_reload2.wav"}
			self.NPC_ExtraFireSound = {}
			self.NPC_CustomSpread = 1
			self.Primary.ClipSize = 50
			self.Primary.NumberOfShots = 1
		end
	end
end
 ---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	return self.Owner:GetAttachment(self.Owner:LookupAttachment(self:GetNWInt("VJ_HGrunt_BulletAttachmet"))).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		ParticleEffectAttach(VJ_PICKRANDOMTABLE(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self.Owner,self.Owner:LookupAttachment(self:GetNWInt("VJ_HGrunt_BulletAttachmet")))
	end
	return false
end
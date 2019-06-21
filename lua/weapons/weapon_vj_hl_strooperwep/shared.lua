if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Shock Weapon"
SWEP.Author 					= "Cpt. Hazama"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
-- SWEP.Category					= "VJ Base"
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
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/props_junk/watermelon01_chunk02c.mdl"
SWEP.HoldType 					= "smg"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0,0)
SWEP.WorldModel_CustomPositionOrigin = Vector(-2,-25,-5)
SWEP.WorldModel_CustomPositionBone = "Bone58" -- The bone it will use as the main point
SWEP.WorldModel_NoShadow = true -- Should the world model have a shadow?
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 10 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.2 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.DisableBulletCode	= true

-- Custom
SWEP.NPC_AnimationTbl_Custom 	= {ACT_RANGE_ATTACK1,ACT_RANGE_ATTACK2}
SWEP.NPC_ReloadAnimationTbl_Custom 	= {ACT_RELOAD}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle_mp5")
	self:SetMaterial("models/effects/vol_light001.mdl")
	self:SetNoDraw(true)
	self.NextIdleSoundT = CurTime() +math.Rand(5,12)
	if IsValid(self.Owner) then
		if self.Owner:GetClass() != "npc_vj_hlrof_shocktrooper" then
			self:Remove()
			return
		end
		self.Owner:SetBodygroup(1,0)
	else
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
if (CLIENT) then return end
	local proj = ents.Create("npc_vj_hlrof_plasma")
	proj:SetPos(self:CustomBulletSpawnPosition())
	proj:SetOwner(self.Owner)
	proj:Activate()
	proj:Spawn()
	
	local phy = proj:GetPhysicsObject()
	if phy:IsValid() then
		local pos = self.Owner:GetPos() +self.Owner:OBBCenter() +self.Owner:GetForward() *700
		if IsValid(self.Owner:GetEnemy()) then
			pos = self.Owner:GetEnemy():GetPos()
		end
		phy:ApplyForceCenter(((pos -self.Owner:GetRight() *20) - self.Owner:GetPos()) *150)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink()
	self.Owner:SetBodygroup(1,0)
	self:SetNWInt("VJ_HGrunt_BulletAttachmet","muzzle")
	self.Primary.Sound = {"vj_hlr/hl1_weapon/shockroach/shock_fire.wav"}
	self.NPC_ReloadSound = {"vj_hlr/hl1_weapon/shockroach/shock_recharge.wav"}
	self.NPC_CustomSpread = 1
	self.Primary.ClipSize = 10
	self.Primary.NumberOfShots = 1
	if CurTime() > self.NextIdleSoundT then
		if IsValid(self.Owner:GetEnemy()) then
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_angry.wav",70,100)
		else
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_idle" .. math.random(1,3) .. ".wav",65,100)
		end
		self.NextIdleSoundT = CurTime() +math.Rand(5,12)
	end
end
 ---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	return self.Owner:GetAttachment(self.Owner:LookupAttachment(self:GetNWInt("VJ_HGrunt_BulletAttachmet"))).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if IsValid(self.Owner) then self.Owner:SetBodygroup(1,1) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		-- ParticleEffectAttach(VJ_PICKRANDOMTABLE(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self.Owner,self.Owner:LookupAttachment(self:GetNWInt("VJ_HGrunt_BulletAttachmet")))
	end
	return false
end
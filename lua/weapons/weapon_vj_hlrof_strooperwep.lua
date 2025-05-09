AddCSLuaFile()

SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Shock Weapon"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false
SWEP.NPC_ReloadSound			= "vj_hlr/gsrc/wep/shockroach/shock_recharge.wav"
SWEP.NPC_CanBePickedUp			= false
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true
SWEP.WorldModel					= "models/props_junk/watermelon01_chunk02c.mdl"
SWEP.HoldType 					= "smg"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(0, 0, 0)
SWEP.WorldModel_CustomPositionOrigin = Vector(20, 3, -2.5)
SWEP.WorldModel_CustomPositionBone = "Bone58"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5
SWEP.Primary.ClipSize			= 30
SWEP.Primary.Ammo				= "SMG1"
SWEP.Primary.Sound				= {"vj_hlr/gsrc/wep/shockroach/shock_fire.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/gsrc/wep/shockroach/shock_fire_distant.wav"}
SWEP.Primary.DisableBulletCode	= true
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_MuzzleFlash = false

SWEP.HasDryFireSound			= false

-- Custom
SWEP.HLR_NextIdleSoundT = 0
local validModels = {
	["models/vj_hlr/opfor/strooper.mdl"] = true,
}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	self:SetDrawWorldModel(false)
	timer.Simple(0.1, function()
		if IsValid(self) && IsValid(self:GetOwner()) && VJ.HLR_Weapon_CheckModel(self, validModels) then
			self.NPC_NextPrimaryFire = false
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Init" then
		if CLIENT then return end
		local owner = self:GetOwner()
		local projectile = ents.Create("obj_vj_hlrof_plasma")
		local spawnPos = self:GetBulletPos()
		projectile:SetPos(spawnPos)
		projectile:SetAngles(owner:GetAngles())
		projectile:SetOwner(owner)
		projectile:Activate()
		projectile:Spawn()
		ParticleEffectAttach("vj_hlr_shockroach_muzzle", PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment("muzzle"))
		local phys = projectile:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos + Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(-15, 15)), 1, 10000))
			projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnGetBulletPos()
	-- Return a position to override the bullet spawn position
	return self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("muzzle")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnThink()
	local owner = self:GetOwner()
	owner:SetBodygroup(1, 0)
	
	-- Play shock roach idle sounds
	if CurTime() > self.HLR_NextIdleSoundT then
		if IsValid(owner:GetEnemy()) then
			self:EmitSound("vj_hlr/gsrc/npc/shockroach/shock_angry.wav", 70)
		else
			self:EmitSound("vj_hlr/gsrc/npc/shockroach/shock_idle" .. math.random(1, 3) .. ".wav", 65)
		end
		self.HLR_NextIdleSoundT = CurTime() + math.Rand(5, 12)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if IsValid(self:GetOwner()) then self:GetOwner():SetBodygroup(1, 1) end
end
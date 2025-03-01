SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Shock Weapon"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/shockroach/shock_recharge.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_CanBePickedUp			= false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/props_junk/watermelon01_chunk02c.mdl"
SWEP.HoldType 					= "smg"
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0, 0, 0)
SWEP.WorldModel_CustomPositionOrigin = Vector(20, 3, -2.5)
SWEP.WorldModel_CustomPositionBone = "Bone58" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 30 -- Max amount of rounds per clip
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/shockroach/shock_fire.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hl1_weapon/shockroach/shock_fire_distant.wav"}
SWEP.Primary.DisableBulletCode	= true
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_MuzzleFlash = false

SWEP.HasDryFireSound			= false -- Should it play a sound when it's out of ammo?

-- Custom
SWEP.HLR_NextIdleSoundT = 0
local validModels = {
	["models/vj_hlr/opfor/strooper.mdl"] = true,
}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
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
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_angry.wav", 70)
		else
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_idle" .. math.random(1, 3) .. ".wav", 65)
		end
		self.HLR_NextIdleSoundT = CurTime() + math.Rand(5, 12)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if IsValid(self:GetOwner()) then self:GetOwner():SetBodygroup(1, 1) end
end
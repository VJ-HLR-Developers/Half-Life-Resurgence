SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Charge Bow"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Spawnable = true
SWEP.Category = "Half-Life Resurgence"
SWEP.ViewModel = "models/vj_hlr/hl2/weapons/c_chargebow.mdl"
SWEP.WorldModel = "models/vj_hlr/hl2/weapons/w_chargebow.mdl"
SWEP.HoldType = "crossbow"
SWEP.Slot = 3 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 3 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.SwayScale = 1 -- Default is 1, The scale of the viewmodel sway
SWEP.UseHands = true

SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 3 -- RPM of the weapon in seconds | Calculation: 60 / RPM
SWEP.NPC_TimeUntilFire = 0.4 -- How much time until the bullet/projectile is fired?
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
SWEP.NPC_FiringDistanceScale = 0.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_ReloadSound = "weapons/physcannon/physcannon_pickup.wav" -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_BulletSpawnAttachment = "muzzle" -- The attachment that the bullet spawns on, leave empty for base to decide!
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize = 1 -- Max amount of rounds per clip
SWEP.Primary.Delay = 1.25 -- Time until it can shoot again
SWEP.Primary.Ammo = "XBowBolt" -- Ammo type
SWEP.Primary.Automatic = true
SWEP.Primary.Sound = {"vj_hlr/hl2_weapon/chargebow/chargebow_1.wav", "vj_hlr/hl2_weapon/chargebow/chargebow_2.wav", "vj_hlr/hl2_weapon/chargebow/chargebow_3.wav"}
SWEP.Primary.DistantSound = {}
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
SWEP.Primary.DisableBulletCode = true
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = "weapons/physcannon/physcannon_pickup.wav" // npc/assassin/ball_zap1.wav
SWEP.Reload_TimeUntilAmmoIsSet = 1

-- Custom
SWEP.Bow_NumShots = 1
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:PreDrawViewModel(vm, weapon, ply)
	vm:SetBodygroup(1, 1) -- Because bodygroup texture is broken
end
---------------------------------------------------------------------------------------------------------------------------------------------
local posAngPly = Vector(0, -60, 180)
local posOrgPly = Vector(0, -2, 1.5)
local posAngNPC = Vector(-100, 30, 180)
local posOrgNPC = Vector(-3, -3, -12)
--
function SWEP:OnDrawWorldModel() -- This is client only!
	local owner = self:GetOwner()
	if IsValid(owner) then
		if owner:IsPlayer() then
			self.WorldModel_CustomPositionAngle = posAngPly
			self.WorldModel_CustomPositionOrigin = posOrgPly
			self.WorldModel_CustomPositionBone = "ValveBiped.Bip01_L_Hand"
		else
			self.WorldModel_CustomPositionAngle = posAngNPC
			self.WorldModel_CustomPositionOrigin = posOrgNPC
			self.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand"
		end
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnReload(status)
	if status == "Start" then
		self.Bow_NumShots = 1
		VJ.CreateSound(self, "buttons/button19.wav")
		self.AnimTbl_Idle = ACT_VM_IDLE
		self.AnimTbl_Draw = ACT_VM_DRAW
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	self.Bow_NumShots = 3
	self:PrimaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Initial" then
		local owner = self:GetOwner()
		if owner:IsPlayer() then
			self.AnimTbl_Idle = ACT_VM_FIDGET
			self.AnimTbl_Draw = ACT_VM_DRAW_EMPTY
		end
		if CLIENT then return end
	
		-- Projectile
		for i = 1, self.Bow_NumShots do
			local projectile = ents.Create("obj_vj_hlr2_chargebolt")
			local spawnPos = self:GetBulletPos()
			if owner:IsPlayer() then
				local plyAng = owner:GetAimVector():Angle()
				projectile:SetPos(owner:GetShootPos() + plyAng:Forward()*-33 + plyAng:Up()*-5 + plyAng:Right())
				projectile:SetAngles(plyAng)
			else
				projectile:SetPos(spawnPos)
				projectile:SetAngles(owner:GetAngles())
			end
			projectile:SetOwner(owner)
			projectile:Activate()
			projectile:Spawn()
			projectile.DirectDamage = projectile.DirectDamage / self.Bow_NumShots -- Decrease the damage per bolt depending on the number of bolts being fired
	
			local phys = projectile:GetPhysicsObject()
			if phys:IsValid() then
				if owner:IsPlayer() then
					phys:SetVelocity(owner:GetAimVector() * 3000 + Vector(i == 2 && -75 or i == 3 && 75 or 0, 0, 0))
				else
					phys:SetVelocity(VJ.CalculateTrajectory(owner, owner:GetEnemy(), "Line", spawnPos + Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(-15, 15)), 1, 3000))
				end
				projectile:SetAngles(projectile:GetVelocity():GetNormal():Angle())
			end
		end
	end
end
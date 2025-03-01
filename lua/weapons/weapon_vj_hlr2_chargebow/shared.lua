SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Charge Bow"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Spawnable = true
SWEP.Category = "Half-Life Resurgence"
SWEP.ViewModel = "models/vj_hlr/hl2/weapons/c_chargebow.mdl"
SWEP.WorldModel = "models/vj_hlr/hl2/weapons/w_chargebow.mdl"
SWEP.HoldType = "crossbow"
SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.SwayScale = 1
SWEP.UseHands = true

SWEP.WorldModel_UseCustomPosition = true
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 3
SWEP.NPC_TimeUntilFire = 0.4
SWEP.NPC_StandingOnly = true
SWEP.NPC_FiringDistanceScale = 0.5
SWEP.NPC_ReloadSound = "weapons/physcannon/physcannon_pickup.wav"
SWEP.NPC_BulletSpawnAttachment = "muzzle"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 1.25
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Automatic = true
SWEP.Primary.Sound = {"vj_hlr/hl2_weapon/chargebow/chargebow_1.wav", "vj_hlr/hl2_weapon/chargebow/chargebow_2.wav", "vj_hlr/hl2_weapon/chargebow/chargebow_3.wav"}
SWEP.Primary.DistantSound = {}
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
SWEP.Primary.DisableBulletCode = true
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true
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
	if status == "Init" then
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
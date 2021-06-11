if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Charge Bow"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
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
SWEP.NPC_NextPrimaryFire = 3 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0.4 -- How much time until the bullet/projectile is fired?
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
SWEP.NPC_FiringDistanceScale = 0.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_ReloadSound = {"weapons/physcannon/physcannon_pickup.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_BulletSpawnAttachment = "muzzle" -- The attachment that the bullet spawns on, leave empty for base to decide!
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize = 1 -- Max amount of bullets per clip
SWEP.Primary.Delay = 1.25 -- Time until it can shoot again
SWEP.Primary.Ammo = "XBowBolt" -- Ammo type
SWEP.Primary.Automatic = true
SWEP.Primary.Sound = {"vj_hlr/hl2_weapon/chargebow/chargebow_1.wav","vj_hlr/hl2_weapon/chargebow/chargebow_2.wav","vj_hlr/hl2_weapon/chargebow/chargebow_3.wav"}
SWEP.Primary.DistantSound = {}
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
SWEP.Primary.DisableBulletCode = true
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy = 0.4 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound = "weapons/physcannon/physcannon_pickup.wav" // npc/assassin/ball_zap1.wav
SWEP.Reload_TimeUntilAmmoIsSet = 1 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished = 1.25 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation = true -- Does it have a idle animation?
SWEP.AnimTbl_Idle = {ACT_VM_IDLE}
SWEP.NextIdle_Deploy = 1.55 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack = 1 -- How much time until it plays the idle animation after attacking(Primary)
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
function SWEP:CustomOnDrawWorldModel() -- This is client only!
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
function SWEP:CustomOnReload()
	VJ_CreateSound(self, "buttons/button19.wav")
	self.AnimTbl_Idle = {ACT_VM_IDLE}
	self.AnimTbl_Draw = {ACT_VM_DRAW}
	self.NextIdle_Deploy = 1.55
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	local owner = self:GetOwner()
	if owner:IsPlayer() then
		self.AnimTbl_Idle = {ACT_VM_FIDGET}
		self.AnimTbl_Draw = {ACT_VM_DRAW_EMPTY}
		self.NextIdle_Deploy = 1
		self.Reloading = true
		timer.Simple(0.9, function() if IsValid(self) then self.Reloading = false self:DoIdleAnimation() end end)
	end
	if CLIENT then return end

	-- Projectile
	local proj = ents.Create("obj_vj_hlr2_chargebolt")
	if owner:IsPlayer() then
		local ply_Ang = owner:GetAimVector():Angle()
		proj:SetPos(owner:GetShootPos() + ply_Ang:Forward()*-33 + ply_Ang:Up()*-5 + ply_Ang:Right()*1)
		proj:SetAngles(ply_Ang)
	else
		proj:SetPos(self:GetNW2Vector("VJ_CurBulletPos"))
		proj:SetAngles(owner:GetAngles())
	end
	proj:SetOwner(owner)
	proj:Activate()
	proj:Spawn()
	
	local phys = proj:GetPhysicsObject()
	if phys:IsValid() then
		if owner:IsPlayer() then
			phys:SetVelocity(owner:GetAimVector() * 3000)
		else
			phys:SetVelocity(owner:CalculateProjectile("Line", self:GetNW2Vector("VJ_CurBulletPos"), owner:GetEnemy():GetPos() + owner:GetEnemy():OBBCenter(), 3000))
		end
	end
end
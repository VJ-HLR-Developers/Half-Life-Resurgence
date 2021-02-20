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
-- SWEP.WorldModel_CustomPositionAngle = Vector(0,-60,180)
-- SWEP.WorldModel_CustomPositionOrigin = Vector(0,-2,1.5)
-- SWEP.WorldModel_CustomPositionBone = "ValveBiped.Bip01_L_Hand"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 3 -- Next time it can use primary fire
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 0 -- Damage
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
SWEP.ReloadSound = "weapons/pistol/pistol_reload1.wav"
SWEP.Reload_TimeUntilAmmoIsSet = 1 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished = 1.25 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation = true -- Does it have a idle animation?
SWEP.AnimTbl_Idle = {ACT_VM_IDLE}
SWEP.NextIdle_Deploy = 1.55 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack = 1 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0,function()
		if IsValid(self:GetOwner()) then
			if self:GetOwner():IsPlayer() then
				if IsValid(self:GetOwner():GetViewModel()) then
					self:GetOwner():GetViewModel():SetBodygroup(1,1)
				end
				self.WorldModel_CustomPositionAngle = Vector(0,-60,180)
				self.WorldModel_CustomPositionOrigin = Vector(0,-2,1.5)
				self.WorldModel_CustomPositionBone = "ValveBiped.Bip01_L_Hand"
			else
				self.WorldModel_CustomPositionAngle = Vector(-100,30,180)
				self.WorldModel_CustomPositionOrigin = Vector(-3,-3,-12)
				self.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand"
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel() -- This is client only!
	if IsValid(self:GetOwner()) then
		if self:GetOwner():IsPlayer() then
			self.WorldModel_CustomPositionAngle = Vector(0,-60,180)
			self.WorldModel_CustomPositionOrigin = Vector(0,-2,1.5)
			self.WorldModel_CustomPositionBone = "ValveBiped.Bip01_L_Hand"
		else
			self.WorldModel_CustomPositionAngle = Vector(-100,30,180)
			self.WorldModel_CustomPositionOrigin = Vector(-3,-3,-12)
			self.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand"
		end
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload()
	VJ_CreateSound(self,"buttons/button19.wav")
	self.AnimTbl_Idle = {ACT_VM_IDLE}
	self.AnimTbl_Draw = {ACT_VM_DRAW}
	self.NextIdle_Deploy = 1.55
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	self.AnimTbl_Idle = {ACT_VM_FIDGET}
	self.AnimTbl_Draw = {ACT_VM_DRAW_EMPTY}
	self.NextIdle_Deploy = 1
	self.Reloading = true
	timer.Simple(0.9,function() if IsValid(self) then self.Reloading = false self:DoIdleAnimation() end end)

	if CLIENT then return end

	local proj = ents.Create("obj_vj_hlr2_chargebolt")
	local OwnerPos = self:GetOwner():GetShootPos()
	local OwnerAng = self:GetOwner():GetAimVector():Angle()
	OwnerPos = OwnerPos + OwnerAng:Forward()*-33 + OwnerAng:Up()*-5 + OwnerAng:Right()*1
	if self:GetOwner():IsPlayer() then proj:SetPos(OwnerPos) else proj:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos) end
	if self:GetOwner():IsPlayer() then proj:SetAngles(OwnerAng) else proj:SetAngles(self:GetOwner():GetAngles()) end
	proj:SetOwner(self:GetOwner())
	proj:Activate()
	proj:Spawn()
	
	local phy = proj:GetPhysicsObject()
	if phy:IsValid() then
		if self:GetOwner():IsPlayer() then
		phy:ApplyForceCenter(self:GetOwner():GetAimVector() * 10000) else //200000
		phy:ApplyForceCenter((self:GetOwner():GetEnemy():GetPos() - self:GetOwner():GetPos()) * 10000)
		end
	end
end
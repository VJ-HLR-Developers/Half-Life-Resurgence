AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Combine Sniper"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Category = "Half-Life Resurgence"
SWEP.HoldType = "ar2"
SWEP.ViewModel = "models/vj_hlr/hl2/weapons/c_combinesniper.mdl"
SWEP.WorldModel = "models/vj_hlr/hl2/weapons/w_combinesniper.mdl"
SWEP.UseHands = true
SWEP.ViewModelFOV = 70
SWEP.Spawnable = true
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = false
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 0, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1, 0, 0.5)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General NPC Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 1.75
SWEP.NPC_TimeUntilFire = 0.5
SWEP.NPC_CustomSpread = 0.5
SWEP.NPC_StandingOnly = true
SWEP.NPC_FiringDistanceScale = 2.5
	-- ====== Reload Variables ====== --
SWEP.NPC_ReloadSound = "vj_hlr/src/wep/sniper_comb/sniper_reload.wav"
	-- ====== Extra Firing Sound Variables ====== --
SWEP.NPC_ExtraFireSound = "vj_hlr/src/wep/sniper_comb/sniper_reload.wav"
SWEP.NPC_ExtraFireSoundTime = 0.4
SWEP.NPC_ExtraFireSoundLevel = 70 -- How far does the sound go?
SWEP.NPC_ExtraFireSoundPitch = VJ.SET(90, 100)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Primary Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 95
SWEP.Primary.Force = 1.6
SWEP.Primary.ClipSize = 5
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.TracerType = "AR2Tracer"
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 1
SWEP.Primary.Sound = "vj_hlr/src/wep/sniper_comb/sniper_fire.wav"
SWEP.Primary.DistantSound = "vj_hlr/src/wep/sniper_comb/sniper_fire_dist.wav"
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Dry Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Examples: Under water, out of ammo
SWEP.DryFireSound = "vj_hlr/src/wep/sniper_comb/sniper_empty.wav"
SWEP.DryFireSoundPitch = VJ.SET(100, 100)
-- Player Stuff ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ReloadSound = "vj_hlr/src/wep/sniper_comb/sniper_reload.wav"
SWEP.AnimTbl_PrimaryFire = ACT_VM_SECONDARYATTACK
SWEP.AnimTbl_Reload = ACT_VM_DRAW

local vec_def = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", "Zoomed")
	self:NetworkVar("Float", "ZoomLevel")
	baseclass.Get("weapon_vj_base").SetupDataTables(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Zoom()
	local calcLevel = self:GetZoomLevel() + 1 -- Calculate the new level
	local newLevel = (calcLevel > 3 and 0) or calcLevel -- The new level
	self:SetZoomLevel(newLevel)
	self:GetOwner():SetFOV((newLevel == 1) && 40 or (newLevel == 2) && 25 or (newLevel == 3) && 10 or 40, 0.5) -- Set the new FOV
	self:EmitSound("buttons/combine_button7.wav", 65, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "PostFire" && self:GetOwner():IsPlayer() then
		timer.Simple(0.5, function()
			if IsValid(self) then
				self:EmitSound("vj_hlr/src/wep/sniper_comb/sniper_reload.wav", 70, 100)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	self:Zoom()
	self:SetNextSecondaryFire(CurTime() + 0.2)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnThink()
	local owner = self:GetOwner()
	if IsValid(owner) then
		if owner:IsNPC() then
			if IsValid(owner:GetEnemy()) && self:Visible(owner:GetEnemy()) then -- Return the enemy center position
				self:SetNW2Vector("OwnerEnemyPos", self.Owner:GetEnemy():GetPos() + self.Owner:GetEnemy():OBBCenter())
			else -- Make the vector default position, used to determine whether or not to lock onto the enemy (the laser)
				self:SetNW2Vector("OwnerEnemyPos", vec_def)
			end
		elseif owner:IsPlayer() then
			if self:GetZoomLevel() == 0 then -- If level is 0, reset it to the default FOV
				owner:SetFOV(GetConVar("fov_desired"):GetInt() or 90, 0.1)
			end
			self:SetZoomed(self:GetZoomLevel() > 0) -- > 0 means it's zoomed
			self.Primary.Cone = (self:GetZoomed() and 1) or 10
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	-- Make the gun move to the center when aiming
	local aimPos = Vector(-9, 0, -32)
	local aimAng = Angle(0, 0, 0)
	---------------------------------------------------------------------------------------------------------------------------------------------
	function SWEP:GetViewModelPosition(pos, ang)
		if !self:GetZoomed() then return pos, ang end

		ang:RotateAroundAxis(ang:Right(), aimAng.x)
		ang:RotateAroundAxis(ang:Up(), aimAng.y)
		ang:RotateAroundAxis(ang:Forward(), aimAng.z)

		pos = pos + aimPos.x * ang:Right()
		pos = pos + aimPos.y * ang:Up()
		pos = pos + aimPos.z * ang:Forward()
		
		return pos, ang
	end

	local matLaser = Material("sprites/rollermine_shock")
	local matSprite = Material("particle/particle_glow_02")
	local laserColor = Color(0, 161, 255, 255)
	---------------------------------------------------------------------------------------------------------------------------------------------
	function SWEP:PostDrawViewModel(vm, wep, ply)
		local owner = wep:GetOwner()
		-- Player only
		local attach = vm:GetAttachment(vm:LookupAttachment("laser"))
		render.SetMaterial(matLaser)
		render.DrawBeam(attach.Pos, owner:GetEyeTrace().HitPos, 5, 0, 5, laserColor)
		render.SetMaterial(matSprite)
		render.DrawSprite(attach.Pos, 3, 3, laserColor)
		render.SetMaterial(matSprite)
		render.DrawSprite(owner:GetEyeTrace().HitPos, math.random(4, 6), math.random(4, 6), laserColor)
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function SWEP:OnDrawWorldModel()
		local owner = self:GetOwner()
		if IsValid(owner) then
			local attach = self:GetAttachment(self:LookupAttachment("laser"))
			local attachPos = attach.Pos
			local attachAng = attach.Ang
			local endPos = attachPos + attachAng:Forward()*10000 + attachAng:Up()*180 + attachAng:Right()*700
			local strictPointer = (!owner:IsNPC() and 1) or GetConVar("vj_hlr2_csniper_laser_usebarrel"):GetInt()
			if strictPointer == 1 or vec_def == self:GetNW2Vector("OwnerEnemyPos") then -- Face straight from the attachment
				endPos = attachPos + attachAng:Forward()*10000 + attachAng:Up()*180 + attachAng:Right()*700
			else -- Face towards the enemy
				endPos = self:GetNW2Vector("OwnerEnemyPos")
			end
			local tr = util.TraceLine({
				start = attachPos,
				endpos = endPos,
				filter = self,
			})
			render.SetMaterial(matLaser)
			render.DrawBeam(attachPos, tr.HitPos, 5, 0, 5, laserColor)
			render.SetMaterial(matSprite)
			render.DrawSprite(attachPos, 3, 3, laserColor)
			if tr.Hit == true then
				render.SetMaterial(matSprite)
				render.DrawSprite(tr.HitPos, math.random(4, 6), math.random(4, 6), laserColor)
			end
		end
		return true
	end
end
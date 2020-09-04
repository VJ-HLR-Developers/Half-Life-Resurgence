if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Combine Sniper"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "Half-Life Resurgence"
SWEP.HoldType = "ar2"
SWEP.ViewModel = "models/vj_hlr/hl2/weapons/c_combinesniper.mdl"
SWEP.WorldModel = "models/vj_hlr/hl2/weapons/w_combinesniper.mdl"
SWEP.UseHands = true
SWEP.ViewModelFOV = 70
SWEP.Spawnable = true
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = false -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 0, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1, 0, 0.5)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General NPC Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 1.75 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0.5 -- How much time until the bullet/projectile is fired?
SWEP.NPC_CustomSpread = 0.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
SWEP.NPC_FiringDistanceScale = 2.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
	-- ====== Reload Variables ====== --
SWEP.NPC_ReloadSound = {"vj_hlr/hl2_weapon/combinesniper/sniper_reload.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
	-- ====== Extra Firing Sound Variables ====== --
SWEP.NPC_ExtraFireSound = {"vj_hlr/hl2_weapon/combinesniper/sniper_reload.wav"} -- Plays an extra sound after it fires (Example: Bolt action sound)
SWEP.NPC_ExtraFireSoundTime = 0.4 -- How much time until it plays the sound (After Firing)?
SWEP.NPC_ExtraFireSoundLevel = 70 -- How far does the sound go?
SWEP.NPC_ExtraFireSoundPitch = VJ_Set(90,100) -- How much time until the secondary fire can be used again?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Primary Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage = 95 -- Damage
SWEP.Primary.Force = 3 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize = 5 -- Max amount of bullets per clip
SWEP.Primary.Ammo = "SniperRound" -- Ammo type
SWEP.Primary.TracerType = "AR2Tracer"
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 1
SWEP.Primary.Sound = {"vj_hlr/hl2_weapon/combinesniper/sniper_fire.wav"}
SWEP.Primary.DistantSound = {"vj_hlr/hl2_weapon/combinesniper/sniper_fire_dist.wav"}
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Dry Fire Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Examples: Under water, out of ammo
SWEP.DryFireSound = {"vj_hlr/hl2_weapon/combinesniper/sniper_empty.wav"} -- The sound that it plays when the weapon is out of ammo
SWEP.DryFireSoundPitch1 = 100 -- Dry fire sound pitch 1
-- Player Stuff ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ReloadSound = "vj_hlr/hl2_weapon/combinesniper/sniper_reload.wav"
SWEP.AnimTbl_PrimaryFire = {ACT_VM_SECONDARYATTACK}
SWEP.AnimTbl_Reload = {ACT_VM_DRAW}
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Zoomed")
	self:NetworkVar("Float", 0, "ZoomLevel")
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
function SWEP:CustomOnPrimaryAttack_AfterShoot()
	if self:GetOwner():IsPlayer() then
		timer.Simple(0.5, function()
			if IsValid(self) then
				self:EmitSound("vj_hlr/hl2_weapon/combinesniper/sniper_reload.wav", 70, 100)
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
local vec_def = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	if IsValid(self:GetOwner()) then
		if self:GetOwner():IsNPC() then
			if IsValid(self:GetOwner():GetEnemy()) && self:Visible(self:GetOwner():GetEnemy()) then -- Return the enemy center position
				self:SetNWVector("OwnerEnemyPos", self.Owner:GetEnemy():GetPos() + self.Owner:GetEnemy():OBBCenter())
			else -- Make the vector default position, used to determine whether or not to lock onto the enemy (the laser)
				self:SetNWVector("OwnerEnemyPos", vec_def)
			end
		elseif self:GetOwner():IsPlayer() then
			if self:GetZoomLevel() == 0 then -- If level is 0, reset it to the default FOV
				self:GetOwner():SetFOV(GetConVarNumber("fov_desired"), 0.1)
			end
			self:SetZoomed(self:GetZoomLevel() > 0) -- > 0 means it's zoomed
			self.Primary.Cone = (self:GetZoomed() and 1) or 10
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	-- Make the gun move to the center when aiming
	local aimPos = Vector(-9, 0, -32)
	local aimAng = Angle(0, 0, 0)
	---------------------------------------------------------------------------------------------------------------------------------------------
	function SWEP:GetViewModelPosition(pos, ang)
		if !self:GetZoomed() then return pos,ang end

		ang:RotateAroundAxis(ang:Right(),aimAng.x)
		ang:RotateAroundAxis(ang:Up(),aimAng.y)
		ang:RotateAroundAxis(ang:Forward(),aimAng.z)

		pos = pos +aimPos.x *ang:Right()
		pos = pos +aimPos.y *ang:Up()
		pos = pos +aimPos.z *ang:Forward()
		
		return pos, ang
	end

	local matLaser = Material("sprites/rollermine_shock")
	local matSprite = Material("particle/particle_glow_02")
	---------------------------------------------------------------------------------------------------------------------------------------------
	function SWEP:PostDrawViewModel(vm, wep, ply)
		-- Player only
		local attach = vm:GetAttachment(vm:LookupAttachment("laser"))
		render.SetMaterial(matLaser)
		render.DrawBeam(attach.Pos, wep:GetOwner():GetEyeTrace().HitPos, 5, 0, 5, Color(0,161,255,255))
		render.SetMaterial(matSprite)
		render.DrawSprite(attach.Pos, 3, 3, Color(0,161,255,255))
		render.SetMaterial(matSprite)
		render.DrawSprite(wep:GetOwner():GetEyeTrace().HitPos, math.random(4,6), math.random(4,6), Color(0,161,255,255))
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function SWEP:CustomOnDrawWorldModel()
		if IsValid(self:GetOwner()) then
			local attach = self:GetAttachment(self:LookupAttachment("laser"))
			local attachPos = attach.Pos
			local attachAng = attach.Ang
			local endPos = attachPos + attachAng:Forward()*10000 + attachAng:Up()*180 + attachAng:Right()*700
			local strictPointer = (!self:GetOwner():IsNPC() and 1) or GetConVarNumber("vj_hlr2_csniper_strict")
			if strictPointer == 1 or vec_def == self:GetNWVector("OwnerEnemyPos") then -- Face straight from the attachment
				endPos = attachPos + attachAng:Forward()*10000 + attachAng:Up()*180 + attachAng:Right()*700
			else -- Face towards the enemy
				endPos = self:GetNWVector("OwnerEnemyPos")
			end
			local tr = util.TraceLine({
				start = attachPos,
				endpos = endPos,
				filter = self,
			})
			render.SetMaterial(matLaser)
			render.DrawBeam(attachPos, tr.HitPos, 5, 0, 5, Color(0,161,255,255))
			render.SetMaterial(matSprite)
			render.DrawSprite(attachPos, 3, 3, Color(0,161,255,255))
			if tr.Hit == true then
				render.SetMaterial(matSprite)
				render.DrawSprite(tr.HitPos, math.random(4,6), math.random(4,6), Color(0,161,255,255))
			end
		end
		return true
	end
end
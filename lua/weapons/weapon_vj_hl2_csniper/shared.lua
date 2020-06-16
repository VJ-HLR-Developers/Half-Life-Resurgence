if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
local name = "Combine Sniper"
local dmg = 95
local clip = 5
local fire = {"vj_hlr/hl2_weapon/combinesniper/sniper_fire.wav"}
local firedist = {"vj_hlr/hl2_weapon/combinesniper/sniper_fire_dist.wav"}
local extrafire = {"vj_hlr/hl2_weapon/combinesniper/sniper_reload.wav"}
local reload = {}
local firetimes = {}
local nextpossiblefire = 1.75
local muzzle = "muzzle"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.NPC_FiringDistanceScale = 2.5
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= name
SWEP.Author 					= "Cpt. Hazama"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
SWEP.Spawnable = true
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
-- SWEP.MadeForNPCsOnly 			= true -- Is tihs weapon meant to be for NPCs only?
SWEP.ViewModel					= "models/vj_hlr/hl2/weapons/c_combinesniper.mdl"
SWEP.WorldModel					= "models/vj_hlr/hl2/weapons/w_combinesniper.mdl"
SWEP.HoldType 					= "ar2"
SWEP.UseHands 					= true
SWEP.ViewModelFOV 				= 70
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= nextpossiblefire -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.01 -- How much time until the bullet/projectile is fired?
SWEP.NPC_TimeUntilFireExtraTimers = firetimes -- Extra timers, which will make the gun fire again! | The seconds are counted after the self.NPC_TimeUntilFire!
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = false -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-10,0,180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1,0,0.5)
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= dmg -- Damage
SWEP.NPC_CustomSpread	 		= 0
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= clip -- Max amount of bullets per clip
SWEP.Primary.Ammo				= "SniperRound" -- Ammo type
SWEP.Primary.TracerType			= "AR2Tracer"
SWEP.Primary.Sound				= fire
SWEP.Primary.DistantSound		= firedist
SWEP.PrimaryEffects_MuzzleAttachment = muzzle
SWEP.NPC_ExtraFireSound			= extrafire
SWEP.NPC_ReloadSound			= reload
SWEP.ReloadSound			= "vj_hlr/hl2_weapon/combinesniper/sniper_reload.wav"
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.AnimTbl_PrimaryFire = {ACT_VM_SECONDARYATTACK}
SWEP.AnimTbl_Reload = {ACT_VM_DRAW}
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 1

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Zoomed")
	self:NetworkVar("Float",0,"ZoomLevel")
end

function SWEP:Zoom()
	self:SetZoomLevel(self:GetZoomLevel() +1)
	if self:GetZoomLevel() > 3 then
		self:SetZoomLevel(0)
	end
	local level = self:GetZoomLevel()
	local set = level == 1 && 40 or level == 2 && 25 or level == 3 && 10 or 40
	self:GetOwner():SetFOV(set,0.2)
	self:EmitSound("buttons/combine_button7.wav",65,100)
end

function SWEP:CustomOnPrimaryAttack_AfterShoot()
	if self:GetOwner():IsPlayer() then
		timer.Simple(0.5,function()
			if IsValid(self) then
				self:EmitSound("vj_hlr/hl2_weapon/combinesniper/sniper_reload.wav",70,100)
			end
		end)
	end
end

function SWEP:SecondaryAttack()
	self:Zoom()
	self:SetNextSecondaryFire(CurTime() +0.5)
	return true
end

function SWEP:CustomOnThink()
	if IsValid(self:GetOwner()) then
		if self:GetOwner():IsNPC() then self.Owner:SetNWEntity("enemy",self.Owner:GetEnemy()) end
		if self:GetOwner():IsPlayer() then
			if self:GetZoomLevel() == 0 then
				self:GetOwner():SetFOV(70,0)
			end
			self:SetZoomed(self:GetZoomLevel() > 0)
			self.Primary.Cone = self:GetZoomed() && 1 or 10
		end
	end
end

if (CLIENT) then
	local aimPos = Vector(-9,0,-32)
	local aimAng = Angle(0,0,0)
	function SWEP:GetViewModelPosition(pos,ang)
		if !self:GetZoomed() then return pos,ang end

		ang:RotateAroundAxis(ang:Right(),aimAng.x)
		ang:RotateAroundAxis(ang:Up(),aimAng.y)
		ang:RotateAroundAxis(ang:Forward(),aimAng.z)

		pos = pos +aimPos.x *ang:Right()
		pos = pos +aimPos.y *ang:Up()
		pos = pos +aimPos.z *ang:Forward()

		return pos, ang
	end

	local LaserMaterial = Material("sprites/rollermine_shock")
	local SpriteMaterial = Material("particle/particle_glow_02")
	local useEnt = true

	function SWEP:PostDrawViewModel(vm,wep,ply)
		local attach = vm:GetAttachment(vm:LookupAttachment("laser"))

		render.SetMaterial(LaserMaterial)
		render.DrawBeam(attach.Pos,wep:GetOwner():GetEyeTrace().HitPos,5,0,5,Color(0,161,255,255))
		render.SetMaterial(SpriteMaterial)
		render.DrawSprite(attach.Pos,3,3,Color(0,161,255,255))

		render.SetMaterial(SpriteMaterial)
		render.DrawSprite(wep:GetOwner():GetEyeTrace().HitPos,math.random(4,6),math.random(4,6),Color(0,161,255,255))
	end

	function SWEP:CustomOnDrawWorldModel()
		if IsValid(self:GetOwner()) then
			local var = GetConVarNumber("vj_hlr2_csniper")
			local attach = self:GetAttachment(self:LookupAttachment("laser"))
			local ud,lr = -180, 700
			local endPos = attach.Pos +attach.Ang:Forward() *10000 +attach.Ang:Up() *ud +attach.Ang:Right() *lr
			local ent = self:GetOwner():IsNPC() && self:GetOwner():GetNWEntity("enemy")
			if !self:GetOwner():IsNPC() then var = 1 end
			if var == 1 then
				endPos = attach.Pos +attach.Ang:Forward() *10000 +attach.Ang:Up() *ud +attach.Ang:Right() *lr
			else
				if IsValid(ent) then
					endPos = ent:GetPos() +ent:OBBCenter()
				end
			end
			local tr = util.TraceLine({
				start = attach.Pos,
				endpos = endPos,
				filter = self,
			})
			render.SetMaterial(LaserMaterial)
			render.DrawBeam(attach.Pos,tr.HitPos,5,0,5,Color(0,161,255,255))
			render.SetMaterial(SpriteMaterial)
			render.DrawSprite(attach.Pos,3,3,Color(0,161,255,255))
			if tr.Hit == true then
				render.SetMaterial(SpriteMaterial)
				render.DrawSprite(tr.HitPos,math.random(4,6),math.random(4,6),Color(0,161,255,255))
			end
		end
		return true
	end
end
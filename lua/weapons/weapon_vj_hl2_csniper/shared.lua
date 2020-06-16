if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
local name = "Combine Sniper"
local mdl = "models/vj_hlr/hl2/weapons/w_combinesniper.mdl"
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
-- SWEP.Category					= "VJ Base"
SWEP.Spawnable = false
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is tihs weapon meant to be for NPCs only?
SWEP.WorldModel					= mdl
SWEP.HoldType 					= "ar2"
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
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}

function SWEP:CustomOnThink()
	self.Owner:SetNWEntity("enemy",self.Owner:GetEnemy())
end

if (CLIENT) then
	local LaserMaterial = Material("sprites/rollermine_shock")
	local SpriteMaterial = Material("particle/particle_glow_02")
	local useEnt = true
	function SWEP:CustomOnDrawWorldModel()
		if self:GetOwner():IsValid() then
			local var = GetConVarNumber("vj_hlr2_csniper")
			attach = self:GetAttachment(self:LookupAttachment("laser"))
			local ud,lr = -180, 700
			local endPos = attach.Pos +attach.Ang:Forward() *10000 +attach.Ang:Up() *ud +attach.Ang:Right() *lr
			local ent = self:GetOwner():GetNWEntity("enemy")
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
			render.DrawBeam(attach.Pos,tr.HitPos, 5, 0, 5, Color(0,161,255,255))
			render.SetMaterial(SpriteMaterial)
			render.DrawSprite(attach.Pos,3,3,Color(0,161,255,255))
			if tr.Hit == true then
				render.SetMaterial(SpriteMaterial)
				render.DrawSprite(tr.HitPos,5,5,Color(0,161,255,255))
			end
		end
		return true
	end
end
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Combine Reager"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."

	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/vj_hlr/hl2/weapons/combine_reager.mdl"
SWEP.HoldType = "ar2"
SWEP.MadeForNPCsOnly = true

	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.1 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0 -- How much time until the bullet/projectile is fired?
SWEP.NPC_FiringDistanceScale = 0.15 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_ReloadSound = {"weapons/physgun_off.wav"}
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize = 200 -- Max amount of bullets per clip
SWEP.Primary.Ammo = "CrossbowBolt" -- Ammo type
SWEP.Primary.Sound = {}
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 0, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1, 15, 0.5)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	-- Initialize the firing loop sounds that will be used later
	self.NextStopFireLoop = CurTime()
	self.FireLoop1 = CreateSound(self, "ambient/levels/citadel/zapper_loop2.wav")
	self.FireLoop1:SetSoundLevel(80)
	self.FireLoop2 = CreateSound(self, "ambient/levels/citadel/zapper_ambient_loop1.wav")
	self.FireLoop2:SetSoundLevel(70)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	-- Stop the firing loop sound if we are no longer firing!
	if CurTime() > self.NextStopFireLoop then
		VJ_STOPSOUND(self.FireLoop1)
		if self.FireLoop2:IsPlaying() then self.FireLoop2:Stop() VJ_EmitSound(self, "ambient/levels/citadel/weapon_disintegrate1.wav", 75, 100) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnHolster(newWep)
	VJ_STOPSOUND(self.FireLoop1)
	VJ_STOPSOUND(self.FireLoop2)
	return true
end -- Return false to disallow the weapon from switching
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if CLIENT then return end
	local ene = self.Owner:GetEnemy()
	if !IsValid(ene) then return end
	
	-- Play the firing sound
	self.NextStopFireLoop = CurTime() + 0.2
	self.FireLoop1:Play()
	self.FireLoop2:Play()
	
	-- Create electrical particle and deal radius shock damage
	local randPos = (ene:GetPos() + ene:OBBCenter()) + Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-10, 10))
	util.ParticleTracerEx("electrical_arc_01", self:GetAttachment(1).Pos, randPos, false, self:EntIndex(), 1)
	util.VJ_SphereDamage(self.Owner, self.Owner, randPos, 20, math.random(2,5), DMG_SHOCK, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	VJ_STOPSOUND(self.FireLoop1)
	VJ_STOPSOUND(self.FireLoop2)
end
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Combine Reager"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel = "models/vj_hlr/hl2/weapons/combine_reager.mdl"
SWEP.HoldType = "ar2"
SWEP.MadeForNPCsOnly = true
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 0.1
SWEP.NPC_FiringDistanceScale = 0.15
SWEP.NPC_ReloadSound = "weapons/physgun_off.wav"
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize = 200
SWEP.Primary.Ammo = "CrossbowBolt"
SWEP.Primary.Sound = {}
SWEP.Primary.DisableBulletCode	= true
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 0, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1, 15, 0.5)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	-- Initialize the firing loop sounds that will be used later
	self.NextStopFireLoop = CurTime()
	self.FireLoop1 = CreateSound(self, "ambient/levels/citadel/zapper_loop2.wav")
	self.FireLoop1:SetSoundLevel(80)
	self.FireLoop2 = CreateSound(self, "ambient/levels/citadel/zapper_ambient_loop1.wav")
	self.FireLoop2:SetSoundLevel(70)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnThink()
	-- Stop the firing loop sound if we are no longer firing!
	if CurTime() > self.NextStopFireLoop then
		VJ.STOPSOUND(self.FireLoop1)
		if self.FireLoop2:IsPlaying() then self.FireLoop2:Stop() VJ.EmitSound(self, "ambient/levels/citadel/weapon_disintegrate1.wav", 75, 100) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OwnerChanged()
	VJ.STOPSOUND(self.FireLoop1)
	VJ.STOPSOUND(self.FireLoop2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Init" then
		if CLIENT then return end
		local ene = self.Owner:GetEnemy()
		if !IsValid(ene) then return end
		
		-- Play the firing sound
		self.NextStopFireLoop = CurTime() + 0.2
		self.FireLoop1:Play()
		self.FireLoop2:Play()
		
		-- Create electrical particle and deal radius shock damage
		local targetPos = ene:GetPos() + ene:OBBCenter()
		if targetPos:Distance(self:GetAttachment(1).Pos) > 300 then
			local dir = (targetPos - self:GetAttachment(1).Pos):GetNormalized()
			targetPos = self:GetAttachment(1).Pos + dir * 300
		end
		local randPos = targetPos + Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-10, 10))
		util.ParticleTracerEx("electrical_arc_01", self:GetAttachment(1).Pos, randPos, false, self:EntIndex(), 1)
		VJ.ApplyRadiusDamage(self.Owner, self.Owner, randPos, 20, math.random(2, 5), DMG_SHOCK, true, true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	VJ.STOPSOUND(self.FireLoop1)
	VJ.STOPSOUND(self.FireLoop2)
end
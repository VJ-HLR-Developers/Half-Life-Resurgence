if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Shock Weapon"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- Next time it can use primary fire
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/shockroach/shock_recharge.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_CanBePickedUp			= false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is this weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/props_junk/watermelon01_chunk02c.mdl"
SWEP.HoldType 					= "smg"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_Invisible = true -- Should the world model be invisible?
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(0,0,0)
SWEP.WorldModel_CustomPositionOrigin = Vector(20,3,-2.5)
SWEP.WorldModel_CustomPositionBone = "Bone58" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 5 -- Damage
SWEP.Primary.ClipSize			= 30 -- Max amount of bullets per clip
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/shockroach/shock_fire.wav"}
SWEP.Primary.DisableBulletCode	= true
SWEP.PrimaryEffects_SpawnShells = false

SWEP.HasDryFireSound			= false -- Should it play a sound when it's out of ammo?

-- Custom
SWEP.HLR_ValidModels = {"models/vj_hlr/opfor/strooper.mdl"}
SWEP.HLR_NextIdleSoundT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0.1,function() -- Minag mikani modelner tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) && IsValid(self:GetOwner()) then
			if !VJ_HasValue(self.HLR_ValidModels,self:GetOwner():GetModel()) then
				if IsValid(self:GetOwner():GetCreator()) then
					self:GetOwner():GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for specific NPCs only!")
				end
				self:Remove()
			else
				self.NPC_NextPrimaryFire = false
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if (CLIENT) then return end
	
	local plasma = ents.Create("obj_vj_hlrof_plasma")
	plasma:SetPos(self:GetNWVector("VJ_CurBulletPos"))
	plasma:SetAngles(self:GetOwner():GetAngles())
	plasma:SetOwner(self:GetOwner())
	plasma:Spawn()
	plasma:Activate()
	
	local phys = plasma:GetPhysicsObject()
	if IsValid(phys) then
		local pos = self:GetOwner():GetPos() + self:GetOwner():OBBCenter() + self:GetOwner():GetForward() * 700
		if IsValid(self:GetOwner():GetEnemy()) then
			pos = self:GetOwner():GetEnemy():GetPos()
		end
		phys:SetVelocity(self:GetOwner():CalculateProjectile("Line", self:GetNWVector("VJ_CurBulletPos"), pos, 10000))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	-- Return a position to override the bullet spawn position
	return self:GetOwner():GetAttachment(self:GetOwner():LookupAttachment("muzzle")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink()
	self:GetOwner():SetBodygroup(1,0)
	
	if CurTime() > self.HLR_NextIdleSoundT then
		if IsValid(self:GetOwner():GetEnemy()) then
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_angry.wav", 70)
		else
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_idle" .. math.random(1,3) .. ".wav", 65)
		end
		self.HLR_NextIdleSoundT = CurTime() +math.Rand(5,12)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		ParticleEffect("vj_hl_shockroach", self:GetNWVector("VJ_CurBulletPos"), self:GetNWVector("VJ_CurBulletPos"):Angle(), self:GetOwner())
		timer.Simple(0.05, function() if IsValid(self) && IsValid(self:GetOwner()) then self:GetOwner():StopParticles() end end)
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if IsValid(self:GetOwner()) then self:GetOwner():SetBodygroup(1,1) end
end
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Shock Weapon"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
-- SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= false -- Next time it can use primary fire
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/shockroach/shock_recharge.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
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
SWEP.Primary.ClipSize			= 10 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.2 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/shockroach/shock_fire.wav"}
SWEP.Primary.DisableBulletCode	= true
SWEP.PrimaryEffects_SpawnShells = false

-- Custom
SWEP.HLR_ValidModels = {"models/vj_hlr/opfor/strooper.mdl"}
SWEP.HLR_NextIdleSoundT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0.1,function() -- Minag mikani modelner tske, yete ooresh model-e, serpe as zenke
		if IsValid(self) && IsValid(self.Owner) then
			if !VJ_HasValue(self.HLR_ValidModels,self.Owner:GetModel()) then
				if IsValid(self.Owner:GetCreator()) then
					self.Owner:GetCreator():PrintMessage(HUD_PRINTTALK,self.PrintName.." removed! It's made for specific NPCs only!")
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
	plasma:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone(self.WorldModel_CustomPositionBone)))
	plasma:SetAngles(self.Owner:GetAngles())
	plasma:SetOwner(self.Owner)
	plasma:Activate()
	plasma:Spawn()

	//phy:SetVelocity(self.Owner:CalculateProjectile("Line", self.Owner:GetPos(), self.Owner:GetEnemy():GetPos(), 10000))
	local phy = plasma:GetPhysicsObject()
	if phy:IsValid() then
		local pos = self.Owner:GetPos() +self.Owner:OBBCenter() +self.Owner:GetForward() *700
		if IsValid(self.Owner:GetEnemy()) then
			pos = self.Owner:GetEnemy():GetPos()
		end
		phy:ApplyForceCenter(((pos -self.Owner:GetRight() *20) - self.Owner:GetPos()) *150)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	-- Return a position to override the bullet spawn position
	return self.Owner:GetAttachment(self.Owner:LookupAttachment("muzzle")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink()
	self.Owner:SetBodygroup(1,0)
	
	if CurTime() > self.HLR_NextIdleSoundT then
		if IsValid(self.Owner:GetEnemy()) then
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_angry.wav",70,100)
		else
			self:EmitSound("vj_hlr/hl1_npc/shockroach/shock_idle" .. math.random(1,3) .. ".wav",65,100)
		end
		self.HLR_NextIdleSoundT = CurTime() +math.Rand(5,12)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if IsValid(self.Owner) then self.Owner:SetBodygroup(1,1) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		-- ParticleEffectAttach(VJ_PICKRANDOMTABLE(self.PrimaryEffects_MuzzleParticles),PATTACH_POINT_FOLLOW,self.Owner,self.Owner:LookupAttachment(self:GetNWInt("VJ_HGrunt_BulletAttachmet")))
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnDrawWorldModel() -- This is client only!
	if IsValid(self.Owner) then
		self.WorldModel_Invisible = true
		return false
	else
		self.WorldModel_Invisible = false
		return true -- return false to not draw the world model
	end
end
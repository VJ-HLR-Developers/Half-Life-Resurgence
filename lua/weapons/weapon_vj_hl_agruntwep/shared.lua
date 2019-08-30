if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Hornet Gun"
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
SWEP.NPC_ReloadSound			= {} -- Sounds it plays when the base detects the SNPC playing a reload animation
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
SWEP.WorldModel_CustomPositionOrigin = Vector(13,55,55)
-- SWEP.WorldModel_CustomPositionOrigin = Vector(0,5,30)
SWEP.WorldModel_CustomPositionBone = "Bone39" -- The bone it will use as the main point
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 8 -- Damage
SWEP.Primary.ClipSize			= 30 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.2 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= {"vj_hlr/hl1_npc/agrunt/ag_fire1.wav","vj_hlr/hl1_npc/agrunt/ag_fire2.wav","vj_hlr/hl1_npc/agrunt/ag_fire3.wav"}
SWEP.Primary.DisableBulletCode	= true
SWEP.PrimaryEffects_SpawnShells = false

-- Custom
SWEP.HLR_ValidModels = {"models/vj_hlr/hl1/agrunt.mdl"}
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
	local plasma = ents.Create("obj_vj_hlr1_hornet")
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
	return self.Owner:GetAttachment(self.Owner:LookupAttachment("hornet")).Pos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnNPC_ServerThink()
	self.Owner:SetBodygroup(1,0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if IsValid(self.Owner) then self.Owner:SetBodygroup(1,1) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	if self.PrimaryEffects_MuzzleFlash == true && GetConVarNumber("vj_wep_nomuszzleflash") == 0 then
		-- ParticleEffectAttach("vj_hl_spit_spore_spawn",PATTACH_POINT_FOLLOW,self.Owner,self.Owner:LookupAttachment("hornet"))
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
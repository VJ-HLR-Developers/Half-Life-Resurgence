SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Resistance RPG"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "Half-Life Resurgence"
SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 60 -- Player FOV for the view model
SWEP.Spawnable = true
SWEP.Slot = 4 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands = true
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire = 5 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire = 0.8 -- How much time until the bullet/projectile is fired?
SWEP.NPC_ReloadSound = {"vj_weapons/reload_rpg.wav"}
SWEP.NPC_BulletSpawnAttachment = "missile" -- The attachment that the bullet spawns on, leave empty for base to decide!
SWEP.NPC_FiringDistanceScale = 2.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize = 1 -- Max amount of bullets per clip
SWEP.Primary.Recoil = 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay = 0.3 -- Time until it can shoot again
SWEP.Primary.Ammo = "RPG_Round" -- Ammo type
SWEP.Primary.Sound = {"weapons/rpg/rocketfire1.wav"}
SWEP.Primary.DistantSound = {"vj_weapons/rpg/rpg_fire_far.wav"}
SWEP.Primary.DisableBulletCode = true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_SpawnShells = false
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound = true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.Reload_TimeUntilAmmoIsSet = 0.8 -- Time until ammo is set to the weapon
SWEP.ReloadSound = "vj_weapons/reload_rpg.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "NWLaser")
	self:NetworkVar("Entity", 0, "NWEnemy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetNWLaser(true)
	self.RPG_LastShotEnt = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	-- If the owner is an NPC then set the rocket to follow its enemy
	if IsValid(self:GetOwner()) && self:GetOwner():IsNPC() then
		//self:SetNWEnemy(IsValid(self:GetOwner():GetEnemy()) && self:GetOwner():GetEnemy() or NULL)
		self:SetNWEnemy(self:GetOwner():GetEnemy())
		self:SetNWLaser(true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if CLIENT then return end
	if IsValid(self.RPG_LastShotEnt) then return true end -- Wait until the last shot has detonated
	
	-- Create the rocket entity
	local owner = self:GetOwner()
	local proj = ents.Create("obj_vj_hlr2_rocket")
	if owner:IsPlayer() then
		local plyAng = owner:GetAimVector():Angle()
		proj:SetPos(owner:GetShootPos() + plyAng:Forward()*-20 + plyAng:Up()*-9 + plyAng:Right()*10)
		proj:SetAngles(plyAng)
	else
		proj:SetPos(self:GetNW2Vector("VJ_CurBulletPos"))
		proj:SetAngles((owner:IsNPC() && IsValid(owner:GetEnemy()) && (owner:GetEnemy():GetPos() - self:GetNW2Vector("VJ_CurBulletPos")):Angle()) or owner:GetAngles())
	end
	proj:SetOwner(owner)
	proj:Activate()
	proj:Spawn()
	proj.Rocket_Follow = self:GetNWLaser()
	self.RPG_LastShotEnt = proj
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	-- Smoke back effects
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	timer.Simple(4, function() if IsValid(self) then self:StopParticles() end end)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	-- Toggle whether to laser track or not (Only for players)
	VJ.EmitSound(self, (self:GetNWLaser() and "buttons/button16.wav") or "buttons/button17.wav")
	self:SetNWLaser(!self:GetNWLaser())
	
	local owner = self:GetOwner()
	if IsValid(owner) && owner:IsPlayer() then
		owner:PrintMessage(HUD_PRINTTALK, "Laser tracking has been "..(self:GetNWLaser() == true and "enabled" or "disabled"))
	end
	if IsValid(self.RPG_LastShotEnt) then
		self.RPG_LastShotEnt.Rocket_Follow = self:GetNWLaser()
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	local SpriteMaterial = Material("sprites/redglow1")
	function SWEP:PostDrawViewModel(vm, wep, ply)
		if self:GetNWLaser() then
			render.SetMaterial(SpriteMaterial)
			render.DrawSprite(wep:GetOwner():GetEyeTrace().HitPos, math.random(4,6), math.random(4,6), Color(255,0,0,255))
		end
	end

	function SWEP:CustomOnDrawWorldModel()
		local owner = self:GetOwner()
		if IsValid(owner) then
			local pos = self:GetPos()
			local useNWLaser = owner:IsPlayer() and self:GetNWLaser() or owner:IsNPC() and true
			if owner:IsPlayer() then
				pos = owner:GetEyeTrace().HitPos
			else
				local ent = self:GetNWEnemy()
				local tr = util.TraceLine({
					start = self:GetAttachment(1).Pos,
					endpos = self:GetAttachment(1).Pos + self:GetAttachment(1).Ang:Forward()*32000,
					filter = {self, owner},
				})
				pos = (tr.Hit and tr.HitPos) or (IsValid(ent) && ent:GetPos() + ent:OBBCenter() or self:GetAttachment(1).Pos + self:GetAttachment(1).Ang:Forward()*32000)
			end
			local size = (owner:IsPlayer() && 5) or 15
			if useNWLaser then
				render.SetMaterial(SpriteMaterial)
				render.DrawSprite(pos, math.random(size - 1, size + 1), math.random(size - 1, size + 1), Color(255,0,0,255))
			end
		end
		return true
	end
end
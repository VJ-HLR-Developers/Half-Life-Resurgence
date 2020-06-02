if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "RPG-8"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 4 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_FiringDistanceScale = 2.5
SWEP.NPC_NextPrimaryFire 		= 5 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.8 -- How much time until the bullet/projectile is fired?
SWEP.NPC_ReloadSound			= {"vj_weapons/reload_rpg.wav"}
SWEP.NPC_BulletSpawnAttachment = "missile" -- The attachment that the bullet spawns on, leave empty for base to decide!
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/c_rpg.mdl" // "models/weapons/c_rpg.mdl"
SWEP.WorldModel					= "models/weapons/w_rocket_launcher.mdl" // "models/weapons/w_rocket_launcher.mdl"
SWEP.HoldType 					= "rpg"
SWEP.ViewModelFOV				= 60 -- Player FOV for the view model
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.3 -- Time until it can shoot again
SWEP.Primary.Ammo				= "RPG_Round" -- Ammo type
SWEP.Primary.Sound				= {"weapons/rpg/rocketfire1.wav"}
SWEP.Primary.DistantSound		= {"vj_weapons/rpg/rpg_fire_far.wav"}
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 1 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.Reload_TimeUntilAmmoIsSet	= 0.8 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 1.8 -- How much time until the player can play idle animation, shoot, etc.
SWEP.ReloadSound				= "vj_weapons/reload_rpg.wav"
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Laser")
	self:NetworkVar("Entity",0,"NWEnemy")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetLaser(true)
	self.LastShot = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	if IsValid(self:GetOwner()) && self:GetOwner():IsNPC() then
		self:SetNWEnemy(IsValid(self:GetOwner():GetEnemy()) && self:GetOwner():GetEnemy() or NULL)
		self:SetLaser(true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	local SpriteMaterial = Material("sprites/redglow1")
	function SWEP:PostDrawViewModel(vm,wep,ply)
		if self:GetLaser() then
			render.SetMaterial(SpriteMaterial)
			render.DrawSprite(wep:GetOwner():GetEyeTrace().HitPos,math.random(4,6),math.random(4,6),Color(255,0,0,255))
		end
	end

	function SWEP:CustomOnDrawWorldModel()
		if IsValid(self:GetOwner()) then
			local endPos = self:GetPos()
			local useLaser = self:GetOwner():IsPlayer() && self:GetLaser() or self:GetOwner():IsNPC() && true
			local ent = self:GetNWEnemy()
			if self:GetOwner():IsPlayer() then
				endPos = self:GetOwner():GetEyeTrace().HitPos
			else
				if IsValid(ent) then
					local tr = util.TraceLine({
						start = self:GetAttachment(1).Pos,
						endpos = ent:GetPos() +ent:OBBCenter(),
						filter = {self,self:GetOwner()},
					})
					endPos = tr.Hit && tr.HitPos or ent:GetPos() +ent:OBBCenter()
				end
			end
			local size = self:GetOwner():IsPlayer() && 5 or 10
			if useLaser then
				render.SetMaterial(SpriteMaterial)
				render.DrawSprite(endPos,math.random(size -1,size +1),math.random(size -1,size +1),Color(255,0,0,255))
			end
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SecondaryAttack()
	VJ_EmitSound(self,self:GetLaser() && "buttons/button16.wav" or "buttons/button17.wav")
	self:SetLaser(!self:GetLaser())
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Reload()
	if !IsValid(self) or !IsValid(self:GetOwner()) or !self:GetOwner():Alive() or !self:GetOwner():IsPlayer() or self:GetOwner():GetAmmoCount(self.Primary.Ammo) == 0 or !self:GetOwner():KeyDown(IN_RELOAD) or self.Reloading == true then return end
	if IsValid(self.LastShot) then return end
	local smallerthanthis = self.Primary.ClipSize - 1
	if self:Clip1() <= smallerthanthis then
		local setcorrectnum = self.Primary.ClipSize - self:Clip1()
		local test = setcorrectnum + self:Clip1()
		self.Reloading = true
		self:CustomOnReload()
		if self.HasReloadSound == true then self:GetOwner():EmitSound(VJ_PICK(self.ReloadSound),50,math.random(90,100)) end
		if self:GetOwner():IsPlayer() then
			self:SendWeaponAnim(VJ_PICK(self.AnimTbl_Reload)) //self:SendWeaponAnim(VJ_PICK(self.AnimTbl_Reload))
			self:GetOwner():SetAnimation(PLAYER_RELOAD)
			timer.Simple(self.Reload_TimeUntilAmmoIsSet,function() if IsValid(self) then self:GetOwner():RemoveAmmo(setcorrectnum,self.Primary.Ammo) self:SetClip1(test) end end)
			timer.Simple(self.Reload_TimeUntilFinished,function() if IsValid(self) then self.Reloading = false self:DoIdleAnimation() end end)
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if (CLIENT) then return end
	local proj = ents.Create("obj_vj_hl2_rocket")
	local ply_Ang = self:GetOwner():GetAimVector():Angle()
	local ply_Pos = self:GetOwner():GetShootPos() + ply_Ang:Forward()*-20 + ply_Ang:Right()*10
	if self:GetOwner():IsPlayer() then proj:SetPos(ply_Pos) else proj:SetPos(self:GetNWVector("VJ_CurBulletPos")) end
	if self:GetOwner():IsPlayer() then proj:SetAngles(ply_Ang) else proj:SetAngles(self:GetOwner():GetAngles()) end
	proj:SetOwner(self:GetOwner())
	proj:Activate()
	proj:Spawn()
	self.LastShot = proj
	if self:GetLaser() then
		proj:SetTarget(self:GetOwner():IsPlayer() && self:GetOwner():GetEyeTrace().HitPos or self:GetOwner():IsNPC() && self:GetNWEnemy())
	end
end
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Hive Gun"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.MadeForNPCsOnly = true

SWEP.WorldModel = "models/vj_hlr/weapons/w_hgun.mdl"
SWEP.HoldType = "physgun"
SWEP.NPC_HasReloadSound = false

SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(0, 180, 0)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1, -6, -3)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand"

SWEP.NPC_NextPrimaryFire = 0.165
SWEP.NPC_FiringDistanceScale = 0.5
SWEP.NPC_BulletSpawnAttachment = "muzzle"

SWEP.Primary.Damage = 1
SWEP.Primary.ClipSize = 8
SWEP.Primary.DisableBulletCode = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.Sound = {"vj_hlr/hl1_npc/agrunt/ag_fire1.wav","vj_hlr/hl1_npc/agrunt/ag_fire2.wav","vj_hlr/hl1_npc/agrunt/ag_fire3.wav"}

SWEP.PrimaryEffects_SpawnMuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetModelScale(0.5)
	self.NextReloadT = CurTime()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomBulletSpawnPosition()
	local owner = self:GetOwner()
	local att = owner:GetAttachment(2)

	return att.Pos +att.Ang:Forward() *20
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	self.PrimaryEffects_MuzzleFlash = false
	muz = ents.Create("env_sprite")
	muz:SetKeyValue("model","vj_hl/sprites/muz4.vmt")
	muz:SetKeyValue("scale",""..math.Rand(0.3,0.5))
	muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt","255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags","0")
	muz:SetPos(self:CustomBulletSpawnPosition())
	-- muz:SetParent(self)
	-- muz:Fire("SetParentAttachment",self.PrimaryEffects_MuzzleAttachment)
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",0.08)

	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_Reload()
	self:SetClip1(self.LastClip)
	local owner = self:GetOwner()
	owner:SetWeaponState()
	owner.NextChaseTime = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	if SERVER then
		local owner = self:GetOwner()
		self.LastClip = self:Clip1()
		if CurTime() > self.NextReloadT && self:Clip1() < self:GetMaxClip1() then
			self:SetClip1(self:Clip1() +1)
			self.NextReloadT = CurTime() +1
			owner:SetWeaponState(VJ_WEP_STATE_RELOADING)
		elseif self:Clip1() >= self:GetMaxClip1() then
			owner:SetWeaponState()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if CLIENT then return end
	local bolt = ents.Create("obj_vj_hlr1_hornet")
	local spawnpos = self:GetNW2Vector("VJ_CurBulletPos")
	bolt:SetPos(spawnpos)
	bolt:SetAngles(self:GetOwner():GetAngles())
	bolt:SetOwner(self:GetOwner())
	bolt:Activate()
	bolt:Spawn()

	self.NextReloadT = CurTime() +1
	
	local phys = bolt:GetPhysicsObject()
	if IsValid(phys) then
		bolt.Track_Enemy = self:GetOwner():GetEnemy()
		phys:ApplyForceCenter(bolt:CalculateProjectile("Line", spawnpos, self:GetOwner():GetEnemy():GetPos() + self:GetOwner():GetEnemy():OBBCenter(), 4000) + Vector(math.Rand(-30,30), math.Rand(-30,30), math.Rand(-30,30)))
	end
end
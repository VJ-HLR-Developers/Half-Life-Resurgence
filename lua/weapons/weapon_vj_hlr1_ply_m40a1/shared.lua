if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "M40A1"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.MadeForNPCsOnly = true

SWEP.WorldModel = "models/vj_hlr/weapons/w_m40a1.mdl"
SWEP.HoldType = "smg"
SWEP.HLR_HoldType = "sniper"

SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(-90, 0, 90)
SWEP.WorldModel_CustomPositionOrigin = Vector(-13, 2, -2)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand"

SWEP.NPC_CustomSpread	 		= 0.2
SWEP.NPC_ReloadSound			= {"vj_hlr/hl1_weapon/sniper/sniper_reload_full.wav"}
SWEP.NPC_ExtraFireSound			= {"vj_hlr/hl1_weapon/sniper/sniper_bolt1.wav"}
SWEP.NPC_ExtraFireSoundTime		= 0.5

SWEP.NPC_NextPrimaryFire = 1.25
SWEP.NPC_BulletSpawnAttachment = "muzzle"
SWEP.NPC_FiringDistanceScale = 2.5

SWEP.Primary.Damage = 30
SWEP.Primary.ClipSize = 5
SWEP.Primary.Ammo = "357"
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.Primary.Sound				= {"vj_hlr/hl1_weapon/sniper/sniper_fire.wav"}
SWEP.Primary.DistantSound		= {"vj_hlr/hl1_weapon/sniper/sniper_fire_distant.wav"}

SWEP.PrimaryEffects_MuzzleAttachment = "0"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	-- self:SetModelScale(0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	self.PrimaryEffects_MuzzleFlash = false
	muz = ents.Create("env_sprite")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash1.vmt")
	muz:SetKeyValue("scale",""..math.Rand(0.3,0.5))
	muz:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt","255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags","0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment",self.PrimaryEffects_MuzzleAttachment)
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",0.08)
	return true
end
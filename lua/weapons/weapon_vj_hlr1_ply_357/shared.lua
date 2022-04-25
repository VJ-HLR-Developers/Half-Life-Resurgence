if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = ".357 Magnum"
SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.MadeForNPCsOnly = true

SWEP.WorldModel = "models/vj_hlr/weapons/w_357.mdl"
SWEP.HoldType = "revolver"

SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(0, 180, -90)
SWEP.WorldModel_CustomPositionOrigin = Vector(3, -7.5, -0.5)
SWEP.WorldModel_CustomPositionBone = "Bip01 R Hand"

SWEP.NPC_NextPrimaryFire = 0.8
SWEP.NPC_BulletSpawnAttachment = "0"

SWEP.Primary.Damage = 40
SWEP.Primary.ClipSize = 6
SWEP.Primary.Ammo = "357"
SWEP.Primary.TracerType = "VJ_HLR_Tracer"
SWEP.Primary.Sound = {"vj_hlr/hl1_weapon/357/357_shot1.wav","vj_hlr/hl1_weapon/357/357_shot2.wav"}
SWEP.Primary.DistantSound = {"vj_hlr/hl1_weapon/357/357_shot_distant.wav"}
SWEP.NPC_ReloadSound = {"vj_hlr/hl1_weapon/357/357_reload1.wav"}

SWEP.PrimaryEffects_MuzzleAttachment = "0"
SWEP.PrimaryEffects_ShellAttachment = "1"
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_PistolShell1"
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self:SetModelScale(0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	self.PrimaryEffects_MuzzleFlash = false
	muz = ents.Create("env_sprite")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash2.vmt")
	muz:SetKeyValue("scale",""..math.Rand(0.5,0.75))
	muz:SetKeyValue("GlowProxySize","2.0")
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3")
	muz:SetKeyValue("renderamt","255")
	muz:SetKeyValue("disablereceiveshadows","0")
	muz:SetKeyValue("framerate","10.0")
	muz:SetKeyValue("spawnflags","0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment",self.PrimaryEffects_MuzzleAttachment)
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",0.08)

	return true
end
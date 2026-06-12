AddCSLuaFile()

SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "Combine Reager"
SWEP.Category = "Half-Life Resurgence"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Instructions = "The Reager is standard issue for Combine expeditionary forces, primarily used to dig through solid materials or remove debris. Within its primary chamber, a crystal is superheated to extreme temperatures and focused into a powerful beam of energy."
SWEP.Spawnable = true
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.ViewModel = "models/vj_hlr/hl2/weapons/c_combine_reager.mdl"
SWEP.WorldModel = "models/vj_hlr/hl2/weapons/combine_reager.mdl"
SWEP.HoldType = "ar2"
-- SWEP.MadeForNPCsOnly = true

SWEP.NPC_NextPrimaryFire = 0.06
SWEP.NPC_FiringDistanceScale = 0.15
SWEP.NPC_ReloadSound = "vj_hlr/src/wep/reager/reager_reload.wav"

SWEP.Primary.ClipSize = 200
SWEP.Primary.Delay = 0.07
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.DisableBulletCode	= true
SWEP.PrimaryEffects_MuzzleParticles = "vj_rifle_full_blue"
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(134, 217, 255)

SWEP.HasReloadSound = true
SWEP.ReloadSound = "vj_hlr/src/wep/reager/reager_reload.wav"

SWEP.WorldModel_UseCustomPosition = true
SWEP.WorldModel_CustomPositionAngle = Vector(-10, 0, 180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1, 15, 0.5)
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
    if EmissiveSys then
        EmissiveSys:Add("models/hl_resurgence/hl2/weapons/reager",{
            Brightness=1,
            Mask="models/hl_resurgence/hl2/weapons/reager_i"
        })
	end

	local glowVecOffset = Vector(0,0,0.1)
	local glowMat = Material("sprites/light_glow02_add")
	function SWEP:PostDrawViewModel(vm, wep, ply)
		if !IsValid(vm) then return end

		cam.Start3D(EyePos(), EyeAngles())
			render.SetMaterial(glowMat)
			local remainingAmmo = self:Clip1() /self.Primary.ClipSize
			local pulse = 0.75 +math.sin(CurTime() *(4 +(1 -remainingAmmo) ^2 *20)) *0.25
			local col = Color(255, 247, 134, 180 *pulse)
			for i = 1,math.max(1,math.ceil(remainingAmmo *10)) do
				local attID = vm:LookupAttachment("light" .. i)
				if !attID or attID <= 0 then continue end
				local att = vm:GetAttachment(attID)
				if !att then continue end
				render.DrawSprite(att.Pos +glowVecOffset,5 *pulse,5 *pulse,col)
			end
		cam.End3D()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", "DrawLaser")
	self:NetworkVar("Vector", "LaserHitPos")

	self:SetDrawLaser(false)

	baseclass.Get("weapon_vj_base").SetupDataTables(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:Init()
	self.NextStopFireLoop = CurTime()
	self.DidStopFireLoops = true

	local beam = EffectData()
	beam:SetStart(self:GetAttachment(1).Pos)
	beam:SetOrigin(self:GetAttachment(1).Pos)
	beam:SetEntity(self)
	beam:SetAttachment(1)
	util.Effect("VJ_HLR_Tracer_Reager",beam)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnThink()
	if CLIENT then return end
	local curTime = CurTime()

	self:SetDrawLaser(curTime < self.NextStopFireLoop)
	if !self.DidStopFireLoops && curTime > self.NextStopFireLoop then
		if self.FireLoop1:IsPlaying() then
			self.FireLoop1:Stop()
			VJ.EmitSound(self, "vj_hlr/src/wep/reager/reager_fire_end.wav", 75, 100)
		end
		VJ.STOPSOUND(self.FireLoop1)
		VJ.STOPSOUND(self.FireLoop2)
		self.DidStopFireLoops = true
	end

	if !IsValid(self.Owner) then return end
	local targetPos
	if self.Owner:IsNPC() && IsValid(self.Owner:GetEnemy()) then
		targetPos = self.Owner:GetEnemy():GetPos() +self.Owner:GetEnemy():OBBCenter()
	else
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 400,
			filter = self.Owner
		})
		targetPos = tr.HitPos
	end
	if targetPos:Distance(self:GetAttachment(1).Pos) > 400 then
		local dir = (targetPos - self:GetAttachment(1).Pos):GetNormalized()
		targetPos = self:GetAttachment(1).Pos + dir * 400
	end
	local randPos = targetPos + Vector(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(-2, 2))
	self:SetLaserHitPos(randPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OwnerChanged()
	VJ.STOPSOUND(self.FireLoop1)
	VJ.STOPSOUND(self.FireLoop2)
	self:SetDrawLaser(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnPrimaryAttack(status, statusData)
	if status == "Init" then
		if CLIENT then return end

		self.NextStopFireLoop = CurTime() +0.1
		self.FireLoop1 = CreateSound(self, "vj_hlr/src/wep/reager/reager_fire_loop.wav")
		self.FireLoop1:SetSoundLevel(80)
		self.FireLoop2 = CreateSound(self, "ambient/levels/citadel/zapper_ambient_loop1.wav")
		self.FireLoop2:SetSoundLevel(70)
		self.FireLoop1:Play()
		self.FireLoop2:Play()
		self:SetDrawLaser(true)
		self.DidStopFireLoops = false

		-- sound.Play("vj_hlr/src/wep/reager/reager_hit" .. math.random(1,3) .. ".wav",self:GetLaserHitPos(),75)
		-- VJ.EmitSound(self,"vj_hlr/src/wep/reager/reager_fire_solo.wav",75)
		VJ.ApplyRadiusDamage(self.Owner,self.Owner,self:GetLaserHitPos(),20,5,DMG_PLASMA,true,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:OnReload(s)
	if s == "Start" then
		timer.Simple(1.4,function()
			if IsValid(self) then
				self:EmitSound("vj_hlr/src/wep/reager/reager_reload_end.wav", 60, 100)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	VJ.STOPSOUND(self.FireLoop1)
	VJ.STOPSOUND(self.FireLoop2)
end
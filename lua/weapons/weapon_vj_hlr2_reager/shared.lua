if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Combine Reager"
SWEP.Author 					= "Cpt. Hazama"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
-- SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 4 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true
SWEP.NPC_NextPrimaryFire 		= 0.1 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0 -- How much time until the bullet/projectile is fired?
SWEP.NPC_ReloadSound			= {"weapons/physgun_off.wav"}
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/vj_weapons/c_physcannon.mdl"
SWEP.WorldModel					= "models/vj_hlr/hl2/weapons/combine_reager.mdl"
SWEP.HoldType 					= "ar2"
SWEP.ViewModelFOV				= 60 -- Player FOV for the view model
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.ClipSize			= 200 -- Max amount of bullets per clip
SWEP.Primary.Delay				= 0.1 -- Time until it can shoot again
SWEP.Primary.Ammo				= "CrossbowBolt" -- Ammo type
SWEP.Primary.Sound				= {}
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon

SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_full_blue"}
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0, 31, 225)
	-- World Model ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-10,0,180)
SWEP.WorldModel_CustomPositionOrigin = Vector(-1,15,0.5)
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ParticleFX = "electrical_arc_01"
SWEP.AttackRange = 450
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	self.OldFireDistance = 3000
	if IsValid(self.Owner) && self.Owner:IsNPC() then
		self.OldFireDistance = self.Owner.Weapon_FiringDistanceFar
		self.Owner.Weapon_FiringDistanceFar = self.AttackRange
	end
	self.StopLoopT = CurTime()
	self.Loop = CreateSound(self,"ambient/levels/citadel/zapper_loop2.wav")
	self.Loop:SetSoundLevel(80)
	self.LoopB = CreateSound(self,"ambient/levels/citadel/zapper_ambient_loop1.wav")
	self.LoopB:SetSoundLevel(70)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	if CurTime() > self.StopLoopT then
		if self.Loop:IsPlaying() then self.Loop:Stop() end
		if self.LoopB:IsPlaying() then self.LoopB:Stop() VJ_EmitSound(self,"ambient/levels/citadel/weapon_disintegrate1.wav",75,100) end
	else
		if !self.Loop:IsPlaying() then self.Loop:Play() end
		if !self.LoopB:IsPlaying() then self.LoopB:Play() end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_AfterShoot()
	if self:Clip1() <= 0 then
		VJ_EmitSound(self,"ambient/levels/citadel/weapon_disintegrate2.wav",80,100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if (CLIENT) then return end
	self.StopLoopT = CurTime() +0.2
	if !IsValid(self.Owner:GetEnemy()) then return end
	local ene = self.Owner:GetEnemy()
	local enePos = (ene:GetPos() +ene:OBBCenter())
	local srtPos = (self:GetAttachment(1).Pos)
	local rand = math.Rand(-10,10)
	local randPos = enePos +ene:GetUp() *rand +ene:GetRight() *rand +ene:GetForward() *rand
	-- local tr = util.TraceLine({
		-- start = srtPos,
		-- endpos = (randPos -srtPos) *200,
		-- filter = {self,self.Owner}
	-- })
	-- util.ParticleTracerEx(self.ParticleFX,tr.StartPos,tr.HitPos,false,self:EntIndex(),1)
	util.ParticleTracerEx(self.ParticleFX,srtPos,randPos,false,self:EntIndex(),1)
	-- VJ_EmitSound(self,{"ambient/energy/weld1.wav","ambient/energy/weld2.wav"},80,120)
	-- VJ_EmitSound(self,"ambient/energy/spark" .. math.random(1,6) .. ".wav",80,120)
	if randPos:Distance(enePos) <= 20 then
		local damagecode = DamageInfo()
		damagecode:SetDamage(math.random(2,4))
		damagecode:SetDamageType(DMG_SHOCK)
		damagecode:SetAttacker(self.Owner)
		damagecode:SetAttacker(self.Owner)
		damagecode:SetDamagePosition(randPos)
		ene:TakeDamageInfo(damagecode,self.Owner)
		VJ_DestroyCombineTurret(self.Owner,ene)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if IsValid(self.Owner) && self.Owner:IsNPC() then
		self.Owner.Weapon_FiringDistanceFar = self.OldFireDistance
	end
	if self.Loop then self.Loop:Stop() end
	if self.LoopB then self.LoopB:Stop() end
end
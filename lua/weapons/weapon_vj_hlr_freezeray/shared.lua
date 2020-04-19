if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Free-ze Cannon"
SWEP.Author 					= "Cpt. Hazama"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base - Half-Life Resurgence"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel					= "models/weapons/c_physcannon.mdl"
SWEP.WorldModel					= "models/weapons/w_physics.mdl"
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= false -- Not ready yet
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 10 -- Damage
SWEP.Primary.Force				= 5 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 100 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 1 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.1 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "AR2" -- Ammo type
SWEP.Primary.Sound				= {} -- npc/roller/mine/rmine_explode_shock1.wav
SWEP.Primary.HasDistantSound	= false -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleFlash = false
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(0,255,255)
SWEP.AnimTbl_PrimaryFire = {}
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 0.2 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= {"vj_hlr/hl1_weapon/displacer/displacer_spin2.wav"}
SWEP.Reload_TimeUntilAmmoIsSet	= 1.5 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 1.5 -- How much time until the player can play idle animation, shoot, etc.
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)

SWEP.FreezeDistance = 500
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnInitialize()
	timer.Simple(0,function() -- Fix Initialize not running
		if SERVER then
			self.Loop = CreateSound(self,"vj_hlr/hl1_weapon/egon/egon_run3.wav")
			self.Loop:SetSoundLevel(65)
			self.LoopB = CreateSound(self,"ambient/gas/cannister_loop.wav")
			self.LoopB:SetSoundLevel(65)
		end
		-- if CLIENT then
			-- self.Owner:GetViewModel():SetColor(Color(0,255,255))
			-- self.Owner:GetViewModel():SetMaterial(Material("Models/Weapons/V_physcannon/v_superphyscannon_sheet"))
		-- end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnThink()
	if SERVER then
		if self.Owner:KeyDown(IN_ATTACK) && self:Clip1() > 0 && !self.Reloading then
			self:RayCode()
			self:SendWeaponAnim(ACT_VM_RELOAD)
		else
			if self.Loop:IsPlaying() then
				VJ_EmitSound(self,"vj_hlr/hl1_weapon/egon/egon_off1.wav",75)
			end
			self.Loop:Stop()
			self.LoopB:Stop()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnRemove()
	if SERVER then
		if self.Loop then self.Loop:Stop() end
		if self.LoopB then self.LoopB:Stop() end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:RayCode()
	local aimPos = self:GetOwner():GetShootPos()
	local aimDir = self:GetOwner():GetAimVector():Angle()

	local hitPos = self:GetOwner():GetEyeTrace().HitPos
	if hitPos:Distance(aimPos) > self.FreezeDistance then
		if self.Loop:IsPlaying() then
			self.Loop:Stop()
			VJ_EmitSound(self,"vj_hlr/hl1_weapon/egon/egon_off1.wav",75)
		end
		self.Primary.TakeAmmo = 0
		self.LoopB:Play()
		return
	end
	self.Primary.TakeAmmo = 1
	self.Loop:Play()
	self.LoopB:Stop()
	
	for _,v in ipairs(ents.FindInSphere(hitPos,75)) do
		if v:IsNPC() then
			if v:IsNPC() && v.AnimationPlaybackRate then
				v.AnimationPlaybackRate = math.Clamp(v.AnimationPlaybackRate -0.00245,0,1)
				if v.VJ_HLR_FreezeChangeT == nil then
					v.VJ_HLR_FreezeChangeT = CurTime() +3
				end
				if v.VJ_HLR_FreezeTurnSpeed == nil then
					v.VJ_HLR_FreezeTurnSpeed = v:GetMaxYawSpeed()
				end
				v.VJ_HLR_FreezeChangeT = CurTime() +3 -v.AnimationPlaybackRate

				local index = "VJ_HLR_FreezeThink_" .. v:EntIndex()
				if !IsValid(v) then
					hook.Remove("Think",index)
					return
				end
				hook.Add("Think",index,function()
					if !v:IsValid() then
						hook.Remove("Think",index)
					else
						if CurTime() > v.VJ_HLR_FreezeChangeT then
							v.AnimationPlaybackRate = math.Clamp(v.AnimationPlaybackRate +0.00245,0,1)
						end
						if v.AnimationPlaybackRate < 0.9 then
							local col = 255 -(v.AnimationPlaybackRate *120)
							v:SetColor(Color(0,col,col))
							v:SetMaxYawSpeed(v:GetMaxYawSpeed() *v.AnimationPlaybackRate)
						else
							v:SetColor(Color(255,255,255))
							v:SetMaxYawSpeed(v.VJ_HLR_FreezeTurnSpeed)
						end
						if v.AnimationPlaybackRate == 1 then
							v:StopAttacks(true)
							v:SetMaxYawSpeed(v.VJ_HLR_FreezeTurnSpeed)
							v:SetColor(Color(255,255,255))
							hook.Remove("Think",index)
						end
					end
				end)
			end
		end
	end

	if CLIENT then
		local freeze = EffectData()
		freeze:SetStart(aimPos)
		freeze:SetOrigin(hitPos)
		freeze:SetEntity(self.Owner:GetViewModel())
		freeze:SetAttachment(1)
		util.Effect("VJ_HLR_FreezeRay",freeze)
	else
		local freeze = EffectData()
		freeze:SetStart(aimPos)
		freeze:SetOrigin(hitPos)
		freeze:SetEntity(self)
		freeze:SetAttachment(1)
		util.Effect("VJ_HLR_FreezeRay",freeze)
	end
end
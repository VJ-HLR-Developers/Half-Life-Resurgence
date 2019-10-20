ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Mounted Turret"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

if (SERVER) then
	AddCSLuaFile()
	
	ENT.EmplacementModel = "models/props_combine/bunker_gun01.mdl"
	ENT.BarricadeModel = "models/props_combine/combine_barricade_short01a.mdl"
	
	function ENT:CustomOnInitialize()
		self:SetModel(self.BarricadeModel)
		-- self:SetCollisionBounds(Vector(20,20,65),Vector(-20,-20,0))
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_BBOX)

		self.Emplacement = ents.Create("prop_vj_animatable")
		self.Emplacement:SetModel(self.EmplacementModel)
		self.Emplacement:SetPos(self:GetPos() +self:GetUp() *10 +self:GetForward() *-3.4)
		self.Emplacement:SetAngles(self:GetAngles())
		self.Emplacement:Spawn()
		self.Emplacement:SetParent(self)
		self.Emplacement:SetMoveType(MOVETYPE_NONE)
		self.Emplacement:SetSolid(SOLID_BBOX)
		self:DeleteOnRemove(self.Emplacement)
		self.Emplacement:ResetSequence("idle_inactive")

		local eyeglow = ents.Create("env_sprite")
		eyeglow:SetKeyValue("model","sprites/light_glow01.vmt")
		eyeglow:SetKeyValue("scale","1")
		eyeglow:SetKeyValue("rendermode","9")
		eyeglow:SetKeyValue("rendercolor","225 225 225 0")
		eyeglow:SetKeyValue("spawnflags","1") -- If animated
		eyeglow:SetParent(self.Emplacement)
		eyeglow:Fire("SetParentAttachment","light",0)
		eyeglow:Spawn()
		eyeglow:Activate()
		self.Emplacement:DeleteOnRemove(eyeglow)
		
		self.Operator = NULL
		self.PullingOperator = NULL -- Entity that the turret called to handle it
		self.Overheat = 0
		self.OverheatRechargeT = 0
		self.LastShotT = 0
		self.CanFire = false
		self.IsActivated = false
		self.IsActivating = false
		self.CanPlayIdle = false
		self.Shift = 12 -- Manipulate the pitch of the emplacement
	end
	
	function ENT:SetEmplacementStatus()
		if IsValid(self.Operator) then
			if !self.IsActivated && !self.IsActivating then
				self.Emplacement:ResetSequence("activate")
				self:EmitSound("weapons/shotgun/shotgun_cock.wav",70,100)
				self.IsActivating = true
				timer.Simple(1.3,function()
					if IsValid(self) then
						self.IsActivated = true
						self.IsActivating = false
						self.CanPlayIdle = true
						self:EmitSound("buttons/combine_button1.wav",70,100)
					end
				end)
			elseif self.IsActivated then
				self.CanFire = true
				if self.CanPlayIdle then
					self.Emplacement:ResetSequence("idle")
					self.CanPlayIdle = false
				end
			end
		else
			if self.IsActivated && !self.IsActivating then
				self.CanFire = false
				self.Emplacement:ResetSequence("retract")
				self:EmitSound("weapons/shotgun/shotgun_cock.wav",70,92)
				self.IsActivating = true
				timer.Simple(1.3,function()
					if IsValid(self) then
						self.IsActivated = false
						self.IsActivating = false
						self.CanPlayIdle = true
						self:EmitSound("buttons/combine_button2.wav",70,100)
					end
				end)
			elseif !self.IsActivated then
				if self.CanPlayIdle then
					self.Emplacement:ResetSequence("idle_inactive")
					self.CanPlayIdle = false
				end
			end
		end
	end

	function ENT:ManGun(ent)
		self.Operator = ent
		self.Operator:StopMoving()
		self.Operator:StopMoving()
		self.Operator.OldIdle = self.Operator.AnimTbl_IdleStand
		self.Operator.OldAttack = self.Operator.AnimTbl_WeaponAttack
		self.Operator.OldMeleeAttack = self.Operator.HasMeleeAttack
		self.Operator.OldGrenadeAttack = self.Operator.HasGrenadeAttack
		if IsValid(self.Operator:GetActiveWeapon()) then
			self.Operator.OldWeapon = self.Operator:GetActiveWeapon():GetClass()
			self.Operator:GetActiveWeapon():Remove()
		end
		self.Operator.MovementType = VJ_MOVETYPE_STATIONARY
		self.Operator.CanTurnWhileStationary = false
		self.Operator.AnimTbl_IdleStand = {ACT_IDLE_MANNEDGUN}
		self.Operator.AnimTbl_WeaponAttack = {ACT_IDLE_MANNEDGUN}
		self.Operator.DisableWandering = true
		self.Operator.DisableChasingEnemy = true
		self.Operator.NoWeapon_UseScaredBehavior = false
		self.Operator.HasMeleeAttack = false
		self.Operator.HasGrenadeAttack = false
		self.Operator:StartEngineTask(GetTaskList("TASK_PLAY_SEQUENCE"),ACT_IDLE_MANNEDGUN)
		self.VJ_GoingToManGun = false
		self.VJ_ManningGun = true
		self.PullingOperator = NULL
	end

	function ENT:UnMan()
		self.Operator.VJ_NextManGunT = CurTime() +10
		self.Operator.AnimTbl_WeaponAttack = self.Operator.OldAttack
		self.Operator.HasMeleeAttack = self.Operator.OldMeleeAttack
		self.Operator.HasGrenadeAttack = self.Operator.OldGrenadeAttack
		if self.Operator.OldWeapon != nil then
			self.Operator:Give(self.Operator.OldWeapon)
		end
		self.Operator.MovementType = VJ_MOVETYPE_GROUND
		self.Operator.CanTurnWhileStationary = true
		self.Operator.AnimTbl_IdleStand = self.Operator.OldIdle
		self.Operator.DisableWandering = false
		self.Operator.DisableChasingEnemy = false
		self.Operator.NoWeapon_UseScaredBehavior = true
		self.Operator:SetPos(self.Operator:GetPos() +self.Operator:GetForward() *-16 +self:GetUp() *6)
		self.Emplacement:SetPoseParameter("aim_pitch",0)
		self.Emplacement:SetPoseParameter("aim_yaw",0)
		self.Operator.VJ_GoingToManGun = false
		self.Operator.VJ_ManningGun = false
		self.Operator = NULL
	end

	function ENT:Think()
		if !IsValid(self.Emplacement) then self:Remove() return end
		self:SetEmplacementStatus()
		if CurTime() > self.LastShotT then
			self.Overheat = 0
		end
		if CurTime() > self.OverheatRechargeT then
			if self.Emplacement.Loop then self.Emplacement:StopParticles(); self.Emplacement.Loop:Stop() end
		end
		self.TargetPos = self:GetPos() +self:GetForward() *-50
		self.HandlePos = self:GetPos() +self:GetForward() *-40 +self:GetUp() *-30
		if !IsValid(self.Operator) then
			self:WeaponAimPoseParameters(true)
			if !IsValid(self.PullingOperator) then
				for _,v in ipairs(ents.FindInSphere(self:GetPos(),500)) do
					if v:IsNPC() && v:Visible(self) && v.IsVJBaseSNPC then
						if VJ_AnimationExists(v,ACT_IDLE_MANNEDGUN) && (!v.VJ_GoingToManGun && !v.VJ_ManningGun) then
							if v.VJ_NextManGunT && v.VJ_NextManGunT > CurTime() then return end
							self.PullingOperator = v
							v.VJ_GoingToManGun = true
							break
						end
					end
				end
			else
				local task = "TASK_WALK_PATH"
				if IsValid(self.PullingOperator:GetEnemy()) then
					task = "TASK_RUN_PATH"
				end
				self.PullingOperator:SetLastPosition(self.TargetPos)
				self.PullingOperator:VJ_TASK_GOTO_LASTPOS(task)
				if self.PullingOperator:GetPos():Distance(self.TargetPos) <= 50 then
					self.PullingOperator:SetPos(self.TargetPos)
					self:ManGun(self.PullingOperator)
				end
			end
		else
			self.Operator:SetPos(self.HandlePos)
			self.Operator:SetAngles(self:GetAngles())
			if IsValid(self.Operator:GetEnemy()) then
				local ene = self.Operator:GetEnemy()
				if (self:GetForward():Dot((ene:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.Operator.SightAngle))) && (ene:GetPos():Distance(self:GetPos()) < self.Operator.Weapon_FiringDistanceFar) then
					if self:Visible(ene) then
						self:FireEmplacement()
					end
				else
					if ene:GetPos():Distance(self.Operator:GetPos()) <= 200 then
						self:UnMan()
					end
				end
			end
			self:WeaponAimPoseParameters()
		end
		self:NextThink(CurTime()+(0.069696968793869+FrameTime()))
		return true
	end
	
	function ENT:FireEmplacement()
		if !self.CanFire then return end
		if self.OverheatRechargeT > CurTime() then
			return
		end
		local att = self.Emplacement:GetAttachment(1)
		local bullet = {}
		bullet.Num = 1
		bullet.Src = att.Pos
		bullet.Dir = att.Ang:Forward()
		bullet.Callback = function(attacker, tr, dmginfo)
			local laserhit = EffectData()
			laserhit:SetOrigin(tr.HitPos)
			laserhit:SetNormal(tr.HitNormal)
			laserhit:SetScale(25)
			util.Effect("AR2Impact",laserhit)
		end
		bullet.Spread = Vector(0.04,0.04,0)
		bullet.Tracer = 1
		bullet.TracerName = "AirboatGunTracer"
		bullet.Force = 3
		bullet.Damage = self.Operator:VJ_GetDifficultyValue(7)
		bullet.AmmoType = "SMG1"
		self.Emplacement:FireBullets(bullet)
		self.LastShotT = CurTime() +6
		self.Overheat = self.Overheat +1
		if self.Overheat >= 125 then
			self.OverheatRechargeT = CurTime() +6
			self.Overheat = 0
			for i = 1,5 do
				timer.Simple(i,function()
					if IsValid(self) then
						sound.Play("ambient/alarms/warningbell1.wav",self.Emplacement:GetPos(),72,100 *GetConVarNumber("host_timescale"))
					end
				end)
			end
			ParticleEffectAttach("Advisor_Pod_Steam_Continuous",PATTACH_POINT_FOLLOW,self.Emplacement,1)
			self.Emplacement.Loop = CreateSound(self.Emplacement,"ambient/gas/steam2.wav")
			self.Emplacement.Loop:SetSoundLevel(72)
			self.Emplacement.Loop:Play()
		end
		ParticleEffectAttach("vj_rifle_full_blue",PATTACH_POINT_FOLLOW,self.Emplacement,1)
		self.Emplacement:ResetSequence("fire")
		sound.Play("weapons/ar1/ar1_dist2.wav",self.Emplacement:GetPos(),90,100 +(self.Overheat /4) *GetConVarNumber("host_timescale"))
	end

	function ENT:OnRemove()
		if self.Emplacement.Loop then self.Emplacement.Loop:Stop() end
		self:StopParticles()
		self.Emplacement:StopParticles()
		if IsValid(self.Operator) then
			self:UnMan()
		end
	end

	function ENT:WeaponAimPoseParameters(ResetPoses)
		if !IsValid(self.Operator) then return end
		ResetPoses = ResetPoses or false
		//self:VJ_GetAllPoseParameters(true)
		local ent = NULL
		if self.Operator.VJ_IsBeingControlled == true then ent = self.Operator.VJ_TheController else ent = self.Operator:GetEnemy() end
		local p_enemy = 0 -- Pitch
		local y_enemy = 0 -- Yaw
		local r_enemy = 0 -- Roll
		local ang_dif = math.AngleDifference
		local ang_app = math.ApproachAngle
		if IsValid(ent) && ResetPoses == false then
			local self_pos = self.Emplacement:GetPos() + self.Emplacement:OBBCenter()
			local enemy_pos = false //Vector(0,0,0)
			if self.Operator.VJ_IsBeingControlled == true then enemy_pos = self.Operator.VJ_TheController:GetEyeTrace().HitPos else enemy_pos = ent:GetPos() + ent:OBBCenter() end
			if enemy_pos == false then return end
			local self_ang = self.Emplacement:GetAngles()
			local enemy_ang = (enemy_pos - self_pos):Angle()
			p_enemy = ang_dif(enemy_ang.p,self_ang.p)
			if self.PoseParameterLooking_InvertPitch == true then p_enemy = -p_enemy end
			y_enemy = ang_dif(enemy_ang.y,self_ang.y)
			if self.PoseParameterLooking_InvertYaw == true then y_enemy = -y_enemy end
			r_enemy = ang_dif(enemy_ang.z,self_ang.z)
			if self.PoseParameterLooking_InvertRoll == true then r_enemy = -r_enemy end
		end
		self.Emplacement:SetPoseParameter("aim_pitch",ang_app(self.Emplacement:GetPoseParameter("aim_pitch"),p_enemy +self.Shift,10))
		self:SetPoseParameter("aim_pitch",ang_app(self:GetPoseParameter("aim_pitch"),p_enemy,10))
		self.Emplacement:SetPoseParameter("aim_yaw",ang_app(self.Emplacement:GetPoseParameter("aim_yaw"),y_enemy +5,10))
		self:SetPoseParameter("aim_yaw",ang_app(self:GetPoseParameter("aim_yaw"),y_enemy,10))
		self.DidWeaponAttackAimParameter = true
	end
end
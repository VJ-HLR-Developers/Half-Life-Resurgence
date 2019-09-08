AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/decay/sentry.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) then
		self.HECUTurret_StandDown = false
		self.AnimTbl_IdleStand = {"spin"}
		
		if CurTime() > self.HECUTurret_NextAlarmT then
			local glow = ents.Create("env_sprite")
			glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
			glow:SetKeyValue("scale","0.1")
			glow:SetKeyValue("rendermode","5")
			glow:SetKeyValue("rendercolor","255 0 0")
			glow:SetKeyValue("spawnflags","1") -- If animated
			glow:SetParent(self)
			glow:Fire("SetParentAttachment","sensor",0)
			glow:Spawn()
			glow:Activate()
			glow:Fire("Kill","",0.1)
			self:DeleteOnRemove(glow)
			self.HECUTurret_NextAlarmT = CurTime() + 1
			VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_ping.wav"},75,100)
		end
		
		if self:CustomAttackCheck_RangeAttack() == true && (self.RangeAttacking == true or self:GetEnemy():Visible(self)) then
			self:SetSkin(0)
		else
			self:SetSkin(1)
		end
	else
		if CurTime() > self.NextResetEnemyT && self.Alerted == false then
			self:SetSkin(0)
			if self.HECUTurret_StandDown == false then
				self.HECUTurret_StandDown = true
				self:VJ_ACT_PLAYACTIVITY({"retire"},true,1)
				VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_retract.wav"},65,self:VJ_DecideSoundPitch(100,110))
			end
		end
		if self.HECUTurret_StandDown == true then
			self.AnimTbl_IdleStand = {"idle_off"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetAttachment(self:LookupAttachment("muzzle")).Pos
	bullet.Dir = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-self:GetAttachment(self:LookupAttachment("muzzle")).Pos
	bullet.Spread = 0.001
	bullet.Tracer = 1
	bullet.TracerName = "Tracer"
	bullet.Force = 5
	bullet.Damage = GetConVarNumber("vj_bms_turret_d")
	bullet.AmmoType = "SMG1"
	self:FireBullets(bullet)
	
	VJ_EmitSound(self,{"vj_hlr/hl1_npc/turret/tu_fire1.wav"},90,self:VJ_DecideSoundPitch(100,110))
	
	ParticleEffectAttach("vj_bms_turret_full",PATTACH_POINT_FOLLOW,self,1)
	timer.Simple(0.2,function() if IsValid(self) then self:StopParticles() end end)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(self:GetAttachment(self:LookupAttachment("muzzle")).Pos)
	FireLight1:SetLocalAngles(self:GetAngles())
	FireLight1:Fire("Color", "255 150 60")
	FireLight1:SetParent(self)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",0.07)
	self:DeleteOnRemove(FireLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	ParticleEffectAttach("smoke_exhaust_01a",PATTACH_POINT_FOLLOW,GetCorpse,2)
	ParticleEffect("explosion_turret_break_fire", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("center")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_flash", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("center")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_pre_smoke Version #2", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("center")).Pos, Angle(0,0,0), GetCorpse)
	ParticleEffect("explosion_turret_break_sparks", GetCorpse:GetAttachment(GetCorpse:LookupAttachment("center")).Pos, Angle(0,0,0), GetCorpse)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
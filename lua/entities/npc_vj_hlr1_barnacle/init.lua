AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/barnacle.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.SightDistance = 0 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.StartHealth = 85
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodPool = false -- Does it have a blood pool?

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB -- Type of Damage
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 80 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 120 -- How far does the damage go?

ENT.VJ_NoTarget = true
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_MeleeAttack = {"vj_bmsx/beneathacle/beneathacle_crunch2.wav","vj_bmsx/beneathacle/beneathacle_crunch3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_hlr/hl1_npc/zombie/claw_miss1.wav","vj_hlr/hl1_npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Death = {
	"vj_bmsx/beneathacle/beneathacle_die1.wav",
	"vj_bmsx/beneathacle/beneathacle_die2.wav",
	"vj_bmsx/beneathacle/beneathacle_die3.wav",
}
ENT.SoundTbl_Digest = {
	"vj_bmsx/beneathacle/beneathacle_digesting1.wav",
	"vj_bmsx/beneathacle/beneathacle_digesting2.wav",
}
ENT.SoundTbl_Pull = {
	"vj_bmsx/beneathacle/beneathacle_pull1.wav",
	"vj_bmsx/beneathacle/beneathacle_pull2.wav",
	"vj_bmsx/beneathacle/beneathacle_pull3.wav",
	"vj_bmsx/beneathacle/beneathacle_pull4.wav",
}
ENT.SoundTbl_Snatch = {
	"vj_bmsx/beneathacle/beneathacle_bark1.wav",
	"vj_bmsx/beneathacle/beneathacle_bark2.wav",
}

ENT.GeneralSoundPitch1 = 100

	-- Custom --
ENT.HeightAdjust = -180
ENT.MaxHeight = 1024
ENT.TongueDecreaseAmount = 4
ENT.TongueCatchDistance = 50
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(18,18,50),Vector(-18,-18,0))
	self.TonguePos = self:GetPos()
	self.DidEat = false
	self.CaughtSomething = false
	self.CaughtEntity = NULL
	self.NextTongueCheckT = CurTime()
	self.NextDigestT = CurTime()
	self.NextPullT = CurTime()
	local pose = self:FindAccurateTongueParameter()
	timer.Simple(0.01,function() if IsValid(self) then self:SetPoseParameter("tongue_height",pose) end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindAccurateTongueParameter()
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() +self:GetUp() *-self.MaxHeight,
		filter = self
	})
	local tongueheight = self:GetPos():Distance(tr.HitPos) +self.HeightAdjust
	return tongueheight
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetTongue(slow)
	local moveSlow = slow or false
	local tongueheight = self:FindAccurateTongueParameter()
	if moveSlow then
		if self:GetTongueHeight().height != tongueheight then
			self:SetTongueHeight(self:GetTongueHeight().height +self.TongueDecreaseAmount)
			if self:GetTongueHeight().height > tongueheight then
				self:SetTongueHeight(tongueheight)
			end
		end
	else
		self:SetTongueHeight(tongueheight)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	local corpse = ents.Create("prop_dynamic")
	corpse:SetModel(self:GetModel())
	corpse:SetPos(self:GetPos())
	corpse:SetAngles(self:GetAngles())
	corpse:Spawn()
	corpse:SetPoseParameter("tongue_height",self:GetTongueHeight().height)
	corpse:ResetSequence("death")
	timer.Simple(25,function()
		if IsValid(corpse) then
			corpse:Remove()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetTongueHeight()
	local tbl = {height=self:GetPoseParameter("tongue_height"),pos=self:GetPos() +self:GetUp() *(-self:GetPoseParameter("tongue_height") +self.HeightAdjust)}
	return tbl
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTongueHeight(x)
	self:SetPoseParameter("tongue_height",math.Clamp(x,-1024,self.MaxHeight))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCatchEntity(ent)
	VJ_EmitSound(self,self.SoundTbl_Snatch,75,100)
	ent:EmitSound("vj_bmsx/beneathacle/beneathacle_neck_snap"..math.random(1,2)..".wav",60,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor)
	self.NextDigestT = CurTime() +10
	self.DidEat = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.TonguePos = self:GetTongueHeight().pos
	local tHeight = self:GetTongueHeight().height
	print(self:GetPoseParameter("tongue_height"),tHeight)
	if GetConVarNumber("ai_disabled") == 1 then return end
	if self.CaughtSomething then
		if IsValid(self.CaughtEntity) && self.CaughtEntity:Health() > 0 then
			local ent = self.CaughtEntity
			table.insert(self.VJ_AddCertainEntityAsEnemy,ent)
			self:VJ_DoSetEnemy(ent,true,true)
			self:SetEnemy(ent)
			ent:SetPos(self.TonguePos +Vector(0,0,-12))
			self.AnimTbl_IdleStand = {"slurp"}
		else
			self.CaughtSomething = false
		end
		if tHeight >= 0 then
			if CurTime() > self.NextPullT then
				VJ_EmitSound(self,self.SoundTbl_Pull,75,100)
				if IsValid(self.CaughtEntity) then
					self.CaughtEntity:EmitSound("vj_bmsx/beneathacle/beneathacle_tongue_pull"..math.random(1,3)..".wav",60,100)
				end
				self.NextPullT = CurTime() +1.35
			end
			self:SetTongueHeight(self:GetTongueHeight().height -self.TongueDecreaseAmount)
		end
	else
		self.AnimTbl_IdleStand = {ACT_IDLE}
		if self.DidEat && CurTime() < self.NextDigestT then
			VJ_EmitSound(self,self.SoundTbl_Digest,75,100)
			self.DidEat = false
		end
	end
	if !self.CaughtSomething && CurTime() > self.NextTongueCheckT then
		for _,v in pairs(ents.FindInSphere(self.TonguePos,self.TongueCatchDistance)) do
			if (v:IsNPC() && v:Disposition(self) != D_LI && v != self) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) then
				if !self.CaughtSomething && v:VisibleVec(self.TonguePos) then
					self.CaughtSomething = true
					self.CaughtEntity = v
					self:OnCatchEntity(v)
				end
			end
		end
		self.NextTongueCheckT = CurTime() +0.5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "attack" then
		self:MeleeAttackCode()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
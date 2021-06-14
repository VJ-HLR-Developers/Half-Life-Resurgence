/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
-- AERIAL & AQUATIC BASE --
// MOVETYPE_FLY | MOVETYPE_FLYGRAVITY
ENT.CurrentAnim_AAMovement = nil
ENT.AA_NextMovementAnimation = 0
ENT.AA_CanPlayMoveAnimation = false
ENT.AA_CurrentMoveAnimationType = "Calm"
ENT.AA_MoveLength_Wander = 0
ENT.AA_MoveLength_Chase = 0
ENT.AA_MoveTime = 0
ENT.AA_MoveTimeCur = 0
//ENT.AA_TargetPos = Vector(0, 0, 0)

ENT.FlySpeed = 425
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AA_MoveAnimation()
	if self:GetSequence() != self.CurrentAnim_AAMovement && self:BusyWithActivity() == false /*&& self:GetActivity() == ACT_IDLE*/ && CurTime() > self.AA_NextMovementAnimation then
		local animtbl = {}
		if self.AA_CurrentMoveAnimationType == "Calm" then
			if self.MovementType == VJ_MOVETYPE_AQUATIC then
				animtbl = self.Aquatic_AnimTbl_Calm
			else
				animtbl = self.Aerial_AnimTbl_Calm
			end
		elseif self.AA_CurrentMoveAnimationType == "Alert" then
			if self.MovementType == VJ_MOVETYPE_AQUATIC then
				animtbl = self.Aquatic_AnimTbl_Alerted
			else
				animtbl = self.Aerial_AnimTbl_Alerted
			end
		end
		local pickedanim = VJ_PICK(animtbl)
		if type(pickedanim) == "number" then pickedanim = self:GetSequenceName(self:SelectWeightedSequence(pickedanim)) end
		local idleanimid = VJ_GetSequenceName(self,pickedanim)
		self.CurrentAnim_AAMovement = idleanimid
		//self:AddGestureSequence(idleanimid)
		self:VJ_ACT_PLAYACTIVITY(pickedanim,false,0,false,0,{AlwaysUseSequence=true,SequenceDuration=false,SequenceInterruptible=true})
		self.AA_NextMovementAnimation = CurTime() + self:DecideAnimationLength(self.CurrentAnim_AAMovement, false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AA_StopMoving()
	if self:GetVelocity():Length() > 0 then
		self:SetLocalVelocity(LerpVector(0.1,self:GetVelocity(),Vector(0, 0, 0)))
		self:SetPoseParameter("tilt",Lerp(0.2,self:GetPoseParameter("tilt"),0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Between(pos,a,b)
	local ang = (pos -self:GetPos()):Angle()
	local dif = math.AngleDifference(self:GetAngles().y,ang.y)
	return dif < a && dif > b
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DecideYaw(pos)
	local y = 0
	if self:Between(pos,30,-30) then
		y = 0
	elseif self:Between(pos,50,70) then
		y = -45
	elseif self:Between(pos,120,70) then
		y = -90
	elseif self:Between(pos,150,120) then
		y = -135
	elseif !self:Between(pos,150,-150) then
		y = 180
	elseif self:Between(pos,-110,-150) then
		y = 135
	elseif self:Between(pos,-70,-110) then
		y = 90
	elseif self:Between(pos,-30,-70) then
		y = 45
	end
	
	self.CurrentTargetYaw = y
	self:SetPoseParameter("tilt",Lerp(0.5,self:GetPoseParameter("tilt"),y))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AA_IdleWander()
	local rand = 2500
	local randZMin = 800
	local randZMax = 1250
	self:AAMove_FlyToPosition(self:GetPos() +Vector(math.Rand(-rand,rand),math.Rand(-rand,rand),math.Rand(-randZMin,randZMax)),true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_FlyToPosition(Pos,isWander,ovSpeed)
	self.AA_CanPlayMoveAnimation = true
	self.AA_CurrentMoveAnimationType = "Calm"

	local speed = ovSpeed or self.Aerial_FlyingSpeed_Alerted
	self:DecideYaw(Pos)
	if self:GetPoseParameter("tilt") -self.CurrentTargetYaw > 0.08 then
		-- speed = math.Clamp(self:GetVelocity():Length() -self:GetVelocity():Length() /2,5,self.Aerial_FlyingSpeed_Alerted)
	end
	local tr = util.TraceLine({start=self:GetPos(),endpos=Pos,filter={self,self.VJ_TheController}})
	if tr.Hit && tr.HitWorld then
		Pos = tr.HitPos -tr.HitNormal *self:OBBMaxs()
	end
	local tr = util.TraceLine({start=Pos,endpos=Pos +Vector(0,0,-800),filter={self,self.VJ_TheController}})
	if tr.Hit then
		Pos = Pos +Vector(0,0,800)
	end
	local GoToPos = (Pos -self:GetPos()):GetNormal() *speed
	
	self:FaceCertainPosition(Pos)

	-- if vel_stop == false then
		self.AA_CurrentTurnAng = self:GetFaceAngle(self:GetFaceAngle((Pos):Angle()))
		self:SetLocalVelocity(GoToPos)
		-- self:SetLocalVelocity(LerpVector(0.1,self:GetVelocity(),GoToPos))
		-- self:AddVelocity(GoToPos)
		-- self:FaceCertainPosition(GoToPos)
		local moveTime = ((self:GetPos():Distance(Pos)) /self:GetVelocity():Length())
		local vel_len = CurTime() +moveTime
		self.AA_MoveTime = moveTime
		self.AA_MoveTimeCur = vel_len
		if isWander then
			self.AA_MoveLength_Wander = vel_len
			self.AA_MoveLength_Chase = 0
			self:FaceCertainPosition(GoToPos)
			-- self:SetIdealYawAndUpdate(Angle(0,(Pos -self:GetPos()):Angle().y,0).y,speed)
		else
			self.AA_MoveLength_Wander = 0
			self.AA_MoveLength_Chase = vel_len
		end
		if vel_len == vel_len then
			self.NextIdleTime = vel_len
		end
		return self.AA_MoveTime
	-- else
		-- self:AA_StopMoving()
	-- end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AA_MoveTo(Ent)
	if !IsValid(Ent) then return end
	self:FaceCertainPosition(Ent:GetPos())
	self:AAMove_FlyToPosition(Ent:GetPos())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AA_ChaseEnemy()
	if self.Dead == true or (self.NextChaseTime > CurTime()) or !IsValid(self:GetEnemy()) then return end
	
	self:FaceCertainPosition(self:GetEnemy():GetPos())
	self:AAMove_FlyToPosition(self:GetEnemy():GetPos())
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
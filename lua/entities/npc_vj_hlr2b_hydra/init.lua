AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hydra.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Blue" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2,"strikedown45deg"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 180 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 210 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 60
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Alert = {
	"vj_hlr/hl2b_npc/hydra/hydra_alert1.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_alert2.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_alert3.wav",
}
ENT.SoundTbl_CombatIdle = {
	"vj_hlr/hl2b_npc/hydra/hydra_search5.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_search6.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_search7.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_search8.wav",
}
ENT.SoundTbl_BumpWorld = {
	"vj_hlr/hl2b_npc/hydra/hydra_bump1.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_bump2.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_bump3.wav",
}
ENT.SoundTbl_PrepareAttack = {
	"vj_hlr/hl2b_npc/hydra/hydra_sendtentacle1.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_sendtentacle2.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_sendtentacle3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/hl2b_npc/hydra/hydra_strike1.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_strike2.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_strike3.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl2b_npc/hydra/hydra_pain1.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_pain2.wav",
	"vj_hlr/hl2b_npc/hydra/hydra_pain3.wav",
}

	-- Enumerations --
CHAIN_LINKS = 32
BONE_COUNT = 47
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 250), Vector(-20, -20, 0))
	self.HeartBeatSnd = "vj_hlr/hl2b_npc/hydra/hydra_heartloop" .. math.random(1,2) .. ".wav"
	self.HeartBeat = CreateSound(self,self.HeartBeatSnd)
	self.HeartBeat:SetSoundLevel(70)
	self.NextHeartBeatT = CurTime()
	self.NextRefreshRate = 0
	self.tbl_HydraBones = {}
	for i = 0,BONE_COUNT do
		print("Added bone " .. i)
		local pos,ang = self:GetBonePosition(i)
		local add = i +1
		if i == 47 then
			add = i
		end
		local posB,angB = self:GetBonePosition(add)
		self.tbl_HydraBones[i] = {
			Length = self:BoneLength(i),
			Pos = pos,
			Ang = ang,
			Stretch = (posB -pos):Length(),
			MaxStretch = (posB -pos):Length() +(posB -pos):Length()
		}
	end
	self:CalcChain(self:GetPos(),self.tbl_HydraBones)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CalcChain(pos,bones)
	local tblData = {}
	local doRun = false
	for i = 0,#bones do
		if i > 0 then
			if (bones[i].Pos -bones[i -1].Pos):LengthSqr() > 0.0 then
				doRun = true
			end
		end
	end
	if !doRun then return end
	local totalLength = 0
	local maxPossibleLength = 0
	local relaxedLength = 0
	for i = 0,#bones do
		tblData[i] = {}
		if i != 0 then
			maxPossibleLength = maxPossibleLength +bones[i].MaxStretch
			totalLength = totalLength +bones[i].Length
			relaxedLength = bones[i].Length
		end
	end
	totalLength = math.Clamp(totalLength,1,maxPossibleLength)
	local scale = relaxedLength /totalLength
	local dist = -16
	for i = 0,#bones do
		if i != 0 then
			local dt = (bones[i].Pos -bones[i -1].Pos):Length() *scale
			local len = bones[i].Length
			local dx = dt
			if dist +dt >= bones[i].Length then
				local s = (dx -(dt -(len -dist))) / dx
				if (s < 0 || s > 1) then
					s = 0
				end
				-- Catmull_Rom_Spline( chain[(i<CHAIN_LINKS-1)?i+1:CHAIN_LINKS-1], chain[i], chain[(i>0)?i-1:0], chain[(i>1)?i-2:0], s, pos[j] );
				dt = dt -(len -dist)
				dist = 0
			end
			dist = dist +dt
			-- print("----------------------------")
			-- print("Bone: " .. tostring(i))
			-- print("DT: " .. tostring(dt))
			-- print("Length: " .. tostring(len))
			-- print("DX: " .. tostring(dx))
			-- print("Dist: " .. tostring(dist))
			tblData[i] = {
				DT = dt,
				DX = dx,
				Dist = dist,
			}
		end
	end
	return tblData
end
local lerp = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MoveHead(pos,rate,bones)
	if CurTime() > self.NextRefreshRate then
		for i = 0,#bones do
			if i > 0 then
				print(pos,bones[47].Pos)
				if i != 47 then
					lerp = Lerp(1 *FrameTime(),lerp,1)
					self:ManipulateBonePosition(i,LerpVector(math.Clamp(lerp,bones[i].Length,bones[i].MaxStretch),bones[i].Pos,bones[47].Pos))
					self:ManipulateBoneAngles(i,LerpAngle(math.Clamp(lerp *0.6,0,1)*1,bones[i].Ang,bones[i].Ang,(bones[i].Pos +pos):Angle()))
				else
					lerp = Lerp(1 *FrameTime(),lerp,1)
					self:ManipulateBoneAngles(i,LerpAngle(math.Clamp(lerp *0.6,0,1)*1,bones[i].Ang,(bones[i].Pos +pos):Angle()))
					self:ManipulateBonePosition(i,LerpVector(math.Clamp(lerp *0.6,0,1)*1,bones[i].Pos,bones[i].Ang:Forward() *5))
				end
			end
		end
		self.NextRefreshRate = CurTime() +rate
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if CurTime() > self.NextHeartBeatT then
		self.HeartBeat:Stop()
		self.HeartBeat:Play()
		self.NextHeartBeatT = CurTime() +SoundDuration(self.HeartBeatSnd)
	end
	self:CalcChain(nil,self.tbl_HydraBones)
	-- if IsValid(self:GetEnemy()) then
		-- self.AnimTbl_IdleStand = {ACT_IDLE_ANGRY}
		-- self:MoveHead(self:GetEnemy():GetPos(),1,self.tbl_HydraBones)
	-- else
		-- self.AnimTbl_IdleStand = {ACT_IDLE}
	-- end
	-- local pos,ang = self:GetBonePosition(47)
	-- self:ManipulateBonePosition(47,pos +self:GetForward() *0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() self.HeartBeat:Stop() end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
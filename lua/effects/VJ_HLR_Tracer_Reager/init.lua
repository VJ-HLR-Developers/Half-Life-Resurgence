/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
EFFECT.MainMat = Material("effects/bluelaser1")
EFFECT.SecondaryMat = Material("effects/beam_nocolor")
EFFECT.WarpMat = Material("effects/energy_swave_warp2")
EFFECT.ImpactMat = Material("effects/energy_flare_03_nocolor")

local function getStartEnt(ent)
	if !IsValid(ent) then return end

	local owner = ent:GetOwner()
	local locPly = LocalPlayer()
	if IsValid(owner) && owner:IsPlayer() then
		if owner == locPly && !owner:ShouldDrawLocalPlayer() then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				return vm
			end
		end
	end
	return ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.DoDraw = false
	local ent = data:GetEntity()
	local att = data:GetAttachment()
	local locPly = LocalPlayer()
	self.Ent = ent
	self.Att = att
	self.RenderEnt = getStartEnt(self.Ent)

	if IsValid(self.RenderEnt) && self.Att > 0 then
		local att = self.RenderEnt:GetAttachment(self.Att)
		if att then
			self.StartPos = att.Pos
		end
	end

	self.HitPos = self.EndPos -self.StartPos
	self.Normal = self.HitPos:GetNormalized()
	self:SetRenderBoundsWS(self.StartPos,self.EndPos)
	self.NextEffectSoundT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	-- print(self.StartPos, self.EndPos)
	if !IsValid(self.Ent) then return false end
	self.RenderEnt = getStartEnt(self.Ent)
	if IsValid(self.RenderEnt) && self.Att > 0 then
		local att = self.RenderEnt:GetAttachment(self.Att)
		if att then
			self.StartPos = att.Pos
		end
	end
	self.DoDraw = self.Ent:GetDrawLaser() or false
	self.EndPos = self.Ent:GetLaserHitPos() or self.EndPos
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	if !self.DoDraw then return true end

	local tr = util.TraceLine({
		start = self.StartPos,
		endpos = self.EndPos,
		filter = self.Ent:GetOwner()
	})
	if tr.Hit then
		self.Normal = tr.HitNormal
		-- if tr.HitWorld then
		-- 	util.Decal("FadingScorch",tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)
		-- end
		if CurTime() > self.NextEffectSoundT then
			sound.Play("vj_hlr/src/wep/reager/reager_hit" .. math.random(1,3) .. ".wav",tr.HitPos,50)
			self.NextEffectSoundT = CurTime() +0.15
		end
		local Emitter = ParticleEmitter(self.EndPos)
		for _ = 1, math.random(4, 7) do
			local particle = Emitter:Add("effects/spark", self.EndPos)
			particle:SetVelocity(VectorRand()*math.Rand(100, 350))
			particle:SetDieTime(math.Rand(0.1, 1))
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(1)
			particle:SetEndSize(3)
			particle:SetRoll(math.random(0, 360))
			particle:SetGravity(Vector(math.random(-300, 300), math.random(-300, 300), math.random(-300, -700)))
			particle:SetCollide(true)
			particle:SetBounce(0.9)
			particle:SetAirResistance(120)
			particle:SetStartLength(0)
			particle:SetEndLength(0.1)
			particle:SetVelocityScale(true)
			particle:SetCollide(true)
			particle:SetColor(185,242,255)
		end
		for _ = 1,8 do
			local particle = Emitter:Add("effects/spark",self.EndPos)
			particle:SetVelocity(math.Rand(325,425) *(self.Normal *VectorRand()):GetNormalized())
			particle:SetDieTime(0.1)
			particle:SetStartAlpha(255)
			particle:SetStartSize(4)
			particle:SetEndSize(0)
			particle:SetStartLength(10)
			particle:SetEndLength(0)
			particle:SetColor(185,242,255)
			particle:SetGravity(Vector(0,0,0))
			particle:SetAirResistance(15)
			particle:SetCollide(false)
			particle:SetBounce(0)
		end
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render()
	if !self.DoDraw then return end
	-- render.SetMaterial(self.WarpMat)
	-- render.DrawBeam(self.StartPos,self.EndPos,math.Rand(8,12),math.Rand(0,1),math.Rand(0,1) +((self.StartPos -self.EndPos):Length() /128),Color(255,255,255,255))

	render.SetMaterial(self.MainMat)
	render.DrawBeam(self.StartPos,self.EndPos,math.Rand(18,24),math.Rand(0,1),math.Rand(0,1) +((self.StartPos -self.EndPos):Length() /128),Color(112,238,255,200))

	render.SetMaterial(self.SecondaryMat)
	render.DrawBeam(self.StartPos,self.EndPos,math.Rand(8,12),math.Rand(0,1),math.Rand(0,1) +((self.StartPos -self.EndPos):Length() /128),Color(255,255,255,255))

	render.SetMaterial(self.ImpactMat)
	render.DrawSprite(self.EndPos,math.Rand(24,36),math.Rand(24,36),Color(188,247,255))
end
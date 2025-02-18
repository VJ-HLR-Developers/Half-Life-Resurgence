/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Voltigore Electrical Energy"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlrof_voltigore_energy", ENT.PrintName, VJ.KILLICON_PROJECTILE)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/vj_base/projectiles/spit_acid_large.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 25
ENT.DirectDamageType = DMG_SHOCK
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro4.wav", "vj_hlr/hl1_weapon/gauss/electro5.wav", "vj_hlr/hl1_weapon/gauss/electro6.wav"}
ENT.CollisionDecal = "VJ_HLR_Scorch"
ENT.RemoveDelay = 1

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	
	local sprite = ents.Create("env_sprite")
	sprite:SetKeyValue("model","vj_hl/sprites/flare3.vmt")
	sprite:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	sprite:SetKeyValue("renderfx","14")
	sprite:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	sprite:SetKeyValue("renderamt","255") -- Transparency
	sprite:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	sprite:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	sprite:SetKeyValue("spawnflags","0")
	sprite:SetPos(self:GetPos())
	sprite:SetParent(self)
	sprite:Spawn()
	sprite:Activate()
	self:DeleteOnRemove(sprite)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Vort_DoElecEffect(sp, hp, hn, a, t)
	local elec = EffectData()
	elec:SetStart(sp)
	elec:SetOrigin(hp)
	elec:SetEntity(self)
	elec:SetNormal(hn)
	elec:SetAttachment(a)
	elec:SetScale(0.15)
	util.Effect("VJ_HLR_Electric_Purple", elec)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think() -- Override think because we need it to run while doing delayed remove!
	local myPos = self:GetPos()
	-- Tsakh --------------------------
	local tsakhSpawn = myPos + self:GetUp()*45 + self:GetRight()*20
	for _ = 1, 4 do
		local randt = math.Rand(0, 0.6)
		timer.Simple(randt, function()
			if IsValid(self) then
				local tr = util.TraceLine({
					start = tsakhSpawn,
					endpos = myPos + VectorRand(-150, 150),
					filter = self
				})
				//if tr.Hit == true then
					self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal, 1, randt)
				//end
			end
		end)
	end
	-- Ach --------------------------
	local achSpawn = myPos + self:GetUp()*45 + self:GetRight()*-20
	for _ = 1, 4 do
		local randt = math.Rand(0, 0.6)
		timer.Simple(randt, function()
			if IsValid(self) then
				local tr = util.TraceLine({
					start = achSpawn,
					endpos = myPos + VectorRand(-150, 150),
					filter = self
				})
				//if tr.Hit == true then
					self:Vort_DoElecEffect(tr.StartPos, tr.HitPos, tr.HitNormal, 1, randt)
				//end
			end
		end)
	end
end
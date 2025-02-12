/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Shock Roach Plasma"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "Projectiles"

ENT.PhysicsSolidMask = MASK_SHOT

if CLIENT then
	VJ.AddKillIcon("obj_vj_hlof_shock", ENT.PrintName, VJ.KILLICON_PROJECTILE)
	
	-- net.Receive("vj_hlr_svencoop_glow",function(len,pl)
		-- local Ent = net.ReadEntity()
		-- local Target = net.ReadEntity()
		-- local ENTInd = Target:EntIndex()
		
		-- Target.VJ_HLR_NextEffectBlendT = 0
		-- Target.VJ_HLR_EffectBlend = 1

		-- hook.Add("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd,function()
			-- if !IsValid(Target) then
				-- hook.Remove("RenderScreenspaceEffects","VJ_HLR_Effects" .. ENTInd)
				-- return
			-- end
			-- local EffectTime = 5
			-- local EffectDeathDelay = CurTime() +EffectTime
			-- local EffectBlendAdd = 0.05
			-- if !IsValid(Target) then return end
			-- cam.Start3D(EyePos(),EyeAngles())
				-- if util.IsValidModel(Target:GetModel()) then
					-- render.SetBlend(Target.VJ_HLR_EffectBlend)
					-- render.MaterialOverride(Material("vj_hl/renderfx/render_blue"))
					-- Target:DrawModel()
					-- render.MaterialOverride(0)
					-- render.SetBlend(1)
				-- end
			-- cam.End3D()
			-- cam.Start3D(EyePos(),EyeAngles(),70)
				-- if Target:IsPlayer() && IsValid(Target:GetViewModel()) then
					-- if util.IsValidModel(Target:GetViewModel():GetModel()) then
						-- render.SetBlend(Target.VJ_HLR_EffectBlend)
						-- render.MaterialOverride(Material("vj_hl/renderfx/render_blue"))
						-- Target:GetViewModel():DrawModel()
						-- render.MaterialOverride(0)
						-- render.SetBlend(1)
					-- end
				-- end
			-- cam.End3D()
			-- if CurTime() >= Target.VJ_HLR_NextEffectBlendT then
				-- Target.VJ_HLR_NextEffectBlendT = CurTime() +0.05
				-- if Target.VJ_HLR_EffectBlend > 0 then
					-- if CurTime() >= EffectDeathDelay then
						-- EffectBlendAdd = EffectBlendAdd +math.Clamp(((CurTime() -EffectDeathDelay) /100),0,0.05)
					-- end
					-- Target.VJ_HLR_EffectBlend = Target.VJ_HLR_EffectBlend -(EffectTime /(EffectTime ^2)) *EffectBlendAdd
				-- end
			-- end
		-- end)
	-- end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = "models/weapons/w_missile_launch.mdl"
ENT.DoesDirectDamage = true
ENT.DirectDamage = 10
ENT.DirectDamageType = DMG_SHOCK
ENT.CollisionDecal = "VJ_HLR_Scorch_Small"
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro5.wav", "vj_hlr/hl1_weapon/gauss/electro6.wav"}

//util.AddNetworkString("vj_hlr_svencoop_glow")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetNoDraw(true)
	ParticleEffectAttach("vj_hlr_shockroach", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	
	local lightDyn = ents.Create("light_dynamic")
	lightDyn:SetKeyValue("brightness", "1")
	lightDyn:SetKeyValue("distance", "200")
	lightDyn:SetLocalPos(self:GetPos())
	lightDyn:Fire("Color", "128 255 255")
	lightDyn:SetParent(self)
	lightDyn:Spawn()
	lightDyn:Activate()
	lightDyn:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(lightDyn)
end
---------------------------------------------------------------------------------------------------------------------------------------------
//function ENT:OnDealDamage(data, phys, hitEnts)
//	local ply = player.GetAll()[1]
//    net.Start("vj_hlr_svencoop_glow")
//		net.WriteEntity(self)
//		net.WriteEntity(hitEnts)
//    net.Send(ply)
//end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys)
	local effectData = EffectData()
	effectData:SetOrigin(data.HitPos)
	util.Effect("StunstickImpact", effectData)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "2")
	expLight:SetKeyValue("distance", "400")
	expLight:SetLocalPos(data.HitPos)
	expLight:Fire("Color", "128 255 255")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)
end
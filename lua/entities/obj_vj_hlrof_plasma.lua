/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Shock Roach Plasma"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "Projectiles"

if (CLIENT) then
	local Name = "Shock Trooper"
	local LangName = "obj_vj_hlof_shock"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
	
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
if !(SERVER) then return end

ENT.Model = {"models/weapons/w_missile_launch.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 10 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SHOCK -- Damage type
ENT.DecalTbl_DeathDecals = {"VJ_HLR_Scorch_Small"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_weapon/gauss/electro5.wav","vj_hlr/hl1_weapon/gauss/electro6.wav"}

util.AddNetworkString("vj_hlr_svencoop_glow")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetNoDraw(true)
	ParticleEffectAttach("vj_hl_shockroach",PATTACH_ABSORIGIN_FOLLOW,self,0)
	self.StartLight1 = ents.Create("light_dynamic")
	self.StartLight1:SetKeyValue("brightness", "1")
	self.StartLight1:SetKeyValue("distance", "200")
	self.StartLight1:SetLocalPos(self:GetPos())
	self.StartLight1:SetLocalAngles( self:GetAngles() )
	self.StartLight1:Fire("Color", "0 255 255")
	self.StartLight1:SetParent(self)
	self.StartLight1:Spawn()
	self.StartLight1:Activate()
	self.StartLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.StartLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data,phys,hitEnt)
	-- local ply = player.GetAll()[1]
    -- net.Start("vj_hlr_svencoop_glow")
		-- net.WriteEntity(self)
		-- net.WriteEntity(hitEnt)
    -- net.Send(ply)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	local effectdata = EffectData()
	effectdata:SetOrigin(data.HitPos)
	util.Effect("StunstickImpact", effectdata)

	local expLight = ents.Create("light_dynamic")
	expLight:SetKeyValue("brightness", "2")
	expLight:SetKeyValue("distance", "400")
	expLight:SetLocalPos(data.HitPos)
	expLight:SetLocalAngles(self:GetAngles())
	expLight:Fire("Color", "0 255 255")
	expLight:SetParent(self)
	expLight:Spawn()
	expLight:Activate()
	expLight:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(expLight)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
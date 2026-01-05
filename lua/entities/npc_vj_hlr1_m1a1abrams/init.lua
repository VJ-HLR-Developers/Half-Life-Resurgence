AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/tank_body_destroyed.mdl"
ENT.StartHealth = 500
ENT.ControllerParams = {
    ThirdP_Offset = Vector(-20, 0, 40),
    FirstP_Bone = "static_prop",
    FirstP_Offset = Vector(00, 0, 130),
	FirstP_ShrinkBone = false,
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"}

ENT.SoundTbl_Breath = "vj_hlr/gsrc/npc/tanks/abrams_idle_loop.wav"
ENT.SoundTbl_Idle = {"vj_hlr/gsrc/npc/hgrunt/gr_idle1.wav", "vj_hlr/gsrc/npc/hgrunt/gr_idle2.wav", "vj_hlr/gsrc/npc/hgrunt/gr_idle3.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/gsrc/npc/hgrunt/gr_taunt1.wav", "vj_hlr/gsrc/npc/hgrunt/gr_taunt2.wav", "vj_hlr/gsrc/npc/hgrunt/gr_taunt3.wav", "vj_hlr/gsrc/npc/hgrunt/gr_taunt4.wav", "vj_hlr/gsrc/npc/hgrunt/gr_taunt5.wav", "vj_hlr/gsrc/npc/hgrunt/gr_combat1.wav", "vj_hlr/gsrc/npc/hgrunt/gr_combat2.wav", "vj_hlr/gsrc/npc/hgrunt/gr_combat3.wav", "vj_hlr/gsrc/npc/hgrunt/gr_combat4.wav"}
ENT.SoundTbl_ReceiveOrder = {"vj_hlr/gsrc/npc/hgrunt/gr_answer1.wav", "vj_hlr/gsrc/npc/hgrunt/gr_answer2.wav", "vj_hlr/gsrc/npc/hgrunt/gr_answer3.wav", "vj_hlr/gsrc/npc/hgrunt/gr_answer5.wav", "vj_hlr/gsrc/npc/hgrunt/gr_answer7.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/gsrc/npc/hgrunt/gr_investigate.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/gsrc/npc/hgrunt/gr_alert1.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert2.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert3.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert4.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert5.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert6.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert7.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert8.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert9.wav", "vj_hlr/gsrc/npc/hgrunt/gr_alert10.wav"}
ENT.SoundTbl_CallForHelp = {"vj_hlr/gsrc/npc/hgrunt/gr_taunt6.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover2.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover3.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover4.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover7.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/gsrc/npc/hgrunt/gr_allydeath.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover2.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover3.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover4.wav", "vj_hlr/gsrc/npc/hgrunt/gr_cover7.wav"}
ENT.SoundTbl_Death = {"vj_hlr/gsrc/wep/explosion/explode3.wav", "vj_hlr/gsrc/wep/explosion/explode4.wav", "vj_hlr/gsrc/wep/explosion/explode5.wav"}

-- Tank Base
ENT.Tank_SoundTbl_DrivingEngine = "vj_hlr/gsrc/npc/tanks/tankdrive.wav"
ENT.Tank_SoundTbl_Track = "vj_hlr/gsrc/npc/tanks/tanktrack.wav"

ENT.Tank_GunnerENT = "npc_vj_hlr1_m1a1abrams_gun"
ENT.Tank_CollisionBoundSize = 110
ENT.Tank_CollisionBoundUp = 90
ENT.Tank_DeathDriverCorpse = "models/vj_hlr/hl1/hgrunt.mdl"
ENT.Tank_DeathDecal = "VJ_HLR1_Scorch"

-- Custom
ENT.Bradley_DmgForce = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos() + self:GetUp()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_UpdateMoveParticles()
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetEntity(self)
	effectData:SetOrigin(self:GetPos() + self:GetForward() * -180 + self:GetRight() * 80)
	util.Effect("VJ_VehicleMove", effectData, true, true)
	effectData:SetOrigin(self:GetPos() + self:GetForward() * -180 + self:GetRight() * -80)
	util.Effect("VJ_VehicleMove", effectData, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randPos = math.random(1, 5)
	if randPos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*15 + self:GetForward()*-16 + self:GetUp()*100)
	elseif randPos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 3 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 4 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*105 + self:GetForward()*-40 + self:GetUp()*50)
	elseif randPos == 5 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-105 + self:GetForward()*-40 + self:GetUp()*50)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local expPos = Vector(0, 0, 150)
--
function ENT:Tank_OnInitialDeath(dmginfo, hitgroup)
	self.Bradley_DmgForce = dmginfo:GetDamageForce()
	for i=0, 1, 0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
				VJ.EmitSound(self, self.SoundTbl_Death, 100)
				VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris" .. math.random(1, 3) .. ".wav", 100)
				VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/explode" .. math.random(3, 5) .. "_dist.wav", 140, 100)
				util.BlastDamage(self, self, self:GetPos(), 200, 40)
				util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
				
				local spr = ents.Create("env_sprite")
				spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
				spr:SetKeyValue("GlowProxySize", "2.0")
				spr:SetKeyValue("HDRColorScale", "1.0")
				spr:SetKeyValue("renderfx", "14")
				spr:SetKeyValue("rendermode", "5")
				spr:SetKeyValue("renderamt", "255")
				spr:SetKeyValue("disablereceiveshadows", "0")
				spr:SetKeyValue("mindxlevel", "0")
				spr:SetKeyValue("maxdxlevel", "0")
				spr:SetKeyValue("framerate", "15.0")
				spr:SetKeyValue("spawnflags", "0")
				spr:SetKeyValue("scale", "4")
				spr:SetPos(self:GetPos() + expPos)
				spr:Spawn()
				spr:Fire("Kill", "", 0.9)
				timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
			end
		end)
	end
	
	timer.Simple(1.5, function()
		if IsValid(self) then
			VJ.EmitSound(self, self.SoundTbl_Death, 100)
			util.BlastDamage(self, self, self:GetPos(), 200, 40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/debris" .. math.random(1, 3) .. ".wav", 100)
			VJ.EmitSound(self, "vj_hlr/gsrc/wep/explosion/explode" .. math.random(3, 5) .. "_dist.wav", 140, 100)
			local spr = ents.Create("env_sprite")
			spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
			spr:SetKeyValue("GlowProxySize", "2.0")
			spr:SetKeyValue("HDRColorScale", "1.0")
			spr:SetKeyValue("renderfx", "14")
			spr:SetKeyValue("rendermode", "5")
			spr:SetKeyValue("renderamt", "255")
			spr:SetKeyValue("disablereceiveshadows", "0")
			spr:SetKeyValue("mindxlevel", "0")
			spr:SetKeyValue("maxdxlevel", "0")
			spr:SetKeyValue("framerate", "15.0")
			spr:SetKeyValue("spawnflags", "0")
			spr:SetKeyValue("scale", "4")
			spr:SetPos(self:GetPos() + expPos)
			spr:Spawn()
			spr:Fire("Kill", "", 0.9)
			timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
		end
	end)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Init" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local metalCollideSD = {"vj_hlr/gsrc/fx/metal1.wav", "vj_hlr/gsrc/fx/metal2.wav", "vj_hlr/gsrc/fx/metal3.wav", "vj_hlr/gsrc/fx/metal4.wav", "vj_hlr/gsrc/fx/metal5.wav"}
--
function ENT:Tank_OnDeathCorpse(dmginfo, hitgroup, corpse, status, statusData)
	if status == "Override" then
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 81)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 82)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 83)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 84)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 85)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 86)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 87)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 88)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 89)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 90)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 91)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 92)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 93)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 94)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 95)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 96)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 97)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 98)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 0, 99)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 0, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11_g.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(1, 1, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog1.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 1, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog2.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 2, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_rib.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 3, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 4, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 5, 80)), CollisionSound = metalCollideSD})
		self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {CollisionDecal = false, Pos = self:LocalToWorld(Vector(0, 6, 80)), CollisionSound = metalCollideSD})
		util.BlastDamage(self, self, self:GetPos() + self:GetUp()*80, 200, 10)
	elseif status == "Soldier" then
		statusData:SetSkin(math.random(0, 1))
		statusData:SetBodygroup(2, 2)
	elseif status == "Effects" then
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/zerogxplode.vmt")
		spr:SetKeyValue("GlowProxySize", "2.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "5")
		spr:SetKeyValue("renderamt", "255")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "15.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "4")
		spr:SetPos(self:GetPos() + expPos)
		spr:Spawn()
		spr:Fire("Kill", "", 0.9)
		timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
		return true
	end
end
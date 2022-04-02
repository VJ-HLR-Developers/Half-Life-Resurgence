AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/tank_body_destroyed.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 500
ENT.VJC_Data = {
    ThirdP_Offset = Vector(-20, 0, 40), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "static _prop", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 50), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other\

ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/tanks/abrams_idle_loop.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/hgrunt/gr_idle1.wav","vj_hlr/hl1_npc/hgrunt/gr_idle2.wav","vj_hlr/hl1_npc/hgrunt/gr_idle3.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/hgrunt/gr_taunt1.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt2.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt3.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt4.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt5.wav","vj_hlr/hl1_npc/hgrunt/gr_combat1.wav","vj_hlr/hl1_npc/hgrunt/gr_combat2.wav","vj_hlr/hl1_npc/hgrunt/gr_combat3.wav","vj_hlr/hl1_npc/hgrunt/gr_combat4.wav"}
ENT.SoundTbl_OnReceiveOrder = {"vj_hlr/hl1_npc/hgrunt/gr_answer1.wav","vj_hlr/hl1_npc/hgrunt/gr_answer2.wav","vj_hlr/hl1_npc/hgrunt/gr_answer3.wav","vj_hlr/hl1_npc/hgrunt/gr_answer5.wav","vj_hlr/hl1_npc/hgrunt/gr_answer7.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/hl1_npc/hgrunt/gr_investigate.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/hgrunt/gr_alert1.wav","vj_hlr/hl1_npc/hgrunt/gr_alert2.wav","vj_hlr/hl1_npc/hgrunt/gr_alert3.wav","vj_hlr/hl1_npc/hgrunt/gr_alert4.wav","vj_hlr/hl1_npc/hgrunt/gr_alert5.wav","vj_hlr/hl1_npc/hgrunt/gr_alert6.wav","vj_hlr/hl1_npc/hgrunt/gr_alert7.wav","vj_hlr/hl1_npc/hgrunt/gr_alert8.wav","vj_hlr/hl1_npc/hgrunt/gr_alert9.wav","vj_hlr/hl1_npc/hgrunt/gr_alert10.wav"}
ENT.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/hgrunt/gr_taunt6.wav","vj_hlr/hl1_npc/hgrunt/gr_cover2.wav","vj_hlr/hl1_npc/hgrunt/gr_cover3.wav","vj_hlr/hl1_npc/hgrunt/gr_cover4.wav","vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/hgrunt/gr_allydeath.wav","vj_hlr/hl1_npc/hgrunt/gr_cover2.wav","vj_hlr/hl1_npc/hgrunt/gr_cover3.wav","vj_hlr/hl1_npc/hgrunt/gr_cover4.wav","vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"}

-- Tank Base
ENT.Tank_SoundTbl_DrivingEngine = {"vj_hlr/hl1_npc/tanks/tankdrive.wav"}
ENT.Tank_SoundTbl_Track = {"vj_hlr/hl1_npc/tanks/tanktrack.wav"}

ENT.Tank_GunnerENT = "npc_vj_hlr1_m1a1abrams_gun"
ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_CollisionBoundSize = 110
ENT.Tank_CollisionBoundUp = 90
ENT.Tank_DeathSoldierModels = {"models/vj_hlr/hl1/hgrunt.mdl"} -- The corpses it will spawn on death (Example: A soldier) | false = Don't spawn anything
ENT.Tank_DeathDecal = {"VJ_HLR_Scorch"} -- The decal that it places on the ground when it dies

util.AddNetworkString("vj_hlr1_m1a1abrams_moveeffects")

-- Custom
ENT.Bradley_DmgForce = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos() + self:GetUp()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMoveEffects()
	net.Start("vj_hlr1_m1a1abrams_moveeffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randpos = math.random(1,5)
	if randpos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*15 + self:GetForward()*-16 + self:GetUp()*100)
	elseif randpos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randpos == 3 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randpos == 4 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*105 + self:GetForward()*-40 + self:GetUp()*50)
	elseif randpos == 5 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-105 + self:GetForward()*-40 + self:GetUp()*50)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local expPos = Vector(0, 0, 150)
--
function ENT:Tank_CustomOnPriorToKilled(dmginfo, hitgroup)
	self.Bradley_DmgForce = dmginfo:GetDamageForce()
	for i=0,1,0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
				VJ_EmitSound(self, self.SoundTbl_Death, 100)
				VJ_EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris"..math.random(1,3)..".wav", 100)
				util.BlastDamage(self, self, self:GetPos(), 200, 40)
				util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
				
				local spr = ents.Create("env_sprite")
				spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
				spr:SetKeyValue("GlowProxySize","2.0")
				spr:SetKeyValue("HDRColorScale","1.0")
				spr:SetKeyValue("renderfx","14")
				spr:SetKeyValue("rendermode","5")
				spr:SetKeyValue("renderamt","255")
				spr:SetKeyValue("disablereceiveshadows","0")
				spr:SetKeyValue("mindxlevel","0")
				spr:SetKeyValue("maxdxlevel","0")
				spr:SetKeyValue("framerate","15.0")
				spr:SetKeyValue("spawnflags","0")
				spr:SetKeyValue("scale","4")
				spr:SetPos(self:GetPos() + expPos)
				spr:Spawn()
				spr:Fire("Kill","",0.9)
				timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
			end
		end)
	end
	
	timer.Simple(1.5, function()
		if IsValid(self) then
			VJ_EmitSound(self, self.SoundTbl_Death, 100)
			util.BlastDamage(self, self, self:GetPos(), 200, 40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			
			local spr = ents.Create("env_sprite")
			spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
			spr:SetKeyValue("GlowProxySize","2.0")
			spr:SetKeyValue("HDRColorScale","1.0")
			spr:SetKeyValue("renderfx","14")
			spr:SetKeyValue("rendermode","5")
			spr:SetKeyValue("renderamt","255")
			spr:SetKeyValue("disablereceiveshadows","0")
			spr:SetKeyValue("mindxlevel","0")
			spr:SetKeyValue("maxdxlevel","0")
			spr:SetKeyValue("framerate","15.0")
			spr:SetKeyValue("spawnflags","0")
			spr:SetKeyValue("scale","4")
			spr:SetPos(self:GetPos() + expPos)
			spr:Spawn()
			spr:Fire("Kill","",0.9)
			timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
		end
	end)
	return false
end
local vec = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	if dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico",rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p1_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p2_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,81)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p3_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,82)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p4_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,83)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,84)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,85)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,86)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,87)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p9_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,88)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p10_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,89)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p11_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,90)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p1_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,91)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p2_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,92)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p3_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,93)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p4_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,94)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p5_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,95)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p6_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,96)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p7_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,97)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p8_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,98)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p9_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,99)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p10_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/metalgib_p11_g.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,0,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog1.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,1,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_cog2.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,2,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_rib.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,3,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,4,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,5,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/rgib_screw.mdl",{BloodDecal="",Pos=self:LocalToWorld(Vector(0,6,80)),CollideSound={"vj_hlr/fx/metal1.wav","vj_hlr/fx/metal2.wav","vj_hlr/fx/metal3.wav","vj_hlr/fx/metal4.wav","vj_hlr/fx/metal5.wav"}})
	util.BlastDamage(self, self, self:GetPos() + self:GetUp()*80, 200, 10)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterDeathSoldierSpawned(dmginfo, hitgroup, soldierCorpse)
	soldierCorpse:SetSkin(math.random(0, 1))
	soldierCorpse:SetBodygroup(2, 2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned_Effects(dmginfo, hitgroup, corpseEnt)
	local spr = ents.Create("env_sprite")
	spr:SetKeyValue("model","vj_hl/sprites/zerogxplode.vmt")
	spr:SetKeyValue("GlowProxySize","2.0")
	spr:SetKeyValue("HDRColorScale","1.0")
	spr:SetKeyValue("renderfx","14")
	spr:SetKeyValue("rendermode","5")
	spr:SetKeyValue("renderamt","255")
	spr:SetKeyValue("disablereceiveshadows","0")
	spr:SetKeyValue("mindxlevel","0")
	spr:SetKeyValue("maxdxlevel","0")
	spr:SetKeyValue("framerate","15.0")
	spr:SetKeyValue("spawnflags","0")
	spr:SetKeyValue("scale","4")
	spr:SetPos(self:GetPos() + expPos)
	spr:Spawn()
	spr:Fire("Kill","",0.9)
	timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
	return false
end
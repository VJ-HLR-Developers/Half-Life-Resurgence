AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/hl1/apc_body.mdl" -- Model(s) to spawn with | Picks a random one if it's a table 
ENT.StartHealth = 350
ENT.VJC_Data = {
    ThirdP_Offset = Vector(-40, 0, 20), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "static_prop", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 40), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = false, -- Should the bone shrink? Useful if the bone is obscuring the player's view
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other
ENT.DeathCorpseModel = "models/vj_hlr/hl1/apc_body_destroyed.mdl" -- Model(s) to spawn as the NPC's corpse | false = Use the NPC's model | Can be a single string or a table of strings

ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/tanks/bradley_idle.wav"}
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

ENT.Tank_GunnerENT = "npc_vj_hlr1_m2a3bradley_gun"
ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 130
ENT.Tank_DeathSoldierModels = {"models/vj_hlr/hl1/hGrunt.mdl"} -- The corpses it will spawn on death (Example: A soldier) | false = Don't spawn anything
ENT.Tank_DeathDecal = {"VJ_HLR_Scorch"} -- The decal that it places on the ground when it dies

util.AddNetworkString("vj_hlr1_m2a3bradley_moveeffects")

-- Custom
ENT.Bradley_DmgForce = 0
ENT.Bradley_DoorOpen = false
ENT.Bradley_HasSpawnedSoldiers = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank()
	self:SetSkin(math.random(0, 1))
	self.Bradley_Grunts = {}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("JUMP: Deploy human grunt squad (1 time)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE && self.Bradley_DoorOpen then
		return ACT_IDLE_RELAXED
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos() + self:GetRight()*16 + self:GetForward()*-8 + self:GetUp()*100
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMoveEffects()
	net.Start("vj_hlr1_m2a3bradley_moveeffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThink()
	-- If moving then close the door
	if self.Tank_Status == 0 && self.Bradley_DoorOpen then
		self.Bradley_DoorOpen = false
		self:VJ_ACT_PLAYACTIVITY(ACT_SPECIAL_ATTACK2, true, false, false)
	end
	
	-- Deploy soldiers
	if self.Tank_Status == 1 && !self.Bradley_HasSpawnedSoldiers && !self.Bradley_DoorOpen && IsValid(self:GetEnemy()) && GetConVar("vj_hlr1_bradley_deploygrunts"):GetInt() == 1 && ((!self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.VJ_TheController:KeyDown(IN_JUMP))) then
		self.Bradley_DoorOpen = true
		self:VJ_ACT_PLAYACTIVITY(ACT_SPECIAL_ATTACK1, true, false, false)
		self.Bradley_HasSpawnedSoldiers = true
		timer.Simple(0.5, function()
			if IsValid(self) then
				if self.Bradley_DoorOpen == false then -- Door was suddenly closed, so try again later
					self.Bradley_HasSpawnedSoldiers = false
				else
					local ene = self:GetEnemy()
					for i = 1, 6 do
						local hGrunt = ents.Create("npc_vj_hlr1_hgrunt")
						local opSide = ((i % 2 == 0) and -25) or 25 -- Make every other grunt spawn to the opposite side
						hGrunt:SetPos(self:GetPos() + self:GetForward()*(i <= 2 and -160 or (i <= 4 and -220 or -290)) + self:GetRight()*opSide + self:GetUp()*5)
						hGrunt:SetAngles(Angle(0, self:GetAngles().y + 180, 0))
						hGrunt.VJ_NPC_Class = self.VJ_NPC_Class
						hGrunt:Spawn()
						hGrunt:VJ_DoSetEnemy(ene, true)
						hGrunt:SetState(VJ_STATE_FREEZE)
						timer.Simple(0.2, function()
							if IsValid(hGrunt) then
								hGrunt:SetState(VJ_STATE_NONE)
								hGrunt:SetLastPosition(hGrunt:GetPos() + hGrunt:GetForward()*150 + hGrunt:GetRight()*opSide)
								hGrunt:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
							end
						end)
						self.Bradley_Grunts[#self.Bradley_Grunts + 1] = hGrunt -- Register the grunt
					end
				end
			end
		end)
	end
	
	-- Keep the skin of the gunner the same!
	if IsValid(self.Gunner) then
		self.Gunner:SetSkin(self:GetSkin())
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec = Vector(0, 0, 0)
--
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "Initial" && dmginfo:GetDamagePosition() != vec then
		local rico = EffectData()
		rico:SetOrigin(dmginfo:GetDamagePosition())
		rico:SetScale(5) -- Size
		rico:SetMagnitude(math.random(1, 2)) -- Effect type | 1 = Animated | 2 = Basic
		util.Effect("VJ_HLR_Rico", rico)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randPos = math.random(1, 5)
	if randPos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*15 + self:GetForward()*-16 + self:GetUp()*120)
	elseif randPos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 3 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randPos == 4 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*60 + self:GetForward()*-40 + self:GetUp()*81)
	elseif randPos == 5 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-60 + self:GetForward()*-40 + self:GetUp()*81)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local expPos = Vector(0, 0, 150)
--
function ENT:Tank_OnInitialDeath(dmginfo, hitgroup)
	self.Bradley_DmgForce = dmginfo:GetDamageForce()
	for i=0,1,0.5 do
		timer.Simple(i, function()
			if IsValid(self) then
				VJ.EmitSound(self, self.SoundTbl_Death, 100)
				VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/debris"..math.random(1,3)..".wav", 100)
				VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3,5).."_dist.wav", 140, 100)
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
			VJ.EmitSound(self, self.SoundTbl_Death, 100)
			util.BlastDamage(self, self, self:GetPos(), 200, 40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			VJ.EmitSound(self, "vj_hlr/hl1_weapon/explosion/explode"..math.random(3,5).."_dist.wav", 140, 100)
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
---------------------------------------------------------------------------------------------------------------------------------------------
local metalCollideSD = {"vj_hlr/fx/metal1.wav", "vj_hlr/fx/metal2.wav", "vj_hlr/fx/metal3.wav", "vj_hlr/fx/metal4.wav", "vj_hlr/fx/metal5.wav"}
--
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	self:CreateExtraDeathCorpse("prop_physics", "models/vj_hlr/hl1/apc_door.mdl", {Pos=corpseEnt:GetPos() + corpseEnt:GetUp()*30 + corpseEnt:GetForward()*-130, Vel=self.Bradley_DmgForce / 55}, function(extraent) extraent:SetSkin(corpseEnt:GetSkin()) extraent:SetCollisionGroup(0) end)
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 90)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 91)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 92)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 93)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 94)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 95)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 96)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 97)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 98)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 99)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 100)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p1.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 101)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p2.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 102)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p3.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 103)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p4.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 104)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p5.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 105)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p6.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 106)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p7.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 107)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p8.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 108)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p9.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 0, 109)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p10.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(1, 0, 90)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/metalgib_p11.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(1, 1, 90)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog1.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 1, 80)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_cog2.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 2, 80)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_rib.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 3, 80)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 4, 80)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 5, 80)), CollideSound=metalCollideSD})
	self:CreateGibEntity("obj_vj_gib", "models/vj_hlr/gibs/rgib_screw.mdl", {BloodDecal="", Pos=self:LocalToWorld(Vector(0, 6, 80)), CollideSound=metalCollideSD})
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
	timer.Simple(0.9, function() if IsValid(spr) then spr:Remove() end end)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	-- If the NPC was removed, then remove its children as well, but not when it's killed!
	if !self.Dead then
		for _, v in ipairs(self.Bradley_Grunts) do
			if IsValid(v) then v:Remove() end
		end
	end
end
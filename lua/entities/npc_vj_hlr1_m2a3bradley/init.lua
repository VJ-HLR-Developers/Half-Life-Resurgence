AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/apc_body.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 350
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_UNITED_STATES"} -- NPCs with the same class with be allied to each other\
ENT.DeathCorpseModel = {"models/vj_hlr/hl1/apc_body_destroyed.mdl"} -- The corpse model that it will spawn when it dies | Leave empty to use the NPC's model | Put as many models as desired, the base will pick a random one.

ENT.SoundTbl_Breath = {"vj_hlr/hl1_npc/tanks/bradley_idle.wav"}
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/hgrunt/gr_idle1.wav","vj_hlr/hl1_npc/hgrunt/gr_idle2.wav","vj_hlr/hl1_npc/hgrunt/gr_idle3.wav"}
ENT.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/hgrunt/gr_taunt1.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt2.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt3.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt4.wav","vj_hlr/hl1_npc/hgrunt/gr_taunt5.wav","vj_hlr/hl1_npc/hgrunt/gr_combat1.wav","vj_hlr/hl1_npc/hgrunt/gr_combat2.wav","vj_hlr/hl1_npc/hgrunt/gr_combat3.wav","vj_hlr/hl1_npc/hgrunt/gr_combat4.wav"}
ENT.SoundTbl_OnReceiveOrder = {"vj_hlr/hl1_npc/hgrunt/gr_answer1.wav","vj_hlr/hl1_npc/hgrunt/gr_answer2.wav","vj_hlr/hl1_npc/hgrunt/gr_answer3.wav","vj_hlr/hl1_npc/hgrunt/gr_answer5.wav","vj_hlr/hl1_npc/hgrunt/gr_answer7.wav"}
ENT.SoundTbl_Investigate = {"vj_hlr/hl1_npc/hgrunt/gr_investigate.wav"}
ENT.SoundTbl_Alert = {"vj_hlr/hl1_npc/hgrunt/gr_alert1.wav","vj_hlr/hl1_npc/hgrunt/gr_alert2.wav","vj_hlr/hl1_npc/hgrunt/gr_alert3.wav","vj_hlr/hl1_npc/hgrunt/gr_alert4.wav","vj_hlr/hl1_npc/hgrunt/gr_alert5.wav","vj_hlr/hl1_npc/hgrunt/gr_alert6.wav","vj_hlr/hl1_npc/hgrunt/gr_alert7.wav","vj_hlr/hl1_npc/hgrunt/gr_alert8.wav","vj_hlr/hl1_npc/hgrunt/gr_alert9.wav","vj_hlr/hl1_npc/hgrunt/gr_alert10.wav"}
ENT.SoundTbl_CallForHelp = {"vj_hlr/hl1_npc/hgrunt/gr_taunt6.wav","vj_hlr/hl1_npc/hgrunt/gr_cover2.wav","vj_hlr/hl1_npc/hgrunt/gr_cover3.wav","vj_hlr/hl1_npc/hgrunt/gr_cover4.wav","vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
ENT.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/hgrunt/gr_cover7.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert1.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert2.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert3.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert4.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert5.wav","vj_hlr/hl1_npc/hgrunt/gr_grenadealert6.wav","vj_hlr/hl1_npc/hgrunt/gr_cover1.wav"}
ENT.SoundTbl_AllyDeath = {"vj_hlr/hl1_npc/hgrunt/gr_allydeath.wav","vj_hlr/hl1_npc/hgrunt/gr_cover2.wav","vj_hlr/hl1_npc/hgrunt/gr_cover3.wav","vj_hlr/hl1_npc/hgrunt/gr_cover4.wav","vj_hlr/hl1_npc/hgrunt/gr_cover7.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"}

-- Tank Base
ENT.Tank_SoundTbl_DrivingEngine = {"vj_hlr/hl1_npc/tanks/tankdrive.wav"}
ENT.Tank_SoundTbl_Track = {"vj_hlr/hl1_npc/tanks/tanktrack.wav"}

ENT.Tank_GunnerENT = "npc_vj_hlr1_m2a3bradley_gun"
ENT.Tank_SpawningAngle = 0
ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_MoveAwaySpeed = 70 -- Move away speed
ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 130
ENT.Tank_DeathSoldierModels = {"models/vj_hlr/hl1/hgrunt.mdl"} -- The corpses it will spawn on death (Example: A soldier) | false = Don't spawn anything
ENT.Tank_DeathDecal = {"VJ_HLR_Scorch"} -- The decal that it places on the ground when it dies

util.AddNetworkString("vj_hlr1_m2a3bradley_moveeffects")

-- Custom
ENT.Bradley_DmgForce = 0
ENT.Bradley_DoorOpen = false
ENT.Bradley_HasSpawnedSoldiers = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank()
	self:SetSkin(math.random(0,1))
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
function ENT:Tank_CustomOnThink()
	if self.Tank_Status == 0 && self.Bradley_DoorOpen == true then
		self.Bradley_DoorOpen = false
		self:VJ_ACT_PLAYACTIVITY(ACT_SPECIAL_ATTACK2,true,false,false)
		self.AnimTbl_IdleStand = {ACT_IDLE}
	end
	if self.Tank_Status == 1 && self.Bradley_HasSpawnedSoldiers == false && IsValid(self:GetEnemy()) && self.Bradley_DoorOpen == false then
		self.Bradley_DoorOpen = true
		self.AnimTbl_IdleStand = {ACT_IDLE_RELAXED}
		self:VJ_ACT_PLAYACTIVITY(ACT_SPECIAL_ATTACK1,true,false,false)
		self.Bradley_HasSpawnedSoldiers = true
		timer.Simple(0.5,function()
			if IsValid(self) then
				if self.Bradley_DoorOpen == false then
					self.Bradley_HasSpawnedSoldiers = false
				else
					for i=1,2 do
						local hgrunt = ents.Create("npc_vj_hlr1_hgrunt")
						local rnum = 25
						if i == 2 then rnum = -25 end
						hgrunt:SetPos(self:GetPos() + self:GetForward()*-150 + self:GetRight()*rnum + self:GetUp()*10)
						hgrunt:SetAngles(-self:GetAngles())
						hgrunt:Spawn()
						hgrunt:VJ_DoSetEnemy(self:GetEnemy(),true)
						timer.Simple(0.2,function() if IsValid(hgrunt) then hgrunt:SetLastPosition(self:GetPos() + self:GetForward()*-280 + self:GetRight()*rnum); hgrunt:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH") end end)
					end
					for i=1,2 do
						local hgrunt = ents.Create("npc_vj_hlr1_hgrunt")
						local rnum = 25
						if i == 2 then rnum = -25 end
						hgrunt:SetPos(self:GetPos() + self:GetForward()*-220 + self:GetRight()*rnum + self:GetUp()*5)
						hgrunt:SetAngles(-self:GetAngles())
						hgrunt:Spawn()
						hgrunt:VJ_DoSetEnemy(self:GetEnemy(),true)
						timer.Simple(0.2,function() if IsValid(hgrunt) then hgrunt:SetLastPosition(self:GetPos() + self:GetForward()*-370 + self:GetRight()*rnum); hgrunt:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH") end end)
					end
					for i=1,2 do
						local hgrunt = ents.Create("npc_vj_hlr1_hgrunt")
						local rnum = 25
						if i == 2 then rnum = -25 end
						hgrunt:SetPos(self:GetPos() + self:GetForward()*-290 + self:GetRight()*rnum + self:GetUp()*5)
						hgrunt:SetAngles(-self:GetAngles())
						hgrunt:Spawn()
						hgrunt:VJ_DoSetEnemy(self:GetEnemy(),true)
						timer.Simple(0.2,function() if IsValid(hgrunt) then hgrunt:SetLastPosition(self:GetPos() + self:GetForward()*-440 + self:GetRight()*rnum); hgrunt:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH") end end)
					end
				end
			end
		end)
	end
	if IsValid(self.Gunner) then
		self.Gunner:SetSkin(self:GetSkin())
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randpos = math.random(1,5)
	if randpos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*15 + self:GetForward()*-16 + self:GetUp()*120)
	elseif randpos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randpos == 3 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-42 + self:GetForward()*123 + self:GetUp()*50)
	elseif randpos == 4 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*60 + self:GetForward()*-40 + self:GetUp()*81)
	elseif randpos == 5 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetRight()*-60 + self:GetForward()*-40 + self:GetUp()*81)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnPriorToKilled(dmginfo,hitgroup)
	self.Bradley_DmgForce = dmginfo:GetDamageForce()
	for i=0,1,0.5 do
		timer.Simple(i,function()
			if IsValid(self) then
				VJ_EmitSound(self,{"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"},100)
				VJ_EmitSound(self,"vj_hlr/hl1_weapon/explosion/debris"..math.random(1,3)..".wav",100)
				util.BlastDamage(self,self,self:GetPos(),200,40)
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
				spr:SetPos(self:GetPos() + Vector(0,0,150))
				spr:Spawn()
				spr:Fire("Kill","",0.9)
				timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
			end
		end)
	end
	
	timer.Simple(1.5,function()
		if IsValid(self) then
			VJ_EmitSound(self,{"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"},100)
			util.BlastDamage(self,self,self:GetPos(),200,40)
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
			spr:SetPos(self:GetPos() + Vector(0,0,150))
			spr:Spawn()
			spr:Fire("Kill","",0.9)
			timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
		end
	end)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	self:CreateExtraDeathCorpse("prop_physics", "models/vj_hlr/hl1/apc_door.mdl", {Pos=GetCorpse:GetPos() + GetCorpse:GetUp()*30 + GetCorpse:GetForward()*-130, Vel=self.Bradley_DmgForce / 55}, function(extraent) extraent:SetSkin(GetCorpse:GetSkin()) extraent:SetCollisionGroup(0) end)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterDeathSoldierSpawned(dmginfo,hitgroup,SoldierCorpse)
	SoldierCorpse:SetSkin(math.random(0,1))
	SoldierCorpse:SetBodygroup(2,2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned_Effects(dmginfo,hitgroup,GetCorpse)
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
	spr:SetPos(self:GetPos() + Vector(0,0,150))
	spr:Spawn()
	spr:Fire("Kill","",0.9)
	timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
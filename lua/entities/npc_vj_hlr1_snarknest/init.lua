AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/sqknest.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 20
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_SNARK"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Particle = {"vj_hl_blood_yellow"}
ENT.CustomBlood_Decal = {"VJ_HLR_Blood_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Behavior = VJ_BEHAVIOR_PASSIVE -- The behavior of the SNPC
ENT.AnimTbl_Run = {ACT_WALK} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_hlr/hl1_npc/squeek/sqk_hunt1.wav","vj_hlr/hl1_npc/squeek/sqk_hunt2.wav","vj_hlr/hl1_npc/squeek/sqk_hunt3.wav"}
ENT.SoundTbl_Death = {"vj_hlr/hl1_npc/squeek/sqk_blast1.wav"}

ENT.IdleSoundLevel = 65
ENT.GeneralSoundPitch1 = 50

-- Custom
ENT.BugType = "npc_vj_hlr1_snark"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(15, 15, 18), Vector(-15, -15, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if self.Snark_Type == 0 then
		util.VJ_SphereDamage(self,self,self:GetPos(),50,15,DMG_ACID,true,true)
		if self.BugType == "npc_vj_hlr1_snark" then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
			bloodeffect:SetScale(40)
			util.Effect("VJ_Blood1",bloodeffect)
			
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodspray:SetScale(6)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(1)
			util.Effect("bloodspray",bloodspray)
			util.Effect("bloodspray",bloodspray)
			
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos() + self:OBBCenter())
			effectdata:SetScale(0.4)
			util.Effect("StriderBlood",effectdata)
			util.Effect("StriderBlood",effectdata)
		end
	elseif self.BugType == "npc_vj_hlrof_penguin" then
		VJ_EmitSound(self,{"vj_hlr/hl1_weapon/explosion/explode3.wav","vj_hlr/hl1_weapon/explosion/explode4.wav","vj_hlr/hl1_weapon/explosion/explode5.wav"},90)
		util.BlastDamage(self,self,self:GetPos(),80,35)
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(40)
			util.Effect("VJ_Blood1",bloodeffect)
			
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos() + self:OBBCenter())
			bloodspray:SetScale(6)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("bloodspray",bloodspray)
			util.Effect("bloodspray",bloodspray)
			
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
			spr:SetPos(self:GetPos() + self:GetUp()*80)
			spr:Spawn()
			spr:Fire("Kill","",0.9)
			timer.Simple(0.9,function() if IsValid(spr) then spr:Remove() end end)
		end
	end
	
	if math.random(1,1000) == 1 then
		if self.BugType == "npc_vj_hlr1_snark" then
			self.BugType = "npc_vj_hlrof_penguin"
		elseif self.BugType == "npc_vj_hlrof_penguin" then
			self.BugType = "npc_vj_hlr1_snark"
		end
	end
	
	for i = 1,math.random(4,8) do
		local ent = ents.Create(self.BugType)
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:SetVelocity(self:GetUp()*math.Rand(250,350) + self:GetRight()*math.Rand(-100,100) + self:GetForward()*math.Rand(-100,100))
		ent:Spawn()
		ent:Activate()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
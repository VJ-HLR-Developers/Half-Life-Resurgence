AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/big_mom.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 1000
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_Blood_HL1_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?

ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(100, 100, 200), Vector(-100, -100, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(255,221,35)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(1)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() +self:OBBCenter())
		effectdata:SetScale(1)
		util.Effect("StriderBlood",effectdata)
		util.Effect("StriderBlood",effectdata)
	end
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_shellgib.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,160)),Ang=self:LocalToWorldAngles(Angle(0,0,180))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_sacgib.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(20,0,60)),Ang=self:LocalToWorldAngles(Angle(-89.999908447266, 179.99996948242, 180))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(55,-70,80)),Ang=Angle(3.1017229557037, -35.476417541504, 91.352874755859)})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(70,55,80)),Ang=Angle(3.6497807502747, 60.498592376709, 93.368896484375)})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(-70,-45,80)),Ang=Angle(3.8801980018616, -128.15255737305, 91.630615234375)})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/big_mom_leggib.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(-45,70,80)),Ang=self:LocalToWorldAngles(Angle(3.8801965713501, -45, 91.630599975586))})
	return true -- Return to true if it gibbed!
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	VJ_EmitSound(self,"vj_gib/default_gib_splat.wav",90,math.random(100,100))
	return false
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
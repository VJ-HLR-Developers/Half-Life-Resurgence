AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/garg.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 800
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.CustomBlood_Decal = {"VJ_Blood_HL1_Yellow"} -- Decals to spawn when it's damaged
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.VJ_NPC_Class = {"CLASS_XEN"} -- NPCs with the same class with be allied to each other

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDistance = 65 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 165 -- How far does the damage go?

ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
//ENT.DeathAnimationTime = 0.8 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 2 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 1
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH,ACT_BIG_FLINCH} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {
	"vj_hlr/hl1_npc/garg/gar_step1.wav",
	"vj_hlr/hl1_npc/garg/gar_step2.wav",
}
ENT.SoundTbl_Idle = {
	"vj_hlr/hl1_npc/garg/gar_breathe1.wav",
	"vj_hlr/hl1_npc/garg/gar_breathe2.wav",
	"vj_hlr/hl1_npc/garg/gar_breathe3.wav",
	"vj_hlr/hl1_npc/garg/gar_idle1.wav",
	"vj_hlr/hl1_npc/garg/gar_idle2.wav",
	"vj_hlr/hl1_npc/garg/gar_idle3.wav",
	"vj_hlr/hl1_npc/garg/gar_idle4.wav",
	"vj_hlr/hl1_npc/garg/gar_idle5.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl1_npc/garg/gar_alert1.wav",
	"vj_hlr/hl1_npc/garg/gar_alert2.wav",
	"vj_hlr/hl1_npc/garg/gar_alert3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/hl1_npc/garg/gar_attack1.wav",
	"vj_hlr/hl1_npc/garg/gar_attack2.wav",
	"vj_hlr/hl1_npc/garg/gar_attack3.wav",
}
ENT.SoundTbl_MeleeAttackExtra = {
	"weapons/cbar_hitbod1.wav",
	"weapons/cbar_hitbod2.wav",
	"weapons/cbar_hitbod3.wav",
}
ENT.SoundTbl_MeleeAttackMiss = {
	"vj_hlr/hl1_npc/zombie/claw_miss1.wav",
	"vj_hlr/hl1_npc/zombie/claw_miss2.wav",
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl1_npc/garg/gar_pain1.wav",
	"vj_hlr/hl1_npc/garg/gar_pain2.wav",
	"vj_hlr/hl1_npc/garg/gar_pain3.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl1_npc/garg/gar_die1.wav",
	"vj_hlr/hl1_npc/garg/gar_die2.wav",
}
ENT.GeneralSoundPitch1 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(78,78,220),Vector(-78,-78,0))
	local eyeGlow = ents.Create( "env_sprite" )
	eyeGlow:SetKeyValue( "rendercolor","255 128 0" )
	eyeGlow:SetKeyValue( "GlowProxySize","2.0" )
	eyeGlow:SetKeyValue( "HDRColorScale","1.0" )
	eyeGlow:SetKeyValue( "renderfx","14" )
	eyeGlow:SetKeyValue( "rendermode","3" )
	eyeGlow:SetKeyValue( "renderamt","255" )
	eyeGlow:SetKeyValue( "disablereceiveshadows","0" )
	eyeGlow:SetKeyValue( "mindxlevel","0" )
	eyeGlow:SetKeyValue( "maxdxlevel","0" )
	eyeGlow:SetKeyValue( "framerate","10.0" )
	eyeGlow:SetKeyValue( "model","sprites/blueflare1.spr" )
	eyeGlow:SetKeyValue( "spawnflags","0" )
	eyeGlow:SetKeyValue( "scale","2" )
	-- eyeGlow:SetKeyValue( "setparentattachment","0.75" )
	eyeGlow:SetPos( self.Entity:GetPos() )
	eyeGlow:Spawn()
	eyeGlow:Fire("SetParentAttachment","eyes",0)
	eyeGlow:SetParent( self.Entity )
	self:DeleteOnRemove(eyeGlow)
	glowLight = ents.Create("light_dynamic")
	glowLight:SetKeyValue("brightness","1")
	glowLight:SetKeyValue("distance","150")
	glowLight:SetLocalPos(self:GetPos())
	glowLight:SetLocalAngles(self:GetAngles())
	glowLight:Fire("Color", "255 128 0")
	glowLight:SetParent(self)
	glowLight:Spawn()
	glowLight:Activate()
	glowLight:Fire("SetParentAttachment","eyes",0)
	glowLight:Fire("TurnOn","",0)
	self:DeleteOnRemove(glowLight)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "melee" then
		self:MeleeAttackCode()
	end
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
	
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib1.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib2.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,20))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib3.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,30))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib4.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,35))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib5.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib6.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,55))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib7.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib8.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib9.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,25))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/agib10.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	if self.Zombie_Type == 1 then
		self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/zombiegib.mdl",{BloodType="Yellow",BloodDecal="VJ_Blood_HL1_Yellow",Pos=self:LocalToWorld(Vector(0,0,15))})
	end
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
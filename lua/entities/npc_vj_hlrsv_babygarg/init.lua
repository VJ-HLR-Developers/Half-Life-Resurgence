AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/sven/babygarg.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 600
ENT.HullType = HULL_HUMAN

ENT.MeleeAttackDamageType = DMG_SLASH -- How close does it have to be until it attacks?
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 165 -- How far does the damage go?

ENT.WorldShakeOnMoveAmplitude = 6 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 750 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds

ENT.SoundTbl_FootStep = {
	"vj_hlr/hl1_npc/babygarg/gar_step1.wav",
	"vj_hlr/hl1_npc/babygarg/gar_step2.wav",
}
ENT.SoundTbl_Idle = {
	"vj_hlr/hl1_npc/babygarg/gar_breathe1.wav",
	"vj_hlr/hl1_npc/babygarg/gar_breathe2.wav",
	"vj_hlr/hl1_npc/babygarg/gar_breathe3.wav",
	"vj_hlr/hl1_npc/babygarg/gar_idle1.wav",
	"vj_hlr/hl1_npc/babygarg/gar_idle2.wav",
	"vj_hlr/hl1_npc/babygarg/gar_idle3.wav",
	"vj_hlr/hl1_npc/babygarg/gar_idle4.wav",
	"vj_hlr/hl1_npc/babygarg/gar_idle5.wav",
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl1_npc/babygarg/gar_alert1.wav",
	"vj_hlr/hl1_npc/babygarg/gar_alert2.wav",
	"vj_hlr/hl1_npc/babygarg/gar_alert3.wav",
}
ENT.SoundTbl_BeforeMeleeAttack = {
	"vj_hlr/hl1_npc/babygarg/gar_attack1.wav",
	"vj_hlr/hl1_npc/babygarg/gar_attack2.wav",
	"vj_hlr/hl1_npc/babygarg/gar_attack3.wav",
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
	"vj_hlr/hl1_npc/babygarg/gar_pain1.wav",
	"vj_hlr/hl1_npc/babygarg/gar_pain2.wav",
	"vj_hlr/hl1_npc/babygarg/gar_pain3.wav",
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl1_npc/babygarg/gar_die1.wav",
	"vj_hlr/hl1_npc/babygarg/gar_die2.wav",
}

ENT.BloodScale = 200
ENT.GibColor = Color(255,127,127)
ENT.GargDamageScale = 0.4
ENT.FlameAttackDistance = 175
ENT.FlameAnimation = ACT_MELEE_ATTACK2
ENT.DeathExplosions = 3
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(32,32,105), Vector(-32,-32,0))
	local eyeGlow = ents.Create( "env_sprite" )
	eyeGlow:SetKeyValue( "rendercolor","255 75 0" )
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
	eyeGlow:Fire("SetParentAttachment","0",0)
	eyeGlow:SetParent( self.Entity )
	self:DeleteOnRemove(eyeGlow)
	glowLight = ents.Create("light_dynamic")
	glowLight:SetKeyValue("brightness","1")
	glowLight:SetKeyValue("distance","150")
	glowLight:SetLocalPos(self:GetPos())
	glowLight:SetLocalAngles(self:GetAngles())
	glowLight:Fire("Color", "255 75 0")
	glowLight:SetParent(self)
	glowLight:Spawn()
	glowLight:Activate()
	glowLight:Fire("SetParentAttachment","0",0)
	glowLight:Fire("TurnOn","",0)
	self:DeleteOnRemove(glowLight)

	self.UsingFlameAttack = false
	self.HasFlameParticle = false
	self.FlameLoop = CreateSound(self,"vj_hlr/hl1_npc/babygarg/gar_flamerun1.wav")
	self.FlameLoop:SetSoundLevel(80)
	self.NextFlameLoopT = 0
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
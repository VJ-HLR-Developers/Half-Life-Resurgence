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
	self.FlameLoop = CreateSound(self,"vj_hlr/hl1_npc/garg/gar_flamerun1.wav")
	self.FlameLoop:SetSoundLevel(80)
	self.NextFlameLoopT = 0
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
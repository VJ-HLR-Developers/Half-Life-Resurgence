AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/sven/babygarg.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 600
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
	eyeGlow:Fire("SetParentAttachment","0",0)
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
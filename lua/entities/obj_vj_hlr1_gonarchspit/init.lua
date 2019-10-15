AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/spitball_medium.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 70 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 15 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_ACID -- Damage type
ENT.DecalTbl_DeathDecals = {"VJ_HLR_Spit_Acid"}
ENT.SoundTbl_Idle = {"vj_acid/acid_idle1.wav"}
ENT.SoundTbl_OnCollide = {"vj_hlr/hl1_npc/bullchicken/bc_spithit1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:SetMass(1)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	ParticleEffectAttach("vj_hl_spit_gonarch", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	
	self.Sprite1 = ents.Create("env_sprite")
	self.Sprite1:SetKeyValue("model","vj_hl/sprites/mommaspit.vmt")
	self.Sprite1:SetKeyValue("scale","4")
	//self.Sprite1:SetKeyValue("rendercolor","255 128 0")
	self.Sprite1:SetKeyValue("GlowProxySize","2.0") -- Size of the glow to be rendered for visibility testing.
	self.Sprite1:SetKeyValue("HDRColorScale","1.0")
	self.Sprite1:SetKeyValue("renderfx","14")
	self.Sprite1:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	self.Sprite1:SetKeyValue("renderamt","255") -- Transparency
	self.Sprite1:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	self.Sprite1:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	self.Sprite1:SetKeyValue("spawnflags","0")
	self.Sprite1:SetPos(self:GetPos())
	self.Sprite1:SetParent(self)
	self.Sprite1:Spawn()
	self.Sprite1:Activate()
	self:DeleteOnRemove(self.Sprite1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("vj_hl_spit_gonarch_impact", data.HitPos, Angle(0,0,0), nil)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_entity"
ENT.Type 			= "ai"
ENT.PrintName 		= "Xen Crystal"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Category		= "VJ Base"

function ENT:Draw() self:DrawModel() end
function ENT:DrawTranslucent() self:Draw() end
---------------------------------------------------------------------------------------------------------------------------------------------
if (!SERVER) then return end

ENT.VJ_NPC_Class = {"CLASS_XEN"}
ENT.Assignee = NULL -- Is another entity the owner of this crystal?

local sdHit = {"vj_hlr/gsrc/fx/glass1.wav", "vj_hlr/gsrc/fx/glass2.wav", "vj_hlr/gsrc/fx/glass3"}
local sdBreak = {"vj_hlr/gsrc/fx/bustglass1.wav", "vj_hlr/gsrc/fx/bustglass2.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if !IsValid(self.Assignee) then
		self:SetPos(self:GetPos() + self:GetUp() * -40)
	end
	
	self:SetModel("models/vj_hlr/hl1/crystal.mdl")
	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_BBOX)
	self:SetMaxHealth(200)
	self:SetHealth(200)
	
	local dynamicLight = ents.Create("light_dynamic")
	dynamicLight:SetKeyValue("brightness", "4")
	dynamicLight:SetKeyValue("distance", "150")
	dynamicLight:SetKeyValue("style", 5)
	dynamicLight:SetLocalPos(self:GetPos() + self:GetUp() * 30)
	dynamicLight:SetLocalAngles(self:GetAngles())
	dynamicLight:Fire("Color", "255 128 0")
	dynamicLight:SetParent(self)
	dynamicLight:Spawn()
	dynamicLight:Activate()
	dynamicLight:SetParent(self)
	dynamicLight:Fire("TurnOn")
	self:DeleteOnRemove(dynamicLight)
	
	self.IdleSd = CreateSound(self, "vj_hlr/gsrc/fx/alien_cycletone.wav")
	self.IdleSd:SetSoundLevel(80)
	self.IdleSd:Play()

	for i = 0, 0.8, 0.2 do -- Create 5 energy charges
		timer.Simple(i, function()
			if IsValid(self) && IsValid(self.Assignee) then
				local charge = ents.Create("sent_vj_hlr1_orb_crystal_charge")
				charge:SetAngles(self.Assignee:GetAngles())
				charge:SetPos(self:GetPos() + self:GetUp() * 50)
				charge.Assignee = self.Assignee
				charge:Spawn()
				charge:Activate()
				//charge:SetParent(self)
				self.Assignee:DeleteOnRemove(charge)
				table.insert(self.Assignee.Nih_Charges, charge)
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ90 = Vector(0, 0, 90)
--
function ENT:OnTakeDamage(dmginfo)
	local myPos = self:GetPos()
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	self:EmitSound(VJ.PICK(sdHit), 70)
	if self:Health() <= 0 then -- If health is now less than 0 then explode!
		local spr = ents.Create("env_sprite")
		spr:SetKeyValue("model", "vj_hl/sprites/fexplo1.vmt")
		spr:SetKeyValue("GlowProxySize", "2.0")
		spr:SetKeyValue("HDRColorScale", "1.0")
		spr:SetKeyValue("renderfx", "14")
		spr:SetKeyValue("rendermode", "5")
		spr:SetKeyValue("renderamt", "255")
		spr:SetKeyValue("disablereceiveshadows", "0")
		spr:SetKeyValue("mindxlevel", "0")
		spr:SetKeyValue("maxdxlevel", "0")
		spr:SetKeyValue("framerate", "15.0")
		spr:SetKeyValue("spawnflags", "0")
		spr:SetKeyValue("scale", "7")
		spr:SetPos(myPos + vecZ90)
		spr:Spawn()
		spr:Fire("Kill", "", 0.9)
	
		VJ.ApplyRadiusDamage(self, self, myPos, 100, 50, DMG_NERVEGAS, true, true)
		self:EmitSound("vj_hlr/gsrc/fx/xtal_down1.wav", 100)
		self:EmitSound(VJ.PICK(sdBreak), 70)
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	VJ.STOPSOUND(self.IdleSd)
	
	local assignee = self.Assignee
	if IsValid(assignee) then
		assignee:Nih_NotifyCrystalChange(self)
	end
end
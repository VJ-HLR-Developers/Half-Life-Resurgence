ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Xen Crystal"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

if (!SERVER) then return end
AddCSLuaFile()

ENT.Assignee = NULL -- Is another entity the owner of this crystal?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	if !IsValid(self.Assignee) then
		self:SetPos(self:GetPos() + self:GetUp()*-40)
	end
	self:SetModel("models/vj_hlr/hl1/crystal.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetMaxHealth(200)
	self:SetHealth(200)
	
	self.StartLight1 = ents.Create("light_dynamic")
	self.StartLight1:SetKeyValue("brightness", "4")
	self.StartLight1:SetKeyValue("distance", "150")
	self.StartLight1:SetKeyValue("style", 5)
	self.StartLight1:SetLocalPos(self:GetPos() + self:GetUp()*30)
	self.StartLight1:SetLocalAngles(self:GetAngles())
	self.StartLight1:Fire("Color", "255 128 0")
	self.StartLight1:SetParent(self)
	self.StartLight1:Spawn()
	self.StartLight1:Activate()
	self.StartLight1:SetParent(self)
	self.StartLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.StartLight1)
	
	self.IdleSd = CreateSound(self, "vj_hlr/fx/alien_cycletone.wav")
	self.IdleSd:SetSoundLevel(80)
	self.IdleSd:Play()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if IsValid(self.Assignee) then
		
	end
	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	self:EmitSound(VJ_PICK({"vj_hlr/fx/bustglass1.wav","vj_hlr/fx/bustglass2.wav"}), 70)
	if self:Health() <= 0 then
		//util.BlastDamage(self, self, self:GetPos(), 100, 50)
		util.VJ_SphereDamage(self, self, self:GetPos(), 100, 50, DMG_NERVEGAS, true, true)
		self:EmitSound("vj_hlr/fx/xtal_down1.wav", 100)
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	VJ_STOPSOUND(self.IdleSd)
end
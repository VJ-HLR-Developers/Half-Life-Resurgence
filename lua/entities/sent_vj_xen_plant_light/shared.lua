ENT.Base 			= "prop_vj_animatable"
ENT.Type 			= "anim"
ENT.PrintName 		= "Xen Plant Light"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used to make simple props and animate them, since prop_dynamic doesn't work properly in Garry's Mod."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

if (SERVER) then
	AddCSLuaFile()
	
	ENT.IsRetracted = false
	ENT.NextDeployT = 0
	
	function ENT:CustomOnInitialize()
		self:SetModel("models/vj_hlr/hl1/light.mdl")
		self:SetCollisionBounds(Vector(8, 8, 22), Vector(-8, -8, 0))
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_BBOX)
		self:ResetSequence("Idle1")
		
		self.StartLight1 = ents.Create("light_dynamic")
		self.StartLight1:SetKeyValue("brightness", "6")
		self.StartLight1:SetKeyValue("distance", "150")
		self.StartLight1:SetLocalPos(self:GetPos())
		self.StartLight1:SetLocalAngles(self:GetAngles())
		self.StartLight1:Fire("Color", "255 128 0")
		self.StartLight1:SetParent(self)
		self.StartLight1:Spawn()
		self.StartLight1:Activate()
		self.StartLight1:SetParent(self)
		self.StartLight1:Fire("SetParentAttachment", "0", 0)
		self.StartLight1:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.StartLight1)
		
		self.StartGlow1 = ents.Create("env_sprite")
		self.StartGlow1:SetKeyValue("model","sprites/glow01.vmt")
		self.StartGlow1:SetKeyValue("rendercolor","255 128 0")
		self.StartGlow1:SetKeyValue("GlowProxySize","2.0")
		self.StartGlow1:SetKeyValue("HDRColorScale","1.0")
		self.StartGlow1:SetKeyValue("renderfx","14")
		self.StartGlow1:SetKeyValue("rendermode","3")
		self.StartGlow1:SetKeyValue("renderamt","255")
		self.StartGlow1:SetKeyValue("disablereceiveshadows","0")
		self.StartGlow1:SetKeyValue("mindxlevel","0")
		self.StartGlow1:SetKeyValue("maxdxlevel","0")
		self.StartGlow1:SetKeyValue("framerate","10.0")
		self.StartGlow1:SetKeyValue("spawnflags","0")
		self.StartGlow1:SetKeyValue("scale","1")
		self.StartGlow1:SetPos(self:GetPos())
		self.StartGlow1:Spawn()
		self.StartGlow1:SetParent(self)
		self.StartGlow1:Fire("SetParentAttachment", "0", 0)
		self:DeleteOnRemove(self.StartGlow1)
	end
	
	function ENT:Think()
		local getents = ents.FindInSphere(self:GetPos(), 200)
		for k, v in ipairs(getents) do
			if (v:IsNPC() or v:IsPlayer()) && VJ_IsAlive(v) then
				if self.IsRetracted == false then
					self:ResetSequence("Retract")
					self.StartGlow1:Fire("HideSprite", "", 0.1)
					self.StartLight1:Fire("TurnOff", "", 0)
					self:SetSkin(1)
				end
				self.IsRetracted = true
				self.NextDeployT = CurTime() + math.Rand(2,3.5)
				self:NextThink(CurTime())
				return true
			end
		end
		
		if self.IsRetracted == true && self.NextDeployT < CurTime() then
			self.IsRetracted = false
			self:ResetSequence("Delpoy")
			timer.Simple(1,function()
				if IsValid(self) && self.IsRetracted == false then
					self.StartGlow1:Fire("ShowSprite", "", 0)
					self.StartLight1:Fire("TurnOn", "", 0)
					self:SetSkin(0)
				end
			end)
			timer.Simple(1.85,function()
				if IsValid(self) && self.IsRetracted == false then
					self:ResetSequence("Idle1")
				end
			end)
		end
		self:NextThink(CurTime())
		return true
	end
end
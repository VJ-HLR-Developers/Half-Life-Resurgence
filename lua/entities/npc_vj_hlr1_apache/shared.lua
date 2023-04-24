ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "AH-64 Apache"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	ENT.Apache_NextSmoke = 0
	function ENT:Draw()
		self:DrawModel()
		if IsValid(self) && CurTime() > self.Apache_NextSmoke then
			local lvl = self:GetNW2Int("Heli_SmokeLevel")
			self.Apache_NextSmoke = CurTime() + 0.1
			if lvl > 0 then
				local emitter = ParticleEmitter(self:GetPos())
				local smoke1 = emitter:Add("vj_hl/sprites/steam1", self:GetAttachment(self:LookupAttachment("rotor_tail")).Pos)
				smoke1:SetVelocity(self:GetUp()*100 + VectorRand(-30, 30))
				smoke1:SetDieTime(2)
				smoke1:SetStartSize(30)
				smoke1:SetEndSize(30 + math.random(0, 9))
				smoke1:SetRoll(math.Rand(-2, 2))
				smoke1:SetEndAlpha(0)
				if lvl == 2 then
					local smoke2 = emitter:Add("vj_hl/sprites/steam1", self:GetAttachment(self:LookupAttachment("rotor")).Pos)
					smoke2:SetVelocity(self:GetUp()*100 + VectorRand(-30, 30))
					smoke2:SetDieTime(2)
					smoke2:SetStartSize(50)
					smoke2:SetEndSize(50 + math.random(0, 9))
					smoke2:SetRoll(math.Rand(-2, 2))
					smoke2:SetEndAlpha(0)
				end
				emitter:Finish()
			end
		end
	end
end
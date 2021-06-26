ENT.Base 			= "npc_vj_tank_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Merkava"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

---------------------------------------------------------------------------------------------------------------------------------------------
local smokeSize = 80
local heatSize = 20
--
net.Receive("vj_hlr1_merkava_spawneffects", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		ent.Emitter = ParticleEmitter(ent:GetPos())
		ent.SmokeEffect1 = ent.Emitter:Add("particles/smokey",ent:GetPos() + ent:GetForward()*-130 + ent:GetRight()*25 + ent:GetUp()*45)
		ent.SmokeEffect1:SetVelocity(ent:GetVelocity() + ent:GetForward()*-30)
		ent.SmokeEffect1:SetDieTime(0.6)
		ent.SmokeEffect1:SetStartAlpha(80)
		ent.SmokeEffect1:SetEndAlpha(0)
		ent.SmokeEffect1:SetStartSize(10)
		ent.SmokeEffect1:SetEndSize(smokeSize)
		ent.SmokeEffect1:SetRoll(math.Rand(-0.2,0.2))
		ent.SmokeEffect1:SetColor(150,150,150,255)
		ent.SmokeEffect1:SetAirResistance(100)

		ent.HeatEffect1 = ent.Emitter:Add("sprites/heatwave",ent:GetPos() + ent:GetForward()*-130 + ent:GetRight()*25 + ent:GetUp()*45)
		ent.HeatEffect1:SetVelocity(ent:GetForward() * math.Rand(0, 50) + Vector(math.Rand(5, -5),math.Rand(5, -5),math.Rand(5, -5)) + ent:GetVelocity())
		ent.HeatEffect1:SetDieTime(0.1)
		ent.HeatEffect1:SetStartAlpha(255)
		ent.HeatEffect1:SetEndAlpha(255)
		ent.HeatEffect1:SetStartSize(heatSize)
		ent.HeatEffect1:SetEndSize(5)
		ent.HeatEffect1:SetRoll(math.Rand(-50,50))
		ent.HeatEffect1:SetColor(255,255,255)
		//ent.HeatEffect1:Finish()
		ent.Emitter:Finish()
		
		ent.Emitter = ParticleEmitter(ent:GetPos())
		ent.SmokeEffect1 = ent.Emitter:Add("particles/smokey",ent:GetPos() + ent:GetForward()*-130 + ent:GetRight()*-28 + ent:GetUp()*45)
		ent.SmokeEffect1:SetVelocity(ent:GetVelocity() + ent:GetForward()*-30)
		ent.SmokeEffect1:SetDieTime(0.6)
		ent.SmokeEffect1:SetStartAlpha(80)
		ent.SmokeEffect1:SetEndAlpha(0)
		ent.SmokeEffect1:SetStartSize(10)
		ent.SmokeEffect1:SetEndSize(smokeSize)
		ent.SmokeEffect1:SetRoll(math.Rand(-0.2,0.2))
		ent.SmokeEffect1:SetColor(150,150,150,255)
		ent.SmokeEffect1:SetAirResistance(100)

		ent.HeatEffect1 = ent.Emitter:Add("sprites/heatwave",ent:GetPos() + ent:GetForward()*-130 + ent:GetRight()*-28 + ent:GetUp()*45)
		ent.HeatEffect1:SetVelocity(ent:GetForward() * math.Rand(0, 50) + Vector(math.Rand(5, -5),math.Rand(5, -5),math.Rand(5, -5)) + ent:GetVelocity())
		ent.HeatEffect1:SetDieTime(0.1)
		ent.HeatEffect1:SetStartAlpha(255)
		ent.HeatEffect1:SetEndAlpha(255)
		ent.HeatEffect1:SetStartSize(heatSize)
		ent.HeatEffect1:SetEndSize(5)
		ent.HeatEffect1:SetRoll(math.Rand(-50,50))
		ent.HeatEffect1:SetColor(255,255,255)
		//ent.HeatEffect1:Finish()
		ent.Emitter:Finish()
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_hlr1_merkava_moveeffects", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		ent.Emitter = ParticleEmitter(ent:GetPos())
		ent.MoveSmokeEffect1 = ent.Emitter:Add("particles/smokey", ent:GetPos() + ent:GetForward()*-115 + ent:GetRight()*58 + ent:GetUp()*1)
		ent.MoveSmokeEffect1:SetVelocity(ent:GetForward()*math.Rand(100,200) + Vector(math.Rand(5,-5),math.Rand(5,-5),math.Rand(5,-5)) + ent:GetVelocity())
		ent.MoveSmokeEffect1:SetDieTime(4)
		ent.MoveSmokeEffect1:SetStartAlpha(30)
		ent.MoveSmokeEffect1:SetEndAlpha(0)
		ent.MoveSmokeEffect1:SetStartSize(math.Rand(12,20))
		ent.MoveSmokeEffect1:SetEndSize(math.Rand(60,80))
		ent.MoveSmokeEffect1:SetRoll(math.Rand(-0.2,0.2))
		ent.MoveSmokeEffect1:SetColor(80,60,20)
		ent.MoveSmokeEffect1:SetAirResistance(300)
		ent.MoveSmokeEffect1:SetGravity(Vector(0,0,50))
		
		ent.MoveSmokeEffect2 = ent.Emitter:Add("particles/smokey", ent:GetPos() + ent:GetForward()*-115 + ent:GetRight()*-58 + ent:GetUp()*1)
		ent.MoveSmokeEffect2:SetVelocity(ent:GetForward()*math.Rand(100,200) + Vector(math.Rand(5,-5),math.Rand(5,-5),math.Rand(5,-5)) + ent:GetVelocity())
		ent.MoveSmokeEffect2:SetDieTime(4)
		ent.MoveSmokeEffect2:SetStartAlpha(30)
		ent.MoveSmokeEffect2:SetEndAlpha(0)
		ent.MoveSmokeEffect2:SetStartSize(math.Rand(12,20))
		ent.MoveSmokeEffect2:SetEndSize(math.Rand(60,80))
		ent.MoveSmokeEffect2:SetRoll(math.Rand(-0.2,0.2))
		ent.MoveSmokeEffect2:SetColor(80,60,20)
		ent.MoveSmokeEffect2:SetAirResistance(300)
		ent.MoveSmokeEffect2:SetGravity(Vector(0,0,50))
		ent.Emitter:Finish()
	end
end)
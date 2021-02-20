ENT.Base 			= "npc_vj_tankg_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "M1A1 Abrams"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

if CLIENT then
	local Name = "M1A1 Abrams"
	local LangName = "npc_vj_hlr1_m1a1abrams_gun"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_hlr1_m1a1abrams_shooteffects", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		ent.Emitter = ParticleEmitter(ent:GetPos())
		ent.SmokeEffect2 = ent.Emitter:Add("particles/smokey", ent:GetPos() + ent:GetForward()*80 + ent:GetUp()*10)
		ent.SmokeEffect2:SetVelocity(ent:GetForward()*math.Rand(0,-50) + Vector(0,-30,math.Rand(-10,-20)) + ent:GetVelocity())
		ent.SmokeEffect2:SetDieTime(2)
		ent.SmokeEffect2:SetStartAlpha(30)
		ent.SmokeEffect2:SetEndAlpha(0)
		ent.SmokeEffect2:SetStartSize(3)
		ent.SmokeEffect2:SetEndSize(50)
		ent.SmokeEffect2:SetRoll(math.Rand(-0.2,0.2))
		ent.SmokeEffect2:SetColor(150,150,150,255)
		ent.Emitter:Finish()
	end
end)
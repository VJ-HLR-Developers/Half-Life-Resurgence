ENT.Base 			= "npc_vj_hlr2_com_sentry"
ENT.Type 			= "ai"
ENT.PrintName 		= "Resistance Sentry Gun"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Half-Life Resurgence"

ENT.HLR_Type = "Turret"

if CLIENT then
	local matLaser = Material("vj_hl/sprites/hl2/turret_laser_fade")
	local laserColor = Color(255, 0, 0)
    function ENT:Initialize()
        local hookName = "VJ_HLR_TurretLaser_" .. self:EntIndex()
        hook.Add("PreDrawEffects",hookName,function()
            if !IsValid(self) then
                hook.Remove("PreDrawEffects",hookName)
                return
            end

            local attStart = self:GetAttachment(self:LookupAttachment("laser_start"))
            local attEnd = self:GetAttachment(self:LookupAttachment("laser_end"))
            local tr = util.TraceLine({
                start = attStart.Pos,
                endpos = attEnd.Pos,
                filter = self,
            })
            render.SetMaterial(matLaser)
            render.DrawBeam(tr.StartPos, tr.HitPos, 2, 0, 0.98, laserColor)
        end)
    end
end
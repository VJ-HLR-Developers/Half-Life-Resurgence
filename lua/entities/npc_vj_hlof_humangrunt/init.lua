AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/hgrunt.mdl","models/vj_hlr/opfor/hgrunt.mdl","models/vj_hlr/opfor/hgrunt.mdl","models/vj_hlr/opfor/hgrunt_medic.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
// models/vj_hlr/opfor/hgrunt.mdl
// models/vj_hlr/opfor/hgrunt_medic.mdl

ENT.HasOnPlayerSight = true -- Should do something when it sees the enemy? Example: Play a sound
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?

/*
Heavy damage:
vj_hlr/hl1_npc/hgrunt_oppf/busted.wav
vj_hlr/hl1_npc/hgrunt_oppf/critical.wav
vj_hlr/hl1_npc/hgrunt_oppf/hitbad.wav
vj_hlr/hl1_npc/hgrunt_oppf/makeit.wav
vj_hlr/hl1_npc/hgrunt_oppf/sdamage.wav

When they hear something:
vj_hlr/hl1_npc/hgrunt_oppf/hear.wav
vj_hlr/hl1_npc/hgrunt_oppf/hearsome.wav
vj_hlr/hl1_npc/hgrunt_oppf/quiet.wav
vj_hlr/hl1_npc/hgrunt_oppf/staydown.wav
vj_hlr/hl1_npc/hgrunt_oppf/intro_fg17.wav

-- Engineer:
vj_hlr/hl1_npc/hgrunt_oppf/locksmith.wav
vj_hlr/hl1_npc/hgrunt_oppf/stand.wav
vj_hlr/hl1_npc/hgrunt_oppf/thick.wav

vj_hlr/hl1_npc/hgrunt_oppf/medic_give_shot.wav
*/
	-- ====== Sounds ====== --
ENT.SoundTbl_Idle = {
	"vj_hlr/hl1_npc/hgrunt_oppf/allclear.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/area.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/babysitting.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/bfeeling.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/charge.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/checkrecon.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/coverup.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/current.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/disney.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/dogs.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/frosty.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/guard.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/lost.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/mission.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/nohostiles.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/nomovement.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/now.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/outof.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/secure.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/seensquad.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/short.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/stayalert.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/zone.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/check.wav"
}
ENT.SoundTbl_CombatIdle = {
	"vj_hlr/hl1_npc/hgrunt_oppf/ass.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/chicken.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/clear.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/corners.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/flank.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/freaks.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/fubar.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/go.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/marines.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/move.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/moveup.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/recon.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/sweep.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/tag.wav"
}
ENT.SoundTbl_OnReceiveOrder = {
	"vj_hlr/hl1_npc/hgrunt_oppf/moving.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/of6a1_fg02.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/right.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/roger.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/sir.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/siryessir.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/yes.wav"
}
ENT.SoundTbl_FollowPlayer = {
	"vj_hlr/hl1_npc/hgrunt_oppf/clear.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/corporal_01.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/damage.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gotit.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/notfail.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/six.wav"
}
ENT.SoundTbl_UnFollowPlayer = {
	"vj_hlr/hl1_npc/hgrunt_oppf/guardduty.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/orders.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/post.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/scout.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/situations.wav"
}
ENT.SoundTbl_MedicBeforeHeal = {
	"vj_hlr/hl1_npc/hgrunt_oppf/fwound.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/help.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/hurt.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/medical.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/sting.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/of2a5_fg03.wav"
}
ENT.SoundTbl_MedicReceiveHeal = {
	"vj_hlr/hl1_npc/hgrunt_oppf/thanks.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/of2a5_fg04.wav"
}
ENT.SoundTbl_OnPlayerSight = {
	"vj_hlr/hl1_npc/hgrunt_oppf/hellosir.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/shephard.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/sir_01.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/sore.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/tosee.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/feel.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/check.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/of5a1_fg01.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/of5a3_fg01.wav"
}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl1_npc/hgrunt_oppf/bogies.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/hostiles.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/mister.wav"
}
ENT.SoundTbl_CallForHelp = {
	"vj_hlr/hl1_npc/hgrunt_oppf/suppressing.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/backup.wav"
}
ENT.SoundTbl_Suppressing = {
	"vj_hlr/hl1_npc/hgrunt_oppf/covering.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/fwound.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/nothing.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/rapidfire.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/wantsome.wav"
}
ENT.SoundTbl_GrenadeAttack = {
	"vj_hlr/hl1_npc/hgrunt_oppf/fire.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/take.wav"
}
ENT.SoundTbl_OnGrenadeSight = {
	"vj_hlr/hl1_npc/hgrunt_oppf/cover.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/down.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/grenade.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/hellout.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/incoming.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/retreat.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/takecover.wav"
}
ENT.SoundTbl_OnKilledEnemy = {
	"vj_hlr/hl1_npc/hgrunt_oppf/killer.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/oneshot.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/sniper.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/talking.wav"
}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain1.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain2.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain3.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain4.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain5.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain6.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/imhit.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/medic.wav"
}
ENT.SoundTbl_DamageByPlayer = {
	"vj_hlr/hl1_npc/hgrunt_oppf/athority.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/checkfire.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/friendly.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/watchfire.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/watchit.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/of2a6_fg02.wav"
}
ENT.SoundTbl_Death = {
	"vj_hlr/hl1_npc/hgrunt_oppf/death1.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death2.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death3.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death4.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death5.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death6.wav"
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	if self.HECU_Type == 1 then
		self:SetBodygroup(1,math.random(0,7))
		
		local randwep = math.random(1,4)
		if randwep == 1 or randwep == 2 then
			self:SetBodygroup(3,0)
		elseif randwep == 3 then
			self:SetBodygroup(3,1)
		elseif randwep == 4 then
			self:SetBodygroup(3,2)
		end
		
		-- Marminen hamar
		if self:GetBodygroup(3) == 0 then
			self:SetBodygroup(2,0) -- Barz zenk
		elseif self:GetBodygroup(3) == 1 then
			self:SetBodygroup(2,3) -- bonebakshen
		elseif self:GetBodygroup(3) == 2 then
			self:SetBodygroup(2,1) -- Medz reshesh
		end
	elseif self.HECU_Type == 2 then
		-- Medic bodygroup starts from 2
		self:SetBodygroup(2,math.random(0,1))
		
		self:SetBodygroup(3,math.random(0,1))
		
		self.IsMedicSNPC = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
	self:SetBodygroup(self.HECU_WepBG,3)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
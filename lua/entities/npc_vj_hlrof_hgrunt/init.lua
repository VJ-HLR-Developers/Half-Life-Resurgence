include("entities/npc_vj_hlr1_hgrunt/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_hlr/opfor/hgrunt.mdl"
ENT.ControllerParams = {
    ThirdP_Offset = Vector(0, 0, -15),
    FirstP_Bone = "Bip01 Head",
    FirstP_Offset = Vector(5, 0, 1),
}
ENT.HasOnPlayerSight = true
ENT.BecomeEnemyToPlayer = 2

/*
Heavy damage:
vj_hlr/gsrc/npc/hgrunt_opf/busted.wav
vj_hlr/gsrc/npc/hgrunt_opf/critical.wav
vj_hlr/gsrc/npc/hgrunt_opf/hitbad.wav
vj_hlr/gsrc/npc/hgrunt_opf/makeit.wav
vj_hlr/gsrc/npc/hgrunt_opf/sdamage.wav

-- Engineer:
vj_hlr/gsrc/npc/hgrunt_opf/locksmith.wav
vj_hlr/gsrc/npc/hgrunt_opf/stand.wav
vj_hlr/gsrc/npc/hgrunt_opf/thick.wav

vj_hlr/gsrc/npc/hgrunt_opf/medic_give_shot.wav
*/
	-- ====== Sounds ====== --
ENT.SoundTbl_Idle = {
	"vj_hlr/gsrc/npc/hgrunt_opf/allclear.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/area.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/babysitting.wav",
	--"vj_hlr/gsrc/npc/hgrunt_opf/bfeeling.wav",
	--"vj_hlr/gsrc/npc/hgrunt_opf/charge.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/checkrecon.wav",
	--"vj_hlr/gsrc/npc/hgrunt_opf/coverup.wav",
	--"vj_hlr/gsrc/npc/hgrunt_opf/current.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/disney.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/dogs.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/frosty.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/guard.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/lost.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/mission.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/nohostiles.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/nomovement.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/now.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/outof.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/secure.wav",
	--"vj_hlr/gsrc/npc/hgrunt_opf/seensquad.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/short.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/stayalert.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/zone.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/check.wav"
}
ENT.SoundTbl_CombatIdle = {
	"vj_hlr/gsrc/npc/hgrunt_opf/ass.wav",
	--"vj_hlr/gsrc/npc/hgrunt_opf/chicken.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/clear.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/corners.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/flank.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/freaks.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/fubar.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/go.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/marines.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/move.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/moveup.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/recon.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/sweep.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/tag.wav"
}
ENT.SoundTbl_IdleDialogue = {
	"vj_hlr/gsrc/npc/hgrunt_opf/seensquad.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/current.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/coverup.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/chicken.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/charge.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/bfeeling.wav"
	
}
ENT.SoundTbl_IdleDialogueAnswer = {
	"vj_hlr/gsrc/npc/hgrunt_opf/yes.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/roger.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/sir.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/no.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/quiet.wav"
}
ENT.SoundTbl_ReceiveOrder = {
	"vj_hlr/gsrc/npc/hgrunt_opf/moving.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/of6a1_fg02.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/right.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/roger.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/sir.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/siryessir.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/yes.wav"
}
ENT.SoundTbl_FollowPlayer = {
	"vj_hlr/gsrc/npc/hgrunt_opf/clear.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/corporal_01.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/damage.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/gotit.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/notfail.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/six.wav"
}
ENT.SoundTbl_UnFollowPlayer = {
	"vj_hlr/gsrc/npc/hgrunt_opf/guardduty.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/orders.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/post.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/scout.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/situations.wav"
}
ENT.SoundTbl_MedicBeforeHeal = {
	"vj_hlr/gsrc/npc/hgrunt_opf/fwound.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/help.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/hurt.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/medical.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/sting.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/of2a5_fg03.wav"
}
ENT.SoundTbl_MedicReceiveHeal = {
	"vj_hlr/gsrc/npc/hgrunt_opf/thanks.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/of2a5_fg04.wav"
}
ENT.SoundTbl_OnPlayerSight = {
	"vj_hlr/gsrc/npc/hgrunt_opf/hellosir.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/shephard.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/sir_01.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/sore.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/tosee.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/feel.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/check.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/of5a1_fg01.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/of5a3_fg01.wav"
}
ENT.SoundTbl_Investigate = {
	"vj_hlr/gsrc/npc/hgrunt_opf/hear.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/hearsome.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/quiet.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/staydown.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/intro_fg17.wav"
}
ENT.SoundTbl_Alert = {
	"vj_hlr/gsrc/npc/hgrunt_opf/bogies.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/hostiles.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/mister.wav"
}
ENT.SoundTbl_CallForHelp = {
	"vj_hlr/gsrc/npc/hgrunt_opf/suppressing.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/backup.wav"
}
ENT.SoundTbl_Suppressing = {
	"vj_hlr/gsrc/npc/hgrunt_opf/covering.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/getsome.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/nothing.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/rapidfire.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/wantsome.wav"
}
ENT.SoundTbl_GrenadeAttack = {
	"vj_hlr/gsrc/npc/hgrunt_opf/fire.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/grenade.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/take.wav"
}
ENT.SoundTbl_GrenadeSight = {
	"vj_hlr/gsrc/npc/hgrunt_opf/cover.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/down.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/grenade.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/hellout.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/incoming.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/retreat.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/takecover.wav"
}
ENT.SoundTbl_DangerSight = {
	"vj_hlr/gsrc/npc/hgrunt_opf/cover.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/down.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/retreat.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/takecover.wav"
}
ENT.SoundTbl_KilledEnemy = {
	"vj_hlr/gsrc/npc/hgrunt_opf/killer.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/oneshot.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/sniper.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/talking.wav"
}
ENT.SoundTbl_Pain = {
	"vj_hlr/gsrc/npc/hgrunt_opf/gr_pain1.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/gr_pain2.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/gr_pain3.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/gr_pain4.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/gr_pain5.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/gr_pain6.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/imhit.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/medic.wav"
}
ENT.SoundTbl_DamageByPlayer = {
	"vj_hlr/gsrc/npc/hgrunt_opf/athority.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/checkfire.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/friendly.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/watchfire.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/watchit.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/of2a6_fg02.wav"
}
ENT.SoundTbl_Death = {
	"vj_hlr/gsrc/npc/hgrunt_opf/death1.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/death2.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/death3.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/death4.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/death5.wav",
	"vj_hlr/gsrc/npc/hgrunt_opf/death6.wav"
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_OnInit()
	if self.HECU_Type == 1 then
		self:SetBodygroup(1, math.random(0, 9))
		
		local randWep = math.random(1, 4)
		if randWep == 1 or randWep == 2 then
			self:SetBodygroup(3, 0)
		elseif randWep == 3 then
			self:SetBodygroup(3, 1)
		elseif randWep == 4 then
			self:SetBodygroup(3, 2)
		end
		
		-- Marminen hamar
		if self:GetBodygroup(3) == 0 then
			self:SetBodygroup(2, 0) -- Barz zenk
		elseif self:GetBodygroup(3) == 1 then
			self:SetBodygroup(2, 3) -- bonebakshen
		elseif self:GetBodygroup(3) == 2 then
			self:SetBodygroup(2, 1) -- Medz reshesh
		end
	end
end
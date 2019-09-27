AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 100

/*
-- Can't reach player, unfollow
"vj_hlr/hl1_npc/rosenberg/ro_stop0.wav"
"vj_hlr/hl1_npc/rosenberg/ro_stop1.wav"
"vj_hlr/hl1_npc/rosenberg/ro_stop2.wav"
"vj_hlr/hl1_npc/rosenberg/ro_stop3.wav"
"vj_hlr/hl1_npc/rosenberg/ro_stop4.wav"

vj_hlr/hl1_npc/rosenberg/ro_01_alive.wav
vj_hlr/hl1_npc/rosenberg/ro_01_assure.wav
vj_hlr/hl1_npc/rosenberg/ro_01_callhelp.wav
vj_hlr/hl1_npc/rosenberg/ro_01_chargers.wav
vj_hlr/hl1_npc/rosenberg/ro_01_dampen.wav
vj_hlr/hl1_npc/rosenberg/ro_01_danger.wav
vj_hlr/hl1_npc/rosenberg/ro_01_fields.wav
vj_hlr/hl1_npc/rosenberg/ro_01_grudge.wav
vj_hlr/hl1_npc/rosenberg/ro_01_sigh.wav
vj_hlr/hl1_npc/rosenberg/ro_01_touch.wav
vj_hlr/hl1_npc/rosenberg/ro_01_yesright.wav

vj_hlr/hl1_npc/rosenberg/ro_01_admin.wav
vj_hlr/hl1_npc/rosenberg/ro_01_keller.wav
vj_hlr/hl1_npc/rosenberg/ro_01_leaving.wav
vj_hlr/hl1_npc/rosenberg/ro_01_realize.wav
vj_hlr/hl1_npc/rosenberg/ro_01_spectrom.wav
vj_hlr/hl1_npc/rosenberg/ro_01_survived.wav
vj_hlr/hl1_npc/rosenberg/ro_02_careful.wav
vj_hlr/hl1_npc/rosenberg/ro_02_despite.wav
vj_hlr/hl1_npc/rosenberg/ro_02_elevator.wav
vj_hlr/hl1_npc/rosenberg/ro_02_madeit.wav
vj_hlr/hl1_npc/rosenberg/ro_02_moving.wav
vj_hlr/hl1_npc/rosenberg/ro_02_opendoor.wav
vj_hlr/hl1_npc/rosenberg/ro_02_thanks.wav
vj_hlr/hl1_npc/rosenberg/ro_02_waithere.wav
vj_hlr/hl1_npc/rosenberg/ro_03_aligned.wav
vj_hlr/hl1_npc/rosenberg/ro_03_excellent.wav
vj_hlr/hl1_npc/rosenberg/ro_03_inside.wav
vj_hlr/hl1_npc/rosenberg/ro_03_keller.wav
vj_hlr/hl1_npc/rosenberg/ro_03_madeit.wav
vj_hlr/hl1_npc/rosenberg/ro_03_makeway.wav
vj_hlr/hl1_npc/rosenberg/ro_03_notalign.wav
vj_hlr/hl1_npc/rosenberg/ro_03_notalign2.wav
vj_hlr/hl1_npc/rosenberg/ro_03_perfect.wav
vj_hlr/hl1_npc/rosenberg/ro_03_rotated.wav
vj_hlr/hl1_npc/rosenberg/ro_03_senddown.wav
vj_hlr/hl1_npc/rosenberg/ro_03_surface.wav
vj_hlr/hl1_npc/rosenberg/ro_03_toofar.wav
vj_hlr/hl1_npc/rosenberg/ro_03_waithere.wav

vj_hlr/hl1_npc/rosenberg/ro_inside_car.wav
vj_hlr/hl1_npc/rosenberg/ro_outro1.wav
vj_hlr/hl1_npc/rosenberg/ro_outro2.wav
vj_hlr/hl1_npc/rosenberg/ro_rug.wav

-- vj_hlr/hl1_npc/rosenberg/ro_tele_final0.wav ---> vj_hlr/hl1_npc/rosenberg/ro_tele_final23.wav
-- vj_hlr/hl1_npc/rosenberg/ro_tele_final25.wav ---> vj_hlr/hl1_npc/rosenberg/ro_tele_final28.wav
vj_hlr/hl1_npc/rosenberg/ro_tele_nocell.wav
-- vj_hlr/hl1_npc/rosenberg/ro_tele_power1.wav ---> vj_hlr/hl1_npc/rosenberg/ro_to_teleport.wav
-- vj_hlr/hl1_npc/rosenberg/ro_xen_call1.wav ---> vj_hlr/hl1_npc/rosenberg/ro_yard_hurry02.wav
-- vj_hlr/hl1_npc/rosenberg/ro_yard_rose1.wav ---> vj_hlr/hl1_npc/rosenberg/ro_yard_scanner.wav
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCI_CustomOnInitialize()
	self.SoundTbl_Idle = {"vj_hlr/hl1_npc/scientist/yawn.wav","vj_hlr/hl1_npc/scientist/sneeze.wav","vj_hlr/hl1_npc/scientist/sniffle.wav","vj_hlr/hl1_npc/scientist/cough.wav","vj_hlr/hl1_npc/scientist/c1a0_sci_stall.wav"}
	self.SoundTbl_CombatIdle = {"vj_hlr/hl1_npc/rosenberg/ro_plfear1.wav","vj_hlr/hl1_npc/rosenberg/ro_plfear2.wav","vj_hlr/hl1_npc/rosenberg/ro_plfear3.wav","vj_hlr/hl1_npc/rosenberg/ro_plfear4.wav","vj_hlr/hl1_npc/rosenberg/ro_fear0.wav","vj_hlr/hl1_npc/rosenberg/ro_fear1.wav","vj_hlr/hl1_npc/rosenberg/ro_fear2.wav","vj_hlr/hl1_npc/rosenberg/ro_fear3.wav","vj_hlr/hl1_npc/rosenberg/ro_fear4.wav","vj_hlr/hl1_npc/rosenberg/ro_fear5.wav"}
	self.SoundTbl_FollowPlayer = {"vj_hlr/hl1_npc/rosenberg/ro_yard_notime1.wav","vj_hlr/hl1_npc/rosenberg/ro_ok0.wav","vj_hlr/hl1_npc/rosenberg/ro_ok1.wav","vj_hlr/hl1_npc/rosenberg/ro_ok2.wav","vj_hlr/hl1_npc/rosenberg/ro_ok3.wav","vj_hlr/hl1_npc/rosenberg/ro_ok4.wav","vj_hlr/hl1_npc/rosenberg/ro_ok5.wav","vj_hlr/hl1_npc/rosenberg/ro_ok6.wav","vj_hlr/hl1_npc/rosenberg/ro_ok7.wav","vj_hlr/hl1_npc/rosenberg/ro_ok8.wav","vj_hlr/hl1_npc/rosenberg/ro_ok9.wav","vj_hlr/hl1_npc/rosenberg/ro_01_letsgo.wav","vj_hlr/hl1_npc/rosenberg/ro_02_follow.wav"}
	self.SoundTbl_UnFollowPlayer = {"vj_hlr/hl1_npc/rosenberg/ro_wait0.wav","vj_hlr/hl1_npc/rosenberg/ro_wait1.wav","vj_hlr/hl1_npc/rosenberg/ro_wait2.wav","vj_hlr/hl1_npc/rosenberg/ro_wait3.wav","vj_hlr/hl1_npc/rosenberg/ro_wait4.wav","vj_hlr/hl1_npc/rosenberg/ro_wait5.wav","vj_hlr/hl1_npc/rosenberg/ro_wait6.wav","vj_hlr/hl1_npc/rosenberg/ro_wait7.wav"}
	self.SoundTbl_MedicBeforeHeal = {"vj_hlr/hl1_npc/rosenberg/ro_letstrythis.wav","vj_hlr/hl1_npc/rosenberg/ro_cure0.wav","vj_hlr/hl1_npc/rosenberg/ro_cure1.wav","vj_hlr/hl1_npc/rosenberg/ro_cure2.wav","vj_hlr/hl1_npc/rosenberg/ro_heal0.wav","vj_hlr/hl1_npc/rosenberg/ro_heal1.wav","vj_hlr/hl1_npc/rosenberg/ro_heal2.wav","vj_hlr/hl1_npc/rosenberg/ro_heal3.wav","vj_hlr/hl1_npc/rosenberg/ro_heal4.wav"}
	self.SoundTbl_OnPlayerSight = {"vj_hlr/hl1_npc/rosenberg/ro_calhoun.wav","vj_hlr/hl1_npc/rosenberg/ro_calhoun2.wav"}
	self.SoundTbl_Alert = {"vj_hlr/hl1_npc/rosenberg/ro_plfear1.wav","vj_hlr/hl1_npc/rosenberg/ro_plfear2.wav","vj_hlr/hl1_npc/rosenberg/ro_plfear3.wav","vj_hlr/hl1_npc/rosenberg/ro_plfear4.wav"}
	self.SoundTbl_OnGrenadeSight = {"vj_hlr/hl1_npc/rosenberg/ro_tele_final24.wav"}
	self.SoundTbl_Pain = {"vj_hlr/hl1_npc/rosenberg/ro_wound0.wav","vj_hlr/hl1_npc/rosenberg/ro_wound1.wav","vj_hlr/hl1_npc/rosenberg/ro_mortal0.wav","vj_hlr/hl1_npc/rosenberg/ro_mortal1.wav","vj_hlr/hl1_npc/rosenberg/ro_pain0.wav","vj_hlr/hl1_npc/rosenberg/ro_pain1.wav","vj_hlr/hl1_npc/rosenberg/ro_pain2.wav","vj_hlr/hl1_npc/rosenberg/ro_pain3.wav","vj_hlr/hl1_npc/rosenberg/ro_pain4.wav","vj_hlr/hl1_npc/rosenberg/ro_pain5.wav","vj_hlr/hl1_npc/rosenberg/ro_pain6.wav","vj_hlr/hl1_npc/rosenberg/ro_pain7.wav","vj_hlr/hl1_npc/rosenberg/ro_pain8.wav"}
	self.SoundTbl_DamageByPlayer = {"vj_hlr/hl1_npc/rosenberg/ro_plfear0.wav","vj_hlr/hl1_npc/rosenberg/ro_scared0.wav","vj_hlr/hl1_npc/rosenberg/ro_scared1.wav","vj_hlr/hl1_npc/rosenberg/ro_scared2.wav"}
	self.SoundTbl_Death = {"vj_hlr/hl1_npc/rosenberg/ro_pain0.wav","vj_hlr/hl1_npc/rosenberg/ro_pain1.wav","vj_hlr/hl1_npc/rosenberg/ro_pain2.wav","vj_hlr/hl1_npc/rosenberg/ro_pain3.wav","vj_hlr/hl1_npc/rosenberg/ro_pain4.wav","vj_hlr/hl1_npc/rosenberg/ro_pain5.wav","vj_hlr/hl1_npc/rosenberg/ro_pain6.wav","vj_hlr/hl1_npc/rosenberg/ro_pain7.wav","vj_hlr/hl1_npc/rosenberg/ro_pain8.wav"}

	self:SetBodygroup(1,5)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/opfor/massn.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_NPC_Class = {"CLASS_BLACKOPS"}

	-- ====== Sounds ====== --
ENT.SoundTbl_Idle = {
	"vj_hlr/hl1_npc/ops/of2a5_bo01.wav",
	"vj_hlr/hl1_npc/ops/package.mp3",
	"vj_hlr/hl1_npc/ops/of6a2_bo02.wav",
	"vj_hlr/hl1_npc/ops/of2a5_bo03.wav",
}
ENT.SoundTbl_CombatIdle = {

}
ENT.SoundTbl_OnReceiveOrder = {

}
ENT.SoundTbl_FollowPlayer = {

}
ENT.SoundTbl_UnFollowPlayer = {

}
ENT.SoundTbl_MedicBeforeHeal = {

}
ENT.SoundTbl_MedicReceiveHeal = {

}
ENT.SoundTbl_OnPlayerSight = {

}
ENT.SoundTbl_Alert = {
	"vj_hlr/hl1_npc/ops/of6a2_bo03.wav",
}
ENT.SoundTbl_CallForHelp = {
	"vj_hlr/hl1_npc/ops/of6a2_bo03.wav",
}
ENT.SoundTbl_Suppressing = {

}
ENT.SoundTbl_GrenadeAttack = {

}
ENT.SoundTbl_OnGrenadeSight = {

}
ENT.SoundTbl_OnKilledEnemy = {

}
ENT.SoundTbl_Pain = {
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain1.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain2.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain3.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain4.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain5.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/gr_pain6.wav",
}
ENT.SoundTbl_DamageByPlayer = {

}
ENT.SoundTbl_Death = {
	"vj_hlr/hl1_npc/hgrunt_oppf/death1.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death2.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death3.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death4.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death5.wav",
	"vj_hlr/hl1_npc/hgrunt_oppf/death6.wav",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HECU_CustomOnInitialize()
	self:SetBodygroup(1,math.random(0,2))
	self:SetBodygroup(2,math.random(0,1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(15, 15, 80), Vector(-15, -15, 0))
	self:HECU_CustomOnInitialize()
	self:Give("weapon_vj_hl_massassinwep")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	print(key)
	if key == "event_emit step" then
		self:FootStepSoundCode()
	end
	if key == "event_mattack" then
		self:MeleeAttackCode()
	end
	if key == "event_rattack mp5_fire" then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) then
			wep:NPCShoot_Primary(ShootPos,ShootDir)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	-- Veravorvadz kalel
	if self:Health() <= (self:GetMaxHealth() / 2.2) then
		self.AnimTbl_Walk = {ACT_WALK_HURT}
		self.AnimTbl_Run = {ACT_RUN_HURT}
		self.AnimTbl_ShootWhileMovingWalk = {ACT_WALK_HURT}
		self.AnimTbl_ShootWhileMovingRun = {ACT_RUN_HURT}
	else
		self.AnimTbl_Walk = {ACT_WALK}
		self.AnimTbl_Run = {ACT_RUN}
		self.AnimTbl_ShootWhileMovingWalk = {ACT_WALK}
		self.AnimTbl_ShootWhileMovingRun = {ACT_RUN}
	end
	
	local bgroup = self:GetBodygroup(2)
	if bgroup == 0 then -- MP5
		self.AnimTbl_WeaponAttack = {ACT_RANGE_ATTACK_SMG1}
		self.AnimTbl_WeaponAttackCrouch = {ACT_RANGE_ATTACK_SMG1_LOW}
		self.Weapon_StartingAmmoAmount = 50
	elseif bgroup == 1 then -- Sniper
		self.AnimTbl_WeaponAttack = {self:GetSequenceActivity(self:LookupSequence("standing_m40a1"))}
		self.AnimTbl_WeaponAttackCrouch = {self:GetSequenceActivity(self:LookupSequence("crouching_m40a1"))}
		self.Weapon_StartingAmmoAmount = 5
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(120)
		util.Effect("VJ_Blood1",bloodeffect)
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
	end
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh1.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh2.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh3.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/flesh4.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_bone.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,50))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_b_gib.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_guts.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,40))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_hmeat.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_lung.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,45))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_skull.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,60))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/hgib_legbone.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,15))})
	self:CreateGibEntity("obj_vj_gib","models/vj_hlr/gibs/gib_hgrunt.mdl",{BloodDecal="VJ_Blood_HL1_Red",Pos=self:LocalToWorld(Vector(0,0,15))})
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	self:SetBodygroup(2,2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
	self:SetBodygroup(2,2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDropWeapon_AfterWeaponSpawned(dmginfo,hitgroup,GetWeapon)
	GetWeapon:SetNWString("VJ_MAssassin_WeaponModel",self:GetActiveWeapon():GetNWInt("VJ_MAssassin_WeaponModel"))
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
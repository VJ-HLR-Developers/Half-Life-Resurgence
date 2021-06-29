if CLIENT then return end
print("Executing Half-Life Resurgence auto replace script...")

-- https://developer.valvesoftware.com/wiki/Half-Life.fgd
-- https://developer.valvesoftware.com/wiki/Half_Life_2.fgd

local replaceTbl_Entities = {
		-- Half-Life 1 --
	["monster_alien_grunt"] = "npc_vj_hlr1_aliengrunt",
	["monster_nihilanth"] = "npc_vj_hlr1_nihilanth",
	["monster_tentacle"] = "npc_vj_hlr1_tentacle",
	["monster_alien_slave"] = "npc_vj_hlr1_alienslave",
	["monster_bigmomma"] = "npc_vj_hlr1_gonarch",
	["monster_bullchicken"] = "npc_vj_hlr1_bullsquid",
	["monster_gargantua"] = "npc_vj_hlr1_garg",
	["monster_human_assassin"] = "npc_vj_hlr1_assassin_female",
	["monster_babycrab"] = "npc_vj_hlr1_headcrab_baby",
	-- ["monster_human_grunt"] = {"npc_vj_hlr1_hgrunt","npc_vj_hlrof_hgrunt","npc_vj_hlrof_hgrunt_med","npc_vj_hlrof_hgrunt_eng"},
	["monster_human_grunt"] = "npc_vj_hlr1_hgrunt",
	["monster_cockroach"] = "npc_vj_hlr1_cockroach",
	["monster_houndeye"] = "npc_vj_hlr1_houndeye",
	["monster_scientist"] = "npc_vj_hlr1_scientist",
	["monster_sitting_scientist"] = "npc_vj_hlr1_scientist",
	["monster_snark"] = "npc_vj_hlr1_snark",
	["monster_zombie"] = {"npc_vj_hlr1_zombie","npc_vj_hlr1_zombie","npc_vj_hlr1_zombie","npc_vj_hlrof_zombie_sec","npc_vj_hlrof_zombie_sec","npc_vj_hlrof_zombie_soldier"},
	["monster_headcrab"] = "npc_vj_hlr1_headcrab",
	["monster_alien_controller"] = "npc_vj_hlr1_aliencontroller",
	["monster_barney"] = "npc_vj_hlr1_securityguard",
	["monster_turret"] = "npc_vj_hlr1_turret",
	["monster_miniturret"] = "npc_vj_hlr1_turret_small",
	["monster_sentry"] = "npc_vj_hlr1_sentry",
	["monster_barnacle"] = "npc_vj_hlr1_barnacle",
	["monster_ichthyosaur"] = "npc_vj_hlr1_ichthyosaur",
	["monster_gman"] = "npc_vj_hlr1_gman",
	["monster_apache"] = "npc_vj_hlr1_apache",
	["monster_osprey"] = "npc_vj_hlr1_osprey",
	["monster_turret"] = "npc_vj_hlr1_cturret",
	["monster_miniturret"] = "npc_vj_hlr1_cturret_mini",
		-- Half-Life 2 --
	["npc_advisor"] = "npc_vj_hlr2_com_advisor",
	["npc_alyx"] = "npc_vj_hlr2_alyx",
	["npc_antlion"] = "npc_vj_hlr2_antlion",
	["npc_antlion_worker"] = "npc_vj_hlr2_antlion_worker",
	["npc_antlionguard"] = "npc_vj_hlr2_antlion_guard",
	["npc_barney"] = "npc_vj_hlr2_barney",
	["npc_citizen"] = "npc_vj_hlr2_citizen",
	["npc_combine_s"] = "npc_vj_hlr2_com_soldier",
	["npc_combinegunship"] = "npc_vj_hlr2_com_gunship",
	["npc_crabsynth"] = "npc_vj_hlr2_com_crab",
	["npc_fastzombie"] = "npc_vj_hlr2_zombie_fast",
	["npc_gman"] = "npc_vj_hlr2_gman",
	["npc_headcrab"] = "npc_vj_hlr2_headcrab",
	["npc_headcrab_black"] = "npc_vj_hlr2_headcrab_poison",
	["npc_headcrab_fast"] = "npc_vj_hlr2_headcrab_fast",
	["npc_helicopter"] = "npc_vj_hlr2_com_chopper",
	["npc_hunter"] = "npc_vj_hlr2_com_hunter",
	["npc_metropolice"] = "npc_vj_hlr2_com_civilp",
	["npc_monk"] = "npc_vj_hlr2_father_grigori",
	["npc_mortarsynth"] = "npc_vj_hlr2_com_mortar",
	["npc_poisonzombie"] = "npc_vj_hlr2_zombie_poison",
	["npc_sniper"] = "npc_vj_hlr2_com_sniper",
	["npc_stalker"] = "npc_vj_hlr2_com_stalker",
	["npc_strider"] = "npc_vj_hlr2_com_strider",
	["npc_turret_ceiling"] = "npc_vj_hlr2_com_ceilingturret",
	["npc_turret_floor"] = "npc_vj_hlr2_com_sentry",
	["npc_zombie"] = "npc_vj_hlr2_zombie",
	["npc_zombine"] = "npc_vj_hlr2_zombine",
	["prop_vehicle_apc"] = "npc_vj_hlr2_com_apc",
}

local replaceTbl_Weapons = {
		-- Half-Life 2 --
	["weapon_357"] = "weapon_vj_357",
	["weapon_alyxgun"] = "weapon_vj_hlr2_alyxgun",
	["weapon_annabelle"] = "weapon_vj_hlr2_annabelle",
	["weapon_ar2"] = "weapon_vj_ar2",
	["weapon_crossbow"] = "weapon_vj_crossbow",
	["weapon_crowbar"] = "weapon_vj_crowbar",
	["weapon_pistol"] = "weapon_vj_9mmpistol",
	["weapon_rpg"] = "weapon_vj_hlr2_rpg",
	["weapon_shotgun"] = "weapon_vj_spas12",
	["weapon_smg1"] = "weapon_vj_smg1",
	["weapon_stunstick"] = "weapon_vj_hlr2_stunstick"
}

-- Before Create
local replaceOptions = {
	-- If its an antlion guardian, then make sure to spawn that variant!
	["npc_antlionguard"] = function(ent, replaceEnt)
		return (ent:GetSkin() == 0 && "npc_vj_hlr2_antlion_guard") or "npc_vj_hlr2_antlion_guardian"
	end,
	-- Handle citizen / refugee / rebel variants
	["npc_citizen"] = function(ent, replaceEnt)
		for key, val in pairs(ent:GetKeyValues()) do
			if key == "citizentype" then
				if val == 0 or val == 1 then
					return "npc_vj_hlr2_citizen"
				elseif val == 2 then
					return "npc_vj_hlr2_refugee"
				elseif val == 3 or val == 4 then
					return "npc_vj_hlr2_rebel"
				end
			end
		end
	end,
	-- Handle combine soldier variants
	["npc_combine_s"] = function(ent, replaceEnt)
		local mdl = ent:GetModel()
		if mdl == "models/combine_soldier.mdl" then
			return (ent:GetSkin() == 0 && "npc_vj_hlr2_com_soldier") or "npc_vj_hlr2_com_shotgunner"
		elseif mdl == "models/combine_soldier_prisonguard.mdl" then
			return (ent:GetSkin() == 0 && "npc_vj_hlr2_com_prospekt") or "npc_vj_hlr2_com_prospekt_sg"
		elseif mdl == "models/combine_super_soldier.mdl" then
			return "npc_vj_hlr2_com_elite"
		end
	end
}

-- Before Spawn
local replacePreSpawn = {
	["npc_citizen"] = function(ent, newEnt)
		if string.find(ent:GetModel(), "female") then
			newEnt.Human_Gender = 1
		else
			newEnt.Human_Gender = 0
		end
	end,
}

-- After Spawn
-- local afterSpawned = {}

local defPos = Vector(0, 0, 0)

local gStatePrecriminal = false
local gStateAntlionFri = false

hook.Add("OnEntityCreated", "VJ_HLR_AutoReplace_EntCreate", function(ent)
	local class = ent:GetClass()
	local rEnt = VJ_PICK(replaceTbl_Entities[class])
	if rEnt then
		-- Make sure the game is loaded
		if game && game.GetGlobalState then
			gStatePrecriminal = game.GetGlobalState("gordon_precriminal") == 1
		end
		-- Check if it's HL1 & HL2 and stop if it's not supposed to continue
		local isHL1 = string.StartWith(class, "monster_")
		if isHL1 then
			if GetConVar("vj_hlr_autoreplace_hl1"):GetInt() == 0 then
				return
			end
		elseif GetConVar("vj_hlr_autoreplace_hl2"):GetInt() == 0 then
			return
		end
		timer.Simple(0.01, function()
			if IsValid(ent) then
				local worldName = ent.GetName && ent:GetName() or nil
				//local spawnAnim = ent:GetSequenceName(ent:GetSequence())
				-- Spawn the correct entity (Ex: different combine or rebels/citizens)
				if replaceOptions[class] then
					rEnt = replaceOptions[class](ent, rEnt) or rEnt
				end
				if GetConVar("vj_hlr_autoreplace_random"):GetInt() == 1 then
					local tempTable = {}
					for oldClass,newClass in pairs(replaceTbl_Entities) do -- Not sure what the best way is to do this, feel free to mess with it @Vrej
						if isHL1 then
							if string.StartWith(oldClass, "monster_") then
								table.insert(tempTable,newClass)
							end
						else
							table.insert(tempTable,newClass)
						end
					end
					rEnt = VJ_PICK(tempTable) or rEnt
				end
				-- Start the actual final entity --
				local finalEnt = ents.Create(VJ_PICK(rEnt))
				if !IsValid(finalEnt) then MsgN("Entity [" .. rEnt .. "] not valid (missing pack?), keeping original entity") return end
				-- Certain entities need some checks before spawn (Ex: Citizen gender)
				if replacePreSpawn[class] then
					replacePreSpawn[class](ent,finalEnt)
				end
				finalEnt:SetPos(ent:GetPos() + Vector(0, 0, (class == "monster_barnacle" && -1) or 4))
				finalEnt:SetAngles(ent:GetAngles())
				finalEnt:Spawn()
				finalEnt:Activate()
				-- Handle naming
				if worldName then
					finalEnt:SetName(worldName)
					if worldName != "" then -- Scripted NPC
						finalEnt.DisableWandering = true
					end
				end
				-- Handle weapon
				local wep = ent:GetActiveWeapon()
				if IsValid(wep) then
					local foundWep = replaceTbl_Weapons[wep:GetClass()]
					finalEnt:Give(VJ_PICK(foundWep))
				end
				-- Handle enemy
				local ene = ent:GetEnemy()
				if IsValid(ene) then
					finalEnt:SetEnemy(ene)
				end
				-- Handle key values
				for key, val in pairs(ent:GetSaveTable()) do
					key = tostring(key)
					if key == "health" then
						finalEnt:SetHealth(val)
					elseif key == "max_health" then
						finalEnt:SetMaxHealth(val)
					-- elseif key == "m_bSequenceLoops" && val == true && finalEnt:GetInternalVariable("sequence") != -1 then
						-- finalEnt.Old_AnimTbl_IdleStand = finalEnt.AnimTbl_IdleStand
						-- finalEnt.AnimTbl_IdleStand = {VJ_SequenceToActivity(finalEnt,finalEnt:GetInternalVariable("sequence"))}
						-- finalEnt:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
						-- finalEnt:VJ_ACT_PLAYACTIVITY(finalEnt:GetInternalVariable("sequence"),true,false,false)
					elseif key == "m_vecLastPosition" then
						if val != defPos then
							finalEnt:SetLastPosition(val)
							finalEnt:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
						end
					end
				end
				-- Handle Gordon precriminal game state
				if gStatePrecriminal == true then -- Toggles friendly-AI for the intro of Half-Life 2
					//finalEnt.DisableWandering = true
					finalEnt.DisableFindEnemy = true
					finalEnt.DisableMakingSelfEnemyToNPCs = true
					finalEnt.FriendsWithAllPlayerAllies = true
					finalEnt.FollowPlayer = false
					finalEnt.Behavior = VJ_BEHAVIOR_PASSIVE
					finalEnt.VJ_AutoScript_OldClass = finalEnt.VJ_NPC_Class
					finalEnt.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
					finalEnt.VJ_AutoScript_Reset = true
				end
				-- Things to run after it's fully spawned (EX: )
				-- NONE atm
				//if afterSpawned[rEnt] then
					//afterSpawned[rEnt](ent,finalEnt)
				//end
				-- print(ent:GetClass(), ent:GetInternalVariable("GameEndAlly"))
				-- Set the starting animation AND velocity
				local vel = ent:GetVelocity()
				timer.Simple(0.01, function()
					if IsValid(finalEnt) then
						//finalEnt:VJ_ACT_PLAYACTIVITY(spawnAnim, true, false, false)
						if vel:Length() > 0 then
							finalEnt:SetGroundEntity(NULL)
							finalEnt:SetVelocity(vel)
						end
					end
				end)
				undo.ReplaceEntity(ent, finalEnt)
				ent:Remove()
			end
		end)
	end
end)

hook.Add("Think", "VJ_HLR_AutoReplace_Think", function()
	-- Make sure the game is loaded
	if game && game.GetGlobalState then
		gStatePrecriminal = game.GetGlobalState("gordon_precriminal") == 1
		gStateAntlionFri = game.GetGlobalState("antlion_allied") == 1
	end
	for _,v in pairs(ents.GetAll()) do
		if v:IsNPC() then
			if !gStatePrecriminal && v.VJ_AutoScript_Reset then
				v.VJ_NPC_Class = v.VJ_AutoScript_OldClass
				v.VJ_AutoScript_Reset = false
			end
			if gStateAntlionFri && v.VJ_HLR_Antlion then
				table.insert(v.VJ_NPC_Class,"CLASS_PLAYER_ALLY")
				v.PlayerFriendly = true
				v.FriendsWithAllPlayerAllies = true
			end
		end
	end
end)
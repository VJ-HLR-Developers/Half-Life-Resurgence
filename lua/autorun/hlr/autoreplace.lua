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

local essentialTbl = { -- Will expand upon this later, I recommend we add support for custom HLR packs to add their own data to the auto-replace script (Example: Half-Life 2 HLR pack adding Kleiner or Breen to the auto-script)
		-- Half-Life 2 --
	npc_vj_hlr2_alyx=true,
	npc_vj_hlr2_barney=true,
	npc_vj_hlr2_father_grigori=true,
}

-- Before Create
local replaceOptions = {
	-- If its an antlion guardian, then make sure to spawn that variant!
	["npc_antlionguard"] = function(ent, replaceEnt)
		return (ent:GetSkin() == 0 and "npc_vj_hlr2_antlion_guard") or "npc_vj_hlr2_antlion_guardian"
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
			return (ent:GetSkin() == 0 and "npc_vj_hlr2_com_soldier") or "npc_vj_hlr2_com_shotgunner"
		elseif mdl == "models/combine_soldier_prisonguard.mdl" then
			return (ent:GetSkin() == 0 and "npc_vj_hlr2_com_prospekt") or "npc_vj_hlr2_com_prospekt_sg"
		elseif mdl == "models/combine_super_soldier.mdl" then
			return "npc_vj_hlr2_com_elite"
		end
	end,
	-- Check for resistance turrets!
	["npc_turret_floor"] = function(ent, replaceEnt)
		return ent:HasSpawnFlags(SF_FLOOR_TURRET_CITIZEN) and "npc_vj_hlr2_res_sentry" or "npc_vj_hlr2_com_sentry"
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
	["npc_metropolice"] = function(ent, newEnt)
		for key, val in pairs(ent:GetKeyValues()) do
			if key == manhacks && val == 0 then
				newEnt.Metrocop_CanHaveManhack = false
			end
		end
	end,
}

-- After Spawn
local afterSpawned = {
	
}

// lua_run PrintTable(Entity(1):GetEyeTrace().Entity:GetTable())
local defPos = Vector(0, 0, 0)

local gStatePrecriminal = false
local gStateAntlionFri = false

-- Prepare the HL1 and HL2 tables (This includes ALL NPCs!)
local allNPCs = list.Get("NPC")
local allHLR = {}
local allHLR1 = {}
local allHLR2 = {}
timer.Simple(0.01, function()
	for k, _ in pairs(allNPCs) do
		-- This should capture all the HL2 NPCs
		if string.StartWith(k, "npc_vj_hlr2") then
			table.insert(allHLR, k)
			table.insert(allHLR2, k)
		-- This should capture all the HL1 NPCs because many of them are "hlrof", "hlr1", "hlrsv", "hlrdc", etc.
		elseif string.StartWith(k, "npc_vj_hlr") then
			table.insert(allHLR, k)
			table.insert(allHLR1, k)
		end
	end
end)


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
				//if worldName == "rocketman" then return end -- Makes Odessa work a little bit
				//local spawnAnim = ent:GetSequenceName(ent:GetSequence())
				-- Spawn the correct entity (Ex: different combine or rebels/citizens)
				if replaceOptions[class] then
					rEnt = replaceOptions[class](ent, rEnt) or rEnt
				end
				-- FUN OPTION: Randomized NPC System
				if GetConVar("vj_hlr_autoreplace_random"):GetInt() == 1 then
					if GetConVar("vj_hlr_autoreplace_randommix"):GetInt() == 1 then
						rEnt = VJ_PICK(allHLR) or rEnt
					else
						if isHL1 then
							rEnt = VJ_PICK(allHLR1) or rEnt
						else
							rEnt = VJ_PICK(allHLR2) or rEnt
						end
					end
				end
				-- Start the actual final entity --
				local newClass = VJ_PICK(rEnt)
				local newEnt = ents.Create(newClass)
				if !IsValid(newEnt) then MsgN("Entity [" .. newClass .. "] not valid (missing pack?), keeping original entity") return end
				-- Certain entities need some checks before spawn (Ex: Citizen gender)
				if replacePreSpawn[class] then
					replacePreSpawn[class](ent, newEnt)
				end
				newEnt:SetPos(ent:GetPos() + Vector(0, 0, (class == "monster_barnacle" && -1) or 4))
				newEnt:SetAngles(ent:GetAngles())
				if IsValid(ent:GetParent()) then newEnt:SetParent(ent:GetParent()) end
				newEnt:Spawn()
				newEnt:Activate()
				-- Handle naming
				if worldName then
					newEnt:SetName(worldName)
					if worldName != "" then -- Scripted NPC
						newEnt.DisableWandering = true
					end
				end
				-- Handle weapon
				local wep = ent.GetActiveWeapon && ent:GetActiveWeapon() or false -- In case GetActiveWeapon is not in the ent's metatable
				print(worldName, wep)
				if IsValid(wep) then
					local foundWep = replaceTbl_Weapons[wep:GetClass()]
					newEnt:Give(VJ_PICK(foundWep))
				end
				-- Handle enemy
				local ene = ent.GetEnemy && ent:GetEnemy() or false -- In case GetEnemy is not in the ent's metatable
				if IsValid(ene) then
					newEnt:SetEnemy(ene)
				end
				-- Handle key values
				for key, val in pairs(ent:GetSaveTable()) do
					//newEnt:SetSaveValue(key, val)
					key = tostring(key)
					if key == "health" then
						newEnt:SetHealth(val)
					elseif key == "max_health" then
						newEnt:SetMaxHealth(val)
					-- elseif key == "m_bSequenceLoops" && val == true && newEnt:GetInternalVariable("sequence") != -1 then
						-- newEnt.Old_AnimTbl_IdleStand = newEnt.AnimTbl_IdleStand
						-- newEnt.AnimTbl_IdleStand = {VJ_SequenceToActivity(newEnt,newEnt:GetInternalVariable("sequence"))}
						-- newEnt:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
						-- newEnt:VJ_ACT_PLAYACTIVITY(newEnt:GetInternalVariable("sequence"),true,false,false)
					elseif key == "m_vecLastPosition" then
						if val != defPos then
							newEnt:SetLastPosition(val)
							newEnt:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
						end
					elseif key == "m_bShouldPatrol" && val == false then
						newEnt.DisableWandering = true
					-- Not what I thought it was, actual variable is m_LookDist using the function SetDistLook
					-- Which both of them can't be accessed in Lua...
					//elseif key == "m_flDistTooFar" then
						//newEnt.SightDistance = val
					end
				end
				//newEnt.SightDistance = 2048 -- Default Source engine sight distance...
				-- Handle spawn flags
				//if ent:HasSpawnFlags(SF_NPC_LONG_RANGE) then
					//newEnt.SightDistance = 6000
				//end
				newEnt:SetKeyValue("spawnflags", ent:GetSpawnFlags())
				if ent:HasSpawnFlags(SF_CITIZEN_NOT_COMMANDABLE) then
					newEnt.FollowPlayer = false
				end
				//print(ent:GetInternalVariable("m_bShouldPatrol"))
				-- Handle Gordon precriminal game state
				if gStatePrecriminal == true then -- Toggles friendly-AI for the intro of Half-Life 2
					//newEnt.DisableWandering = true
					newEnt.DisableFindEnemy = true
					newEnt.DisableMakingSelfEnemyToNPCs = true
					newEnt.FriendsWithAllPlayerAllies = true
					newEnt.FollowPlayer = false
					newEnt.Behavior = VJ_BEHAVIOR_PASSIVE
					newEnt.VJ_AutoScript_OldClass = newEnt.VJ_NPC_Class
					newEnt.VJ_NPC_Class = {"CLASS_PLAYER_ALLY", "CLASS_COMBINE"}
					newEnt.VJ_AutoScript_Reset = true
				end
				-- Things to run after it's fully spawned (EX: Turret sight distance)
				if afterSpawned[rEnt] then
					afterSpawned[rEnt](ent, newEnt)
				end
				-- Handle Essential NPCs
				if GetConVar("vj_hlr_autoreplace_essential"):GetInt() == 1 && essentialTbl[newClass] then
					newEnt.GodMode = true
				end
				-- FUN OPTION: Make them all allied together against players
				if GetConVar("vj_hlr_autoreplace_alliedagainstply"):GetInt() == 1 then
					newEnt.VJ_NPC_Class = {"CLASS_HALF_LIFE_AGAINST_PLAYERS"}
				end
				-- print(ent:GetClass(), ent:GetInternalVariable("GameEndAlly"))
				-- Set the starting animation AND velocity
				local vel = ent:GetVelocity()
				timer.Simple(0.01, function()
					if IsValid(newEnt) then
						//newEnt:VJ_ACT_PLAYACTIVITY(spawnAnim, true, false, false)
						if vel:Length() > 0 then
							newEnt:SetGroundEntity(NULL)
							newEnt:SetVelocity(vel)
						end
					end
				end)
				undo.ReplaceEntity(ent, newEnt)
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
function GetClassnameFromWorldModel(worldModel){
	switch(worldModel){
		case "models/w_models/weapons/w_shotgun.mdl":{
			return "weapon_pumpshotgun"
		}
		case "models/w_models/weapons/w_pumpshotgun_A.mdl":{
			return "weapon_shotgun_chrome"
		}
		case "models/w_models/weapons/w_shotgun_spas.mdl":{
			return "weapon_shotgun_spas"
		}
		case "models/w_models/weapons/w_autoshot_m4super.mdl":{
			return "weapon_autoshotgun"
		}
		case "models/w_models/weapons/w_rifle_m16a2.mdl":{
			return "weapon_rifle"
		}
		case "models/w_models/weapons/w_rifle_ak47.mdl":{
			return "weapon_rifle_ak47"
		}
		case "models/w_models/weapons/w_desert_rifle.mdl":{
			return "weapon_rifle_desert"
		}
		case "models/w_models/weapons/w_m60.mdl":{
			return "weapon_rifle_m60"
		}
		case "models/w_models/weapons/w_rifle_sg552.mdl":{
			return "weapon_rifle_sg552"
		}
		case "models/w_models/weapons/w_sniper_mini14.mdl":{
			return "weapon_hunting_rifle"
		}
		case "models/w_models/weapons/w_sniper_awp.mdl":{
			return "weapon_sniper_awp"
		}
		case "models/w_models/weapons/w_sniper_military.mdl":{
			return "weapon_sniper_military"
		}
		case "models/w_models/weapons/w_sniper_scout.mdl":{
			return "weapon_sniper_scout"
		}
		case "models/w_models/weapons/w_smg_uzi.mdl":{
			return "weapon_smg"
		}
		case "models/w_models/weapons/w_smg_mp5.mdl":{
			return "weapon_smg_mp5"
		}
		case "models/w_models/weapons/w_smg_a.mdl":{
			return "weapon_smg_silenced"
		}
	}
}

function FindNearestSpawn(weapon){
	local origin = weapon.GetOrigin()
	local classname = weapon.GetClassname()
	
	local spawns = [Entities.FindByClassnameNearest(classname + "_spawn", origin, 200)]
	
	local ent = null
	while(ent = Entities.FindByClassnameWithin(ent, "weapon_spawn", origin, 200)){
		if(GetClassnameFromWorldModel(NetProps.GetPropString(ent, "m_ModelName")) == classname){
			spawns.append(ent)
		}
	}
	
	local closestSpawn = null
	local closestDistance = 9999
	foreach(spawn in spawns){
		if(spawn != null && (origin - spawn.GetOrigin()).Length() < closestDistance){
			closestSpawn = spawn
			closestDistance = (origin - spawn.GetOrigin()).Length()
		}
	}
	
	return closestSpawn
}

function HasWeapon(player, classname){
	for(local i=0; i < 10; i++){
		local weapon = NetProps.GetPropEntityArray(player, "m_hMyWeapons", i)
		if(weapon != null && weapon.GetClassname() == classname){
			return weapon
		}
	}
	return false
}

function OnGameEvent_weapon_drop(params){
	if("propid" in params){
		local weapon = EntIndexToHScript(params.propid)
		local player = GetPlayerFromUserID(params.userid)
		local nearestSpawn = FindNearestSpawn(weapon)
		player.ValidateScriptScope()
		if(nearestSpawn != null){
			local index = nearestSpawn.GetEntityIndex()
			player.GetScriptScope()["spawn_" + index] <- {
				clip = NetProps.GetPropInt(weapon, "m_iClip1")
				ammo = NetProps.GetPropIntArray(player, "m_iAmmo", NetProps.GetPropInt(weapon, "m_iPrimaryAmmoType"))
			}
		}
	}
}

function OnGameEvent_player_use(params){

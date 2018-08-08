function OnGameEvent_player_connect(params){
	if(!params.bot){
		local log = "Player " + params.name + " connected from " + params.address + " with SteamID: " + params.networkid
		
		printl(log)
		
		local file = FileToString("connect_log.txt")
		if(file == null){
			StringToFile("connect_log.txt", log)
		} else {
			StringToFile("connect_log.txt", file + log + "\n")
		}
	}
}

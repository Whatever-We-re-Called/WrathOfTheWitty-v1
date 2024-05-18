extends Node

var player_info: PlayerInfo

const DEBUG_SEED_OVERRIDE: String = ""


func start_run(player_info: PlayerInfo, seed: String):
	self.player_info = player_info.duplicate(true)
	if DEBUG_SEED_OVERRIDE.length() > 0:
		SeededGenerator.set_seed(DEBUG_SEED_OVERRIDE)
	else:
		SeededGenerator.set_seed(seed)
	
	MapManager.swap_to_map_scene()

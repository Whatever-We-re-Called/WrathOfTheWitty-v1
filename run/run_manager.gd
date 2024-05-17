extends Node

var player_info: PlayerInfo

const DEBUG_SEED_OVERRIDE: String = ""

func _ready():
	# TODO Tie start call to somewhere else.
	var seed = SeededGenerator.generate_seed()
	start_run(preload("res://players/info/players/test_scrimblo_info.tres"), seed)


func start_run(player_info: PlayerInfo, seed: String):
	self.player_info = player_info.duplicate(true)
	if DEBUG_SEED_OVERRIDE.length() > 0:
		SeededGenerator.set_seed(DEBUG_SEED_OVERRIDE)
	else:
		SeededGenerator.set_seed(seed)
	

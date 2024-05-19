extends Node

var player_info: PlayerInfo
var floor: int

const DEBUG_SEED_OVERRIDE: String = ""
const START_MENU_SCENE = preload("res://ui/menus/start_menu.tscn")
const LAST_FLOOR: int = 6


func start_run(player_info: PlayerInfo, seed: String):
	self.player_info = player_info.duplicate(true)
	if DEBUG_SEED_OVERRIDE.length() > 0:
		SeededGenerator.set_seed(DEBUG_SEED_OVERRIDE)
	else:
		SeededGenerator.set_seed(seed)
	self.floor = 1
	
	MapManager.swap_to_map_scene()


func end_run():
	get_tree().change_scene_to_packed(START_MENU_SCENE)


func update_player_info(battle_player: BattlePlayer):
	player_info.current_health = battle_player.health


func increment_floor():
	floor += 1
	
	if floor > LAST_FLOOR:
		end_run()

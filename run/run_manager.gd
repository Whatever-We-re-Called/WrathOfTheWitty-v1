extends Node

var player_info: PlayerInfo:
	get:
		if player_info == null:
			return TEST_PLAYER_SCENE
		else:
			return _current_player_info
	set(value):
		_current_player_info = value
var floor: int

var _current_player_info

const START_MENU_SCENE = preload("res://ui/menus/start_menu.tscn")
const TEST_PLAYER_SCENE = preload("res://players/info/players/test_scrimblo_info.tres")
const PLAYER_INFO_UI = preload("res://players/info/player_info_ui.tscn")
const LAST_FLOOR: int = 6


func start_run(player_info: PlayerInfo, seed: String):
	self.player_info = player_info.duplicate(true)
	print(seed)
	SeededGenerator.set_seed(seed)
	self.floor = 1
	
	player_info.init_unhandled_equipped_blessings()
	player_info.init_unhandled_equipped_template_cards()
	
	MapManager.swap_to_map_scene()


func end_run():
	MapManager.reset_map()
	get_tree().change_scene_to_packed(START_MENU_SCENE)


func update_player_info(battle_player: BattlePlayer):
	player_info.current_health = battle_player.health


func increment_floor():
	floor += 1
	
	if floor > LAST_FLOOR:
		end_run()


func is_on_valid_floor() -> bool:
	return floor <= LAST_FLOOR


func is_on_last_floor() -> bool:
	return floor == LAST_FLOOR


func open_player_info_ui(ui_parent: Node):
	var player_info_ui = PLAYER_INFO_UI.instantiate()
	ui_parent.add_child(player_info_ui)
	player_info_ui.init(RunManager.player_info)

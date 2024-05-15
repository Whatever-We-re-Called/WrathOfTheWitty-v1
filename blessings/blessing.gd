class_name Blessing extends Resource

signal equipped
signal unequipped
signal battle_started
signal battle_ended
signal turn_started
signal turn_ended
signal damaged
signal rerolled_card

@export var name: String
@export var texture: Texture2D
@export var is_cosmic: bool
@export_multiline var description: String
@export var execution_script: Script

var execution_script_instance = null

const NORMAL_COLOR = Color("#e59544")
const COSMIC_COLOR = Color("#9544e5")

func init(player_info: PlayerInfo):
	if execution_script == null: return
	
	execution_script_instance = execution_script.new()
	
	execution_script_instance.player_info = player_info
	
	execution_script_instance.blessing = self
	equipped.connect(execution_script_instance._on_equipped)
	unequipped.connect(execution_script_instance._on_unequipped)
	battle_started.connect(execution_script_instance._on_battle_started)
	battle_ended.connect(execution_script_instance._on_battle_ended)
	turn_started.connect(execution_script_instance._on_turn_started)
	turn_ended.connect(execution_script_instance._on_turn_ended)
	damaged.connect(execution_script_instance._on_damaged)
	rerolled_card.connect(execution_script_instance._on_rerolled_card)


func get_tooltip():
	var name = name
	if is_cosmic:
		name += " (Cosmic)"
	var description = description
	
	return name + ": " + description

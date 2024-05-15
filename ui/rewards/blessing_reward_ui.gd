extends Control

signal depleted_choices

@onready var choices_remaining_label = %ChoicesRemainingLabel
@onready var blessing_options_container = %BlessingOptionsContainer

var options_count: int
var choices_count: int
var options: Array[Blessing]

const NORMAL_BLESSINGS_LOOT_TABLE = preload("res://blessings/normal_blessings_loot_table.tres")
const BLESSING_OPTION_BUTTON = preload("res://ui/rewards/blessing_option_button.tscn")


func init(player_info: PlayerInfo, options_count: int, choices_count: int):
	self.options_count = options_count
	self.choices_count = choices_count
	
	choices_remaining_label.text = str(choices_count)
	
	_decide_options()
	_update_options_visuals()


func _decide_options():
	var loot_table_result = NORMAL_BLESSINGS_LOOT_TABLE.get_random_unique_entries(options_count)
	for entry in loot_table_result:
		var blessing = load(entry.resource.resource_path)
		options.append(blessing)


func _update_options_visuals():
	for child in blessing_options_container.get_children():
		child.free()
	
	for option in options:
		var blessing_option_button = BLESSING_OPTION_BUTTON.instantiate()
		blessing_option_button.init(option)
		blessing_options_container.add_child(blessing_option_button)


func _decrement_choices():
	choices_count -= 1
	choices_remaining_label.text = str(choices_count)
	_update_options_visuals()
	
	if choices_count <= 0:
		depleted_choices.emit()

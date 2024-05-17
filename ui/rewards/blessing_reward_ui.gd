extends RewardUI

@onready var choices_remaining_label = %ChoicesRemainingLabel
@onready var blessing_options_container = %BlessingOptionsContainer

var player_info: PlayerInfo
var options_count: int
var choices_count: int
var options: Array[Blessing]

const COSMIC_BLESSING_CHANCE = 0.05
const NORMAL_BLESSINGS_LOOT_TABLE = preload("res://blessings/normal_blessings_loot_table.tres")
const COSMIC_BLESSINGS_LOOT_TABLE = preload("res://blessings/cosmic_blessings_loot_table.tres")
const BLESSING_OPTION_BUTTON = preload("res://ui/rewards/blessing_option_button.tscn")


func init(player_info: PlayerInfo, options_count: int, choices_count: int):
	self.player_info = player_info
	self.options_count = options_count
	self.choices_count = choices_count
	
	choices_remaining_label.text = str(choices_count)
	
	_decide_options()
	_update_options_visuals()


func _decide_options():
	var loot_table_result: Array[Resource]
	var rng = RandomNumberGenerator.new()
	
	var normal_blessings_quantity = options_count
	var cosmic_blessings_quantity = 0
	for i in range(options_count):
		var number = rng.randf_range(0.0, 1.0)
		if number <= COSMIC_BLESSING_CHANCE:
			normal_blessings_quantity -= 1
			cosmic_blessings_quantity += 1
	
	var normal_blessings_result = NORMAL_BLESSINGS_LOOT_TABLE.get_random_unique_entries(normal_blessings_quantity)
	for entry in normal_blessings_result:
		var blessing = load(entry.resource.resource_path)
		options.append(blessing)
	
	var cosmic_blessings_result = COSMIC_BLESSINGS_LOOT_TABLE.get_random_unique_entries(cosmic_blessings_quantity)
	for entry in cosmic_blessings_result:
		var blessing = load(entry.resource.resource_path)
		options.append(blessing)
	
	randomize()
	options.shuffle()


func _update_options_visuals():
	for child in blessing_options_container.get_children():
		child.queue_free()
	
	for i in range(options.size()):
		var blessing_option_button = BLESSING_OPTION_BUTTON.instantiate()
		blessing_option_button.init(options[i])
		blessing_option_button.pressed.connect(_select_option.bind(i))
		blessing_options_container.add_child(blessing_option_button)


func _select_option(index: int):
	player_info.add_blessing(Blessings.get_type(options[index]))
	
	options.remove_at(index)
	_decrement_choices()
	_update_options_visuals()


func _decrement_choices():
	choices_count -= 1
	choices_remaining_label.text = str(choices_count)
	_update_options_visuals()
	
	if choices_count <= 0:
		finished.emit()


func _on_skip_button_pressed():
	finished.emit()

extends RewardUI

@onready var choices_remaining_label = %ChoicesRemainingLabel
@onready var enhancement_options_container = %EnhancementOptionsContainer

var player_info: PlayerInfo
var options_count: int
var choices_count: int
var options: Array[Constants.CardEnhancement]

const ENHANCEMENT_OPTION_BUTTON = preload("res://ui/rewards/enhancement_option_button.tscn")
const APPLY_ENHANCEMENT_UI = preload("res://ui/apply_enhancement_ui.tscn")


func init(player_info: PlayerInfo, options_count: int, choices_count: int):
	self.player_info = player_info
	self.options_count = options_count
	self.choices_count = choices_count
	
	choices_remaining_label.text = str(choices_count)
	
	_decide_options()
	_update_options_visuals()


func _decide_options():
	var possible_enhancements = Constants.CardEnhancement.values()
	possible_enhancements.remove_at(0)
	
	var rng = RandomNumberGenerator.new()
	randomize()
	possible_enhancements.shuffle()
	for i in range(options_count):
		options.append(possible_enhancements[0])
		possible_enhancements.remove_at(0)


func _update_options_visuals():
	for child in enhancement_options_container.get_children():
		child.queue_free()
	
	for i in range(options.size()):
		var enhancement_option_button = ENHANCEMENT_OPTION_BUTTON.instantiate()
		enhancement_option_button.text = Constants.enhancement_strings[options[i]]
		enhancement_option_button.pressed.connect(_select_option.bind(i))
		enhancement_options_container.add_child(enhancement_option_button)


func _select_option(index: int):
	var apply_enhancement_ui = APPLY_ENHANCEMENT_UI.instantiate()
	get_parent().add_child(apply_enhancement_ui)
	apply_enhancement_ui.init(player_info, options[index])
	self.visible = false
	await apply_enhancement_ui.finished
	
	self.visible = true
	apply_enhancement_ui.queue_free()
	
	options.remove_at(index)
	_decrement_choices()


func _decrement_choices():
	choices_count -= 1
	choices_remaining_label.text = str(choices_count)
	_update_options_visuals()
	
	if choices_count <= 0:
		finished.emit()


func _on_skip_button_pressed():
	finished.emit()

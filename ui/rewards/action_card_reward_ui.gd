extends RewardUI

@onready var choices_remaining_label = %ChoicesRemainingLabel
@onready var card_options_container = %CardOptionsContainer

var player_info: PlayerInfo
var options_count: int
var choices_count: int
var options: Array[CardInfo]

const ENHANCEMENT_CHANCE = 0.25
const CARD_SCENE = preload("res://battle/cards/card.tscn")


func init(player_info: PlayerInfo, options_count: int, choices_count: int):
	self.player_info = player_info
	self.options_count = options_count
	self.choices_count = choices_count
	
	choices_remaining_label.text = str(choices_count)
	
	_decide_options()
	_update_options_visuals()


func _decide_options():
	var rng = RandomNumberGenerator.new()
	for i in range(options_count):
		var insecurity: Constants.Insecurity
		var enhancement: Constants.CardEnhancement
		var insult_text: String
		
		var chosen_insecurity_index = rng.randi_range(0, Constants.Insecurity.size() - 1)
		insecurity = Constants.Insecurity.values()[chosen_insecurity_index]
		
		var chosen_enhancement_chance = rng.randf_range(0.0, 1.0)
		if chosen_enhancement_chance <= ENHANCEMENT_CHANCE:
			var chosen_enhancmenet_index = rng.randi_range(0, Constants.CardEnhancement.size() - 1)
			enhancement = Constants.CardEnhancement.values()[chosen_enhancmenet_index]
		else:
			enhancement = Constants.CardEnhancement.NONE
		
		insult_text = "placeholder"
		
		var card_info = CardInfo.new()
		card_info.insecurity = insecurity
		card_info.enhancement = enhancement
		card_info.insult_text = insult_text
		card_info.attack_value = rng.randi_range(3, 4)
		
		options.append(card_info)


func _update_options_visuals():
	for child in card_options_container.get_children():
		child.queue_free()
	
	for i in range(options.size()):
		var card = CARD_SCENE.instantiate()
		card.card_info = options[i]
		card.toggle_selected.connect(_select_option.bind(i))
		card_options_container.add_child(card)
		card.init()


func _select_option(index: int):
	player_info.add_card(options[index])
	
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

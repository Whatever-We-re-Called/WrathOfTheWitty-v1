extends ActionUI

@onready var choices_remaining_label = %ChoicesRemainingLabel
@onready var card_options_container = %CardOptionsContainer

var player_info: PlayerInfo
var options_count: int
var choices_count: int
var options: Array[EquippedTemplateCard]

const ENHANCEMENT_CHANCE = 0.25
const TEMPLATE_CARD_LOOT_TABLE = preload("res://ui/actions/template_card_loot_table.tres")
const TEMPLATE_CARD_SCENE = preload("res://battle/template_cards/template_card.tscn")


func init(player_info: PlayerInfo, options_count: int, choices_count: int):
	self.player_info = player_info
	self.options_count = options_count
	self.choices_count = choices_count
	
	choices_remaining_label.text = str(choices_count)
	
	_decide_options()
	_update_options_visuals()


func _decide_options():
	var template_card_result = TEMPLATE_CARD_LOOT_TABLE.get_random_unique_entries(options_count)
	for entry in template_card_result:
		var template_card_info = load(entry.resource.resource_path)
		
		var equipped_template_card = EquippedTemplateCard.new()
		equipped_template_card.template_card_info = template_card_info
		equipped_template_card.init()
		options.append(equipped_template_card)


func _update_options_visuals():
	for child in card_options_container.get_children():
		child.queue_free()
	
	for i in range(options.size()):
		var template_card = TEMPLATE_CARD_SCENE.instantiate()
		template_card.template_card_info = options[i].template_card_info
		template_card.pressed.connect(_select_option.bind(i))
		card_options_container.add_child(template_card)
		template_card.init()
		template_card.remove_context_ui()


func _select_option(index: int):
	player_info.add_template_card(options[index])
	
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

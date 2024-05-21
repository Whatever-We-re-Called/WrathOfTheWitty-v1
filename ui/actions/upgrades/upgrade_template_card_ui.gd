extends ActionUI

@onready var cards_container = %CardsContainer

var player_info: PlayerInfo
var options: Array[EquippedTemplateCard]

const TEMPLATE_CARD_SCENE = preload("res://battle/template_cards/template_card.tscn")


func init(player_info: PlayerInfo):
	self.player_info = player_info
	
	_decide_options()
	_update_options_visuals()


func _decide_options():
	for equipped_template_card in player_info.equipped_template_cards:
		if not equipped_template_card.is_upgraded:
			options.append(equipped_template_card)


func _update_options_visuals():
	for child in cards_container.get_children():
		child.queue_free()
	
	for i in range(options.size()):
		var template_card = TEMPLATE_CARD_SCENE.instantiate()
		template_card.template_card_info = options[i].template_card_info
		template_card.pressed.connect(_select_option.bind(i))
		cards_container.add_child(template_card)
		template_card.init()
		template_card.remove_context_ui()


func _select_option(index: int):
	player_info.upgrade_template_card(options[index])
	
	options.remove_at(index)
	finished.emit()


func _on_skip_button_pressed():
	print("SW")
	finished.emit()

extends Control

signal finished

@onready var apply_enhancement_label = %ApplyEnhancementLabel
@onready var cards_container = %CardsContainer

var player_info: PlayerInfo
var apply_enhancement: Constants.CardEnhancement

const CARD_SCENE = preload("res://battle/cards/card.tscn")


func init(player_info: PlayerInfo, apply_enhancement: Constants.CardEnhancement):
	self.player_info = player_info
	self.apply_enhancement = apply_enhancement
	
	apply_enhancement_label.text = Constants.enhancement_strings[apply_enhancement]
	_init_action_card_list()


func _init_action_card_list():
	for i in range(player_info.action_card_deck.size()):
		var card = CARD_SCENE.instantiate()
		card.card_info = player_info.action_card_deck[i]
		card.toggle_selected.connect(_select_card.bind(i))
		cards_container.add_child(card)
		card.init()


func _select_card(index: int):
	print(index)
	player_info.action_card_deck[index].enhancement = apply_enhancement
	finished.emit()

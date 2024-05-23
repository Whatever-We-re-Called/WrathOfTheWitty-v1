extends Control

signal finished

@onready var change_insecurity_label = %ChangeInsecurityLabel
@onready var cards_container = %CardsContainer

var player_info: PlayerInfo
var change_insecurity: Constants.Insecurity

const CARD_SCENE = preload("res://battle/cards/card.tscn")


func init(player_info: PlayerInfo, change_insecurity: Constants.Insecurity):
	self.player_info = player_info
	self.change_insecurity = change_insecurity
	
	change_insecurity_label.text = Constants.insecurity_strings[change_insecurity]
	_init_action_card_list()


func _init_action_card_list():
	for i in range(player_info.action_card_deck.size()):
		if player_info.action_card_deck[i].insecurity == change_insecurity:
			continue
		
		var card = CARD_SCENE.instantiate()
		card.card_info = player_info.action_card_deck[i]
		card.toggle_selected.connect(_select_card.bind(i))
		cards_container.add_child(card)
		card.init()


func _select_card(index: int):
	player_info.action_card_deck[index].insecurity = change_insecurity
	finished.emit()


func _on_back_button_pressed():
	finished.emit(true)

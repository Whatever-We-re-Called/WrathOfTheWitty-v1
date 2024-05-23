extends Control

signal finished

@onready var upgrade_damage_label = %UpgradeDamageLabel
@onready var cards_container = %CardsContainer

var player_info: PlayerInfo
var upgrade_damage_value: int

const CARD_SCENE = preload("res://battle/cards/card.tscn")


func init(player_info: PlayerInfo, upgrade_damage_value: int):
	self.player_info = player_info
	self.upgrade_damage_value = upgrade_damage_value
	
	upgrade_damage_label.text = str(upgrade_damage_value)
	_init_action_card_list()


func _init_action_card_list():
	for i in range(player_info.action_card_deck.size()):
		if not player_info.action_card_deck[i].can_damage_be_upgraded():
			continue
		
		var card = CARD_SCENE.instantiate()
		card.card_info = player_info.action_card_deck[i]
		card.toggle_selected.connect(_select_card.bind(i))
		cards_container.add_child(card)
		card.init()


func _select_card(index: int):
	player_info.action_card_deck[index].upgrade_damage(upgrade_damage_value)
	finished.emit()


func _on_back_button_pressed():
	finished.emit(true)

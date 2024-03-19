extends Control

@onready var deck_container = %DeckContainer
@onready var deck_first_row = %DeckFirstRow
@onready var deck_second_row = %DeckSecondRow
@onready var left_player_stats_ui = $LeftPlayerStatsUI
@onready var right_player_stats_ui = $RightPlayerStatsUI
@onready var template_card_ui = %TemplateCardUI

const CARD_SCENE = preload("res://battle/cards/card.tscn")
const TEMPLATE_CARD_SCENE = preload("res://battle/template_cards/template_card.tscn")

func update_player_stats(player: BattlePlayer):
	match player.side:
		Constants.PlayerSide.LEFT:
			left_player_stats_ui.update(player)
		Constants.PlayerSide.RIGHT:
			right_player_stats_ui.update(player)


func update_hand(player: BattlePlayer):
	_clear_hand()
	
	var max_deck_size = player.config.max_deck_size
	for i in range(max_deck_size):
		var card_info = player.card_deck[i]
		var new_card_scene = CARD_SCENE.instantiate()
		new_card_scene.card_info = card_info
		
		add_card(new_card_scene)


func _clear_hand():
	for card in deck_first_row.get_children():
		card.free()
	for card in deck_second_row.get_children():
		card.free()


func add_card(card_scene: Control):
	if deck_second_row.get_children().size() >= 5:
		deck_first_row.add_child(card_scene)
	else:
		deck_second_row.add_child(card_scene)


func update_template_card_ui(template_card_info: TemplateCardInfo):
	if template_card_ui.get_children().size() > 0:
		template_card_ui.get_child(0).free()
	
	#print(template_card_info)
	var new_template_card_scene = TEMPLATE_CARD_SCENE.instantiate()
	new_template_card_scene.template_card_info = template_card_info
	
	template_card_ui.add_child(new_template_card_scene)

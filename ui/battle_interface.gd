extends Control

signal card_selected(card: Card)
signal card_unselected(card: Card)

@onready var deck_container = %DeckContainer
@onready var deck_first_row = %DeckFirstRow
@onready var deck_second_row = %DeckSecondRow
@onready var left_player_stats_ui = $LeftPlayerStatsUI
@onready var right_player_stats_ui = $RightPlayerStatsUI
@onready var template_card_ui = %TemplateCardUI

var battle_scene: BattleScene

const CARD_SCENE = preload("res://battle/cards/card.tscn")

func update_player_stats(player: BattlePlayer):
	match player.side:
		Constants.PlayerSide.LEFT:
			left_player_stats_ui.update(player)
		Constants.PlayerSide.RIGHT:
			right_player_stats_ui.update(player)


func update_hand(player: BattlePlayer):
	_clear_hand()
	
	for card_info in player.cards_in_hand:
		var new_card_scene = CARD_SCENE.instantiate()
		new_card_scene.card_info = card_info
		new_card_scene.selected.connect(_on_card_selected.bind(new_card_scene))
		new_card_scene.unselected.connect(_on_card_unselected.bind(new_card_scene))
		
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


func update_template_card_ui(template_card: TemplateCard):
	if template_card_ui.get_children().size() > 0:
		template_card_ui.get_child(0).free()
	
	template_card_ui.add_child(template_card)


func _on_card_selected(card: Card):
	card_selected.emit(card)


func _on_card_unselected(card: Card):
	card_unselected.emit(card)

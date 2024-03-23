extends Control

signal card_pressed(card: Card)

@onready var deck_container = %DeckContainer
@onready var deck_first_row = %DeckFirstRow
@onready var deck_second_row = %DeckSecondRow
@onready var left_player_stats_ui = $LeftPlayerStatsUI
@onready var right_player_stats_ui = $RightPlayerStatsUI
@onready var template_card_ui = %TemplateCardUI

var battle_scene: BattleScene
var active_template_card_scene: TemplateCard

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
	
	for card_info in player.cards_in_hand:
		var new_card_scene = CARD_SCENE.instantiate()
		new_card_scene.card_info = card_info
		new_card_scene.pressed.connect(_on_card_pressed.bind(new_card_scene))
		
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
	active_template_card_scene = TEMPLATE_CARD_SCENE.instantiate()
	active_template_card_scene.template_card_info = template_card_info
	
	template_card_ui.add_child(active_template_card_scene)


func move_card_to_template_card(card: Card):
	active_template_card_scene.add_played_card(card)


func remove_card_from_template_card(card: Card):
	active_template_card_scene.remove_played_card(card)


func can_add_to_template_card() -> int:
	return not active_template_card_scene.is_full()


func _on_card_pressed(card: Card):
	card_pressed.emit(card)

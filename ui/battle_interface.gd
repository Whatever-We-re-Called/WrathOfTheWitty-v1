extends Control

signal card_toggle_selected(card: Card)
signal card_reroll(card: Card)
signal card_throw(card: Card)

@onready var deck_container = %DeckContainer
@onready var deck_first_row = %DeckFirstRow
@onready var deck_second_row = %DeckSecondRow
@onready var left_player_stats_ui = $LeftPlayerStatsUI
@onready var right_player_stats_ui = $RightPlayerStatsUI
@onready var template_card_ui = %TemplateCardUI
@onready var player_card_deck_label = %PlayerCardDeckLabel
@onready var player_card_bag_label = %PlayerCardBagLabel
@onready var player_template_card_deck_label = %PlayerTemplateCardDeckLabel
@onready var player_template_card_bag_label = %PlayerTemplateCardBagLabel
@onready var player_info_ui = %PlayerInfoUI


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
	player.reset_card_hand()
	
	for card_info in player.cards_in_hand:
		add_card_to_hand(card_info, player)


func _clear_hand():
	for card in deck_first_row.get_children():
		card.free()
	for card in deck_second_row.get_children():
		card.free()


func add_card(card_scene: Control):
	if deck_second_row.get_children().size() >= 5:
		if card_scene.get_parent() == null:
			deck_first_row.add_child(card_scene)
		else:
			card_scene.reparent(deck_first_row)
	else:
		if card_scene.get_parent() == null:
			deck_second_row.add_child(card_scene)
		else:
			card_scene.reparent(deck_second_row)


func add_card_to_hand(card_info: CardInfo, player: BattlePlayer):
	var new_card_scene = CARD_SCENE.instantiate()
	new_card_scene.card_info = card_info
	new_card_scene.player = player
	new_card_scene.toggle_selected.connect(_on_card_toggle_selected.bind(new_card_scene))
	new_card_scene.reroll.connect(_on_card_reroll.bind(new_card_scene))
	new_card_scene.throw.connect(_on_card_throw.bind(new_card_scene))
	new_card_scene.fire_extinguished.connect(_on_card_fire_extinguished.bind(player))
	card_info.card_scene = new_card_scene
	
	add_card(new_card_scene)
	player.cards_in_hand_scenes.append(new_card_scene)


func toggle_hand_visibility(visible: bool):
	deck_container.visible = visible


func update_template_card_ui(template_card: TemplateCard):
	if template_card_ui.get_children().size() > 0:
		template_card_ui.get_child(0).queue_free()
	
	template_card_ui.add_child(template_card)


func update_player_deck_and_bag_ui(player: BattlePlayer):
	player_card_deck_label.text = "Action Card Deck (%s)" % player.cards_in_deck.size()
	player_card_bag_label.text = "Action Card Bag (%s)" % player.cards_in_bag.size()
	player_template_card_deck_label.text = "Template Card Deck (%s)" % player.template_cards_in_deck.size()
	player_template_card_bag_label.text = "Template Card Bag (%s)" % player.template_cards_in_bag.size()


func open_player_info_ui(player_info: PlayerInfo):
	if player_info_ui.visible: return
	
	player_info_ui.visible = true
	player_info_ui.init(player_info)


func close_player_info_ui():
	player_info_ui.visible = false


func _on_card_toggle_selected(card: Card):
	card_toggle_selected.emit(card)


func _on_card_reroll(card: Card):
	card_reroll.emit(card)


func _on_card_throw(card: Card):
	card_throw.emit(card)


func _on_card_fire_extinguished(player: BattlePlayer):
	update_player_stats(player)

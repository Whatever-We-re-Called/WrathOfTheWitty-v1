class_name BattleScene extends Node2D

@export_group("Players")
@export var left_player_config: PlayerInfo
@export var right_player_config: PlayerInfo
@export_group("Debug")
@export var debug_template_card_info: TemplateCardInfo

@onready var battle_interface = $CanvasLayer/BattleInterface
@onready var left_player_node = %LeftPlayerNode
@onready var right_player_node = %RightPlayerNode

var active_side: Constants.PlayerSide
var players = {}
var player: BattlePlayer: 
	get:
		return players[active_side]
	set(value):
		players[active_side] = value

var active_template_card: TemplateCard
var template_cards_in_deck: Array[TemplateCardInfo]
var template_cards_in_bag: Array[TemplateCardInfo]
var template_card_arrays = [
	template_cards_in_deck,
	template_cards_in_bag,
]
var is_changing_turns = false

const ACTION_CARD_SCENE = preload("res://battle/cards/card.tscn")
const TEMPLATE_CARD_SCENE = preload("res://battle/template_cards/template_card.tscn")


func _ready():
	active_side = Constants.PlayerSide.LEFT
	
	_init_player(Constants.PlayerSide.LEFT, left_player_config.duplicate(), left_player_node)
	_init_player(Constants.PlayerSide.RIGHT, right_player_config.duplicate(), right_player_node)
	players[Constants.PlayerSide.LEFT].handle_start_battle()
	players[Constants.PlayerSide.LEFT].handle_start_turn()
	players[Constants.PlayerSide.RIGHT].handle_start_battle()
	battle_interface.update_hand(players[active_side])
	
	battle_interface.card_toggle_selected.connect(_on_card_toggle_selected)
	battle_interface.card_reroll.connect(reroll_card)
	battle_interface.card_throw.connect(throw_card)
	battle_interface.close_player_info_ui()


func _init_player(side: Constants.PlayerSide, player_info: PlayerInfo, parent_node: Node2D):
	var player = BattlePlayer.new()
	player.init(player_info, side)
	player.inserted_template_card_into_hand.connect(_on_inserted_template_card_into_hand)
	player.decreased_opponents_max_health.connect(_on_decreased_opponents_max_health)
	parent_node.add_child(player)
	var sprite_height = player.sprite_frames.get_frame_texture("default", 0).get_height()
	player.global_position.y -= (sprite_height * player_info.sprite_scale.y) / 2.0
	battle_interface.update_player_stats(player)
	
	players[side] = player


func _process(delta):
	battle_interface.update_player_deck_and_bag_ui(player)
	
	# Debug
	if Input.is_action_just_pressed("debug_1"):
		player.stamina = player.info.stamina_stat
		battle_interface.update_player_stats(player)
	if Input.is_action_just_pressed("end_turn") and not is_changing_turns:
		end_turn_early()
	if Input.is_action_just_pressed("debug_2"):
		battle_interface.open_player_info_ui(players[Constants.PlayerSide.LEFT].info)
	if Input.is_action_just_pressed("debug_3"):
		battle_interface.open_player_info_ui(players[Constants.PlayerSide.RIGHT].info)
	if Input.is_action_just_pressed("debug_4"):
		battle_interface.close_player_info_ui()


func _on_card_toggle_selected(card: Card):
	var card_info = card.card_info
	if player.selected_cards.has(card_info):
		unselect_card(card)
	else:
		select_card(card)


func _on_decreased_opponents_max_health(amount: int, executing_player: BattlePlayer):
	if players[Constants.PlayerSide.LEFT] == executing_player:
		players[Constants.PlayerSide.RIGHT].info.health_stat -= amount
		players[Constants.PlayerSide.RIGHT].health -= amount
		battle_interface.update_player_stats(players[Constants.PlayerSide.RIGHT])
	else:
		players[Constants.PlayerSide.LEFT].info.health_stat -= amount
		players[Constants.PlayerSide.LEFT].health -= amount
		battle_interface.update_player_stats(players[Constants.PlayerSide.LEFT])


func _on_inserted_template_card_into_hand(template_card_info: TemplateCardInfo):
	if active_template_card != null:
		active_template_card.free()
	
	active_template_card = TEMPLATE_CARD_SCENE.instantiate()
	active_template_card.template_card_info = template_card_info
	active_template_card.play_selected_cards.connect(play_cards)
	
	battle_interface.update_template_card_ui(active_template_card)
	battle_interface.update_template_card_deck_and_bag_ui(template_cards_in_deck.size(), template_cards_in_bag.size())



func select_card(card: Card):
	if active_template_card.is_full(): return
	
	var card_info = card.card_info
	for i in range(player.cards_in_hand.size()):
		if player.cards_in_hand[i] == card_info:
			player.cards_in_hand.remove_at(i)
			break
	player.selected_cards.push_back(card_info)
	
	active_template_card.add_selected_card(card)


func unselect_card(card: Card):
	var card_info = card.card_info
	player.cards_in_hand.push_back(card_info)
	for i in range(player.selected_cards.size()):
		if player.selected_cards[i] == card_info:
			player.selected_cards.remove_at(i)
			break
	
	active_template_card.remove_selected_card(card)
	
	battle_interface.add_card(card)


func play_cards():
	BattleActionExecution.execute_action_cards(player.selected_cards, self)
	BattleAbilityExecution.try_to_execute(active_template_card.template_card_info, player.selected_cards, self)
	player.handle_played_selected_cards()
	
	change_turns()


func end_turn_early():
	for card in active_template_card.selected_cards:
		card.free()
	change_turns()


func reroll_card(card: Card):
	player.reroll_card(card)
	battle_interface.update_player_stats(player)


func throw_card(card: Card):
	player.throw_card(card, self)
	battle_interface.update_player_stats(player)


func change_turns():
	is_changing_turns = true
	
	player.handle_end_turn()
	battle_interface.update_player_stats(player)
	battle_interface.update_player_stats(get_non_active_side_player())
	battle_interface.toggle_hand_visibility(false)
	
	await get_tree().create_timer(2).timeout
	
	if active_side == Constants.PlayerSide.LEFT:
		active_side = Constants.PlayerSide.RIGHT
	else:
		active_side = Constants.PlayerSide.LEFT
	
	player.handle_start_turn()
	battle_interface.update_hand(player)
	active_template_card.set_talking_side(active_side)
	player.handle_delayed_start_turn()
	battle_interface.update_player_deck_and_bag_ui(player)
	battle_interface.update_player_stats(player)
	battle_interface.toggle_hand_visibility(true)
	
	is_changing_turns = false


func get_non_active_side_player():
	if active_side == Constants.PlayerSide.LEFT:
		return players[Constants.PlayerSide.RIGHT]
	elif active_side == Constants.PlayerSide.RIGHT:
		return players[Constants.PlayerSide.LEFT]

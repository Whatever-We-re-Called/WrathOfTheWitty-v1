class_name BattleScene extends Node2D

@export_group("Players")
@export var left_player_config: PlayerConfig
@export var right_player_config: PlayerConfig
@export_group("References")
@export var card_scene: PackedScene
@export_group("Debug")
@export var debug_template_card_info: TemplateCardInfo

@onready var battle_interface = $CanvasLayer/BattleInterface
@onready var left_player_node = %LeftPlayerNode
@onready var right_player_node = %RightPlayerNode

var active_side: Constants.PlayerSide
var players = {}
var active_template_card: TemplateCard
var player: BattlePlayer: 
	get:
		return players[active_side]
	set(value):
		players[active_side] = value

const TEMPLATE_CARD_SCENE = preload("res://battle/template_cards/template_card.tscn")

func _ready():
	active_side = Constants.PlayerSide.LEFT
	
	_init_player(Constants.PlayerSide.LEFT, left_player_config, left_player_node)
	_init_player(Constants.PlayerSide.RIGHT, right_player_config, right_player_node)
	battle_interface.update_hand(players[active_side])
	activate_template_card(debug_template_card_info)
	
	battle_interface.card_toggle_selected.connect(_on_card_toggle_selected)
	battle_interface.card_reroll.connect(reroll_card)


func _init_player(side: Constants.PlayerSide, player_config: PlayerConfig, parent_node: Node2D):
	var player = BattlePlayer.new()
	player.init(player_config, side)
	parent_node.add_child(player)
	var sprite_height = player.sprite_frames.get_frame_texture("default", 0).get_height()
	player.global_position.y -= (sprite_height * player_config.sprite_scale.y) / 2.0
	battle_interface.update_player_stats(player)
	
	players[side] = player


func _process(delta):
	battle_interface.update_player_deck_and_bag_ui(player)


func _on_card_toggle_selected(card: Card):
	var card_info = card.card_info
	if player.selected_cards.has(card_info):
		unselect_card(card)
	else:
		select_card(card)


func activate_template_card(template_card_info: TemplateCardInfo):
	active_template_card = TEMPLATE_CARD_SCENE.instantiate()
	active_template_card.template_card_info = template_card_info
	active_template_card.play_selected_cards.connect(play_cards)
	
	battle_interface.update_template_card_ui(active_template_card)


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
	battle_interface.update_hand(player)
	
	active_template_card.remove_selected_card(card)


func play_cards(cards: Array[Card]):
	if cards == null:
		cards = active_template_card.selected_cards
	
	for card in cards:
		card.free()
	cards.clear()


func reroll_card(card: Card):
	player.send_card_to_bag(card.card_info)
	
	card.card_info = player.get_next_card_in_deck(true)
	card.init()

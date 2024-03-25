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
	
	battle_interface.card_selected.connect(select_card)
	battle_interface.card_unselected.connect(unselect_card)


func _init_player(side: Constants.PlayerSide, player_config: PlayerConfig, parent_node: Node2D):
	var player = BattlePlayer.new()
	player.init(player_config, side)
	parent_node.add_child(player)
	var sprite_height = player.sprite_frames.get_frame_texture("default", 0).get_height()
	player.global_position.y -= (sprite_height * player_config.sprite_scale.y) / 2.0
	battle_interface.update_player_stats(player)
	
	players[side] = player


func _process(delta):
	pass
	#if Input.is_action_just_pressed("debug_1"):
		#left_player.health -= 5
		#battle_interface.update_player_stats(left_player)
	#if Input.is_action_just_pressed("debug_2"):
		#left_player.stamina -= 1
		#battle_interface.update_player_stats(left_player)


func _on_card_selected(card: Card):
	print("selected")
	pass


func _on_card_unselected(card: Card):
	print("unselected")
	pass


func activate_template_card(template_card_info: TemplateCardInfo):
	active_template_card = TEMPLATE_CARD_SCENE.instantiate()
	active_template_card.template_card_info = template_card_info
	active_template_card.selected_card_added.connect(_on_template_card_selected_card_added)
	active_template_card.selected_card_removed.connect(_on_template_card_selected_card_removed)
	active_template_card.play_selected_cards.connect(play_cards)
	
	battle_interface.update_template_card_ui(active_template_card)


func select_card(card: Card):
	active_template_card.add_selected_card(card)


func unselect_card(card: Card):
	active_template_card.remove_selected_card(card)


func _on_template_card_selected_card_added(card: Card):
	for i in range(player.cards_in_hand.size()):
		if player.cards_in_hand[i] == card.card_info:
			player.cards_in_hand.remove_at(i)
			break


func _on_template_card_selected_card_removed(card: Card):
	player.cards_in_hand.push_back(card.card_info)
	battle_interface.update_hand(player)


func play_cards(cards: Array[Card]):
	if cards == null:
		cards = active_template_card.selected_cards
	
	for card in cards:
		card.free()
	cards.clear()

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

func _ready():
	active_side = Constants.PlayerSide.LEFT
	
	_init_player(Constants.PlayerSide.LEFT, left_player_config, left_player_node)
	_init_player(Constants.PlayerSide.RIGHT, right_player_config, right_player_node)
	battle_interface.update_hand(players[active_side])
	_update_template_card()
	
	battle_interface.card_pressed.connect(toggle_card_as_active)


func _init_player(side: Constants.PlayerSide, player_config: PlayerConfig, parent_node: Node2D):
	var player = BattlePlayer.new()
	player.init(player_config, side)
	parent_node.add_child(player)
	var sprite_height = player.sprite_frames.get_frame_texture("default", 0).get_height()
	player.global_position.y -= (sprite_height * player_config.sprite_scale.y) / 2.0
	battle_interface.update_player_stats(player)
	
	players[side] = player


func _update_template_card():
	# TODO Random template card deck draw.
	var template_card_info = debug_template_card_info
	battle_interface.update_template_card_ui(template_card_info)


func _process(delta):
	pass
	#if Input.is_action_just_pressed("debug_1"):
		#left_player.health -= 5
		#battle_interface.update_player_stats(left_player)
	#if Input.is_action_just_pressed("debug_2"):
		#left_player.stamina -= 1
		#battle_interface.update_player_stats(left_player)


func toggle_card_as_active(card: Card):
	var player = players[active_side]
	for card_in_hand in player.cards_in_hand:
		if card_in_hand == card.card_info:
			play_card(player, card)
			return
	
	unplay_card(player, card)


func play_card(player: BattlePlayer, card: Card):
	if not battle_interface.can_add_to_template_card(): return
	
	for i in range(player.cards_in_hand.size()):
		if player.cards_in_hand[i] == card.card_info:
			player.cards_in_hand.remove_at(i)
			break
	
	battle_interface.move_card_to_template_card(card)


func unplay_card(player: BattlePlayer, card: Card):
	player.cards_in_hand.push_back(card.card_info)
	battle_interface.remove_card_from_template_card(card)
	battle_interface.update_hand(player)

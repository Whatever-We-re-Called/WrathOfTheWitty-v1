extends Node2D

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

var left_player: BattlePlayer
var right_player: BattlePlayer

func _ready():
	_init_player(Constants.PlayerSide.LEFT, left_player_config, left_player_node)
	_init_player(Constants.PlayerSide.RIGHT, right_player_config, right_player_node)
	battle_interface.update_hand(left_player)
	_update_template_card()


func _init_player(side: Constants.PlayerSide, player_config: PlayerConfig, parent_node: Node2D):
	var player = BattlePlayer.new()
	player.init(player_config, side)
	parent_node.add_child(player)
	var sprite_height = player.sprite_frames.get_frame_texture("default", 0).get_height()
	player.global_position.y -= (sprite_height * player_config.sprite_scale.y) / 2.0
	battle_interface.update_player_stats(player)
	
	match side:
		Constants.PlayerSide.LEFT:
			left_player = player
		Constants.PlayerSide.RIGHT:
			right_player = player


func _update_template_card():
	# TODO Random template card deck draw.
	var template_card_info = debug_template_card_info
	battle_interface.update_template_card_ui(template_card_info)


func _process(delta):
	if Input.is_action_just_pressed("debug_1"):
		left_player.health -= 5
		battle_interface.update_player_stats(left_player)
	if Input.is_action_just_pressed("debug_2"):
		left_player.stamina -= 1
		battle_interface.update_player_stats(left_player)

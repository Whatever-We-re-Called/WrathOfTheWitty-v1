extends Node2D

@export_group("Players")
@export var first_battle_player: BattlePlayer
@export var second_battle_player: BattlePlayer
@export_group("References")
@export var card_scene: PackedScene

@onready var battle_interface = $CanvasLayer/BattleInterface

func _ready():
	for i in range(9):
		var card_info = first_battle_player.card_deck[i]
		var new_card_scene = card_scene.instantiate()
		new_card_scene.card_info = card_info
		battle_interface.add_card(new_card_scene)

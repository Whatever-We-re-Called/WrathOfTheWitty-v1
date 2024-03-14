extends Control

@onready var deck_container = %DeckContainer


func add_card(card_scene: Control):
	deck_container.add_child(card_scene)

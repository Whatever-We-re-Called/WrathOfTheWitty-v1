extends Control

@onready var deck_container = %DeckContainer
@onready var deck_first_row = %DeckFirstRow
@onready var deck_second_row = %DeckSecondRow


func add_card(card_scene: Control):
	if deck_second_row.get_children().size() >= 5:
		deck_first_row.add_child(card_scene)
	else:
		deck_second_row.add_child(card_scene)

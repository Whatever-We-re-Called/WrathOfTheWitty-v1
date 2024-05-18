extends Control

@onready var seed_text_edit = %SeedTextEdit

func _on_start_new_run_button_pressed():
	const TEMP_USED_PLAYER_INFO = preload("res://players/info/players/test_scrimblo_info.tres")
	var seed = seed_text_edit.text
	RunManager.start_run(TEMP_USED_PLAYER_INFO, seed)

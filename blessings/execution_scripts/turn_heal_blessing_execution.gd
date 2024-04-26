extends BlessingExecution


func _on_turn_started():
	player_info.current_player_instance.heal(2)

extends BlessingExecution


func _on_damaged():
	if blessing.is_cosmic:
		player_info.current_player_instance.damaged_opponent.emit(8, player_info.current_player_instance)
	else:
		player_info.current_player_instance.damaged_opponent.emit(4, player_info.current_player_instance)

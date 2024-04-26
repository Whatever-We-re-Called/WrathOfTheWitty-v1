extends BlessingExecution


func _on_battle_started():
	if blessing.is_cosmic:
		player_info.current_player_instance.decreased_opponents_max_health.emit(0.2, player_info.current_player_instance)
	else:
		player_info.current_player_instance.decreased_opponents_max_health.emit(0.1, player_info.current_player_instance)

extends BlessingExecution


func _on_turn_started():
	if blessing.is_cosmic:
		player_info.current_player_instance.heal(4)
	else:
		player_info.current_player_instance.heal(2)

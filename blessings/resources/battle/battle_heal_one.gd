extends BlessingExecution


func _on_battle_started():
	if blessing.is_cosmic:
		player_info.current_player_instance.heal(16)
	else:
		player_info.current_player_instance.heal(8)

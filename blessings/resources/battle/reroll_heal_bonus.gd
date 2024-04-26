extends BlessingExecution


func _on_rerolled_card():
	if blessing.is_cosmic:
		player_info.current_player_instance.heal(2)
	else:
		player_info.current_player_instance.heal(1)

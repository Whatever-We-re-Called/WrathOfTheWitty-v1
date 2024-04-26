extends BlessingExecution

func _on_turn_started():
	if blessing.is_cosmic:
		player_info.current_player_instance.replenish_stamina(2)
	else:
		player_info.current_player_instance.replenish_stamina(1)

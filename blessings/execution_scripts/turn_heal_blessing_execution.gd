extends BlessingExecution


func _on_turn_started(stack: int):
	for i in range(stack):
		if (i + 1) == 1:
			print(player_info.current_player_instance)
			player_info.current_player_instance.heal(2)
		else:
			player_info.current_player_instance.heal(1)

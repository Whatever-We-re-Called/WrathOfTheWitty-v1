extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.stamina_stat += 6
	else:
		player_info.stamina_stat += 3


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.stamina_stat -= 6
	else:
		player_info.stamina_stat -= 3

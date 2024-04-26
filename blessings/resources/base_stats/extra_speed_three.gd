extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.speed_stat += 2
	else:
		player_info.speed_stat += 1


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.speed_stat -= 2
	else:
		player_info.speed_stat -= 1

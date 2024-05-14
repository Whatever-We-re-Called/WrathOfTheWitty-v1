extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.health_stat += 40
	else:
		player_info.health_stat += 20


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.health_stat -= 40
	else:
		player_info.health_stat -= 20

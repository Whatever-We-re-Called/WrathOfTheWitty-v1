extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.attack_stat += 6
	else:
		player_info.attack_stat += 3


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.attack_stat -= 6
	else:
		player_info.attack_stat -= 3

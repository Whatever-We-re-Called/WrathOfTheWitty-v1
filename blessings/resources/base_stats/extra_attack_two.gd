extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.attack_stat += 4
	else:
		player_info.attack_stat += 2


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.attack_stat -= 4
	else:
		player_info.attack_stat -= 2

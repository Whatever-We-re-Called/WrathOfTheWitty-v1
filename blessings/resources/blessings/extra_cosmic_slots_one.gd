extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.cosmic_blessings_limit += 3
	else:
		player_info.cosmic_blessings_limit += 1


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.attack_stat -= 3
	else:
		player_info.attack_stat -= 1

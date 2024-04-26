extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.cosmic_blessings_limit += 5
	else:
		player_info.cosmic_blessings_limit += 2


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.attack_stat -= 5
	else:
		player_info.attack_stat -= 2

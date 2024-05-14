extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.slime_magic_stat += 12
	else:
		player_info.slime_magic_stat += 6


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.slime_magic_stat -= 12
	else:
		player_info.slime_magic_stat -= 6

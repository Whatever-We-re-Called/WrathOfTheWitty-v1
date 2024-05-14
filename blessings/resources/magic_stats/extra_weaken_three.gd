extends BlessingExecution

func _on_equipped():
	if blessing.is_cosmic:
		player_info.weaken_magic_stat += 18
	else:
		player_info.weaken_magic_stat += 9


func _on_unequipped():
	if blessing.is_cosmic:
		player_info.weaken_magic_stat -= 18
	else:
		player_info.weaken_magic_stat -= 9

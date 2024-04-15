extends BlessingExecution


func _on_equipped(stack: int):
	if stack == 1:
		player_info.attack_stat += 2
	else:
		player_info.attack_stat += 1


func _on_unequipped(stack: int):
	if stack == 0:
		player_info.attack_stat -= 2
	else:
		player_info.attack_stat -= 1

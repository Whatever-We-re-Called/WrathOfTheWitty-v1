extends BlessingExecution


func _on_equipped():
	player_info.attack_stat += 2


func _on_unequipped():
	player_info.attack_stat -= 2

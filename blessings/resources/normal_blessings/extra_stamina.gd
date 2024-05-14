extends BlessingExecution

var extra_stamina_amount = Blessings.BLESSING_INFO.extra_stamina_value


func _on_equipped():
	player_info.stamina_stat += extra_stamina_amount
	if player_info.current_player_instance != null:
		player_info.current_player_instance.stamina += extra_stamina_amount


func _on_unequipped():
	player_info.stamina_stat -= extra_stamina_amount

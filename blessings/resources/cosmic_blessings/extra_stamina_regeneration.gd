extends BlessingExecution

func _on_turn_started():
	var extra_stamina_amount = Blessings.BLESSING_INFO.extra_stamina_regeneration_value
	player_info.current_player_instance.replenish_stamina(extra_stamina_amount)

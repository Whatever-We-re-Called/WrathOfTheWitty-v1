extends BlessingExecution

func _on_turn_ended():
	var heal_amount = Blessings.BLESSING_INFO.turn_health_regeneration_value
	player_info.current_player_instance.heal(heal_amount)

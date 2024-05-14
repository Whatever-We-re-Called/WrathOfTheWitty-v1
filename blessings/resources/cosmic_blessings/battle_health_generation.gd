extends BlessingExecution

func _on_battle_ended():
	var heal_amount = Blessings.BLESSING_INFO.battle_health_regeneration_value
	player_info.current_player_instance.heal(heal_amount)

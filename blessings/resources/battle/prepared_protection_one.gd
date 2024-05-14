extends BlessingExecution


func _on_battle_started():
	if blessing.is_cosmic:
		player_info.current_player_instance.apply_status_effect(Constants.PlayerStatusEffect.SHIELD, 12)
	else:
		player_info.current_player_instance.apply_status_effect(Constants.PlayerStatusEffect.SHIELD, 6)

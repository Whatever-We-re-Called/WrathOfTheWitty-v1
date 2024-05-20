extends BlessingExecution

func _on_battle_started():
	var shield_status_effect = Constants.PlayerStatusEffect.SHIELD
	var shield_amount = Blessings.BLESSING_INFO.starting_protection_value
	# TODO
	#player_info.current_player_instance.apply_status_effect(shield_status_effect, shield_amount)

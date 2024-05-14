extends BlessingExecution

var extra_health_amount = Blessings.BLESSING_INFO.extra_health_value


func _on_equipped():
	player_info.health_stat += extra_health_amount
	if player_info.current_player_instance != null:
		player_info.current_player_instance.health += extra_health_amount
	else:
		player_info.current_health += extra_health_amount


func _on_uneqipped():
	player_info.health_stat -= extra_health_amount

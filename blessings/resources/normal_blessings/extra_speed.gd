extends BlessingExecution

var extra_speed_amount = Blessings.BLESSING_INFO.extra_speed_value


func _on_equipped():
	player_info.speed_stat += extra_speed_amount


func _on_uneqipped():
	player_info.speed_stat -= extra_speed_amount

extends BlessingExecution

var extra_space_amount = Blessings.BLESSING_INFO.extra_action_hand_space_value


func _on_equipped():
	player_info.action_hand_stat += extra_space_amount


func _on_uneqipped():
	player_info.action_hand_stat -= extra_space_amount

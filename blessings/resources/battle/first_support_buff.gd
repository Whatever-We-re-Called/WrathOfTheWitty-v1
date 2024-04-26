extends BlessingExecution

var original_support_stat: int
var reversal_handled = false

func _on_battle_started():
	original_support_stat = player_info.support_stat
	if blessing.is_cosmic:
		player_info.support_stat *= 2
	else:
		player_info.support_stat *= 1.5


func _on_turn_ended():
	if not reversal_handled:
		player_info.support_stat = original_support_stat
		reversal_handled = true

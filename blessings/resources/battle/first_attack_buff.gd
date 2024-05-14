extends BlessingExecution

var original_attack_stat: int
var reversal_handled = false

func _on_battle_started():
	original_attack_stat = player_info.attack_stat
	if blessing.is_cosmic:
		player_info.attack_stat *= 2
	else:
		player_info.attack_stat *= 1.5


func _on_turn_ended():
	if not reversal_handled:
		player_info.attack_stat = original_attack_stat
		reversal_handled = true

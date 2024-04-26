extends BlessingExecution

var original_hide_stat: int
var original_weaken_stat: int
var original_poison_stat: int
var original_burn_stat: int
var original_freeze_stat: int
var original_slime_stat: int
var reversal_handled = false

func _on_battle_started():
	original_hide_stat = player_info.hide_magic_stat
	original_weaken_stat = player_info.weaken_magic_stat
	original_poison_stat = player_info.poison_magic_stat
	original_burn_stat = player_info.burn_magic_stat
	original_freeze_stat = player_info.freeze_magic_stat
	original_slime_stat = player_info.slime_magic_stat
	if blessing.is_cosmic:
		player_info.hide_magic_stat *= 2
		player_info.weaken_magic_stat *= 2
		player_info.poison_magic_stat *= 2
		player_info.burn_magic_stat *= 2
		player_info.freeze_magic_stat *= 2
		player_info.slime_magic_stat *= 2
	else:
		player_info.hide_magic_stat *= 1.5
		player_info.weaken_magic_stat *= 1.5
		player_info.poison_magic_stat *= 1.5
		player_info.burn_magic_stat *= 1.5
		player_info.freeze_magic_stat *= 1.5
		player_info.slime_magic_stat *= 1.5


func _on_turn_ended():
	if not reversal_handled:
		player_info.hide_magic_stat = original_hide_stat
		player_info.weaken_magic_stat = original_weaken_stat
		player_info.poison_magic_stat = original_poison_stat
		player_info.burn_magic_stat = original_burn_stat
		player_info.freeze_magic_stat = original_freeze_stat
		player_info.slime_magic_stat = original_slime_stat
		reversal_handled = true

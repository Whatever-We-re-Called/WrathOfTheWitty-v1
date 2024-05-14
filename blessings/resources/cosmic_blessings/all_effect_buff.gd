extends BlessingExecution

var effect_increment = Blessings.BLESSING_INFO.all_effect_buff_value


func _on_equipped():
	player_info.hide_effect_stat += effect_increment
	player_info.slime_effect_stat += effect_increment
	player_info.poison_effect_stat += effect_increment
	player_info.burn_effect_stat += effect_increment
	player_info.freeze_effect_stat += effect_increment


func _on_unequipped():
	player_info.hide_effect_stat -= effect_increment
	player_info.slime_effect_stat -= effect_increment
	player_info.poison_effect_stat -= effect_increment
	player_info.burn_effect_stat -= effect_increment
	player_info.freeze_effect_stat -= effect_increment

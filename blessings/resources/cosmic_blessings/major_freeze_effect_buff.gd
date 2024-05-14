extends BlessingExecution

var effect_increment = Blessings.BLESSING_INFO.major_effect_buff_value


func _on_equipped():
	player_info.freeze_effect_stat += effect_increment


func _on_unequipped():
	player_info.freeze_effect_stat -= effect_increment

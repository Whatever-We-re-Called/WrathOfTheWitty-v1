extends BlessingExecution

var damage_increment = Blessings.BLESSING_INFO.all_attack_buff_value


func _on_equipped():
	_add_damage_to_cards(damage_increment)


func _on_unequipped():
	_add_damage_to_cards(-damage_increment)

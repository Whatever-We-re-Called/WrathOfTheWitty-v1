extends BlessingExecution

var damage_increment = Blessings.BLESSING_INFO.regular_attack_buff_value
var checked_insecurity = Constants.Insecurity.INTELLIGENCE


func _on_equipped():
	_add_damage_to_cards_with_insecurity(damage_increment, checked_insecurity)


func _on_unequipped():
	_add_damage_to_cards_with_insecurity(-damage_increment, checked_insecurity)

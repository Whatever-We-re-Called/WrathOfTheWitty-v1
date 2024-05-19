class_name BlessingExecution

var blessing: Blessing
var player_info: PlayerInfo


func _on_equipped():
	pass


func _on_unequipped():
	pass


func _on_battle_started():
	pass


func _on_battle_ended():
	pass


func _on_turn_started():
	pass


func _on_turn_ended():
	pass


func _on_damaged():
	pass


func _on_rerolled_card():
	pass


func _add_damage_to_cards_with_insecurity(damage_increment: int, insecurity: Constants.Insecurity):
	if player_info.attack_buffs.has(insecurity):
		player_info.attack_buffs[insecurity] += damage_increment
	else:
		player_info.attack_buffs[insecurity] = damage_increment
	
	for card in player_info.action_card_deck:
		if card.insecurity == insecurity:
			card.attack_value += damage_increment


func _add_damage_to_cards(damage_increment: int):
	for insecurity in Constants.Insecurity.values():
		if player_info.attack_buffs.has(insecurity):
			player_info.attack_buffs[insecurity] += damage_increment
		else:
			player_info.attack_buffs[insecurity] = damage_increment
	
	for card in player_info.action_card_deck:
		card.attack_value += damage_increment

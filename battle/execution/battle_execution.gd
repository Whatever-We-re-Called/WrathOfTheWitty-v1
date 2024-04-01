class_name BattleExecution

const BATTLE_EXECUTION_INFO = preload("res://battle/execution/battle_execution_info.tres")


class BattleExecutionData:
	var card_info: CardInfo
	var battle_scene: BattleScene
	var attacker_player: BattlePlayer
	var defender_player: BattlePlayer
	var is_insecurity_group: bool


static func execute_action_cards(card_infos: Array[CardInfo], battle_scene: BattleScene):
	var is_insecurity_group = _is_a_insecurity_group(card_infos)
	for card_info in card_infos:
		execute_action_card(card_info, battle_scene, is_insecurity_group)


static func _is_a_insecurity_group(card_infos: Array[CardInfo]) -> bool:
	if card_infos.size() == 1: return false
	
	var first_action_type = card_infos[0].action_type
	for card_info in card_infos:
		if not card_info.is_attack_action_type():
			return false
		elif card_info.action_type != first_action_type:
			return false
	
	return true


static func execute_action_card(card_info: CardInfo, battle_scene: BattleScene, is_insecurity_group: bool = false):
	var attacker_player = battle_scene.player
	var defender_player = battle_scene.get_non_active_side_player() 
	
	var battle_execution_data = BattleExecutionData.new()
	battle_execution_data.card_info = card_info
	battle_execution_data.battle_scene = battle_scene
	battle_execution_data.attacker_player = battle_scene.player
	battle_execution_data.defender_player = battle_scene.get_non_active_side_player()
	battle_execution_data.is_insecurity_group = is_insecurity_group
	
	if card_info.is_attack_action_type():
		var damage_dealt = _execute_action_card_attack(battle_execution_data)
	
	#match card_info.action_type:
		#Constants.CardAction.PHYSICAL_ABILITY_ATTACK, :
			#_execute_damage_action_card(battle_execution_data)
		#Constants.CardAction.SHIELD:
			#_execute_shield_action_card(action_card_execution)
		#Constants.CardAction.POISON:
			#_execute_poison_action_card(action_card_execution)
		#Constants.CardAction.HEAL:
			#_execute_heal_action_card(action_card_execution)
		#Constants.CardAction.LIFE_STEAL:
			#_execute_life_steal_action_card(action_card_execution)
		#Constants.CardAction.STAMINA:
			#_execute_stamina_action_card(action_card_execution)
		#Constants.CardAction.FIRE:
			#_execute_fire_action_card(action_card_execution)
		#Constants.CardAction.WEAKNESS:
			#_execute_weakness_action_card(action_card_execution)
	
	battle_execution_data.battle_scene.battle_interface.update_player_stats(attacker_player)
	battle_execution_data.battle_scene.battle_interface.update_player_stats(defender_player)


static func _execute_action_card_attack(battle_execution_data: BattleExecutionData) -> int:
	var damage_dealt = _get_damage_dealt_value(battle_execution_data)
	
	battle_execution_data.defender_player.damage(damage_dealt)
	
	return damage_dealt


static func _get_damage_dealt_value(battle_execution_data: BattleExecutionData) -> int:
	var player_level = battle_execution_data.attacker_player.level
	var card_info = battle_execution_data.card_info
	
	var damage_dealt = float(BATTLE_EXECUTION_INFO.base_attack_damage_value)
	
	var applied_multiplier = 1.0
	# Enhancement Multipliers
	if card_info.enhancement == Constants.CardEnhancement.BUFF:
		applied_multiplier += BATTLE_EXECUTION_INFO.buff_enhancement_percentage_increase
	elif card_info.enhancement == Constants.CardEnhancement.EXTRA_BUFF:
		applied_multiplier += BATTLE_EXECUTION_INFO.extra_buff_enhancement_percentage_increase
	elif card_info.enhancement == Constants.CardEnhancement.WEAK:
		applied_multiplier += BATTLE_EXECUTION_INFO.weak_enhancement_percentage_increase
	# Grouping and Matching Multipliers
	if battle_execution_data.is_insecurity_group:
		applied_multiplier +=  BATTLE_EXECUTION_INFO.insecurity_group_percentage_increase
	if card_info.get_insecurity_type() == battle_execution_data.defender_player.config.insecurity:
		applied_multiplier += BATTLE_EXECUTION_INFO.insecurity_match_percentage_increase
	
	print(damage_dealt, " ", applied_multiplier)
	return int(round(damage_dealt * applied_multiplier))


static func _execute_action_card_heal(battle_execution_data: BattleExecutionData) -> int:
	var health_given = BATTLE_EXECUTION_INFO.base_healing_value
	
	battle_execution_data.attacker_player.heal(health_given)
	
	return health_given


static func _execute_action_card_shield(battle_execution_data: BattleExecutionData) -> int:
	var shield_given = BATTLE_EXECUTION_INFO.base_healing_value
	
	# TODO Shield logic
	#battle_execution_data.attacker_player.heal(shield_given)
	
	return shield_given


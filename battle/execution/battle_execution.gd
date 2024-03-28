class_name BattleExecution

const BATTLE_EXECUTION_INFO = preload("res://battle/execution/battle_execution_info.tres")


class ActionCardExecution:
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
	
	var first_insecurity = card_infos[0].insecurity_type
	for card_info in card_infos:
		if card_info.insecurity_type != first_insecurity:
			return false
	
	return true


static func execute_action_card(card_info: CardInfo, battle_scene: BattleScene, is_insecurity_group: bool = false):
	var attacker_player = battle_scene.player
	var defender_player = battle_scene.get_non_active_side_player() 
	
	var action_card_execution = ActionCardExecution.new()
	action_card_execution.card_info = card_info
	action_card_execution.battle_scene = battle_scene
	action_card_execution.attacker_player = battle_scene.player
	action_card_execution.defender_player = battle_scene.get_non_active_side_player()
	action_card_execution.is_insecurity_group = is_insecurity_group
	
	#match card_info.action_type:
		#Constants.CardAction.DAMAGE:
			#_execute_damage_action_card(action_card_execution)
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
	
	action_card_execution.battle_scene.battle_interface.update_player_stats(attacker_player)
	action_card_execution.battle_scene.battle_interface.update_player_stats(defender_player)


static func _execute_damage_action_card(action_card_execution: ActionCardExecution):
	var execution_value = _get_action_card_execution_value(
		BATTLE_EXECUTION_INFO.base_damage_value,
		action_card_execution.attacker_player.level,
		BATTLE_EXECUTION_INFO.damage_level_increment,
		BATTLE_EXECUTION_INFO.damage_strength_multipliers[action_card_execution.card_info.strength_type],
		action_card_execution.is_insecurity_group
	) 
	
	action_card_execution.defender_player.damage(execution_value)


static func _execute_shield_action_card(action_card_execution: ActionCardExecution):
	pass


static func _execute_poison_action_card(action_card_execution: ActionCardExecution):
	pass


static func _execute_heal_action_card(action_card_execution: ActionCardExecution):
	var execution_value = _get_action_card_execution_value(
		BATTLE_EXECUTION_INFO.base_heal_value,
		action_card_execution.attacker_player.level,
		BATTLE_EXECUTION_INFO.heal_level_increment,
		BATTLE_EXECUTION_INFO.heal_strength_multipliers[action_card_execution.card_info.strength_type],
		action_card_execution.is_insecurity_group
	) 
	
	action_card_execution.attacker_player.heal(execution_value)


static func _execute_life_steal_action_card(action_card_execution: ActionCardExecution):
	var execution_value = _get_action_card_execution_value(
		BATTLE_EXECUTION_INFO.base_life_steal_value,
		action_card_execution.attacker_player.level,
		BATTLE_EXECUTION_INFO.life_steal_level_increment,
		BATTLE_EXECUTION_INFO.life_steal_strength_multipliers[action_card_execution.card_info.strength_type],
		action_card_execution.is_insecurity_group
	)
	
	action_card_execution.attacker_player.heal(execution_value)
	action_card_execution.defender_player.damage(execution_value)


static func _execute_stamina_action_card(action_card_execution: ActionCardExecution):
	var execution_value = _get_action_card_execution_value(
		BATTLE_EXECUTION_INFO.base_stamina_value,
		action_card_execution.attacker_player.level,
		BATTLE_EXECUTION_INFO.stamina_level_increment,
		BATTLE_EXECUTION_INFO.stamina_strength_multipliers[action_card_execution.card_info.strength_type],
		action_card_execution.is_insecurity_group
	)
	
	action_card_execution.attacker_player.replenish_stamina(execution_value)


static func _execute_fire_action_card(action_card_execution: ActionCardExecution):
	pass


static func _execute_weakness_action_card(action_card_execution: ActionCardExecution):
	pass


static func _get_action_card_execution_value(base_value: float, level: int, level_increment: float, strength_multiplier: float, is_insecurity_group: bool) -> int:
	var result = (base_value + (level * level_increment)) * strength_multiplier
	if is_insecurity_group:
		result *= BATTLE_EXECUTION_INFO.insecurity_group_multiplier
	return ceil(result)

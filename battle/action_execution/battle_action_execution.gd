class_name BattleActionExecution

const BATTLE_ACTION_EXECUTION_INFO = preload("res://battle/action_execution/battle_action_execution_info.tres")


class BattleActionExecutionData:
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
		if not card_info.is_attack_card():
			return false
		elif card_info.action_type != first_action_type:
			return false
	
	return true


static func execute_action_card(card_info: CardInfo, battle_scene: BattleScene, is_insecurity_group: bool = false):
	var attacker_player = battle_scene.player
	var defender_player = battle_scene.get_non_active_side_player() 
	
	var battle_action_execution_data = BattleActionExecutionData.new()
	battle_action_execution_data.card_info = card_info
	battle_action_execution_data.battle_scene = battle_scene
	battle_action_execution_data.attacker_player = battle_scene.player
	battle_action_execution_data.defender_player = battle_scene.get_non_active_side_player()
	battle_action_execution_data.is_insecurity_group = is_insecurity_group
	
	if card_info.is_attack_card():
		_execute_action_card_attack(battle_action_execution_data)
	else:
		match battle_action_execution_data.card_info.action_type:
			Constants.CardAction.HEAL:
				_execute_action_card_heal(battle_action_execution_data)
			Constants.CardAction.SHIELD:
				_execute_action_card_shield(battle_action_execution_data)
	
	battle_action_execution_data.battle_scene.battle_interface.update_player_stats(attacker_player)
	battle_action_execution_data.battle_scene.battle_interface.update_player_stats(defender_player)


static func _execute_action_card_attack(battle_action_execution_data: BattleActionExecutionData):
	var damage_dealt = _get_damage_dealt_value(battle_action_execution_data)
	
	battle_action_execution_data.defender_player.damage(damage_dealt)
	
	match battle_action_execution_data.card_info.enhancement:
		Constants.CardEnhancement.POISON:
			_apply_poison_effect(battle_action_execution_data)
		Constants.CardEnhancement.FIRE:
			_apply_fire_effect(battle_action_execution_data)
		Constants.CardEnhancement.FREEZE:
			_apply_freeze_effect(battle_action_execution_data)
		Constants.CardEnhancement.WEAKEN:
			_apply_weaken_effect(battle_action_execution_data)
		Constants.CardEnhancement.SLIME:
			_apply_slime_effect(battle_action_execution_data)
		Constants.CardEnhancement.HIDE:
			_apply_hide_effect(battle_action_execution_data)
		Constants.CardEnhancement.STAMINA:
			_handle_stamina_enhancement(battle_action_execution_data)
		Constants.CardEnhancement.LIFE_STEAL:
			_handle_life_steal_enhancement(battle_action_execution_data, damage_dealt)


static func _get_damage_dealt_value(battle_action_execution_data: BattleActionExecutionData) -> int:
	var player_level = battle_action_execution_data.attacker_player.level
	var card_info = battle_action_execution_data.card_info
	
	var damage_dealt = float(BATTLE_ACTION_EXECUTION_INFO.base_attack_damage_value)
	
	var applied_multiplier = 1.0
	# Enhancement Multipliers
	if card_info.enhancement == Constants.CardEnhancement.BUFF:
		applied_multiplier += BATTLE_ACTION_EXECUTION_INFO.buff_enhancement_percentage_increase
	elif card_info.enhancement == Constants.CardEnhancement.EXTRA_BUFF:
		applied_multiplier += BATTLE_ACTION_EXECUTION_INFO.extra_buff_enhancement_percentage_increase
	elif card_info.enhancement == Constants.CardEnhancement.WEAK:
		applied_multiplier += BATTLE_ACTION_EXECUTION_INFO.weak_enhancement_percentage_increase
	# Grouping and Matching Multipliers
	if battle_action_execution_data.is_insecurity_group:
		applied_multiplier +=  BATTLE_ACTION_EXECUTION_INFO.insecurity_group_percentage_increase
	if card_info.get_insecurity_type() == battle_action_execution_data.defender_player.config.insecurity:
		applied_multiplier += BATTLE_ACTION_EXECUTION_INFO.insecurity_match_percentage_increase
	
	return int(round(damage_dealt * applied_multiplier))


static func _apply_poison_effect(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var applied_poison_value = BATTLE_ACTION_EXECUTION_INFO.base_poison_value
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.POISON, applied_poison_value)


static func _apply_fire_effect(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var applied_burn_value = BATTLE_ACTION_EXECUTION_INFO.base_fire_stack_value
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.BURN, applied_burn_value)


static func _apply_freeze_effect(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var applied_freeze_value = BATTLE_ACTION_EXECUTION_INFO.base_freeze_stack_value
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.FREEZE, applied_freeze_value)


static func _apply_weaken_effect(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var applied_weaken_value = BATTLE_ACTION_EXECUTION_INFO.base_weaken_stack_value
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.WEAKEN, applied_weaken_value)


static func _apply_slime_effect(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var applied_slime_value = BATTLE_ACTION_EXECUTION_INFO.base_slime_stack_value
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.SLIME, applied_slime_value)


static func _apply_hide_effect(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var applied_hide_value = BATTLE_ACTION_EXECUTION_INFO.base_hide_stack_value
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.HIDE, applied_hide_value)


static func _handle_stamina_enhancement(battle_action_execution_data: BattleActionExecutionData):
	var attacker_player = battle_action_execution_data.attacker_player
	var replenished_stamina = BATTLE_ACTION_EXECUTION_INFO.base_stamina_value
	
	attacker_player.replenish_stamina(replenished_stamina)


static func _handle_life_steal_enhancement(battle_action_execution_data: BattleActionExecutionData, damage_dealt: int):
	var attacker_player = battle_action_execution_data.attacker_player 
	var heal_amount = round(float(damage_dealt) * BATTLE_ACTION_EXECUTION_INFO.base_life_steal_heal_percentage)
	
	attacker_player.heal(heal_amount)


static func _execute_action_card_heal(battle_action_execution_data: BattleActionExecutionData) -> int:
	var attacker_player = battle_action_execution_data.attacker_player
	var health_given = BATTLE_ACTION_EXECUTION_INFO.base_heal_value
	
	attacker_player.heal(health_given)
	return health_given


static func _execute_action_card_shield(battle_action_execution_data: BattleActionExecutionData) -> int:
	var attacker_player = battle_action_execution_data.attacker_player
	var shield_given = BATTLE_ACTION_EXECUTION_INFO.base_shield_value
	
	attacker_player.apply_status_effect(Constants.PlayerStatusEffect.SHIELD, shield_given)
	return shield_given


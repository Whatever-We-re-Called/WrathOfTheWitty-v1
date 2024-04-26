class_name BattleAbilityExecution

class BattleAbilityExecutionData:
	var battle_scene: BattleScene
	var attacker_player: BattlePlayer
	var defender_player: BattlePlayer


static func try_to_execute(template_card_info: TemplateCardInfo, card_infos: Array[CardInfo], battle_scene: BattleScene):
	if not _is_matching_insecurities(template_card_info, card_infos): return
	
	var battle_ability_execution_data = BattleAbilityExecutionData.new()
	battle_ability_execution_data.battle_scene = battle_scene
	battle_ability_execution_data.attacker_player = battle_scene.player
	battle_ability_execution_data.defender_player = battle_scene.get_non_active_side_player()
	
	_execute_callable(battle_ability_execution_data, template_card_info, template_card_info.execute_function_name)
	
	# TEMPLATE_ACTION_REPEAT Blessing
	if battle_ability_execution_data.attacker_player.info.has_blessing(Blessings.Type.TEMPLATE_ACTION_REPEAT):
		var rng = RandomNumberGenerator.new()
		var result = rng.randi_range(1, 20)
		var is_cosmic = battle_ability_execution_data.attacker_player.info.is_blessing_cosmic(Blessings.Type.TEMPLATE_ACTION_REPEAT)
		
		if result <= 3:
			_execute_callable(battle_ability_execution_data, template_card_info, template_card_info.execute_function_name)
		elif result <= 6 and is_cosmic:
			_execute_callable(battle_ability_execution_data, template_card_info, template_card_info.execute_function_name)


static func _execute_callable(battle_ability_execution_data: BattleAbilityExecutionData, template_card_info: TemplateCardInfo, called_function: String):
	var execute_callable = Callable(BattleAbilityExecution, template_card_info.execute_function_name)
	execute_callable.call(battle_ability_execution_data)



static func _is_matching_insecurities(template_card_info: TemplateCardInfo, card_infos: Array[CardInfo]) -> bool:
	if card_infos.size() == 1: return false
	
	var first_action_type = card_infos[0].action_type
	for card_info in card_infos:
		if not card_info.is_attack_card():
			return false
		else:
			var found_match = false
			for insecurity in template_card_info.insecurities:
				if Constants.get_insecurity_of_action_type(card_info.action_type) == insecurity:
					found_match = true
			if not found_match: return false
	
	return true


static func _execute_poison_dart(battle_ability_execution_data: BattleAbilityExecutionData):
	const POISON_DART_POISON_STACK_INFLICTED = 6
	var defender_player = battle_ability_execution_data.defender_player
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.POISON, POISON_DART_POISON_STACK_INFLICTED)


static func _execute_punch(battle_ability_execution_data: BattleAbilityExecutionData):
	const PUNCH_DAMAGE_INFLICTED = 12
	var defender_player = battle_ability_execution_data.defender_player
	
	defender_player.damage(PUNCH_DAMAGE_INFLICTED)


static func _execute_brutal_punch(battle_ability_execution_data: BattleAbilityExecutionData):
	const BRUTAL_PUNCH_DAMAGE_INFLICTED = 20
	var defender_player = battle_ability_execution_data.defender_player
	
	defender_player.damage(BRUTAL_PUNCH_DAMAGE_INFLICTED)


static func _execute_pyromancy(battle_ability_execution_data: BattleAbilityExecutionData):
	const PYROMANCY_BURN_STACK_INFLICTED = 3
	var defender_player = battle_ability_execution_data.defender_player
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.BURN, PYROMANCY_BURN_STACK_INFLICTED)


static func _execute_absolute_zero(battle_ability_execution_data: BattleAbilityExecutionData):
	const ABSOLUTE_ZERO_FREEZE_STACK_INFLICTED = 3
	var defender_player = battle_ability_execution_data.defender_player
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.FREEZE, ABSOLUTE_ZERO_FREEZE_STACK_INFLICTED)


static func _execute_depression(battle_ability_execution_data: BattleAbilityExecutionData):
	const DEPRESSION_WEAKEN_STACK_INFLICTED = 3
	var defender_player = battle_ability_execution_data.defender_player
	
	defender_player.apply_status_effect(Constants.PlayerStatusEffect.WEAKEN, DEPRESSION_WEAKEN_STACK_INFLICTED)

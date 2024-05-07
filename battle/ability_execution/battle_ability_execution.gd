class_name BattleAbilityExecution

class BattleAbilityExecutionData:
	var battle_scene: BattleScene
	var attacker_player: BattlePlayer
	var defender_player: BattlePlayer
	var is_upgraded: bool


static func try_to_execute(template_card_info: TemplateCardInfo, card_infos: Array[CardInfo], battle_scene: BattleScene):
	if not _is_matching_insecurities(template_card_info, card_infos): return
	
	var battle_ability_execution_data = BattleAbilityExecutionData.new()
	battle_ability_execution_data.battle_scene = battle_scene
	battle_ability_execution_data.attacker_player = battle_scene.player
	battle_ability_execution_data.defender_player = battle_scene.get_non_active_side_player()
	battle_ability_execution_data.is_upgraded = template_card_info.is_upgraded
	
	_execute_callable(battle_ability_execution_data, template_card_info, template_card_info.execute_function_name)
	
	var attacker_player = battle_ability_execution_data.attacker_player
	var rage_status_effect = Constants.PlayerStatusEffect.RAGE
	if attacker_player.active_status_effects.has(rage_status_effect):
		_execute_callable(battle_ability_execution_data, template_card_info, template_card_info.execute_function_name)
		attacker_player.decrement_status_effect(rage_status_effect, 1)
	
	# TEMPLATE_ACTION_REPEAT Blessing
	if battle_ability_execution_data.attacker_player.info.has_blessing(Blessings.Type.TEMPLATE_ACTION_REPEAT):
		var rng = RandomNumberGenerator.new()
		var result = rng.randi_range(1, 20)
		var is_cosmic = battle_ability_execution_data.attacker_player.info.is_blessing_cosmic(Blessings.Type.TEMPLATE_ACTION_REPEAT)
		
		if result <= 3:
			_execute_callable(battle_ability_execution_data, template_card_info, template_card_info.execute_function_name)
		elif result <= 6 and is_cosmic:
			_execute_callable(battle_ability_execution_data, template_card_info, template_card_info.execute_function_name)


static func _is_matching_insecurities(template_card_info: TemplateCardInfo, card_infos: Array[CardInfo]) -> bool:
	if card_infos.size() == 1: return false
	
	for card_info in card_infos:
		var found_match = false
		for insecurity in template_card_info.insecurities:
			if card_info.insecurity == insecurity:
				found_match = true
			elif card_info.enhancement == Constants.CardEnhancement.WILDCARD:
				found_match = true
		if not found_match: return false
	
	return true


static func _execute_callable(battle_ability_execution_data: BattleAbilityExecutionData, template_card_info: TemplateCardInfo, called_function: String):
	var execute_callable = Callable(BattleAbilityExecution, template_card_info.execute_function_name)
	execute_callable.call(battle_ability_execution_data)


static func _execute_poison_dart(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.POISON
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 4)
	else:
		defender_player.apply_status_effect(status_effect, 2)


static func _execute_punch(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.damage(12)
	else:
		defender_player.damage(8)


static func _execute_pyromancy(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.BURN
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 4)
	else:
		defender_player.apply_status_effect(status_effect, 2)


static func _execute_absolute_zero(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.FREEZE
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 4)
	else:
		defender_player.apply_status_effect(status_effect, 2)


static func _execute_paper_bag(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.HIDE
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 4)
	else:
		defender_player.apply_status_effect(status_effect, 2)


static func _execute_icky(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.SLIME
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 4)
	else:
		defender_player.apply_status_effect(status_effect, 2)


static func _execute_shield_bash(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	var shield_status_effect = Constants.PlayerStatusEffect.SHIELD
	var damage_dealt = attacker_player.active_status_effects[shield_status_effect]
	var defender_player = battle_ability_execution_data.defender_player
	
	defender_player.damage(damage_dealt)
	if not battle_ability_execution_data.is_upgraded:
		attacker_player.decrement_status_effect(shield_status_effect, damage_dealt)


static func _execute_decontaminate(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	
	var is_upgraded = battle_ability_execution_data.is_upgraded
	for i in range(Constants.PlayerStatusEffect.size()):
		var status_effect = Constants.PlayerStatusEffect.values()[i]
		if not attacker_player.active_status_effects.has(i):
			continue
		
		var applied_value = attacker_player.active_status_effects[i]
		
		if not Constants.positive_status_effects.has(i):
			attacker_player.decrement_status_effect(status_effect, applied_value)
		elif not is_upgraded:
			attacker_player.decrement_status_effect(i, applied_value)


static func _execute_energize(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	
	if battle_ability_execution_data.is_upgraded:
		attacker_player.replenish_stamina(5)
	else:
		attacker_player.replenish_stamina(3)


static func _execute_first_aid(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	
	if battle_ability_execution_data.is_upgraded:
		attacker_player.heal(12)
	else:
		attacker_player.heal(8)


static func _execute_block(battle_ability_execution_data: BattleAbilityExecutionData):
	var attack_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.SHIELD
	
	if battle_ability_execution_data.is_upgraded:
		attack_player.apply_status_effect(status_effect, 12)
	else:
		attack_player.apply_status_effect(status_effect, 8)


static func _execute_shit_and_piss(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	var hide_status_effect = Constants.PlayerStatusEffect.HIDE
	var weaken_status_effect = Constants.PlayerStatusEffect.WEAKEN
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(hide_status_effect, 2)
		defender_player.apply_status_effect(weaken_status_effect, 3)
	else:
		defender_player.apply_status_effect(hide_status_effect, 1)
		defender_player.apply_status_effect(weaken_status_effect, 2)


static func _execute_power_up(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.STRENGTH
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 5)
	else:
		defender_player.apply_status_effect(status_effect, 3)


static func _execute_weak(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.WEAKEN
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 5)
	else:
		defender_player.apply_status_effect(status_effect, 3)


static func _execute_pierce(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.PIERCE
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 4)
	else:
		defender_player.apply_status_effect(status_effect, 2)


static func _execute_thorns(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.THORNS
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.apply_status_effect(status_effect, 12)
	else:
		defender_player.apply_status_effect(status_effect, 8)


static func _execute_dodge(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.DODGE
	
	if battle_ability_execution_data.is_upgraded:
		attacker_player.apply_status_effect(status_effect, 2)
	else:
		attacker_player.apply_status_effect(status_effect, 1)


static func _execute_fury(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.FURY
	
	if battle_ability_execution_data.is_upgraded:
		attacker_player.apply_status_effect(status_effect, 2)
	else:
		attacker_player.apply_status_effect(status_effect, 1)


static func _execute_rage(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	var status_effect = Constants.PlayerStatusEffect.RAGE
	
	if battle_ability_execution_data.is_upgraded:
		attacker_player.apply_status_effect(status_effect, 1)
		for i in range(2):
			attacker_player.draw_card(true)
	else:
		attacker_player.apply_status_effect(status_effect, 1)


static func _execute_self_reset(battle_ability_execution_data: BattleAbilityExecutionData):
	var attacker_player = battle_ability_execution_data.attacker_player
	
	if battle_ability_execution_data.is_upgraded:
		attacker_player.reset_action_hand()
		attacker_player.reset_template_hand()
	else:
		attacker_player.reset_action_hand()


static func _execute_reset(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.reset_action_hand()
		defender_player.reset_template_hand()
	else:
		defender_player.reset_action_hand()


static func _execute_drain(battle_ability_execution_data: BattleAbilityExecutionData):
	var defender_player = battle_ability_execution_data.defender_player
	
	if battle_ability_execution_data.is_upgraded:
		defender_player.deplenish_stamina(5)
	else:
		defender_player.deplenish_stamina(3)

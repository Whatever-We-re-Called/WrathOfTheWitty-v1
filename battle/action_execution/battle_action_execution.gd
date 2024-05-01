class_name BattleActionExecution

const BATTLE_ACTION_EXECUTION_INFO = preload("res://battle/action_execution/battle_action_execution_info.tres")


class BattleActionExecutionData:
	var card_info: CardInfo
	var battle_scene: BattleScene
	var attacker_player: BattlePlayer
	var defender_player: BattlePlayer


static func execute_action_cards(card_infos: Array[CardInfo], battle_scene: BattleScene):
	var supportive_enhancement_value = 0
	
	for card_info in card_infos:
		execute_action_card(card_info, battle_scene, supportive_enhancement_value)


static func execute_action_card(card_info: CardInfo, battle_scene: BattleScene, supportive_enhancement_value: int = 0):
	var attacker_player = battle_scene.player
	var defender_player = battle_scene.get_non_active_side_player() 
	
	var battle_action_execution_data = BattleActionExecutionData.new()
	battle_action_execution_data.card_info = card_info
	battle_action_execution_data.battle_scene = battle_scene
	battle_action_execution_data.attacker_player = battle_scene.player
	battle_action_execution_data.defender_player = battle_scene.get_non_active_side_player()
	
	_execute_action_card_attack(battle_action_execution_data)
	
	battle_action_execution_data.battle_scene.battle_interface.update_player_stats(attacker_player)
	battle_action_execution_data.battle_scene.battle_interface.update_player_stats(defender_player)


static func _execute_action_card_attack(battle_action_execution_data: BattleActionExecutionData):
	var damage_dealt = _get_damage_dealt_value(battle_action_execution_data)
	
	battle_action_execution_data.defender_player.damage(damage_dealt)
	
	if battle_action_execution_data.card_info.enhancement == Constants.CardEnhancement.REFRESHING:
		battle_action_execution_data.attacker_player.replenish_stamina(BATTLE_ACTION_EXECUTION_INFO.base_refreshing_enhancement_stamnina_increase_value)
	
	_execute_action_card_effect(battle_action_execution_data)


static func _get_damage_dealt_value(battle_action_execution_data: BattleActionExecutionData) -> int:
	var card_info = battle_action_execution_data.card_info
	var attacker_player = battle_action_execution_data.attacker_player
	var defender_player = battle_action_execution_data.defender_player
	
	var damage_dealt = attacker_player.info.attack_stat
	
	# Handle Weak
	var weaken_status_effect = Constants.PlayerStatusEffect.WEAKEN
	if attacker_player.active_status_effects.has(weaken_status_effect):
		var weaken_value = attacker_player.active_status_effects[weaken_status_effect]
		damage_dealt -= weaken_value
		attacker_player.decrement_status_effect(weaken_status_effect, 1)
		
		if attacker_player.info.has_blessing(Blessings.Type.WEAKEN_RECOVERY):
			if attacker_player.info.is_blessing_cosmic(Blessings.Type.WEAKEN_RECOVERY):
				attacker_player.decrement_status_effect(weaken_status_effect, 2)
			else:
				attacker_player.decrement_status_effect(weaken_status_effect, 1)
	
	# Handle Insecurity Matchings
	var card_insecurity = battle_action_execution_data.card_info.insecurity
	if defender_player.info.insecurity_weaknesses.has(card_insecurity):
		damage_dealt *= BATTLE_ACTION_EXECUTION_INFO.insecurity_weakness_attack_multiplier
	elif defender_player.info.insecurity_strengths.has(card_insecurity):
		damage_dealt *= BATTLE_ACTION_EXECUTION_INFO.insecurity_strength_attack_multiplier
	elif defender_player.info.insecurity_blocks.has(card_insecurity):
		damage_dealt *= BATTLE_ACTION_EXECUTION_INFO.insecurity_block_attack_multiplier
	
	return int(floor(damage_dealt))


static func _execute_action_card_effect(battle_action_execution_data: BattleActionExecutionData):
	match battle_action_execution_data.card_info.insecurity:
		Constants.Insecurity.APPEARANCE:
			_inflict_slime_effect_onto_enemy(battle_action_execution_data)
		Constants.Insecurity.SELF_ESTEEM:
			_inflict_hide_effect_onto_enemy(battle_action_execution_data)
		Constants.Insecurity.INTELLIGENCE:
			_inflict_poison_effect_onto_enemy(battle_action_execution_data)
		Constants.Insecurity.PHYSICAL_ABILITY:
			_inflict_burn_effect_onto_enemy(battle_action_execution_data)
		Constants.Insecurity.SOCIAL_LIFE:
			_inflict_freeze_effect_onto_enemy(battle_action_execution_data)


static func _inflict_hide_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.HIDE
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_hide_stack_value
	var magic_stat_value = attacker_player.info.hide_magic_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, battle_action_execution_data)
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_poison_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.POISON
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_poison_stack_value
	var magic_stat_value = attacker_player.info.poison_magic_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, battle_action_execution_data)
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_burn_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.BURN
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_burn_stack_value
	var magic_stat_value = attacker_player.info.burn_magic_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, battle_action_execution_data)
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_freeze_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.FREEZE
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_freeze_stack_value
	var magic_stat_value = attacker_player.info.freeze_magic_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, battle_action_execution_data)
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_slime_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.SLIME
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_slime_stack_value
	var magic_stat_value = attacker_player.info.slime_magic_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, battle_action_execution_data)
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _get_magic_applied_value(base_stack_value: int, magic_stat_value: int, battle_action_execution_data: BattleActionExecutionData):
	var times_applied = _get_insecurity_status_effect_times_applied(magic_stat_value, battle_action_execution_data)
	var applied_value = base_stack_value * times_applied
	
	return applied_value


static func _get_insecurity_status_effect_times_applied(magic_stat_value: int, battle_action_execution_data: BattleActionExecutionData) -> int:
	var times_applied = 0
	const GUARANTEE_VALUE = 10
	
	var rng = RandomNumberGenerator.new()
	while magic_stat_value > 0:
		if magic_stat_value >= GUARANTEE_VALUE:
			times_applied += 1
		else:
			var result = rng.randi_range(1, 10)
			if result <= magic_stat_value:
				times_applied += 1
		
		magic_stat_value -= 10
	
	return times_applied

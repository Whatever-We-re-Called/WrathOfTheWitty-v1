class_name BattleActionExecution

const BATTLE_ACTION_EXECUTION_INFO = preload("res://battle/action_execution/battle_action_execution_info.tres")


class BattleActionExecutionData:
	var card_info: CardInfo
	var battle_scene: BattleScene
	var attacker_player: BattlePlayer
	var defender_player: BattlePlayer
	var attack_multiplier: float = 1.0
	var effect_multiplier: float = 1.0


static func execute_action_cards(card_infos: Array[CardInfo], battle_scene: BattleScene):
	var attacker_player = battle_scene.player
	
	var attack_multiplier: float = 1.0
	var attack_buff_status_effect = Constants.PlayerStatusEffect.ATTACK_BUFF
	while battle_scene.player.active_status_effects.has(attack_buff_status_effect):
		attack_multiplier += BATTLE_ACTION_EXECUTION_INFO.attack_buff_multiplier_increase_value
		attacker_player.decrement_status_effect(attack_buff_status_effect, 1)
	
	var effect_multiplier: float = 1.0
	var effect_buff_status_effect = Constants.PlayerStatusEffect.EFFECT_BUFF
	while battle_scene.player.active_status_effects.has(effect_buff_status_effect):
		effect_multiplier += BATTLE_ACTION_EXECUTION_INFO.attack_buff_multiplier_increase_value
		attacker_player.decrement_status_effect(effect_buff_status_effect, 1)
	
	for card_info in card_infos:
		execute_action_card(card_info, battle_scene, attack_multiplier, effect_multiplier)


static func execute_action_card(card_info: CardInfo, battle_scene: BattleScene, attack_multiplier: float = 1.0, effect_multiplier: float = 1.0):
	var attacker_player = battle_scene.player
	var defender_player = battle_scene.get_non_active_side_player() 
	
	var battle_action_execution_data = BattleActionExecutionData.new()
	battle_action_execution_data.card_info = card_info
	battle_action_execution_data.battle_scene = battle_scene
	battle_action_execution_data.attacker_player = battle_scene.player
	battle_action_execution_data.defender_player = battle_scene.get_non_active_side_player()
	battle_action_execution_data.attack_multiplier = attack_multiplier
	battle_action_execution_data.effect_multiplier = effect_multiplier
	
	_execute_action_card_attack(battle_action_execution_data)
	
	var fury_status_effect = Constants.PlayerStatusEffect.FURY
	if attacker_player.active_status_effects.has(fury_status_effect):
		_execute_action_card_attack(battle_action_execution_data)
		attacker_player.decrement_status_effect(fury_status_effect, 1)
	
	battle_action_execution_data.battle_scene.battle_interface.update_player_stats(attacker_player)
	battle_action_execution_data.battle_scene.battle_interface.update_player_stats(defender_player)


static func _execute_action_card_attack(battle_action_execution_data: BattleActionExecutionData):
	var attacker_player = battle_action_execution_data.attacker_player
	var defender_player = battle_action_execution_data.defender_player
	var card_info = battle_action_execution_data.card_info
	var card_insecurity = battle_action_execution_data.card_info.insecurity
	
	if _did_nullify_attack(battle_action_execution_data):
		return
	
	if defender_player.info.block_insecurity_affinities.has(card_insecurity):
		return
	else:
		var damage_dealt = _get_damage_dealt_value(battle_action_execution_data)
		
		if defender_player.info.contempt_insecurity_affinities.has(card_insecurity):
			defender_player.heal(damage_dealt)
		elif defender_player.info.repel_insecurity_affinities.has(card_insecurity):
			attacker_player.damage(damage_dealt)
			_execute_action_card_effect(attacker_player, battle_action_execution_data)
			_execute_repress_enhancement_if_applicable(defender_player, battle_action_execution_data)
		else:
			defender_player.damage(damage_dealt)
			_execute_action_card_effect(defender_player, battle_action_execution_data)
			_execute_repress_enhancement_if_applicable(defender_player, battle_action_execution_data)
		
		if battle_action_execution_data.card_info.enhancement == Constants.CardEnhancement.REFRESHING:
			battle_action_execution_data.attacker_player.replenish_stamina(BATTLE_ACTION_EXECUTION_INFO.base_refreshing_enhancement_stamnina_increase_value)


static func _did_nullify_attack(battle_action_execution_data: BattleActionExecutionData) -> bool:
	var attacker_player = battle_action_execution_data.attacker_player
	var defender_player = battle_action_execution_data.defender_player
	var card_info = battle_action_execution_data.card_info
	
	if card_info.card_scene.is_repressed:
		return true
	
	return false


static func _get_damage_dealt_value(battle_action_execution_data: BattleActionExecutionData) -> int:
	var card_info = battle_action_execution_data.card_info
	var card_insecurity = battle_action_execution_data.card_info.insecurity
	var attacker_player = battle_action_execution_data.attacker_player
	var defender_player = battle_action_execution_data.defender_player
	
	var damage_dealt = card_info.attack_value
	
	# Handle Strength
	var strength_status_effect = Constants.PlayerStatusEffect.STRENGTH
	if attacker_player.active_status_effects.has(strength_status_effect):
		var strength_value = attacker_player.active_status_effects[strength_status_effect]
		damage_dealt += strength_status_effect
		
		attacker_player.decrement_status_effect(strength_status_effect, 1)
	
	# Handle Weak
	var weaken_status_effect = Constants.PlayerStatusEffect.WEAKEN
	if attacker_player.active_status_effects.has(weaken_status_effect):
		var weaken_value = attacker_player.active_status_effects[weaken_status_effect]
		damage_dealt -= weaken_value
		
		attacker_player.decrement_status_effect(weaken_status_effect, 1)
	
	# Handle Strong & Weak Insecurity Affinity 
	if defender_player.info.weak_insecurity_affinities.has(card_insecurity):
		damage_dealt += BATTLE_ACTION_EXECUTION_INFO.weak_insecurity_affinity_attack_modifier
	elif defender_player.info.strong_insecurity_affinities.has(card_insecurity):
		damage_dealt += BATTLE_ACTION_EXECUTION_INFO.strong_insecurity_affinity_attack_modifier
	
	# Handle Attack Multiplier
	damage_dealt *= battle_action_execution_data.attack_multiplier
	
	return int(floor(damage_dealt))


static func _execute_action_card_effect(target_player: BattlePlayer, battle_action_execution_data: BattleActionExecutionData):
	match battle_action_execution_data.card_info.insecurity:
		Constants.Insecurity.APPEARANCE:
			_inflict_hide_effect_onto_enemy(target_player, battle_action_execution_data)
		Constants.Insecurity.SELF_ESTEEM:
			_inflict_slime_effect_onto_enemy(target_player, battle_action_execution_data)
		Constants.Insecurity.INTELLIGENCE:
			_inflict_poison_effect_onto_enemy(target_player, battle_action_execution_data)
		Constants.Insecurity.PHYSICAL_ABILITY:
			_inflict_burn_effect_onto_enemy(target_player, battle_action_execution_data)
		Constants.Insecurity.SOCIAL_LIFE:
			_inflict_freeze_effect_onto_enemy(target_player, battle_action_execution_data)


static func _inflict_hide_effect_onto_enemy(target_player: BattlePlayer, battle_action_execution_data: BattleActionExecutionData):
	var status_effect = Constants.PlayerStatusEffect.HIDE
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_hide_stack_value
	var magic_stat_value = attacker_player.info.hide_effect_stat
	var magic_dividend_value = attacker_player.info.hide_dividend_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, magic_dividend_value, battle_action_execution_data)
	
	target_player.apply_status_effect(status_effect, applied_value)


static func _inflict_poison_effect_onto_enemy(target_player: BattlePlayer, battle_action_execution_data: BattleActionExecutionData):
	var status_effect = Constants.PlayerStatusEffect.POISON
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_poison_stack_value
	var magic_stat_value = attacker_player.info.poison_effect_stat
	var magic_dividend_value = attacker_player.info.poison_dividend_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, magic_dividend_value, battle_action_execution_data)
	
	target_player.apply_status_effect(status_effect, applied_value)


static func _inflict_burn_effect_onto_enemy(target_player: BattlePlayer, battle_action_execution_data: BattleActionExecutionData):
	var status_effect = Constants.PlayerStatusEffect.BURN
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_burn_stack_value
	var magic_stat_value = attacker_player.info.burn_effect_stat
	var magic_dividend_value = attacker_player.info.burn_dividend_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, magic_dividend_value, battle_action_execution_data)
	
	target_player.apply_status_effect(status_effect, applied_value)


static func _inflict_freeze_effect_onto_enemy(target_player: BattlePlayer, battle_action_execution_data: BattleActionExecutionData):
	var status_effect = Constants.PlayerStatusEffect.FREEZE
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_freeze_stack_value
	var magic_stat_value = attacker_player.info.freeze_effect_stat
	var magic_dividend_value = attacker_player.info.freeze_dividend_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, magic_dividend_value, battle_action_execution_data)
	
	target_player.apply_status_effect(status_effect, applied_value)


static func _inflict_slime_effect_onto_enemy(target_player: BattlePlayer, battle_action_execution_data: BattleActionExecutionData):
	var status_effect = Constants.PlayerStatusEffect.SLIME
	var attacker_player = battle_action_execution_data.attacker_player
	var base_stack_value = BATTLE_ACTION_EXECUTION_INFO.base_slime_stack_value
	var magic_stat_value = attacker_player.info.slime_effect_stat
	var magic_dividend_value = attacker_player.info.slime_dividend_stat
	var applied_value = _get_magic_applied_value(base_stack_value, magic_stat_value, magic_dividend_value, battle_action_execution_data)
	
	target_player.apply_status_effect(status_effect, applied_value)


static func _get_magic_applied_value(base_stack_value: int, magic_stat_value: int, magic_dividend_value: int, battle_action_execution_data: BattleActionExecutionData):
	var times_applied = _get_insecurity_status_effect_times_applied(magic_stat_value, magic_dividend_value, battle_action_execution_data)
	var applied_value = base_stack_value * times_applied
	
	return applied_value


static func _get_insecurity_status_effect_times_applied(magic_stat_value: int, magic_dividend_value: int, battle_action_execution_data: BattleActionExecutionData) -> int:
	var times_applied = 0
	
	# Handle Effect Buff
	magic_stat_value = int(float(magic_stat_value) * battle_action_execution_data.effect_multiplier)
	
	var rng = RandomNumberGenerator.new()
	while magic_stat_value > 0:
		if magic_stat_value >= magic_dividend_value:
			times_applied += 1
		else:
			var result = rng.randi_range(1, magic_dividend_value)
			if result <= magic_stat_value:
				times_applied += 1
		
		magic_stat_value -= magic_dividend_value
	
	return times_applied


static func _execute_repress_enhancement_if_applicable(target_player: BattlePlayer, battle_action_execution_data: BattleActionExecutionData):
	var enhancement = battle_action_execution_data.card_info.enhancement
	if enhancement == Constants.CardEnhancement.NONE: return
	
	var card_info = battle_action_execution_data.card_info
	match enhancement:
		Constants.CardEnhancement.REPRESS:
			var repress_status_effect = BattlePlayer.INSECURITY_TO_REPRESS_STATUS_EFFECTS[card_info.insecurity]
			target_player.apply_status_effect(repress_status_effect, 1)

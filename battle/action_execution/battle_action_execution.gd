class_name BattleActionExecution

const BATTLE_ACTION_EXECUTION_INFO = preload("res://battle/action_execution/battle_action_execution_info.tres")


class BattleActionExecutionData:
	var card_info: CardInfo
	var battle_scene: BattleScene
	var attacker_player: BattlePlayer
	var defender_player: BattlePlayer


static func execute_action_cards(card_infos: Array[CardInfo], battle_scene: BattleScene):
	for card_info in card_infos:
		execute_action_card(card_info, battle_scene)


static func execute_action_card(card_info: CardInfo, battle_scene: BattleScene):
	var attacker_player = battle_scene.player
	var defender_player = battle_scene.get_non_active_side_player() 
	
	var battle_action_execution_data = BattleActionExecutionData.new()
	battle_action_execution_data.card_info = card_info
	battle_action_execution_data.battle_scene = battle_scene
	battle_action_execution_data.attacker_player = battle_scene.player
	battle_action_execution_data.defender_player = battle_scene.get_non_active_side_player()
	
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
	
	_try_to_execute_action_card_effect(battle_action_execution_data)
	_try_to_execute_action_card_enhancement(battle_action_execution_data)


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
	
	# Handle Insecurity Matchings
	var card_insecurity = Constants.get_insecurity_of_action_type(card_info.action_type)
	if defender_player.info.insecurity_weaknesses.has(card_insecurity):
		damage_dealt *= 1.25
	elif defender_player.info.insecurity_strengths.has(card_insecurity):
		damage_dealt *= 0.75
	elif defender_player.info.insecurity_blocks.has(card_insecurity):
		damage_dealt = 0
	
	return int(floor(damage_dealt))


static func _try_to_execute_action_card_effect(battle_action_execution_data: BattleActionExecutionData):
	var execution_times = 1
	
	var temp_magic_stat = battle_action_execution_data.attacker_player.info.magic_stat
	var rng = RandomNumberGenerator.new()
	while temp_magic_stat > 0:
		var result = rng.randi_range(1, 20)
		if result <= temp_magic_stat:
			execution_times += 1
		temp_magic_stat -= 20
	
	
	for i in range(execution_times):
		match battle_action_execution_data.card_info.action_type:
			Constants.CardAction.PHYSICAL_APPEARANCE_ATTACK:
				_inflict_hide_effect_onto_enemy(battle_action_execution_data)
			Constants.CardAction.SELF_ESTEEM_ATTACK:
				_inflict_weaken_effect_onto_enemy(battle_action_execution_data)
			Constants.CardAction.INTELLIGENCE_ATTACK:
				_inflict_poison_effect_onto_enemy(battle_action_execution_data)
			Constants.CardAction.PHYSICAL_ABILITY_ATTACK:
				_inflict_burn_effect_onto_enemy(battle_action_execution_data)
			Constants.CardAction.SOCIAL_LIFE_ATTACK:
				_inflict_freeze_effect_onto_enemy(battle_action_execution_data)
			Constants.CardAction.FASHION_ATTACK:
				_inflict_slime_effect_onto_enemy(battle_action_execution_data)


static func _inflict_hide_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.HIDE
	var applied_value = 1
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_weaken_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.WEAKEN
	var applied_value = 1
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_poison_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.POISON
	var applied_value = 2
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_burn_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.BURN
	var applied_value = 1
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_freeze_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.FREEZE
	var applied_value = 1
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _inflict_slime_effect_onto_enemy(battle_action_execution_data: BattleActionExecutionData):
	var defender_player = battle_action_execution_data.defender_player
	var status_effect = Constants.PlayerStatusEffect.SLIME
	var applied_value = 1
	
	defender_player.apply_status_effect(status_effect, applied_value)


static func _try_to_execute_action_card_enhancement(battle_action_execution_data: BattleActionExecutionData):
	pass


static func _execute_action_card_heal(battle_action_execution_data: BattleActionExecutionData):
	var attacker_player = battle_action_execution_data.attacker_player
	var heal_value = battle_action_execution_data.attacker_player.info.support_stat
	
	attacker_player.heal(heal_value)


static func _execute_action_card_shield(battle_action_execution_data: BattleActionExecutionData):
	var attacker_player = battle_action_execution_data.attacker_player
	var shield_value = battle_action_execution_data.attacker_player.info.support_stat
	
	attacker_player.apply_status_effect(Constants.PlayerStatusEffect.SHIELD, shield_value)

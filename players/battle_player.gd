class_name BattlePlayer extends AnimatedSprite2D

signal decreased_opponents_max_health(percentage: float, executing_player: BattlePlayer)
signal damaged_opponent(amount: int, executing_player: BattlePlayer)
signal stamina_changed

var info: PlayerInfo
var health: int
var stamina: int

var side: Constants.PlayerSide
var active_status_effects: Dictionary = {}
var frozen_stamina_count = 0

var cards_in_deck: Array[CardInfo]
var cards_in_hand: Array[CardInfo]
var cards_in_bag: Array[CardInfo]
var selected_cards: Array[CardInfo]
var card_arrays = [
	selected_cards,
	cards_in_hand,
	cards_in_deck,
	cards_in_bag
]

var template_cards_in_hand: Array[TemplateCardInfo]
var template_cards_in_deck: Array[TemplateCardInfo]
var template_cards_in_bag: Array[TemplateCardInfo]
var template_card_arrays = [
	template_cards_in_hand,
	template_cards_in_deck,
	template_cards_in_bag
]

var cards_in_hand_scenes: Array[Card]
var opponent_battle_player: BattlePlayer
var selected_template_card_hand_index: int = 0

const BASE_CARD_REROLL_STAMINA_COST = 1
const BASE_TEMPLATE_CARD_REROLL_STAMINA_COST = 2
const STATUS_EFFECT_UI = preload("res://players/status_effects/status_effect_ui.tscn")
const BATTLE_ACTION_EXECUTION_INFO = preload("res://battle/action_execution/battle_action_execution_info.tres")

func init(new_info: PlayerInfo, side: Constants.PlayerSide):
	self.info = new_info.duplicate()
	self.info.current_player_instance = self
	
	self.info.equipped_blessings.clear()
	for equipped_blessing in new_info.equipped_blessings:
		self.info.equipped_blessings.append(equipped_blessing.duplicate(true))
	self.info.init_unhandled_equipped_blessings()
	
	self.health = info.health_stat if info.current_health < 0 else info.current_health
	self.stamina = info.stamina_stat
	
	for card_info in self.info.action_card_deck:
		cards_in_deck.push_back(card_info.duplicate())
	randomize()
	cards_in_deck.shuffle()
	
	self.info.init_unhandled_equipped_template_cards()
	for template_card_info in self.info.get_template_card_info():
		template_cards_in_deck.push_back(template_card_info)
	randomize()
	template_cards_in_deck.shuffle()
	
	self.side = side
	
	scale = info.sprite_scale
	sprite_frames = info.sprite_frames
	play()


func damage(amount: int, skip_blessing_signal: bool = false, ignore_shield: bool = false):
	if amount <= 0: return
	
	if opponent_battle_player.active_status_effects.has(Constants.PlayerStatusEffect.PIERCE):
		opponent_battle_player.decrement_status_effect(Constants.PlayerStatusEffect.PIERCE, 1)
		ignore_shield = true 
	
	if not ignore_shield:
		var shield_amount = 0
		if active_status_effects.has(Constants.PlayerStatusEffect.SHIELD):
			shield_amount = active_status_effects[Constants.PlayerStatusEffect.SHIELD]
		for i in range(shield_amount):
			amount -= 1
			shield_amount -= 1
		active_status_effects[Constants.PlayerStatusEffect.SHIELD] = shield_amount
	
	health -= amount
	health = clamp(health, 0, info.health_stat)
	_execute_damage_visual()
	
	if not skip_blessing_signal:
		info.emit_damaged_signal()


func _execute_damage_visual():
	self_modulate = Color("#ea524d")
	await get_tree().create_timer(0.2).timeout
	self_modulate = Color.WHITE


func heal(amount: int):
	health += amount
	health = clamp(health, 0, info.health_stat)


func replenish_stamina(amount: int):
	stamina += amount
	stamina = clamp(stamina, 0, info.stamina_stat)
	stamina_changed.emit()


func deplenish_stamina(amount: int):
	stamina -= amount
	stamina = clamp(stamina, 0, info.stamina_stat)
	stamina_changed.emit()


func add_cards_to_hand(amount: int):
	for i in range(amount):
		cards_in_hand.push_back(get_next_card_in_deck(true))


func get_next_card_in_deck(remove_result_card: bool) -> CardInfo:
	if cards_in_deck.is_empty():
		_refill_deck_from_bag()
	
	# Edge case where there are so few cards that there is nothing
	# in deck or bag.
	if cards_in_deck.is_empty():
		return
	
	var result = cards_in_deck[0]
	
	if remove_result_card:
		if result.enhancement == Constants.CardEnhancement.RANDOM:
			_ranomize_card_info(result)
		
		cards_in_deck.pop_front()
		if cards_in_deck.is_empty():
			_refill_deck_from_bag()
	
	return result


func _refill_deck_from_bag():
	cards_in_deck = cards_in_bag.duplicate(true)
	
	randomize()
	cards_in_deck.shuffle()
	
	cards_in_bag.clear()


func send_card_to_bag(card_info: CardInfo):
	cards_in_bag.push_back(card_info)
	card_info.reset_insecurity_stack()
	card_info.reset_enhancement_stack()


func add_template_cards_to_hand(amount: int):
	for i in range(amount):
		template_cards_in_hand.push_back(get_next_template_card_in_deck(true))


func get_next_template_card_in_deck(remove_result_card: bool) -> TemplateCardInfo:
	if template_cards_in_deck.is_empty():
		_refill_template_deck_from_bag()
	
	# Edge case where there are so few cards that there is nothing
	# in deck or bag.
	if template_cards_in_deck.is_empty():
		return
	
	var result = template_cards_in_deck[0]
	if remove_result_card:
		template_cards_in_deck.pop_front()
		if template_cards_in_deck.is_empty():
			_refill_template_deck_from_bag()
	
	return result


func _refill_template_deck_from_bag():
	template_cards_in_deck = template_cards_in_bag.duplicate(true)
	
	randomize()
	template_cards_in_deck.shuffle()
	
	template_cards_in_bag.clear()


func send_template_card_to_bag(template_card_info: TemplateCardInfo):
	template_cards_in_bag.push_back(template_card_info)


func reroll_card(card: Card):
	if not can_afford_card_reroll(): return
	deplenish_stamina(get_card_reroll_stamina_cost())
	
	send_card_to_bag(card.card_info)
	
	_overwrite_card_info(card, get_next_card_in_deck(true))
	
	if active_status_effects.has(Constants.PlayerStatusEffect.BURN):
		_set_card_on_fire(card)
	
	if active_status_effects.has(Constants.PlayerStatusEffect.HIDE):
		_set_card_as_hidden(card)
	else:
		card.set_as_hidden(false)
	
	card.set_as_repressed(is_repressed_for_insecurity(card.card_info.insecurity))
	
	info.emit_rerolled_card_signal()


func can_afford_card_reroll() -> bool:
	if get_frozen_stamina_count() >= stamina:
		return false
	
	return stamina >= get_card_reroll_stamina_cost()


func get_card_reroll_stamina_cost() -> int:
	return BASE_CARD_REROLL_STAMINA_COST


func reroll_template_card(template_card: TemplateCard):
	if not can_afford_template_card_reroll(): return
	deplenish_stamina(get_template_card_reroll_stamina_cost())
	
	send_template_card_to_bag(template_card.template_card_info)
	
	_overwrite_template_card_info(template_card, get_next_template_card_in_deck(true))


func can_afford_template_card_reroll() -> bool:
	var cost = get_template_card_reroll_stamina_cost()
	
	if get_frozen_stamina_count() > (stamina - cost): 
		return false
	
	return stamina >= get_template_card_reroll_stamina_cost()


func get_template_card_reroll_stamina_cost() -> int:
	return BASE_TEMPLATE_CARD_REROLL_STAMINA_COST


func _ranomize_card_info(card_info: CardInfo):
	var rng = RandomNumberGenerator.new()
	var new_insecurity = Constants.Insecurity.values()[rng.randi_range(0, Constants.Insecurity.keys().size() - 1)]
	var new_enhancement = Constants.CardEnhancement.NONE
	while new_enhancement == Constants.CardEnhancement.NONE or new_enhancement == Constants.CardEnhancement.RANDOM:
		new_enhancement = Constants.CardEnhancement.values()[rng.randi_range(1, Constants.CardEnhancement.keys().size() - 1)]
	
	card_info.insecurity = new_insecurity
	card_info.add_to_enhancement_stack(new_enhancement)
	


func decrement_status_effect(status_effect: Constants.PlayerStatusEffect, decrement_amount: int):
	if active_status_effects.has(status_effect):
		active_status_effects[status_effect] -= decrement_amount
		if active_status_effects[status_effect] <= 0:
			active_status_effects.erase(status_effect)


func _overwrite_card_info(card: Card, new_card_info: CardInfo):
	var old_card_info = card.card_info
	for card_array in card_arrays:
		for i in range(card_array.size()):
			if card_array[i] == old_card_info:
				card_array[i] = new_card_info
				new_card_info.card_scene = card
				card.card_info = new_card_info
				card.init()
				return


func _overwrite_template_card_info(template_card: TemplateCard, new_template_card_info: TemplateCardInfo):
	var old_template_card_info = template_card.template_card_info
	for template_card_array in template_card_arrays:
		for i in range(template_card_array.size()):
			if template_card_array[i] == old_template_card_info:
				template_card_array[i] = new_template_card_info
				template_card.template_card_info = new_template_card_info
				template_card.init()
				
				return


func handle_played_selected_cards():
	for card in selected_cards:
		if card.enhancement == Constants.CardEnhancement.DEPENDABLE:
			var new_card_info = card.duplicate(true)
			new_card_info.enhancement = Constants.CardEnhancement.NONE
			new_card_info.dont_put_in_bag = true
			cards_in_hand.push_back(new_card_info)
		
		if not card.dont_put_in_bag:
			send_card_to_bag(card)
	selected_cards.clear()


func apply_status_effect(effect: Constants.PlayerStatusEffect, value: int):
	if active_status_effects.has(effect):
		active_status_effects[effect] += value
	else:
		active_status_effects[effect] = value


func apply_repress(insecurity: Constants.Insecurity):
	var effect: Constants.PlayerStatusEffect
	match insecurity:
		Constants.Insecurity.APPEARANCE:
			effect = Constants.PlayerStatusEffect.REPRESS_APPEARANCE
		Constants.Insecurity.SELF_ESTEEM:
			effect = Constants.PlayerStatusEffect.REPRESS_SELF_ESTEEM
		Constants.Insecurity.INTELLIGENCE:
			effect = Constants.PlayerStatusEffect.REPRESS_INTELLIGENCE
		Constants.Insecurity.PHYSICAL_ABILITY:
			effect = Constants.PlayerStatusEffect.REPRESS_PHYSICAL_ABILITY
		Constants.Insecurity.SOCIAL_LIFE:
			effect = Constants.PlayerStatusEffect.REPRESS_SOCIAL_LIFE
	
	active_status_effects[effect] = 1


func get_frozen_stamina_count() -> int:
	return frozen_stamina_count
	
	#var result = 0
	#for i in range(active_status_effects[Constants.PlayerStatusEffect.FREEZE]):
		#if (i + 1) <= stamina:
			#result += 1
	#return result


func is_repressed_for_insecurity(insecurity: Constants.Insecurity) -> bool:
	var is_repressed = false
	
	if insecurity == Constants.Insecurity.APPEARANCE and active_status_effects.has(Constants.PlayerStatusEffect.REPRESS_APPEARANCE):
		is_repressed = true
	if insecurity == Constants.Insecurity.SELF_ESTEEM and active_status_effects.has(Constants.PlayerStatusEffect.REPRESS_SELF_ESTEEM):
		is_repressed = true
	if insecurity == Constants.Insecurity.INTELLIGENCE and active_status_effects.has(Constants.PlayerStatusEffect.REPRESS_INTELLIGENCE):
		is_repressed = true
	if insecurity == Constants.Insecurity.PHYSICAL_ABILITY and active_status_effects.has(Constants.PlayerStatusEffect.REPRESS_PHYSICAL_ABILITY):
		is_repressed = true
	if insecurity == Constants.Insecurity.SOCIAL_LIFE and active_status_effects.has(Constants.PlayerStatusEffect.REPRESS_SOCIAL_LIFE):
		is_repressed = true
	
	return is_repressed


func handle_start_battle():
	info.emit_battle_started_blessing_signal()


func handle_start_turn():
	add_cards_to_hand(_get_needed_cards_count())
	add_template_cards_to_hand(_get_needed_template_cards_count())
	info.emit_turn_started_blessing_signal()
	
	_handle_stamina_recharge()
	_handle_poison_status_effect()


func _get_needed_cards_count() -> int:
	var space = clamp(info.action_card_deck.size(), 1, info.hand_stat)
	return space - cards_in_hand.size()


func _get_needed_template_cards_count() -> int:
	var space = clamp(info.equipped_template_cards.size(), 1, info.TEMPLATE_HAND_STAT)
	return space - template_cards_in_hand.size()


func handle_delayed_start_turn():
	_handle_burn_status_effect()
	_handle_slime_status_effect()
	_handle_hide_status_effect()
	_handle_freeze_status_effect()
	_update_hand_repressed_status()


func handle_end_turn():
	info.emit_turn_ended_blessing_signal()
	_decrement_status_effects()
	_reset_frozen_stamina()


func handle_delayed_end_turn():
	remove_repressed_status()


func _handle_stamina_recharge():
	replenish_stamina(1)


func _handle_poison_status_effect():
	if active_status_effects.has(Constants.PlayerStatusEffect.POISON):
		damage(active_status_effects[Constants.PlayerStatusEffect.POISON], true, true)
		decrement_status_effect(Constants.PlayerStatusEffect.POISON, 1)
		
		if info.has_blessing(Blessings.Type.POISON_RECOVERY):
			if info.is_blessing_cosmic(Blessings.Type.POISON_RECOVERY):
				decrement_status_effect(Constants.PlayerStatusEffect.POISON, 2)
			else:
				decrement_status_effect(Constants.PlayerStatusEffect.POISON, 1)


func _handle_burn_status_effect():
	if active_status_effects.has(Constants.PlayerStatusEffect.BURN):
		var copy_of_cards_in_hands_scene = cards_in_hand_scenes
		randomize()
		copy_of_cards_in_hands_scene.shuffle()
		
		for i in range(active_status_effects[Constants.PlayerStatusEffect.BURN]):
			if i >= info.hand_stat: break
			_set_card_on_fire(copy_of_cards_in_hands_scene[i])


func _set_card_on_fire(card: Card):
	var extinguish_damage = BATTLE_ACTION_EXECUTION_INFO.base_burn_damage_value
	
	if info.has_blessing(Blessings.Type.BURN_TOLERANCE):
		if info.is_blessing_cosmic(Blessings.Type.BURN_TOLERANCE):
			extinguish_damage -= 2
		else:
			extinguish_damage -= 1
	
	if opponent_battle_player.info.has_blessing(Blessings.Type.BURN_STRENGTH):
		if opponent_battle_player.info.is_blessing_cosmic(Blessings.Type.BURN_STRENGTH):
			extinguish_damage += 2
		else:
			extinguish_damage += 1
	
	card.set_on_fire(true, extinguish_damage)
	decrement_status_effect(Constants.PlayerStatusEffect.BURN, 1)


func _handle_slime_status_effect():
	if active_status_effects.has(Constants.PlayerStatusEffect.SLIME):
		var copy_of_cards_in_hands_scene = cards_in_hand_scenes
		randomize()
		copy_of_cards_in_hands_scene.shuffle()
		
		for i in range(active_status_effects[Constants.PlayerStatusEffect.SLIME]):
			if i >= info.hand_stat: break
			_set_card_as_slimed(copy_of_cards_in_hands_scene[i])


func _set_card_as_slimed(card: Card):
	card.set_as_slimed(true)
	decrement_status_effect(Constants.PlayerStatusEffect.SLIME, 1)


func _handle_hide_status_effect():
	if active_status_effects.has(Constants.PlayerStatusEffect.HIDE):
		var copy_of_cards_in_hands_scene = cards_in_hand_scenes
		randomize()
		copy_of_cards_in_hands_scene.shuffle()
		
		for i in range(active_status_effects[Constants.PlayerStatusEffect.HIDE]):
			if i >= info.hand_stat: break
			_set_card_as_hidden(copy_of_cards_in_hands_scene[i])


func _set_card_as_hidden(card: Card):
	card.set_as_hidden(true)
	decrement_status_effect(Constants.PlayerStatusEffect.HIDE, 1)


func _handle_freeze_status_effect():
	if not active_status_effects.has(Constants.PlayerStatusEffect.FREEZE): return
	
	frozen_stamina_count = 0
	var freeze_value = active_status_effects[Constants.PlayerStatusEffect.FREEZE]
	for i in range(freeze_value):
		if (i + 1) > stamina: break
		
		frozen_stamina_count += 1
		decrement_status_effect(Constants.PlayerStatusEffect.FREEZE, 1)


func _decrement_status_effects():
	for status_effect in active_status_effects.keys():
		var status_effect_info = Constants.PlayerStatusEffectInfo[status_effect]
		if not status_effect_info.handle_decrement_automatically: continue
		
		var decrement_value = status_effect_info.decrement_per_turn_value
		
		active_status_effects[status_effect] -= decrement_value
		
		if active_status_effects[status_effect] <= 0:
			active_status_effects.erase(status_effect)
			continue


func _reset_frozen_stamina():
	frozen_stamina_count = 0


func _update_hand_repressed_status():
	for card_info in cards_in_hand:
		var is_repressed = is_repressed_for_insecurity(card_info.insecurity)
		card_info.card_scene.set_as_repressed(is_repressed)


func remove_repressed_status():
	var repress_status_effects = [
		Constants.PlayerStatusEffect.REPRESS_APPEARANCE,
		Constants.PlayerStatusEffect.REPRESS_SELF_ESTEEM,
		Constants.PlayerStatusEffect.REPRESS_INTELLIGENCE,
		Constants.PlayerStatusEffect.REPRESS_PHYSICAL_ABILITY,
		Constants.PlayerStatusEffect.REPRESS_SOCIAL_LIFE
	]
	for repress_status_effect in repress_status_effects:
		if active_status_effects.has(repress_status_effect):
			decrement_status_effect(repress_status_effect, 1000)

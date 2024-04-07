class_name BattlePlayer extends AnimatedSprite2D

var config: PlayerConfig
var level: int
var health: int
var stamina: int
var side: Constants.PlayerSide
var active_status_effects: Dictionary = {}

var cards_in_deck: Array[CardInfo]
var cards_in_hand: Array[CardInfo]
var cards_in_bag: Array[CardInfo]
var selected_cards: Array[CardInfo]

var cards_in_hand_scenes: Array[Card]

const BASE_REROLL_STAMINA_COST = 1
const STATUS_EFFECT_UI = preload("res://players/status_effects/status_effect_ui.tscn")


func init(config: PlayerConfig, side: Constants.PlayerSide):
	self.config = config.duplicate()
	
	self.level = config.base_level
	self.health = config.max_health
	self.stamina = config.max_stamina
	
	for card_info in self.config.card_deck:
		cards_in_deck.push_back(card_info.duplicate())
	randomize()
	cards_in_deck.shuffle()
	add_cards_to_hand(config.max_hand_size)
	
	self.side = side
	
	scale = config.sprite_scale
	sprite_frames = config.sprite_frames
	play()


func damage(amount: int):
	var shield_amount = 0
	if active_status_effects.has(Constants.PlayerStatusEffect.SHIELD):
		shield_amount = active_status_effects[Constants.PlayerStatusEffect.SHIELD]
	for i in range(shield_amount):
		amount -= 1
		shield_amount -= 1
	
	health -= amount
	health = clamp(health, 0, config.max_health)
	_execute_damage_visual()
	
	active_status_effects[Constants.PlayerStatusEffect.SHIELD] = shield_amount


func _execute_damage_visual():
	self_modulate = Color("#ea524d")
	await get_tree().create_timer(0.2).timeout
	self_modulate = Color.WHITE


func heal(amount: int):
	health += amount
	health = clamp(health, 0, config.max_health)


func replenish_stamina(amount: int):
	stamina += amount
	stamina = clamp(stamina, 0, config.max_stamina)


func add_cards_to_hand(amount: int):
	# TODO Add support for proper deck and bag handling.
	for i in range(amount):
		cards_in_hand.push_back(get_next_card_in_deck(true))


func get_next_card_in_deck(remove_result_card: bool) -> CardInfo:
	if cards_in_deck.is_empty():
		_refill_deck_from_bag()
	
	var result = cards_in_deck[0]
	if remove_result_card:
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
	card_info.reset_enhancement_stack()


func reroll_card(card: Card):
	if stamina < get_reroll_stamina_cost(): return
	stamina -= get_reroll_stamina_cost()
	
	send_card_to_bag(card.card_info)
	
	_overwrite_card_info(card, get_next_card_in_deck(true))
	
	if active_status_effects.has(Constants.PlayerStatusEffect.BURN):
		_set_card_on_fire(card)
	
	if active_status_effects.has(Constants.PlayerStatusEffect.FREEZE):
		active_status_effects[Constants.PlayerStatusEffect.FREEZE] -= 1


func get_reroll_stamina_cost() -> int:
	var additional_cost: int = 0
	
	if active_status_effects.has(Constants.PlayerStatusEffect.FREEZE):
		additional_cost += active_status_effects[Constants.PlayerStatusEffect.FREEZE]
	
	return BASE_REROLL_STAMINA_COST + additional_cost


#func throw_card(card: Card, battle_scene: BattleScene):
	#if stamina < THROW_STAMINA_COST: return
	#stamina -= THROW_STAMINA_COST
	#
	#send_card_to_bag(card.card_info)
	#BattleExecution.execute_action_card(card.card_info, battle_scene)
	#card.queue_free()


func _overwrite_card_info(card: Card, new_card_info: CardInfo):
	var card_arrays_to_check = [
		selected_cards,
		cards_in_hand,
		cards_in_deck,
		cards_in_bag
	]
	
	var old_card_info = card.card_info
	for card_array in card_arrays_to_check:
		for i in range(card_array.size()):
			if card_array[i] == old_card_info:
				card_array[i] = new_card_info
				new_card_info.card_scene = card
				card.card_info = new_card_info
				card.init()
				return


func handle_played_selected_cards():
	for card in selected_cards:
		add_cards_to_hand(1)
		send_card_to_bag(card)
	selected_cards.clear()


func apply_status_effect(effect: Constants.PlayerStatusEffect, value: int):
	if active_status_effects.has(effect):
		active_status_effects[effect] += value
	else:
		active_status_effects[effect] = value


func handle_start_turn():
	_handle_stamina_recharge()
	_handle_poison_status_effect()


func handle_delayed_start_turn():
	_handle_burn_status_effect()
	_handle_weaken_status_effect()


func handle_end_turn():
	_decrement_status_effects()


func _handle_stamina_recharge():
	replenish_stamina(1)


func _handle_poison_status_effect():
	if active_status_effects.has(Constants.PlayerStatusEffect.POISON):
		health -= active_status_effects[Constants.PlayerStatusEffect.POISON]
		active_status_effects[Constants.PlayerStatusEffect.POISON] -= 1


func _handle_burn_status_effect():
	if active_status_effects.has(Constants.PlayerStatusEffect.BURN):
		var copy_of_cards_in_hands_scene = cards_in_hand_scenes
		randomize()
		copy_of_cards_in_hands_scene.shuffle()
		
		for i in range(active_status_effects[Constants.PlayerStatusEffect.BURN]):
			if i >= config.max_hand_size: break
			_set_card_on_fire(copy_of_cards_in_hands_scene[i])


func _set_card_on_fire(card: Card):
	card.set_on_fire(true)
	
	active_status_effects[Constants.PlayerStatusEffect.BURN] -= 1
	if active_status_effects[Constants.PlayerStatusEffect.BURN] <= 0:
		active_status_effects.erase(Constants.PlayerStatusEffect.BURN)


func _handle_weaken_status_effect():
	if active_status_effects.has(Constants.PlayerStatusEffect.WEAKEN):
		var copy_of_cards_in_hands_scene = cards_in_hand_scenes
		randomize()
		copy_of_cards_in_hands_scene.shuffle()
		
		for i in range(active_status_effects[Constants.PlayerStatusEffect.WEAKEN]):
			if i >= config.max_hand_size: break
			
			var card_info = copy_of_cards_in_hands_scene[i].card_info
			if not card_info.is_attack_card(): break
			if card_info.card_enhancement_stack.has(Constants.CardEnhancement.WEAK): break
			
			_weaken_card(copy_of_cards_in_hands_scene[i])


func _weaken_card(card: Card):
	card.card_info.add_to_enhancement_stack(Constants.CardEnhancement.WEAK)
	card._init_enhancement_texture()
	
	active_status_effects[Constants.PlayerStatusEffect.WEAKEN] -= 1
	if active_status_effects[Constants.PlayerStatusEffect.WEAKEN] <= 0:
		active_status_effects.erase(Constants.PlayerStatusEffect.WEAKEN)


func _decrement_status_effects():
	for status_effect in active_status_effects.keys():
		var status_effect_info = Constants.PlayerStatusEffectInfo[status_effect]
		if not status_effect_info.handle_decrement_automatically: continue
		
		var decrement_value = status_effect_info.decrement_per_turn_value
		
		active_status_effects[status_effect] -= decrement_value
		
		if active_status_effects[status_effect] <= 0:
			active_status_effects.erase(status_effect)
			continue

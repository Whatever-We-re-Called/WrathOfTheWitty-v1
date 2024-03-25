class_name BattlePlayer extends AnimatedSprite2D

var config: PlayerConfig
var health: int
var stamina: int
var side: Constants.PlayerSide

var cards_in_deck: Array[CardInfo]
var cards_in_hand: Array[CardInfo]
var cards_in_bag: Array[CardInfo]
var selected_cards: Array[CardInfo]

const REROLL_STAMINA_COST = 1
const THROW_STAMINA_COST = 3 


func init(config: PlayerConfig, side: Constants.PlayerSide):
	self.config = config
	self.health = config.max_health
	self.stamina = config.max_stamina
	
	cards_in_deck = config.card_deck
	randomize()
	cards_in_deck.shuffle()
	add_cards_to_hand(config.max_hand_size)
	
	self.side = side
	
	scale = config.sprite_scale
	sprite_frames = config.sprite_frames
	play()


func add_cards_to_hand(amount: int):
	# TODO Add support for proper deck and bag handling.
	for i in range(amount):
		cards_in_hand.push_back(get_next_card_in_deck(true))


func get_next_card_in_deck(remove_result_card: bool) -> CardInfo:
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


func reroll_card(card: Card):
	if stamina < REROLL_STAMINA_COST: return
	stamina -= REROLL_STAMINA_COST
	
	send_card_to_bag(card.card_info)
	
	_overwrite_card_info(card, get_next_card_in_deck(true))


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

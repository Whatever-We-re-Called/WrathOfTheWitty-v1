class_name BattlePlayer extends AnimatedSprite2D

var config: PlayerConfig
var health: int
var stamina: int
var side: Constants.PlayerSide

var cards_in_deck: Array[CardInfo]
var cards_in_hand: Array[CardInfo]
var cards_in_bag: Array[CardInfo]
var selected_cards: Array[CardInfo]


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
		cards_in_hand.push_back(cards_in_deck[i])

class_name BattlePlayer extends AnimatedSprite2D

var config: PlayerConfig
var health: int
var stamina: int
var card_deck: Array[CardInfo]
var side: Constants.PlayerSide


func init(config: PlayerConfig, side: Constants.PlayerSide):
	self.config = config
	self.health = config.max_health
	self.stamina = config.max_stamina
	
	randomize()
	self.card_deck = config.card_deck
	self.card_deck.shuffle()
	
	self.side = side
	
	scale = config.sprite_scale
	sprite_frames = config.sprite_frames
	play()

class_name CardInfo extends Resource

@export var insecurity: Constants.Insecurity:
	get:
		return card_insecurity_stack[0]
	set(value):
		card_insecurity_stack.clear()
		card_insecurity_stack.push_front(value)
@export var attack_value: int
@export var enhancement: Constants.CardEnhancement = Constants.CardEnhancement.NONE:
	get:
		return card_enhancement_stack[0]
	set(value):
		card_enhancement_stack.clear()
		card_enhancement_stack.push_front(value)
@export var insult_text: String

var card_scene: Card
var card_insecurity_stack: Array[Constants.Insecurity]
var card_enhancement_stack: Array[Constants.CardEnhancement]
var dont_put_in_bag = false
var times_damage_upgraded = 0

const ALLOWED_DAMAGE_UPGRADES = 2


func add_to_insecurity_stack(insecurity: Constants.Insecurity):
	card_insecurity_stack.push_front(insecurity)


func reset_insecurity_stack():
	insecurity = card_insecurity_stack[-1]


func add_to_enhancement_stack(enhancement: Constants.CardEnhancement):
	card_enhancement_stack.push_front(enhancement)


func reset_enhancement_stack():
	enhancement = card_enhancement_stack[-1]


func can_damage_be_upgraded() -> bool:
	return times_damage_upgraded < ALLOWED_DAMAGE_UPGRADES


func upgrade_damage(attack_value_increase: int = 0):
	if attack_value_increase <= 0:
		var rng = RandomNumberGenerator.new()
		attack_value += rng.randi_range(2, 3)
	else: 
		attack_value += attack_value_increase
	times_damage_upgraded += 1

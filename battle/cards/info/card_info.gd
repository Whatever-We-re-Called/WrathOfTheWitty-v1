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


func add_to_insecurity_stack(insecurity: Constants.Insecurity):
	card_insecurity_stack.push_front(insecurity)


func reset_insecurity_stack():
	insecurity = card_insecurity_stack[-1]


func add_to_enhancement_stack(enhancement: Constants.CardEnhancement):
	card_enhancement_stack.push_front(enhancement)


func reset_enhancement_stack():
	enhancement = card_enhancement_stack[-1]

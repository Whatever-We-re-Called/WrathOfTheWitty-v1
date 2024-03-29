class_name CardInfo extends Resource

@export var action_type: Constants.CardAction
@export var enhancement: Constants.CardEnhancement = Constants.CardEnhancement.NONE
@export var insult_text: String

var card_scene: Card


func is_attack_action_type() -> bool:
	return action_type >= 0 and action_type <= 5


func get_insecurity_type() -> Constants.Insecurity:
	match action_type:
		Constants.CardAction.PHYSICAL_APPEARANCE_ATTACK:
			return Constants.Insecurity.PHYSICAL_APPEARANCE
		Constants.CardAction.SELF_ESTEEM_ATTACK:
			return Constants.Insecurity.SELF_ESTEEM
		Constants.CardAction.INTELLIGENCE_ATTACK:
			return Constants.Insecurity.INTELLIGENCE
		Constants.CardAction.PHYSICAL_ABILITY_ATTACK:
			return Constants.Insecurity.PHYSICAL_ABILITY
		Constants.CardAction.SOCIAL_LIFE_ATTACK:
			return Constants.Insecurity.SOCIAL_LIFE
		Constants.CardAction.FASHION_ATTACK:
			return Constants.Insecurity.FASHION
	
	return Constants.Insecurity.PHYSICAL_APPEARANCE

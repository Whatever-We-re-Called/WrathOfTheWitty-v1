class_name CardTextures extends Resource

@export_group("Card Actions")
@export_subgroup("Colors")
@export var damage_action_color: Color
@export var shield_action_color: Color
@export var poison_action_color: Color
@export var infliction_action_color: Color
@export var heal_action_color: Color
@export var thorns_action_color: Color
@export var life_steal_action_color: Color
@export_group("Card Strength")
@export var strength_icon: Texture2D
@export_subgroup("Colors")
@export var weak_strength_color: Color
@export var medium_strength_color: Color
@export var strong_strength_color: Color
@export var extra_strong_strength_color: Color


func get_action_color(action: Constants.CardAction) -> Color:
	match (action):
		Constants.CardAction.DAMAGE:
			return damage_action_color
		Constants.CardAction.SHIELD:
			return shield_action_color
		Constants.CardAction.POISON:
			return poison_action_color
		Constants.CardAction.INFLICTION:
			return infliction_action_color
		Constants.CardAction.HEAL:
			return heal_action_color
		Constants.CardAction.THORNS:
			return thorns_action_color
		Constants.CardAction.LIFE_STEAL:
			return life_steal_action_color
	
	return Color.BLACK


func get_strength_color(strength: Constants.CardStrength) -> Color:
	match (strength):
		Constants.CardStrength.WEAK:
			return weak_strength_color
		Constants.CardStrength.MEDIUM:
			return medium_strength_color
		Constants.CardStrength.STRONG:
			return strong_strength_color
		Constants.CardStrength.EXTRA_STRONG:
			return extra_strong_strength_color
	
	return Color.BLACK

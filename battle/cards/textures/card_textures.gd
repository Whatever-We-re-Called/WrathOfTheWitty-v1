class_name CardTextures extends Resource

@export_group("Card Actions")
@export_subgroup("Colors")
@export var damage_action_color: Color
@export var shield_action_color: Color
@export var poison_action_color: Color
@export var heal_action_color: Color
@export var life_steal_action_color: Color
@export var stamina_action_color: Color
@export var fire_action_color: Color
@export var weakness_action_color: Color
@export_group("Card Strength")
@export var strength_icon: Texture2D
@export_subgroup("Colors")
@export var extra_weak_strength_color: Color
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
		Constants.CardAction.HEAL:
			return heal_action_color
		Constants.CardAction.LIFE_STEAL:
			return life_steal_action_color
		Constants.CardAction.STAMINA:
			return stamina_action_color
		Constants.CardAction.FIRE:
			return fire_action_color
		Constants.CardAction.WEAKNESS:
			return weakness_action_color
	
	return Color.BLACK


func get_strength_color(strength: Constants.CardStrength) -> Color:
	match (strength):
		Constants.CardStrength.EXTRA_WEAK:
			return weak_strength_color
		Constants.CardStrength.WEAK:
			return weak_strength_color
		Constants.CardStrength.MEDIUM:
			return medium_strength_color
		Constants.CardStrength.STRONG:
			return strong_strength_color
		Constants.CardStrength.EXTRA_STRONG:
			return extra_strong_strength_color
	
	return Color.BLACK


func get_action_as_string(action: Constants.CardAction) -> String:
	match (action):
		Constants.CardAction.DAMAGE:
			return "Damage"
		Constants.CardAction.SHIELD:
			return "Shield"
		Constants.CardAction.POISON:
			return "Poison"
		Constants.CardAction.HEAL:
			return "Heal"
		Constants.CardAction.LIFE_STEAL:
			return "Life Steal"
		Constants.CardAction.STAMINA:
			return "Stamina"
		Constants.CardAction.FIRE:
			return "Fire"
		Constants.CardAction.WEAKNESS:
			return "Weakness"
	
	return "N/A"

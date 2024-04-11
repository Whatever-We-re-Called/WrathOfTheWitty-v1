class_name CardTextures extends Resource

@export_group("Card Actions")
@export var heal_action_color: Color
@export var shield_action_color: Color
@export_group("Card Enhancements")
@export var enhancement_icon: Texture2D
@export_subgroup("Colors")
@export var weak_enhancement_color: Color
@export var buff_enhancement_color: Color
@export var extra_buff_enhancement_color: Color
@export var poison_enhancement_color: Color
@export var life_steal_enhancement_color: Color
@export var fire_enhancement_color: Color
@export var freeze_enhancement_color: Color
@export var weaken_enhancement_color: Color
@export var slime_enhancement_color: Color
@export var hide_enhancement_color: Color
@export var stamina_enhancement_color: Color


func get_action_color(action: Constants.CardAction) -> Color:
	match (action):
		Constants.CardAction.PHYSICAL_APPEARANCE_ATTACK:
			return Constants.get_insecurity_color(Constants.Insecurity.PHYSICAL_APPEARANCE)
		Constants.CardAction.SELF_ESTEEM_ATTACK:
			return Constants.get_insecurity_color(Constants.Insecurity.SELF_ESTEEM)
		Constants.CardAction.INTELLIGENCE_ATTACK:
			return Constants.get_insecurity_color(Constants.Insecurity.INTELLIGENCE)
		Constants.CardAction.PHYSICAL_ABILITY_ATTACK:
			return Constants.get_insecurity_color(Constants.Insecurity.PHYSICAL_ABILITY)
		Constants.CardAction.SOCIAL_LIFE_ATTACK:
			return Constants.get_insecurity_color(Constants.Insecurity.SOCIAL_LIFE)
		Constants.CardAction.FASHION_ATTACK:
			return Constants.get_insecurity_color(Constants.Insecurity.FASHION)
		Constants.CardAction.HEAL:
			return heal_action_color
		Constants.CardAction.SHIELD:
			return shield_action_color
	
	return Color.BLACK


func get_enhancement_color(enhancement: Constants.CardEnhancement) -> Color:
	#match (enhancement):
		#Constants.CardEnhancement.WEAK:
			#return weak_enhancement_color
		#Constants.CardEnhancement.BUFF:
			#return buff_enhancement_color
		#Constants.CardEnhancement.EXTRA_BUFF:
			#return extra_buff_enhancement_color
		#Constants.CardEnhancement.POISON:
			#return poison_enhancement_color
		#Constants.CardEnhancement.LIFE_STEAL:
			#return life_steal_enhancement_color
		#Constants.CardEnhancement.FIRE:
			#return fire_enhancement_color
		#Constants.CardEnhancement.FREEZE:
			#return freeze_enhancement_color
		#Constants.CardEnhancement.WEAKEN:
			#return weaken_enhancement_color
		#Constants.CardEnhancement.SLIME:
			#return slime_enhancement_color
		#Constants.CardEnhancement.HIDE:
			#return hide_enhancement_color
		#Constants.CardEnhancement.STAMINA:
			#return stamina_enhancement_color
	
	return Color.BLACK


func get_enhancement_as_string(enhancement: Constants.CardEnhancement) -> String:
	match (enhancement):
		Constants.CardEnhancement.NONE:
			return "None"
		Constants.CardEnhancement.REPLENISH:
			return "Replenish"
		Constants.CardEnhancement.LIFE_STEAL:
			return "Life Steal"
		Constants.CardEnhancement.DEFENSE:
			return "Defense"
		Constants.CardEnhancement.GUARANTEE:
			return "Guarantee"
		Constants.CardEnhancement.HOLLOW:
			return "Hollow"
	
	return "N/A"


func get_action_as_string(action: Constants.CardAction) -> String:
	match (action):
		Constants.CardAction.PHYSICAL_APPEARANCE_ATTACK, Constants.CardAction.SELF_ESTEEM_ATTACK, Constants.CardAction.INTELLIGENCE_ATTACK, Constants.CardAction.PHYSICAL_ABILITY_ATTACK, Constants.CardAction.SOCIAL_LIFE_ATTACK, Constants.CardAction.FASHION_ATTACK:
			return "Attack"
		Constants.CardAction.HEAL:
			return "Heal"
		Constants.CardAction.SHIELD:
			return "Shield"
	
	return "N/A"

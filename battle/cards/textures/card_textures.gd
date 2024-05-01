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
	#match (enhancement):
		#Constants.CardEnhancement.NONE:
			#return "None"
		#Constants.CardEnhancement.BUFF:
			#return "Buff"
		#Constants.CardEnhancement.MAGICAL:
			#return "Magical"
		#Constants.CardEnhancement.SUPPORTIVE:
			#return "Supportive"
		#Constants.CardEnhancement.REFRESHING:
			#return "Refreshing"
		#Constants.CardEnhancement.DEPENDABLE:
			#return "Dependable"
	
	return "N/A"

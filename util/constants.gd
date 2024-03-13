# Extension needed for autoload, for some reasons.
# Otherwise, a startup erorr will always occur.
extends Node

var insecurity_colors = preload("res://util/insecurities/insecurity_textures.tres")

enum Insecurity { 
	PHYSICAL_APPEARANCE, 
	SELF_ESTEEM, 
	INTELLIGENCE, 
	PHYSICAL_ABILITY, 
	SOCIAL_LIFE,
	FASHION
}

enum CardAction {
	DAMAGE,
	SHIELD,
	POISON,
	INFLICTION,
	HEAL,
	THORNS,
	LIFE_STEAL
}

enum CardStrength {
	WEAK,
	MEDIUM,
	STRONG,
	EXTRA_STRONG
}

func get_insecurity_color(insecurity: Insecurity) -> Color:
	match (insecurity):
		Insecurity.PHYSICAL_APPEARANCE:
			return insecurity_colors.physical_apprance_color
		Insecurity.SELF_ESTEEM:
			return insecurity_colors.self_esteem_color
		Insecurity.INTELLIGENCE:
			return insecurity_colors.intelligence_color
		Insecurity.PHYSICAL_ABILITY:
			return insecurity_colors.physical_ability_color
		Insecurity.SOCIAL_LIFE:
			return insecurity_colors.social_life_color
		Insecurity.FASHION:
			return insecurity_colors.fashion_color
	
	return Color.BLACK

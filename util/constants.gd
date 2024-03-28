# Extension needed for autoload, for some reasons.
# Otherwise, a startup erorr will always occur.
extends Node

var insecurity_colors = preload("res://util/insecurities/insecurity_textures.tres")

enum CardAction {
	PHYSICAL_APPEARANCE_ATTACK, 
	SELF_ESTEEM_ATTACK, 
	INTELLIGENCE_ATTACK, 
	PHYSICAL_ABILITY_ATTACK, 
	SOCIAL_LIFE_ATTACK,
	FASHION_ATTACK,
	HEAL,
	SHIELD
}

enum Insecurity {
	PHYSICAL_APPEARANCE, 
	SELF_ESTEEM, 
	INTELLIGENCE, 
	PHYSICAL_ABILITY, 
	SOCIAL_LIFE,
	FASHION
}

enum CardEnhancement {
	NONE,
	WEAK,
	BUFF,
	EXTRA_BUFF,
	POISON,
	LIFE_STEAL,
	FIRE,
	FREEZE,
	WEAKEN,
	STAMINA
}

enum PlayerSide {
	LEFT,
	RIGHT
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


func get_insecurity_icon() -> Texture2D:
	return insecurity_colors.insecurity_icon

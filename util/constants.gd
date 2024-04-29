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
	BUFF,
	MAGICAL,
	TEST,
	SUPPORTIVE,
	REFRESHING,
	DEPENDABLE
}

enum PlayerStatusEffect {
	SHIELD,
	STRENGTH,
	THORN,
	DODGE,
	PIERCE,
	FURY,
	POISON,
	BURN,
	FREEZE,
	WEAKEN,
	SLIME,
	HIDE
}

var positive_status_effects = [
	PlayerStatusEffect.SHIELD,
	PlayerStatusEffect.STRENGTH,
	PlayerStatusEffect.THORN,
	PlayerStatusEffect.DODGE,
	PlayerStatusEffect.PIERCE,
	PlayerStatusEffect.FURY
]

var PlayerStatusEffectInfo = {
	PlayerStatusEffect.SHIELD: preload("res://players/status_effects/effects/shield_status_effect_info.tres"),
	PlayerStatusEffect.POISON: preload("res://players/status_effects/effects/poison_status_effect.tres"),
	PlayerStatusEffect.BURN: preload("res://players/status_effects/effects/burn_status_effect.tres"),
	PlayerStatusEffect.FREEZE: preload("res://players/status_effects/effects/freeze_status_effect.tres"),
	PlayerStatusEffect.WEAKEN: preload("res://players/status_effects/effects/weaken_status_effect.tres"),
	PlayerStatusEffect.SLIME: preload("res://players/status_effects/effects/slime_status_effect.tres"),
	PlayerStatusEffect.HIDE: preload("res://players/status_effects/effects/hide_status_effect.tres")
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


func get_insecurity_of_action_type(action_type: CardAction) -> Insecurity:
	match action_type:
		CardAction.PHYSICAL_APPEARANCE_ATTACK:
			return Insecurity.PHYSICAL_APPEARANCE
		CardAction.SELF_ESTEEM_ATTACK:
			return Insecurity.SELF_ESTEEM
		CardAction.INTELLIGENCE_ATTACK:
			return Insecurity.INTELLIGENCE
		CardAction.PHYSICAL_ABILITY_ATTACK:
			return Insecurity.PHYSICAL_ABILITY
		CardAction.SOCIAL_LIFE_ATTACK:
			return Insecurity.SOCIAL_LIFE
		CardAction.FASHION_ATTACK:
			return Insecurity.FASHION
	return Insecurity.PHYSICAL_APPEARANCE

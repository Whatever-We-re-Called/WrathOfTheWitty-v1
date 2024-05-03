# Extension needed for autoload, for some reasons.
# Otherwise, a startup erorr will always occur.
extends Node

var insecurity_colors = preload("res://util/insecurities/insecurity_textures.tres")

enum Insecurity {
	APPEARANCE,
	SELF_ESTEEM,
	INTELLIGENCE,
	PHYSICAL_ABILITY,
	SOCIAL_LIFE
}

enum CardEnhancement {
	NONE,
	REFRESHING,
	DEPENDABLE,
	REPRESS,
	WILDCARD,
	RANDOM
}

const enhancement_strings = {
	Constants.CardEnhancement.NONE: "None",
	Constants.CardEnhancement.REFRESHING: "Refreshing",
	Constants.CardEnhancement.DEPENDABLE: "Dependable",
	Constants.CardEnhancement.REPRESS: "Repress",
	Constants.CardEnhancement.WILDCARD: "Wildcard",
	Constants.CardEnhancement.RANDOM: "Random"
}

enum PlayerStatusEffect {
	SHIELD,
	STRENGTH,
	THORN,
	DODGE,
	PIERCE,
	FURY,
	RAGE,
	POISON,
	BURN,
	FREEZE,
	WEAKEN,
	SLIME,
	HIDE,
	REPRESS_APPEARANCE,
	REPRESS_INTELLIGENCE,
	REPRESS_PHYSICAL_ABILITY,
	REPRESS_SELF_ESTEEM,
	REPRESS_SOCIAL_LIFE,
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
	PlayerStatusEffect.HIDE: preload("res://players/status_effects/effects/hide_status_effect.tres"),
	PlayerStatusEffect.REPRESS_APPEARANCE: preload("res://players/status_effects/effects/repress_appearance_status_effect.tres"),
	PlayerStatusEffect.REPRESS_INTELLIGENCE: preload("res://players/status_effects/effects/repress_intelligence_status_effect.tres"),
	PlayerStatusEffect.REPRESS_PHYSICAL_ABILITY: preload("res://players/status_effects/effects/repress_physical_ability_status_effect.tres"),
	PlayerStatusEffect.REPRESS_SELF_ESTEEM: preload("res://players/status_effects/effects/repress_self_esteem_status_effect.tres"),
	PlayerStatusEffect.REPRESS_SOCIAL_LIFE: preload("res://players/status_effects/effects/repress_social_life_status_effect.tres"),
	PlayerStatusEffect.STRENGTH: preload("res://players/status_effects/effects/strength_status_effect.tres"),
}

enum PlayerSide {
	LEFT,
	RIGHT
}

func get_insecurity_color(insecurity: Insecurity) -> Color:
	match (insecurity):
		Insecurity.APPEARANCE:
			return insecurity_colors.appearance_color
		Insecurity.SELF_ESTEEM:
			return insecurity_colors.self_esteem_color
		Insecurity.INTELLIGENCE:
			return insecurity_colors.intelligence_color
		Insecurity.PHYSICAL_ABILITY:
			return insecurity_colors.physical_ability_color
		Insecurity.SOCIAL_LIFE:
			return insecurity_colors.social_life_color
	
	return Color.BLACK


func get_insecurity_icon() -> Texture2D:
	return insecurity_colors.insecurity_icon

# Extension needed for autoload, for some reasons.
# Otherwise, a startup erorr will always occur.
extends Node

const INSECURITY_TEXTURES = preload("res://util/insecurities/insecurity_textures.tres")

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
	THORNS,
	DODGE,
	SURVIVE,
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
	PlayerStatusEffect.THORNS,
	PlayerStatusEffect.DODGE,
	PlayerStatusEffect.PIERCE,
	PlayerStatusEffect.FURY,
	PlayerStatusEffect.RAGE,
	PlayerStatusEffect.SURVIVE
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
	PlayerStatusEffect.PIERCE: preload("res://players/status_effects/effects/pierce_status_effect.tres"),
	PlayerStatusEffect.THORNS: preload("res://players/status_effects/effects/thorns_status_effect.tres")
}

enum PlayerSide {
	LEFT,
	RIGHT
}

enum InsecurityAffinityType { 
	NONE,
	WEAK,
	STRONG,
	BLOCK,
	CONTEMPT,
	REPEL
}

func get_insecurity_color(insecurity: Insecurity) -> Color:
	match (insecurity):
		Insecurity.APPEARANCE:
			return INSECURITY_TEXTURES.appearance_color
		Insecurity.SELF_ESTEEM:
			return INSECURITY_TEXTURES.self_esteem_color
		Insecurity.INTELLIGENCE:
			return INSECURITY_TEXTURES.intelligence_color
		Insecurity.PHYSICAL_ABILITY:
			return INSECURITY_TEXTURES.physical_ability_color
		Insecurity.SOCIAL_LIFE:
			return INSECURITY_TEXTURES.social_life_color
	
	return Color.BLACK


func get_insecurity_icon(insecurity_affinity_type: InsecurityAffinityType = InsecurityAffinityType.NONE) -> Texture2D:
	match insecurity_affinity_type:
		InsecurityAffinityType.WEAK:
			return INSECURITY_TEXTURES.weak_insecurity_affinity_icon
		InsecurityAffinityType.STRONG:
			return INSECURITY_TEXTURES.strong_insecurity_affinity_icon
		InsecurityAffinityType.BLOCK:
			return INSECURITY_TEXTURES.block_insecurity_affinity_icon
		InsecurityAffinityType.CONTEMPT:
			return INSECURITY_TEXTURES.contempt_insecurity_affinity_icon
		InsecurityAffinityType.REPEL:
			return INSECURITY_TEXTURES.repel_insecurity_affinity_icon
	
	return INSECURITY_TEXTURES.insecurity_icon

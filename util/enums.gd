# Extension needed for autoload, for some reasons.
# Otherwise, a startup erorr will always occur.
extends Node

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

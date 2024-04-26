extends Node

enum Type {
	EXTRA_HEALTH_ONE,
	EXTRA_STAMINA_ONE,
	EXTRA_STAMINA_RECHARGE_ONE,
	EXTRA_HAND_SPACE_ONE,
	EXTRA_SPEED_ONE,
	EXTRA_ATTACK_ONE,
	EXTRA_SUPPORT_ONE,
	EXTRA_HIDE_ONE,
	EXTRA_WEAKEN_ONE,
	EXTRA_POISON_ONE,
	EXTRA_BURN_ONE,
	EXTRA_FREEZE_ONE,
	EXTRA_SLIME_ONE,
	EXTRA_COSMIC_SLOTS_ONE,
	FIRST_ATTACK_BONUS,
	FIRST_SUPPORT_BONUS,
	FIRST_MAGIC_BONUS,
	PREPARED_PROTECTION_ONE,
	THORNS_ONE,
	TURN_HEAL_ONE,
	BATTLE_HEAL_ONE,
	DECREASE_MAX_HEALTH_ONE,
	WEAKEN_RECOVERY,
	POISON_RECOVERY,
	BURN_TOLERANCE,
	BURN_STRENGTH
}

func _ready():
	Blessings.load_all_blessings()


static var loaded_blessings = {}


static func load_blessing(type, resource):
	loaded_blessings[type] = resource


static func get_blessing(type) -> Resource:
	return loaded_blessings[type]


static func load_all_blessings():
	load_blessing(Type.EXTRA_HEALTH_ONE, preload("res://blessings/resources/base_stats/extra_health_one.tres"))

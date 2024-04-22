extends Node

enum Type {
	STRENGTH,
	TURN_HEAL,
	DECREASE_MAX_HEALTH,
}

func _ready():
	Blessings.load_all_blessings()


static var loaded_blessings = {}


static func load_blessing(type, resource):
	loaded_blessings[type] = resource


static func get_blessing(type) -> Resource:
	return loaded_blessings[type]


static func load_all_blessings():
	load_blessing(Type.STRENGTH, preload("res://blessings/resources/strength.tres"))
	load_blessing(Type.TURN_HEAL, preload("res://blessings/resources/turn_heal.tres"))
	load_blessing(Type.DECREASE_MAX_HEALTH, preload("res://blessings/resources/decrease_max_health.tres"))

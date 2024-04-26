extends Node

# IMPORTANT NOTE: 
# Due to how Godot stores Enums, if you were to change the integer
# value of an enum entry, or if you were to delete an enum entry
# altogether, Godot will make inappropriate assumptions on what to
# replace any references to the changed type with.
# 
# It's okay to remove entries, but DO NOT add entries within the center
# or as replacements. Always add a new entry with a newly unique int
# value on the bottom.
enum Type {
	EXTRA_HEALTH_ONE = 0,
	EXTRA_HEALTH_TWO = 1,
	EXTRA_HEALTH_THREE = 2,
	EXTRA_STAMINA_ONE = 3,
	EXTRA_STAMINA_TWO = 4,
	EXTRA_STAMINA_THREE = 5,
	EXTRA_STAMINA_RECHARGE_ONE = 6,
	EXTRA_STAMINA_RECHARGE_TWO = 7,
	EXTRA_HAND_SPACE = 8,
	EXTRA_SPEED_ONE = 9,
	EXTRA_SPEED_TWO = 10,
	EXTRA_SPEED_THREE = 11,
	EXTRA_ATTACK_ONE = 12,
	EXTRA_ATTACK_TWO = 13,
	EXTRA_ATTACK_THREE = 14,
	EXTRA_SUPPORT_ONE = 15,
	EXTRA_SUPPORT_TWO = 16,
	EXTRA_SUPPORT_THREE = 17,
	EXTRA_HIDE_ONE = 18,
	EXTRA_HIDE_TWO = 19,
	EXTRA_HIDE_THREE = 20,
	EXTRA_WEAKEN_ONE = 21,
	EXTRA_WEAKEN_TWO = 22,
	EXTRA_WEAKEN_THREE = 23,
	EXTRA_POISON_ONE = 24,
	EXTRA_POISON_TWO = 25,
	EXTRA_POISON_THREE = 26,
	EXTRA_BURN_ONE = 27,
	EXTRA_BURN_TWO = 28,
	EXTRA_BURN_THREE = 29,
	EXTRA_FREEZE_ONE = 30,
	EXTRA_FREEZE_TWO = 31,
	EXTRA_FREEZE_THREE = 32,
	EXTRA_SLIME_ONE = 33,
	EXTRA_SLIME_TWO = 34,
	EXTRA_SLIME_THREE = 35,
	EXTRA_COSMIC_SLOTS_ONE = 36,
	EXTRA_COSMIC_SLOTS_TWO = 37,
	FIRST_ATTACK_BUFF = 38,
	FIRST_SUPPORT_BUFF = 39,
	FIRST_MAGIC_BUFF = 40,
	PREPARED_PROTECTION_ONE = 41,
	PREPARED_PROTECTION_TWO = 42,
	THORNS_ONE = 43,
	THORNS_TWO = 44,
	TURN_HEAL_ONE = 45,
	TURN_HEAL_TWO = 46,
	BATTLE_HEAL_ONE = 47,
	BATTLE_HEAL_TWO = 48,
	DECREASE_MAX_HEALTH_ONE = 49,
	DECREASE_MAX_HEALTH_TWO = 50,
	REROLL_HEAL_BONUS = 51,
	REROLL_SHIELD_BONUS = 52,
	WEAKEN_RECOVERY = 53,
	POISON_RECOVERY = 54,
	BURN_TOLERANCE = 55,
	BURN_STRENGTH = 56
}

func _ready():
	Blessings.load_all_blessings()


static var loaded_blessings = {}


static func load_blessing(type, resource):
	loaded_blessings[type] = resource


static func get_blessing(type) -> Resource:
	return loaded_blessings[type]


static func load_all_blessings():
	var resource_file_paths = _get_all_blessing_resource_file_paths("res://blessings/resources/")
	
	var regex = RegEx.new()
	regex.compile("[a-z,A-Z,0-9,_]*.tres")
	for resource_file_path in resource_file_paths:
		var result = regex.search(resource_file_path)
		if result != null:
			var result_string = result.get_string()
			var file_name = result_string.substr(0, result_string.length() - 5)
			var blessing_type = Type.get(file_name.to_upper())
			
			load_blessing(blessing_type, load(resource_file_path))


static func _get_all_blessing_resource_file_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += _get_all_blessing_resource_file_paths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()
	return file_paths

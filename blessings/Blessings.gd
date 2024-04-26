extends Node

enum Type {
	EXTRA_HEALTH_ONE,
	EXTRA_HEALTH_TWO,
	EXTRA_HEALTH_THREE,
	EXTRA_STAMINA_ONE,
	EXTRA_STAMINA_TWO,
	EXTRA_STAMINA_THREE,
	EXTRA_STAMINA_RECHARGE_ONE,
	EXTRA_STAMINA_RECHARGE_TWO,
	EXTRA_HAND_SPACE,
	EXTRA_SPEED_ONE,
	EXTRA_SPEED_TWO,
	EXTRA_SPEED_THREE,
	EXTRA_ATTACK_ONE,
	EXTRA_ATTACK_TWO,
	EXTRA_ATTACK_THREE,
	EXTRA_SUPPORT_ONE,
	EXTRA_SUPPORT_TWO,
	EXTRA_SUPPORT_THREE,
	EXTRA_HIDE_ONE,
	EXTRA_HIDE_TWO,
	EXTRA_HIDE_THREE,
	EXTRA_WEAKEN_ONE,
	EXTRA_WEAKEN_TWO,
	EXTRA_WEAKEN_THREE,
	EXTRA_POISON_ONE,
	EXTRA_POISON_TWO,
	EXTRA_POISON_THREE,
	EXTRA_BURN_ONE,
	EXTRA_BURN_TWO,
	EXTRA_BURN_THREE,
	EXTRA_FREEZE_ONE,
	EXTRA_FREEZE_TWO,
	EXTRA_FREEZE_THREE,
	EXTRA_SLIME_ONE,
	EXTRA_SLIME_TWO,
	EXTRA_SLIME_THREE,
	EXTRA_COSMIC_SLOTS_ONE,
	EXTRA_COSMIC_SLOTS_TWO,
	FIRST_ATTACK_BONUS,
	FIRST_SUPPORT_BONUS,
	FIRST_MAGIC_BONUS,
	PREPARED_PROTECTION_ONE,
	PREPARED_PROTECTION_TWO,
	THORNS_ONE,
	THORNS_TWO,
	TURN_HEAL_ONE,
	TURN_HEAL_TWO,
	BATTLE_HEAL_ONE,
	BATTLE_HEAL_TWO,
	DECREASE_MAX_HEALTH_ONE,
	DECREASE_MAX_HEALTH_TWO,
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

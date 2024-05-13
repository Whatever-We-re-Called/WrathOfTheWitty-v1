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
	TEST
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

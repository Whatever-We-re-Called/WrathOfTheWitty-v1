extends Node
class_name RoomScript

@export var icon: PackedScene
@export var scene_to_load: PackedScene


func get_icon() -> PackedScene:
	return icon
	
	
func get_scene_to_load() -> PackedScene:
	return scene_to_load

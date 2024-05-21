extends Node
class_name MapGenerator

var temporary_room_pool: Array[RoomInfo] = [
	preload("res://map/rooms/info/action_battle_room_info.tres"),
	preload("res://map/rooms/info/cosmic_battle_room_info.tres"),
	preload("res://map/rooms/info/enhancement_battle_room_info.tres"),
	preload("res://map/rooms/info/template_battle_room_info.tres"),
	preload("res://map/rooms/info/rest_room_info.tres")
]

func generate(settings: GeneratorSettings) -> MapNode:
	return null

extends Node
class_name MapGenerator

# Just putting battle rooms twice so we have a 2:1 battle to non-battle
# room ratio for now.
var temporary_room_pool: Array[RoomInfo] = [
	preload("res://map/rooms/info/action_battle_room_info.tres"),
	preload("res://map/rooms/info/cosmic_battle_room_info.tres"),
	preload("res://map/rooms/info/enhancement_battle_room_info.tres"),
	preload("res://map/rooms/info/template_battle_room_info.tres"),
	preload("res://map/rooms/info/action_battle_room_info.tres"),
	preload("res://map/rooms/info/cosmic_battle_room_info.tres"),
	preload("res://map/rooms/info/enhancement_battle_room_info.tres"),
	preload("res://map/rooms/info/template_battle_room_info.tres"),
	preload("res://map/rooms/info/rest_room_info.tres"),
	preload("res://map/rooms/info/sacrificial_alter_room_info.tres"),
	preload("res://map/rooms/info/wizard_room_info.tres"),
	preload("res://map/rooms/info/cloaked_dude_room_info.tres")
]

func generate(settings: GeneratorSettings) -> MapNode:
	return null

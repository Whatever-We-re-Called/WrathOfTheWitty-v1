extends Node
class_name GeneratorSettings


@export_category("Floor Size")
@export var min_levels: int
@export var max_levels: int
@export var max_nodes_width: int
@export var max_position_width: int

@export_category("Chances")
@export var split_from_one: int
@export var split_into_two: int
@export var split_into_three: int
@export var dead_end: int

@export_category("Debug")
@export var print = false
@export var connect = true


var _levels = null

func get_levels() -> int:
	if _levels == null:
		_levels = SeededGenerator.mode("map").next_int_min_max(min_levels, max_levels)
	return _levels

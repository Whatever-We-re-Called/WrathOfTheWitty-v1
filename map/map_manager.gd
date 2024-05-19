extends Node

var selected_node_id = 0
var boss_node_id = 0

func generate_new_map():
	SeededGenerator.mode("map").drop_transaction()
	selected_node_id = 0
	boss_node_id = 0


func swap_to_map_scene():
	get_tree().change_scene_to_file("res://map/display/map.tscn")


func can_go_to_next_floor() -> bool:
	if selected_node_id == 0: return false
	
	return selected_node_id == boss_node_id


func go_to_next_floor():
	RunManager.increment_floor()
	generate_new_map()
	await get_tree().process_frame
	swap_to_map_scene()

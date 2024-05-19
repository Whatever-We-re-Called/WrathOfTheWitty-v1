extends Node

var selected_node_id = 0
var boss_node_id = 0

func generate_new_map():
	SeededGenerator.mode("map").drop_transaction()
	reset_map()


func reset_map():
	selected_node_id = 0
	boss_node_id = 0


func swap_to_map_scene():
	if selected_node_id != 0 and selected_node_id == boss_node_id:
		go_to_next_floor()
	else:
		get_tree().change_scene_to_file("res://map/display/map.tscn")


func can_go_to_next_floor() -> bool:
	if selected_node_id == 0: return false
	
	return selected_node_id == boss_node_id


func go_to_next_floor():
	RunManager.increment_floor()
	if RunManager.is_on_valid_floor():
		generate_new_map()
		swap_to_map_scene()

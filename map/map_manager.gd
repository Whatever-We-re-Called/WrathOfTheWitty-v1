extends Node

var selected_node_id = 0


func generate_new_map():
	SeededGenerator.mode("map").drop_transaction()
	selected_node_id = 0


func swap_to_map_scene():
	get_tree().change_scene_to_file("res://map/display/map.tscn")

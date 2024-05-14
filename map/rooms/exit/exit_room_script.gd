extends Node2D

func _ready():
	MapManager.generate_new_map()
	
	
func _process(delta):
	MapManager.swap_to_map_scene()

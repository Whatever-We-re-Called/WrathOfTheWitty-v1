extends Node2D
class_name UIElement


@export var ui_parent: Node


func parent() -> Node:
	if ui_parent == null:
		if get_parent() is UIElement:
			return get_parent().parent()
		else:
			ui_parent = get_parent()
	return ui_parent
	
	
func execute():
	pass
	

func timer(time):
	await get_tree().create_timer(time * (1 - get_process_delta_time())).timeout 
	
	
enum InterpolationStyle {
	LINEAR,
	BEZIER,
	CUBIC_UP,
	CUBIC_DOWN
}

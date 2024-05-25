extends UIAction
class_name UIBoundingBoxHandler


@export var overide_bounding_boxes: Array[Node]
var bounding_boxes = []
var inside


# We cant really connect to the signals, so this serves as our 'mouse enter' 'mouse exit'
# This also allows multiple different hitboxes of a shape by handling overlaps.
# Godot's built in signals don't like overlaps (see the Control docs), so this fixes that
# The awaits allow for small gaps in the hitboxes, but realistically those shouldn't happen, just handling them in case they do
func _process(delta):
	if inside:
		if not is_inside():
			await get_tree().process_frame
			if not is_inside():
				inside = false
				exit()
	else:
		if is_inside():
			await get_tree().process_frame
			if is_inside():
				inside = true
				enter()


func get_controls():
	if overide_bounding_boxes != null and overide_bounding_boxes.size() > 0:
		return overide_bounding_boxes
		
	else:
		if bounding_boxes == null or bounding_boxes.size() == 0:
			var controls = []
			for child in parent().get_children():
				if child is Control:
					controls.append(child)
			bounding_boxes = controls
			return controls
		else:
			return bounding_boxes


func is_inside() -> bool:
	for control in get_controls():
		if control is Control:
			if Rect2(Vector2() - (control.size / 2), control.size).has_point(get_local_mouse_position()):
				return true
	return false


func enter():
	pass
	
	
func exit():
	pass

extends Camera2D

@export var move_threshhold_percentage: int
@export var move_speed: int

func setup(root):
	limit_bottom = root.position.y + 150
	limit_top = get_max(root).position.y - 150
	
	var cam_pos = root.position
	cam_pos.y = get_viewport().get_visible_rect().size.y / 2 + 150
	self.position = cam_pos

func get_max(node) -> MapNode:
	if node.connections.size() == 0:
		return node

	var y = 999
	var max_node: Node = null

	for child in node.connections:
		var max = get_max(child)
		if max.position.y < y:
			y = max.position.y
			max_node = max

	return max_node

func _process(delta):
	var mouse_vertical_percentage = (get_viewport().get_mouse_position().y / float(get_viewport().get_visible_rect().size.y)) * 100
	var mouse_horizontal_percentage = (get_viewport().get_mouse_position().x / float(get_viewport().get_visible_rect().size.x)) * 100
	
	if mouse_vertical_percentage >= 100 or mouse_vertical_percentage <= 0:
		return
	if mouse_horizontal_percentage >= 100 or mouse_horizontal_percentage <= 0:
		return
	
	var cam_pos = position
	
	if mouse_vertical_percentage < move_threshhold_percentage:
		cam_pos.y = cam_pos.y - move_speed + delta
		
	if mouse_vertical_percentage > (100 - move_threshhold_percentage):
		cam_pos.y = cam_pos.y + move_speed + delta
		
	
	cam_pos.y = clamp(cam_pos.y, limit_top + (get_viewport().get_visible_rect().size.y / 2) , limit_bottom - (get_viewport().get_visible_rect().size.y / 2))
	position = cam_pos
	

extends Camera2D

@export var move_threshhold_percentage: int
@export var move_speed: int
@export var map_node_offset: int

var top_y_adjusted_limit: int
var bottom_y_adjusted_limit: int

func setup(root, selected_node):
	limit_bottom = root.position.y + map_node_offset
	limit_top = get_max(root).position.y - map_node_offset
	
	var half_viewport_height = (get_viewport().get_visible_rect().size.y / 2)
	bottom_y_adjusted_limit = limit_bottom - (half_viewport_height * (1 / zoom.y))
	top_y_adjusted_limit = limit_top + (half_viewport_height * (1 / zoom.y))
	
	self.position.y = selected_node.position.y

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
	
	if mouse_vertical_percentage < move_threshhold_percentage:
		position.y = position.y - (move_speed * delta)
		
	if mouse_vertical_percentage > (100 - move_threshhold_percentage):
		position.y = position.y + (move_speed * delta)
		
	
	position.y = clamp(position.y, top_y_adjusted_limit, bottom_y_adjusted_limit)
	

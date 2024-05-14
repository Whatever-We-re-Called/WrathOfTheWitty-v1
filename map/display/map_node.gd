extends Node2D
class_name MapNode

var id = null
var drawn = false
var lines_drawn = false

var x_offset = 0
var y_offset = 0
var room_script = preload("res://map/rooms/example/example_room.tscn").instantiate()

var connections = []
var backwards_connections = []


func draw(parent, map, render_ids):
	if not drawn:
		map.add_child(self)
		
		var icon = room_script.get_icon().instantiate()
		add_child(icon)
		icon.get_node("Button").pressed.connect(pressed.bind(map))
		
		if icon.has_node("Id"):
			if render_ids:
				icon.get_node("Id").text = str(id)
			else:
				icon.get_node("Id").visible = false
			
		
		if parent == null:
			self.position.x = get_viewport().get_visible_rect().size.x / 2.0
			self.position.y = get_viewport().get_visible_rect().size.y
		else:
			self.position.x = get_viewport().get_visible_rect().size.x / 2.0 + x_offset
			self.position.y = parent.position.y - y_offset
			
		drawn = true


func pressed(map):
	map.select(self)
	

func draw_lines(map):
	if not lines_drawn:
		for child in connections:
			var line = Line2D.new()
			line.add_point(self.position)
			line.add_point(child.position)
			map.add_child(line)
		lines_drawn = true


func set_offsets(x, y):
	x_offset = x
	y_offset = y


func connect_node(node):
	connections.push_back(node)
	node.backwards_connections.append(self)
	

static var index = 0

func _init():
	id = MapNode.index
	MapNode.index += 1

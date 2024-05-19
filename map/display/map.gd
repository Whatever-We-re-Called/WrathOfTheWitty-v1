extends Node2D

@export_category("Refs")
@export var camera: Camera2D
@export var player: Node2D

@export_category("Generator")
@export var generator: Resource
@export var settings: GeneratorSettings
@export var render_ids = false

@onready var current_floor_label = %CurrentFloorLabel
@onready var max_floor_label = %MaxFloorLabel

var root
var selected_node = null

func _ready():
	if MapManager.can_go_to_next_floor():
		queue_free()
		MapManager.go_to_next_floor()
		return
	
	generate()
	
	draw(root, null)
	draw_lines(root)
	current_floor_label.text = str(RunManager.floor)
	max_floor_label.text = str(RunManager.LAST_FLOOR)
	
	camera.setup(root)


func _process(delta):
	if Input.is_action_just_pressed("debug_1"):
		MapManager.generate_new_map()
		MapManager.swap_to_map_scene()

func generate():
	SeededGenerator.mode("map").reset_transaction().start_transaction()
	MapNode.index = 0
	root = generator.new().generate(settings)


func draw(map_node, parent):
	map_node.draw(parent, self, render_ids)
	for node in map_node.connections:
		draw(node, map_node)
		
	if map_node.id == MapManager.selected_node_id:
		set_selected_node(map_node)


func draw_lines(map_node):
	map_node.draw_lines(self)
	for node in map_node.connections:
		draw_lines(node)


func select(map_node):
	for node in selected_node.connections:
		if node.id == map_node.id:
			enter_room(map_node)


func set_selected_node(map_node):
	selected_node = map_node
	MapManager.selected_node_id = map_node.id
	player.position = map_node.position


func enter_room(map_node: MapNode):
	set_selected_node(map_node)
	if map_node.id != 0:
		get_tree().change_scene_to_packed(map_node.room_info.target_scene)

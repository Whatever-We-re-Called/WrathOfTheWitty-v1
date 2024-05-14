extends Node2D

@export_category("Refs")
@export var camera: Camera2D
@export var player: Node2D

@export_category("Generator")
@export var generator: Resource
@export var seed: String
@export var settings: GeneratorSettings

var root
var selected_node = null

func _ready():
	generate()
	
	draw(root, null)
	draw_lines(root)
	
	camera.setup(root)


func _process(delta):
	if Input.is_action_just_pressed("debug_1"):
		get_tree().change_scene_to_file("res://map/rooms/exit/exit_scene.tscn")

func generate():
	SeededGenerator.set_seed(seed)
	
	SeededGenerator.mode("map").reset_transaction().start_transaction()
	MapNode.index = 0
	root = generator.new().generate(settings)


func draw(map_node, parent):
	map_node.draw(parent, self)
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
			set_selected_node(map_node)


func set_selected_node(map_node):
	selected_node = map_node
	MapManager.selected_node_id = map_node.id
	player.position = map_node.position
	


func _on_button_pressed():
	get_tree().change_scene_to_packed(selected_node.room_script.get_scene_to_load())
